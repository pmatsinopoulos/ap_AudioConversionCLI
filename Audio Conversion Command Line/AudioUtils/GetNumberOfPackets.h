//
//  GetNumberOfPackets.h
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 8/6/21.
//

#ifndef GetNumberOfPackets_h
#define GetNumberOfPackets_h
#import <AudioToolbox/AudioFile.h>

void GetNumberOfPackets(AudioFileID iAudioFileID, const char *iMessage, UInt64 *oPacketCount);
  
#endif /* GetNumberOfPackets_h */
