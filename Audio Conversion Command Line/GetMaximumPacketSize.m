//
//  GetMaximumPacketSize.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 8/6/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>

#import "CheckError.h"

void GetMaximumPacketSize(AudioFileID inAudioFileID, const char *message, UInt32 *outPacketSize) {
  UInt32 isWriteable = 0;
  UInt32 propertyValueSize = sizeof(UInt32);
  CheckError(AudioFileGetPropertyInfo(inAudioFileID,
                                      kAudioFilePropertyMaximumPacketSize,
                                      &propertyValueSize,
                                      &isWriteable),
             message);
  
  CheckError(AudioFileGetProperty(inAudioFileID,
                                  kAudioFilePropertyMaximumPacketSize,
                                  &propertyValueSize,
                                  outPacketSize),
             "Getting the packet size");
}
