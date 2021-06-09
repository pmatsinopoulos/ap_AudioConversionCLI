//
//  GetAudioFileInformationProperty.h
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 4/6/21.
//

#ifndef GetAudioFilePropertyInfoDictionary_h
#define GetAudioFilePropertyInfoDictionary_h

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

void GetAudioFilePropertyInfoDictionary(AudioFileID iAudioFileID, CFDictionaryRef *oDictionary);

#endif /* GetAudioFilePropertyInfoDictionary_h */
