//
//  GetNumberOfPackets.h
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 8/6/21.
//

#ifndef GetNumberOfPackets_h
#define GetNumberOfPackets_h
#import <AudioToolbox/AudioFile.h>

void GetNumberOfPackets(AudioFileID inAudioFileID, const char *message, UInt64 *outPacketCount);
  
#endif /* GetNumberOfPackets_h */
