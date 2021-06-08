//
//  GetNumberOfPackets.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 8/6/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>
#import "CheckError.h"

void GetNumberOfPackets(AudioFileID inAudioFileID, const char *message, UInt64 *outPacketCount) {
  UInt32 isWriteable = 0;
  UInt32 propertyValueSize = sizeof(UInt32);
  CheckError(AudioFileGetPropertyInfo(inAudioFileID,
                                      kAudioFilePropertyAudioDataPacketCount,
                                      &propertyValueSize,
                                      &isWriteable),
             message);
  
  CheckError(AudioFileGetProperty(inAudioFileID,
                                  kAudioFilePropertyAudioDataPacketCount,
                                  &propertyValueSize,
                                  outPacketCount),
             "Getting the total number of packets");
}
