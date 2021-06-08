//
//  PrintMagicCookieEncodingInformation.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 6/6/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>
#import <MacTypes.h>
#import "GetEncodingMagicCookie.h"
#import "NSPrint.h"


void PrintMagicCookieEncodingInformation(AudioFileID iAudioFileID) {
  Byte *cookieData = NULL;
  UInt32 cookieDataSize = 0;
  
  GetEncodingMagicCookie(iAudioFileID, &cookieData, &cookieDataSize);
  NSPrint(@"Does it have magic cookie? %@\n", cookieData ? @"YES" : @"NO");
  
  if (cookieData) {
    free(cookieData);
  }
}
