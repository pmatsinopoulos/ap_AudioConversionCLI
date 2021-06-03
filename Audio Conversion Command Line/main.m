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

void SetUpAudioDataSettingsForOutputFile (AudioStreamBasicDescription *outAudioStreamBasicDescriptionForOutputFile) {
  outAudioStreamBasicDescriptionForOutputFile->mSampleRate = 44100.0;
  outAudioStreamBasicDescriptionForOutputFile->mFormatID = kAudioFormatLinearPCM;
  outAudioStreamBasicDescriptionForOutputFile->mFormatFlags = kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
  outAudioStreamBasicDescriptionForOutputFile->mBytesPerPacket = 4;
  outAudioStreamBasicDescriptionForOutputFile->mBytesPerFrame = 4;
  outAudioStreamBasicDescriptionForOutputFile->mFramesPerPacket = outAudioStreamBasicDescriptionForOutputFile->mBytesPerPacket / outAudioStreamBasicDescriptionForOutputFile->mBytesPerFrame;
  outAudioStreamBasicDescriptionForOutputFile->mChannelsPerFrame = 2; // stereo
  outAudioStreamBasicDescriptionForOutputFile->mBitsPerChannel = 16;
  
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

UInt32 CalculateInputPacketsPerBuffer (AudioConverterRef audioConverter,
                                       UInt32 *ioOutputBufferSize,
                                       UInt32 inInputFileBytesPerPacket) {
  UInt32 result = 0;

  UInt32 bufferBytesPerPacket = 0;
  
  if (inInputFileBytesPerPacket == 0) {
    NSPrint(@"Variable Bit Rate case\n");
    
    // Variable Bit Rate for the input audio data format
    // This means that there is n't constant number of bytes for every packet.
    
    UInt32 size = sizeof(bufferBytesPerPacket);
    CheckError(AudioConverterGetProperty(audioConverter,
                                         kAudioConverterPropertyMaximumOutputPacketSize,
                                         &size,
                                         &bufferBytesPerPacket),
               "Getting the Audio Converter Property: MaximumOutputPacketSize");
    
  }
  else {
    NSPrint(@"Constant Bit Rate case\n");
    
    bufferBytesPerPacket = inInputFileBytesPerPacket;
  }
  
  if (bufferBytesPerPacket > *ioOutputBufferSize) {
    // It seems that we need a bigger output buffer
    *ioOutputBufferSize = bufferBytesPerPacket;
  }
  
  result = *ioOutputBufferSize / bufferBytesPerPacket;
  
  NSPrint(@"Packets Per Buffer: %d\n", result);
  
  return result;
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

UInt8 *AllocateMemoryForBuffer (UInt32 bufferSize) {
  NSPrint(@"AllocateMemoryForBuffer() will allocate %d bytes\n", bufferSize);
  
  return (UInt8 *)malloc(sizeof(UInt8) * bufferSize);
}

OSStatus AudioConverterCallback (AudioConverterRef inAudioConverter,
                                 UInt32 *ioNumberDataPackets,
                                 AudioBufferList *ioData,
                                 AudioStreamPacketDescription * _Nullable *outDataPacketDescription,
                                 void *inUserData) {
  NSPrint(@"AudioConverterCallback(): Minimum Number of Packets requested (*ioNumberDataPackets) %d\n", *ioNumberDataPackets);
  
  
  AudioConverterSettings *audioConverterSettings = (AudioConverterSettings *)inUserData;
  
  audioConverterSettings->callsToCallback++;
  
  NSPrint(@"AudioConverterCallback(): ....................................................... input packet index: %d\n", audioConverterSettings->inputFilePacketIndex);
  NSPrint(@"AudioConverterCallback(): ....................................................... calls to callback: %d\n", audioConverterSettings->callsToCallback);
  
  if (audioConverterSettings->inputFilePacketIndex + *ioNumberDataPackets > audioConverterSettings->inputFilePacketCount) {
    // I am being asked to read past the input file total number of packets. I will read what is left.
    *ioNumberDataPackets = (UInt32)(audioConverterSettings->inputFilePacketCount - audioConverterSettings->inputFilePacketIndex);
  }
  
  NSPrint(@"AudioConverterCallback(): Number of Packets to read for conversion %d\n", *ioNumberDataPackets);
  
  if (*ioNumberDataPackets <= 0) {
    return noErr;
  }
  
//  if (audioConverterSettings->sourceBuffer != NULL) {
//    free(audioConverterSettings->sourceBuffer);
//    audioConverterSettings->sourceBuffer = NULL;
//  }

  UInt32 inputBufferSize = audioConverterSettings->inputFilePacketMaxSize * (*ioNumberDataPackets);
//  audioConverterSettings->sourceBuffer = malloc(inputBufferSize);
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
    ioData->mBuffers[0].mData = NULL;
    ioData->mBuffers[0].mDataByteSize = 0;
    return result;
  }
  
  audioConverterSettings->inputFilePacketIndex += *ioNumberDataPackets;

//  ioData->mBuffers[0].mData = audioConverterSettings->sourceBuffer;
  ioData->mBuffers[0].mDataByteSize = inputBufferSize; // audioConverterSettings->inputFilePacketMaxSize * (*ioNumberDataPackets);
  if (outDataPacketDescription) {
    *outDataPacketDescription = audioConverterSettings->inputFilePacketDescriptions;
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
  
  UInt32 outputBufferSize = 32 * 1024;  // 32KBytes as a good starting point
  UInt32 packetsPerBuffer = 100;
  outputBufferSize = CalculateOutputBufferSize(audioConverter,
                                               packetsPerBuffer);
  
  UInt32 outputFilePacketPosition = 0;
  
  AudioBufferList convertedData;
  convertedData.mNumberBuffers = 1;
  convertedData.mBuffers[0].mNumberChannels = audioConverterSettings->inputFormat.mChannelsPerFrame;
  
  audioConverterSettings->callsToCallback = 0;
  
  while (true) {
    convertedData.mBuffers[0].mDataByteSize = outputBufferSize;
    convertedData.mBuffers[0].mData = AllocateMemoryForBuffer(outputBufferSize);
    
    UInt32 ioOutputDataPackets = packetsPerBuffer;
    
    NSPrint(@"Convert(): About to call AudioConverterFillComplexBuffer()...\n");
    
    OSStatus error = AudioConverterFillComplexBuffer(audioConverter,
                                                     AudioConverterCallback,
                                                     audioConverterSettings,
                                                     
                                                     &ioOutputDataPackets,
                                                     &convertedData,
                                                     NULL);
                                                     //audioConverterSettings->inputFilePacketDescriptions ? audioConverterSettings->inputFilePacketDescriptions : NULL);
    NSPrint(@"Convert(): error = %d, number of packets of converted data created: %d\n", error, ioOutputDataPackets);
    
    if (error || !ioOutputDataPackets) {
      NSPrint(@"Convert(): breaking\n");
      break;
    }
    
    CheckError(AudioFileWritePackets(audioConverterSettings->outputFile,
                                     FALSE,
                                     ioOutputDataPackets * audioConverterSettings->outputFormat.mBytesPerPacket,
                                     NULL, // the PCM output file is a constant bit rate and therefore doesn't use packet descriptions
                                     outputFilePacketPosition, // / audioConverterSettings->outputFormat.mBytesPerPacket,
                                     &ioOutputDataPackets,
                                     convertedData.mBuffers[0].mData),
               "Writing packets to output file");
    outputFilePacketPosition += ioOutputDataPackets; // * audioConverterSettings->outputFormat.mBytesPerPacket);
    
    convertedData.mBuffers[0].mDataByteSize = 0;
    free(convertedData.mBuffers[0].mData);
    convertedData.mBuffers[0].mData = NULL;
  }
  
  CheckError(AudioConverterDispose(audioConverter), "Disposing the Audio Converter");
  
  return;
}

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    if (argc < 2) {
      NSLog(@"You need to give the input file for converting. You can use any Core Audio supported file such as .mp3, .aac, .m4a, .wav, .aif e.t.c.");
      return 1;
    }
    
    AudioConverterSettings audioConverterSettings = {0};
    
    OpenAudioFile(argv[1], &audioConverterSettings.inputFile);
    
    GetInputAudioFormatAndPacketsInfo(&audioConverterSettings);
    
    SetUpAudioDataSettingsForOutputFile(&audioConverterSettings.outputFormat);
    
    InitializeOutputAudioFile(&audioConverterSettings);
    
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
