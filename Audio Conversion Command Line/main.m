//
//  main.m
//  Audio Conversion Command Line
//
//  Created by Panayotis Matsinopoulos on 29/5/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NSPrint.h"
#import "AudioConverterSettings.h"
#import "OpenAudioFile.h"
#import "CheckError.h"
#import "CharPointerFilenameToNSURLp.h"

void GetInputAudioFormatAndPacketsInfo (AudioConverterSettings *audioConverterSettings) {
  UInt32 propertyValueSize = sizeof(AudioStreamBasicDescription);
  CheckError(AudioFileGetProperty(audioConverterSettings->inputFile,
                                  kAudioFilePropertyDataFormat,
                                  &propertyValueSize,
                                  &audioConverterSettings->inputFormat),
             "Getting the Audio Stream Basic Description of the input audio file");
  
  UInt32 isWriteable = 0;
  CheckError(AudioFileGetPropertyInfo(audioConverterSettings->inputFile,
                                      kAudioFilePropertyAudioDataPacketCount,
                                      &propertyValueSize,
                                      &isWriteable),
             "Getting the input file total number of packets property value size");
  
  CheckError(AudioFileGetProperty(audioConverterSettings->inputFile,
                                  kAudioFilePropertyAudioDataPacketCount,
                                  &propertyValueSize,
                                  &audioConverterSettings->inputFilePacketCount),
             "Getting the input file total number of packets");
  NSPrint(@"Number of input file audio data packet count %d\n", audioConverterSettings->inputFilePacketCount);

  CheckError(AudioFileGetPropertyInfo(audioConverterSettings->inputFile,
                                      kAudioFilePropertyMaximumPacketSize,
                                      &propertyValueSize,
                                      &isWriteable),
             "Getting the input file maximum packet size property value size");

  CheckError(AudioFileGetProperty(audioConverterSettings->inputFile,
                                  kAudioFilePropertyMaximumPacketSize,
                                  &propertyValueSize,
                                  &audioConverterSettings->inputFilePacketMaxSize),
             "Getting the input file maximum packet size");
  NSPrint(@"Input file maximum packet size %d\n", audioConverterSettings->inputFilePacketMaxSize);
}

void SetUpAudioDataSettingsForOutputFile (AudioConverterSettings *outAudioConverterSettings) {
  
  outAudioConverterSettings->outputFormat.mSampleRate = 44100.0;
  outAudioConverterSettings->outputFormat.mFormatID = kAudioFormatLinearPCM;
  outAudioConverterSettings->outputFormat.mFormatFlags = kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
  outAudioConverterSettings->outputFormat.mBytesPerPacket = 4;
  outAudioConverterSettings->outputFormat.mBytesPerFrame = 4;
  outAudioConverterSettings->outputFormat.mFramesPerPacket = outAudioConverterSettings->outputFormat.mBytesPerPacket / outAudioConverterSettings->outputFormat.mBytesPerFrame;
  outAudioConverterSettings->outputFormat.mChannelsPerFrame = 2; // stereo
  outAudioConverterSettings->outputFormat.mBitsPerChannel = 16;
    
  return;
}

void InitializeOutputAudioFile (AudioConverterSettings *audioConverterSettings) {
  CheckError(AudioFileCreateWithURL((__bridge CFURLRef) CharPointerFilenameToNSURLp("output.aif"),
                                    kAudioFileAIFFType,
                                    &audioConverterSettings->outputFormat,
                                    kAudioFileFlags_EraseFile,
                                    &audioConverterSettings->outputFile),
             "Creating the output audio file with URL");
}

UInt32 CalculateOutputBufferSize(AudioConverterRef audioConverter,
                                 UInt32 iPacketsPerBuffer) {
  
  UInt32 size = 0;
  Boolean isWritable = false;
  CheckError(AudioConverterGetPropertyInfo(audioConverter,
                                           kAudioConverterPropertyMaximumOutputPacketSize,
                                           &size,
                                           &isWritable),
             "Getting the Audio Converter property value size for property kAudioConverterPropertyMaximumOutputPacketSize");
  
  UInt32 maximumOutputPackeSize = 0;
  CheckError(AudioConverterGetProperty(audioConverter,
                                       kAudioConverterPropertyMaximumOutputPacketSize,
                                       &size,
                                       &maximumOutputPackeSize),
             "Getting the Audio Converter Property: MaximumOutputPacketSize");

  return iPacketsPerBuffer * maximumOutputPackeSize;
}

void InitializeInputFilePacketDescriptions (UInt32 iInputFileBytesPerPacket,
                                            UInt32 iPackets,
                                            AudioStreamPacketDescription **oInputFilePacketDescriptions) {
  NSPrint(@"InitializeInputFilePacketDescriptions...\n");
  
  if (*oInputFilePacketDescriptions) {
    free(*oInputFilePacketDescriptions);
    *oInputFilePacketDescriptions = NULL;
  }
  
  if (iInputFileBytesPerPacket == 0) {
    // VBR case
    *oInputFilePacketDescriptions = (AudioStreamPacketDescription *)malloc(sizeof(AudioStreamPacketDescription) * iPackets);
  }
  else {
    // CBR case
    *oInputFilePacketDescriptions = NULL;
  }
}

OSStatus AudioConverterCallback (AudioConverterRef inAudioConverter,
                                 UInt32 *ioNumberDataPackets,
                                 AudioBufferList *ioData,
                                 AudioStreamPacketDescription * _Nullable *oDataPacketDescription,
                                 void *inUserData) {
  NSPrint(@"AudioConverterCallback(): Minimum Number of Packets requested (*ioNumberDataPackets) %d\n", *ioNumberDataPackets);

  AudioConverterSettings *audioConverterSettings = (AudioConverterSettings *)inUserData;
  
  audioConverterSettings->callsToCallback++;
  
  NSPrint(@"AudioConverterCallback(): ....................................................... input packet index: %d\n", audioConverterSettings->inputFilePacketIndex);
  NSPrint(@"AudioConverterCallback(): ....................................................... calls to callback: %d\n", audioConverterSettings->callsToCallback);
  
  if (*ioNumberDataPackets < audioConverterSettings->inputMinimumNumberOfPacketsToRead) {
    *ioNumberDataPackets = audioConverterSettings->inputMinimumNumberOfPacketsToRead;
  }
    
  if (audioConverterSettings->inputFilePacketIndex + *ioNumberDataPackets > audioConverterSettings->inputFilePacketCount) {
    // I am being asked to read past the input file total number of packets. I will read what is left.
    *ioNumberDataPackets = (UInt32)(audioConverterSettings->inputFilePacketCount - audioConverterSettings->inputFilePacketIndex);
  }
  
  NSPrint(@"AudioConverterCallback(): Number of Packets to read for conversion %d\n", *ioNumberDataPackets);
  
  if (*ioNumberDataPackets <= 0) {
    return noErr;
  }
  
  UInt32 inputBufferSize = audioConverterSettings->inputFilePacketMaxSize * (*ioNumberDataPackets);
  if (ioData->mBuffers[0].mData) {
    free(ioData->mBuffers[0].mData);
    ioData->mBuffers[0].mData = NULL;
  }
  
  ioData->mBuffers[0].mData = malloc(inputBufferSize);
  memset(ioData->mBuffers[0].mData, 0, inputBufferSize);
    
  InitializeInputFilePacketDescriptions(audioConverterSettings->inputFormat.mBytesPerPacket,
                                        *ioNumberDataPackets,
                                        &audioConverterSettings->inputFilePacketDescriptions);
  
  NSPrint(@"AudioConverterCallback(): calling AudioFileReadPacketData with inputBufferSize %d\n", inputBufferSize);
  
  OSStatus result = AudioFileReadPacketData(audioConverterSettings->inputFile,
                                            FALSE,
                                            &inputBufferSize,
                                            audioConverterSettings->inputFilePacketDescriptions,
                                            audioConverterSettings->inputFilePacketIndex,
                                            ioNumberDataPackets,
                                            ioData->mBuffers[0].mData);
  
  NSPrint(@"AudioConverterCallback(): after AudioFileReadPacketData inputBufferSize is %d\n", inputBufferSize);
  
  if (result == kAudioFileEndOfFileError && *ioNumberDataPackets) {
    result = noErr;
  }
  else if (result != kAudioFileEndOfFileError && result != noErr) {
    if (ioData->mBuffers[0].mData) {
      free(ioData->mBuffers[0].mData);
      ioData->mBuffers[0].mData = NULL;
    }
    ioData->mBuffers[0].mDataByteSize = 0;
    return result;
  }
  
  audioConverterSettings->inputFilePacketIndex += *ioNumberDataPackets;

  ioData->mBuffers[0].mDataByteSize = inputBufferSize;
  if (oDataPacketDescription) {
    *oDataPacketDescription = audioConverterSettings->inputFilePacketDescriptions;
  }
  
  return noErr;
} // AudioConverterCallback()

void Convert (AudioConverterSettings *audioConverterSettings) {
  NSPrint(@"Convert(): Starting conversion...\n");
  
  AudioConverterRef audioConverter;
  
  CheckError(AudioConverterNew(&audioConverterSettings->inputFormat,
                               &audioConverterSettings->outputFormat,
                               &audioConverter),
             "Creating audio converter");
    
  UInt32 outputBufferSize = 0;
  outputBufferSize = CalculateOutputBufferSize(audioConverter,
                                               audioConverterSettings->outputBufferSizeInPackets);
  
  UInt32 outputFilePacketPosition = 0;
  
  AudioBufferList convertedData;
  convertedData.mNumberBuffers = 1;
  convertedData.mBuffers[0].mNumberChannels = audioConverterSettings->inputFormat.mChannelsPerFrame;
  convertedData.mBuffers[0].mDataByteSize = outputBufferSize;
  convertedData.mBuffers[0].mData = (UInt8 *)malloc(sizeof(UInt8) * outputBufferSize);
  
  AudioStreamPacketDescription *outputFilePacketDescriptions = (AudioStreamPacketDescription *)malloc(sizeof(AudioStreamPacketDescription) * audioConverterSettings->outputBufferSizeInPackets);

  audioConverterSettings->callsToCallback = 0;
  UInt32 numberOfLoops = 0;
  
  while (true) {
    numberOfLoops++;
    
    UInt32 ioOutputDataPackets = audioConverterSettings->outputBufferSizeInPackets;
    
    NSPrint(@"Convert(): About to call AudioConverterFillComplexBuffer()...\n");
    
    OSStatus error = AudioConverterFillComplexBuffer(audioConverter,
                                                     AudioConverterCallback,
                                                     audioConverterSettings,
                                                     &ioOutputDataPackets,
                                                     &convertedData,
                                                     outputFilePacketDescriptions);
    NSPrint(@"Convert(): error = %d, number of packets of converted data created: %d\n", error, ioOutputDataPackets);
    
    if (error || !ioOutputDataPackets) {
      NSPrint(@"Convert(): breaking\n");
      break;
    }
    
    CheckError(AudioFileWritePackets(audioConverterSettings->outputFile,
                                     FALSE,
                                     ioOutputDataPackets * audioConverterSettings->outputFormat.mBytesPerPacket,
                                     outputFilePacketDescriptions ? outputFilePacketDescriptions : NULL,
                                     outputFilePacketPosition,
                                     &ioOutputDataPackets,
                                     convertedData.mBuffers[0].mData),
               "Writing packets to output file");
    outputFilePacketPosition += ioOutputDataPackets;
    
    memset(convertedData.mBuffers[0].mData, 0, outputBufferSize);
  }
  
  free(outputFilePacketDescriptions);
  outputFilePacketDescriptions = NULL;

  free(convertedData.mBuffers[0].mData);
  convertedData.mBuffers[0].mData = NULL;

  CheckError(AudioConverterDispose(audioConverter), "Disposing the Audio Converter");
  
  NSPrint(@"Number of calls to AudioConverterFillComplexBuffer(): %d\n", numberOfLoops);
  
  return;
}

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    if (argc < 4) {
      NSLog(@"1st arguments: You need to give the input file for converting. You can use any Core Audio supported file such as .mp3, .aac, .m4a, .wav, .aif e.t.c.\n");
      NSLog(@"2nd argument: You need to give the minimum number of packets to read from the input file.\n");
      NSLog(@"3rd argument: You need to give the size of the conversion output buffer in number of packets.\n");
      NSLog(@"Example: audio_conversion trixtor.mp3 10000 10000\n");
      return 1;
    }
    
    AudioConverterSettings audioConverterSettings = {0};
    
    OpenAudioFile(argv[1], &audioConverterSettings.inputFile);
    
    GetInputAudioFormatAndPacketsInfo(&audioConverterSettings);
    
    // The bigger the number of packets to read the less the number of calls to +AudioConverterCallback+ function
    audioConverterSettings.inputMinimumNumberOfPacketsToRead = atoi(argv[2]);
    
    SetUpAudioDataSettingsForOutputFile(&audioConverterSettings);
    
    InitializeOutputAudioFile(&audioConverterSettings);
    
    // The bigger the number of packets, the less the number of calls to AudioConverterFillComplexBuffer() and program runs faster.
    // However, the number of calls to AudioConverterCallback callback is not affected by this number.
    audioConverterSettings.outputBufferSizeInPackets = atoi(argv[3]);
    
    Convert(&audioConverterSettings);
    
    CheckError(AudioFileClose(audioConverterSettings.inputFile), "Closing audio input file...");
    CheckError(AudioFileClose(audioConverterSettings.outputFile), "Closing audio output file...");
    if (audioConverterSettings.inputFilePacketDescriptions) {
      free(audioConverterSettings.inputFilePacketDescriptions);
      audioConverterSettings.inputFilePacketDescriptions = NULL;
    }
    
    NSPrint(@"...Bye!\n");
  }
  return 0;
}
