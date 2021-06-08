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
#import "GetAudioFileInformationProperty.h"
#import "NSPrint.h"

void PrintAudioFileDictionary(AudioFileID iAudioFile) {
  CFDictionaryRef dictionary;
  
  GetAudioFileInformationProperty(iAudioFile, &dictionary);
  
  NSPrint(@"dictionary: %@\n", dictionary);
  
  CFRelease(dictionary);
}
