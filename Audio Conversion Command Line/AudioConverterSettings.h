//
//  AudioConverterSettings.h
//  Audio Conversion Command Line
//
//  Created by Panayotis Matsinopoulos on 29/5/21.
//

#ifndef AudioConverterSettings_h
#define AudioConverterSettings_h

typedef struct AudioConverterSettings {
  AudioStreamBasicDescription inputFormat;
  AudioStreamBasicDescription outputFormat;
  
  AudioFileID inputFile;
  AudioFileID outputFile;
  
  UInt64 inputFilePacketIndex;
  UInt64 inputFilePacketCount;
  UInt32 inputFilePacketMaxSize;
  
  AudioStreamPacketDescription *inputFilePacketDescriptions;
  
  UInt32 outputBufferPackets;
  AudioStreamPacketDescription *outputFilePacketDescriptions;
  
  UInt64 callsToCallback;  
} AudioConverterSettings;

#endif /* AudioConverterSettings_h */
