//
//  GetMaximumPacketSize.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 8/6/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>

#import "CheckError.h"

void GetMaximumPacketSize(AudioFileID iAudioFileID, const char *iMessage, UInt32 *oPacketSize) {
  UInt32 isWriteable = 0;
  UInt32 propertyValueSize = sizeof(UInt32);
  CheckError(AudioFileGetPropertyInfo(iAudioFileID,
                                      kAudioFilePropertyMaximumPacketSize,
                                      &propertyValueSize,
                                      &isWriteable),
             iMessage);
  
  CheckError(AudioFileGetProperty(iAudioFileID,
                                  kAudioFilePropertyMaximumPacketSize,
                                  &propertyValueSize,
                                  oPacketSize),
             "Getting the packet size");
}
