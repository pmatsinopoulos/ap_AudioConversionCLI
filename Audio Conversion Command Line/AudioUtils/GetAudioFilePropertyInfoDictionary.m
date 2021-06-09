//
//  GetAudioFilePropertyInfoDictionary.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 4/6/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CheckError.h"

void GetAudioFilePropertyInfoDictionary(AudioFileID iAudioFileID, CFDictionaryRef *oDictionary) {
  UInt32 dictionarySize = 0;
  CheckError(AudioFileGetPropertyInfo(iAudioFileID,
                                      kAudioFilePropertyInfoDictionary,
                                      &dictionarySize,
                                      0),
             "Getting the information about the value of the audio file property InfoDictionary");
  
  CheckError(AudioFileGetProperty(iAudioFileID,
                                  kAudioFilePropertyInfoDictionary,
                                  &dictionarySize,
                                  oDictionary),
             "Getting the value of the audio file property InfoDictionary");
}

