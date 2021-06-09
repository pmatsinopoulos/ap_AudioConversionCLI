//
//  GetNumberOfPackets.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 8/6/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>
#import "CheckError.h"

void GetNumberOfPackets(AudioFileID iAudioFileID, const char *iMessage, UInt64 *oPacketCount) {
  UInt32 isWriteable = 0;
  UInt32 propertyValueSize = sizeof(UInt32);
  CheckError(AudioFileGetPropertyInfo(iAudioFileID,
                                      kAudioFilePropertyAudioDataPacketCount,
                                      &propertyValueSize,
                                      &isWriteable),
             iMessage);
  
  CheckError(AudioFileGetProperty(iAudioFileID,
                                  kAudioFilePropertyAudioDataPacketCount,
                                  &propertyValueSize,
                                  oPacketCount),
             "Getting the total number of packets");
}
