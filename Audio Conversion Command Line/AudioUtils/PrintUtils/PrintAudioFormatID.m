//
//  PrintAudioFormatID.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 6/6/21.
//

#import <Foundation/Foundation.h>
#import <CoreAudioTypes/CoreAudioBaseTypes.h>
#import "NSPrint.h"

void PrintAudioFormatID(AudioFormatID iAudioFormatID) {
  UInt32 format4cc = CFSwapInt32HostToBig(iAudioFormatID);
  
  NSPrint(@"Format ID: %4.4s\n", (char*)&format4cc);
}
