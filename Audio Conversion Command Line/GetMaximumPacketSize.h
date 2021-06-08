//
//  GetMaximumPacketSize.h
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 8/6/21.
//

#ifndef GetMaximumPacketSize_h
#define GetMaximumPacketSize_h

#import <AudioToolbox/AudioToolbox.h>

void GetMaximumPacketSize(AudioFileID inAudioFileID, const char *message, UInt32 *outPacketSize);

#endif /* GetMaximumPacketSize_h */
