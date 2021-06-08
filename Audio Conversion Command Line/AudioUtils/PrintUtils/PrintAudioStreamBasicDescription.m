//
//  PrintAudioStreamBasicDescription.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 8/6/21.
//

#import <Foundation/Foundation.h>
#import <CoreAudioTypes/CoreAudioBaseTypes.h>
#import "NSPrint.h"

void PrintAudioStreamBasicDescription(AudioStreamBasicDescription iAudioStreamBasicDescription) {
  NSPrint(@"Sample Rate: %.2f\n", iAudioStreamBasicDescription.mSampleRate);
  NSPrint(@"Bits per channel: %d\n", iAudioStreamBasicDescription.mBitsPerChannel);
  NSPrint(@"Channels per Frame: %d\n", iAudioStreamBasicDescription.mChannelsPerFrame);
  NSPrint(@"Bytes per frame: %d\n",  iAudioStreamBasicDescription.mBytesPerFrame);
  
  NSPrint(@"Bytes per packet: %d\n", iAudioStreamBasicDescription.mBytesPerPacket);
  NSPrint(@"Frames per Packet: %d\n", iAudioStreamBasicDescription.mFramesPerPacket);
  NSPrint(@"Uncompressed Audio: %@\n", iAudioStreamBasicDescription.mFramesPerPacket == 1 ? @"YES" : @"NO");
  NSPrint(@"VBR or CBR?: %@\n", iAudioStreamBasicDescription.mBytesPerPacket > 0 ? @"CBR" : @"VBR");
}
