//
//  PrintFileAudioInformation.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 8/6/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>
#import "CheckError.h"
#import "OpenAudioFile.h"
#import "PrintAudioFileDictionary.h"
#import "PrintAudioFormatFlags.h"
#import "PrintAudioFormatID.h"
#import "PrintMagicCookieEncodingInformation.h"
#import "NSPrint.h"
#import "GetNumberOfPackets.h"
#import "GetMaximumPacketSize.h"
#import "PrintAudioStreamBasicDescription.h"

void PrintFileAudioInformation(const char *iAudioFileName) {
  AudioFileID audioFileID;
  
  OpenAudioFile(iAudioFileName, &audioFileID);
  
  PrintAudioFileDictionary(audioFileID);
  
  UInt32 propertyValueSize = sizeof(AudioStreamBasicDescription);
  AudioStreamBasicDescription fileFormat = {0};
  
  CheckError(AudioFileGetProperty(audioFileID,
                                  kAudioFilePropertyDataFormat,
                                  &propertyValueSize,
                                  &fileFormat),
             "Getting the Audio Stream Basic Description of the audio file");

  PrintAudioStreamBasicDescription(fileFormat);
    
  PrintAudioFormatFlags(fileFormat.mFormatFlags);
  
  PrintAudioFormatID(fileFormat.mFormatID);
  
  UInt64 packetCount = 0;
  GetNumberOfPackets(audioFileID, "Getting number of packets of file", &packetCount);
  NSPrint(@"Number of packets: %ld\n", packetCount);
  
  UInt32 packetMaxSize = 0;
  GetMaximumPacketSize(audioFileID, "Getting maximum packet size", &packetMaxSize);
  NSPrint(@"Maximum packet size: %d\n", packetMaxSize);
  
  PrintMagicCookieEncodingInformation(audioFileID);
  
  CheckError(AudioFileClose(audioFileID), "Closing file...");  
}
