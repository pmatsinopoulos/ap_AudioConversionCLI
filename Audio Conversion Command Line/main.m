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
  
  propertyValueSize = sizeof(audioConverterSettings->inputFilePacketCount);
  CheckError(AudioFileGetProperty(audioConverterSettings->inputFile,
                                  kAudioFilePropertyAudioDataPacketCount,
                                  &propertyValueSize,
                                  &audioConverterSettings->inputFilePacketCount),
             "Getting the input file total number of packets");
  NSPrint(@"Number of input file audio data packet count %d\n", audioConverterSettings->inputFilePacketCount);
  
  propertyValueSize = sizeof(audioConverterSettings->inputFilePacketMaxSize);
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

UInt32 CalculateInputPacketsPerBuffer (AudioConverterRef audioConverter,
                                       UInt32 *ioOutputBufferSize,
                                       UInt32 inInputFileBytesPerPacket) {
  UInt32 result = 0;
  
  if (inInputFileBytesPerPacket == 0) {
    NSPrint(@"Variable Bit Rate case\n");
    
    UInt32 bufferBytesPerPacket = 0;
    
    // Variable Bit Rate for the input audio data format
    // This means that there is n't constant number of bytes for every packet.
    
    UInt32 size = sizeof(bufferBytesPerPacket);
    CheckError(AudioConverterGetProperty(audioConverter,
                                         kAudioConverterPropertyMaximumOutputPacketSize,
                                         &size,
                                         &bufferBytesPerPacket),
               "Getting the Audio Converter Property: MaximumOutputPacketSize");
    if (bufferBytesPerPacket > *ioOutputBufferSize) {
      // It seems that we need a bigger output buffer, because the maximum output packet size is greater than the originally assumed output buffer size.
      *ioOutputBufferSize = bufferBytesPerPacket;
    }
    
    result = *ioOutputBufferSize / bufferBytesPerPacket;
  }
  else {
    NSPrint(@"Constant Bit Rate case\n");
    
    result = *ioOutputBufferSize / inInputFileBytesPerPacket;
  }
  
  NSPrint(@"Packets Per Buffer: %d\n", result);
  
  return result;
}

void InitializeInputFilePacketDescriptions (UInt32 inInputFileBytesPerPacket,
                                            UInt32 inPacketsPerBuffer,
                                            AudioStreamPacketDescription **oInputFilePacketDescriptions) {
  if (inInputFileBytesPerPacket == 0) {
    // VBR case
    *oInputFilePacketDescriptions = (AudioStreamPacketDescription *)malloc(sizeof(AudioStreamPacketDescription) * inPacketsPerBuffer);
  }
  else {
    // CBR case
    *oInputFilePacketDescriptions = NULL;
  }
}

UInt8 *AllocateMemoryForBuffer (UInt32 bufferSize) {
  return (UInt8 *)malloc(sizeof(UInt8) * bufferSize);
}

OSStatus AudioConverterCallback (AudioConverterRef inAudioConverter,
                                 UInt32 *ioNumberDataPackets,
                                 AudioBufferList *ioData,
                                 AudioStreamPacketDescription * _Nullable *outDataPacketDescription,
                                 void *inUserData) {
  AudioConverterSettings *audioConverterSettings = (AudioConverterSettings *)inUserData;
  
  ioData->mBuffers[0].mData = NULL;
  ioData->mBuffers[0].mDataByteSize = 0;
  
  if (audioConverterSettings->inputFilePacketIndex + *ioNumberDataPackets > audioConverterSettings->inputFilePacketCount) {
    // I am being asked to read past the input file total number of packets. I will read what is left.
    *ioNumberDataPackets = audioConverterSettings->inputFilePacketCount - audioConverterSettings->inputFilePacketIndex;
  }
  
  if (*ioNumberDataPackets == 0) {
    return noErr;
  }
  
  if (audioConverterSettings->sourceBuffer != NULL) {
    free(audioConverterSettings->sourceBuffer);
    audioConverterSettings->sourceBuffer = NULL;
  }
  
  UInt32 sourceBufferSize = audioConverterSettings->inputFilePacketMaxSize * (*ioNumberDataPackets);
  audioConverterSettings->sourceBuffer = malloc(sourceBufferSize);
  memset(audioConverterSettings->sourceBuffer, 0, sourceBufferSize);
  
  OSStatus result = AudioFileReadPacketData(audioConverterSettings->inputFile,
                                            FALSE,
                                            &sourceBufferSize,
                                            audioConverterSettings->inputFilePacketDescriptions,
                                            audioConverterSettings->inputFilePacketIndex,
                                            ioNumberDataPackets,
                                            audioConverterSettings->sourceBuffer);
  
  if (result == kAudioFileEndOfFileError && *ioNumberDataPackets) {
    result = noErr;
  }
  else if (result != kAudioFileEndOfFileError){
    return result;
  }
  
  audioConverterSettings->inputFilePacketIndex += *ioNumberDataPackets;
  ioData->mBuffers[0].mData = audioConverterSettings->sourceBuffer;
  ioData->mBuffers[0].mDataByteSize = sourceBufferSize;
  if (outDataPacketDescription) {
    *outDataPacketDescription = audioConverterSettings->inputFilePacketDescriptions;
  }
  
  return noErr;
}

void Convert (AudioConverterSettings *audioConverterSettings) {
  NSPrint(@"Starting conversion...\n");
  
  AudioConverterRef audioConverter;
  
  CheckError(AudioConverterNew(&audioConverterSettings->inputFormat,
                               &audioConverterSettings->outputFormat,
                               &audioConverter),
             "Creating audio converter");
  
  UInt32 outputBufferSize = 32 * 1024;  // 32KBytes as a good starting point
  UInt32 packetsPerBuffer = 0;
  packetsPerBuffer = CalculateInputPacketsPerBuffer(audioConverter,
                                                    &outputBufferSize,
                                                    audioConverterSettings->inputFormat.mBytesPerPacket);
  
  InitializeInputFilePacketDescriptions(audioConverterSettings->inputFormat.mBytesPerPacket,
                                        packetsPerBuffer,
                                        &audioConverterSettings->inputFilePacketDescriptions);
  
  
  UInt8 *outputBuffer = AllocateMemoryForBuffer(outputBufferSize);
  
  UInt32 outputFilePacketPosition = 0;
  
  while (true) {
    AudioBufferList convertedData;
    convertedData.mNumberBuffers = 1;
    convertedData.mBuffers[0].mNumberChannels = audioConverterSettings->inputFormat.mChannelsPerFrame;
    convertedData.mBuffers[0].mDataByteSize = outputBufferSize;
    convertedData.mBuffers[0].mData = outputBuffer;
    
    UInt32 ioOutputDataPackets = packetsPerBuffer;
    OSStatus error = AudioConverterFillComplexBuffer(audioConverter,
                                                     AudioConverterCallback,
                                                     audioConverterSettings,
                                                     &ioOutputDataPackets,
                                                     &convertedData,
                                                     audioConverterSettings->inputFilePacketDescriptions ? audioConverterSettings->inputFilePacketDescriptions : NULL);
    if (error || !ioOutputDataPackets) {
      break;
    }
    
    CheckError(AudioFileWritePackets(audioConverterSettings->outputFile,
                                     FALSE,
                                     ioOutputDataPackets,
                                     NULL, // the PCM output file is a constant bit rate and therefore doesn't use packet descriptions
                                     outputFilePacketPosition / audioConverterSettings->outputFormat.mBytesPerPacket,
                                     &ioOutputDataPackets,
                                     convertedData.mBuffers[0].mData),
               "Writing packets to output file");
    outputFilePacketPosition += (ioOutputDataPackets * audioConverterSettings->outputFormat.mBytesPerPacket);
  }
  
  CheckError(AudioConverterDispose(audioConverter), "Disposing the Audio Converter");
  
  free(outputBuffer);
  
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
    if (audioConverterSettings.sourceBuffer) {
      free(audioConverterSettings.sourceBuffer);
      audioConverterSettings.sourceBuffer = NULL;
    }
    
    NSPrint(@"...Bye!\n");
  }
  return 0;
}
