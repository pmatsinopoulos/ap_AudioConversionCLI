//
//  GetEncodingMagicCookie.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 6/6/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>
#import "CheckError.h"

void GetEncodingMagicCookie(AudioFileID iAudioFile, Byte** oCookieData, UInt32 *oCookieDataSize) {
  *oCookieDataSize = 0;
  UInt32 isWritable = 0;
  
  OSStatus error = AudioFileGetPropertyInfo(iAudioFile,
                                            kAudioFilePropertyMagicCookieData,
                                            oCookieDataSize,
                                            &isWritable);
  if (error == noErr && *oCookieDataSize > 0) {
    *oCookieData = (Byte *)malloc(*oCookieDataSize * sizeof(Byte));
    CheckError(AudioFileGetProperty(iAudioFile,
                                    kAudioFilePropertyMagicCookieData,
                                    oCookieDataSize,
                                    *oCookieData), "Getting the actual magic cookie data from the input audio file");
  }
  else {
    *oCookieData = NULL;
  }
}
