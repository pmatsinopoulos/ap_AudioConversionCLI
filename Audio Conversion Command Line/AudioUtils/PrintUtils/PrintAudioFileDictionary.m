//
//  PrintAudioFileDictionary.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 8/6/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>
#import <CoreFoundation/CFDictionary.h>
#import <CoreFoundation/CFBase.h>
#import "GetAudioFilePropertyInfoDictionary.h"
#import "NSPrint.h"

void PrintAudioFileDictionary(AudioFileID iAudioFile) {
  CFDictionaryRef dictionary;
  
  GetAudioFilePropertyInfoDictionary(iAudioFile, &dictionary);
  
  NSPrint(@"dictionary: %@\n", dictionary);
  
  CFRelease(dictionary);
}
