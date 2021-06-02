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
  
  UInt32 inputFilePacketIndex;
  UInt32 inputFilePacketCount;
  UInt32 inputFilePacketMaxSize;
  AudioStreamPacketDescription *inputFilePacketDescriptions;
  
  void *sourceBuffer;
} AudioConverterSettings;

#endif /* AudioConverterSettings_h */
