//
//  GetAudioFileInformationProperty.h
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 4/6/21.
//

#ifndef GetAudioFileInformationProperty_h
#define GetAudioFileInformationProperty_h

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

void GetAudioFileInformationProperty(AudioFileID audioFile, CFDictionaryRef *dictionary);

#endif /* GetAudioFileInformationProperty_h */
