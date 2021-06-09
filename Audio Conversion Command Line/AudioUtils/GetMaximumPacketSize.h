//
//  GetMaximumPacketSize.h
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 8/6/21.
//

#ifndef GetMaximumPacketSize_h
#define GetMaximumPacketSize_h

#import <AudioToolbox/AudioToolbox.h>

void GetMaximumPacketSize(AudioFileID iAudioFileID, const char *iMessage, UInt32 *oPacketSize);

#endif /* GetMaximumPacketSize_h */
