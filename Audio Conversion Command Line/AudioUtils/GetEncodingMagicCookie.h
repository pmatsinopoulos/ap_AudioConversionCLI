//
//  GetEncodingMagicCookie.h
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 6/6/21.
//

#ifndef GetEncodingMagicCookie_h
#define GetEncodingMagicCookie_h

#import <AudioToolbox/AudioFile.h>
#import "CheckError.h"

void GetEncodingMagicCookie(AudioFileID iAudioFile, Byte** oCookieData, UInt32 *oCookieDataSize);

#endif /* GetEncodingMagicCookie_h */
