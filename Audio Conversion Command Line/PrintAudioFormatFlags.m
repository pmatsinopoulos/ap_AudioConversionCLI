//
//  PrintAudioFormatFlags.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 6/6/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NSPrint.h"

void PrintAudioFormatFlags(AudioFormatFlags iAudioFormatFlags) {
  NSPrint(@"Format Flags: %d\n", iAudioFormatFlags);
  
  if (iAudioFormatFlags != 0 ) {
    NSDictionary *flags = @{
      @"kAudioFormatFlagIsFloat"                  : [NSNumber numberWithInt:kAudioFormatFlagIsFloat],
      @"kAudioFormatFlagIsBigEndian"              : [NSNumber numberWithInt:kAudioFormatFlagIsBigEndian],
      @"kAudioFormatFlagIsNonInterleaved"         : [NSNumber numberWithInt:kAudioFormatFlagIsNonInterleaved],
      @"kAudioFormatFlagIsSignedInteger"          : [NSNumber numberWithInt:kAudioFormatFlagIsSignedInteger],
      @"kAudioFormatFlagIsPacked"                 : [NSNumber numberWithInt:kAudioFormatFlagIsPacked],
      @"kAudioFormatFlagIsAlignedHigh"            : [NSNumber numberWithInt:kAudioFormatFlagIsAlignedHigh],
      @"kAudioFormatFlagIsNonInterleaved"         : [NSNumber numberWithInt:kAudioFormatFlagIsNonInterleaved],
      @"kAudioFormatFlagIsNonMixable"             : [NSNumber numberWithInt:kAudioFormatFlagIsNonMixable],
      @"kAudioFormatFlagsAreAllClear"             : [NSNumber numberWithInt:kAudioFormatFlagsAreAllClear],
      @"kLinearPCMFormatFlagsSampleFractionShift" : [NSNumber numberWithInt:kLinearPCMFormatFlagsSampleFractionShift],
      @"kLinearPCMFormatFlagsSampleFractionMask"  : [NSNumber numberWithInt:kLinearPCMFormatFlagsSampleFractionMask],
      @"kAppleLosslessFormatFlag_16BitSourceData" : [NSNumber numberWithInt:kAppleLosslessFormatFlag_16BitSourceData],
      @"kAppleLosslessFormatFlag_20BitSourceData" : [NSNumber numberWithInt:kAppleLosslessFormatFlag_20BitSourceData],
      @"kAppleLosslessFormatFlag_24BitSourceData" : [NSNumber numberWithInt:kAppleLosslessFormatFlag_24BitSourceData],
      @"kAppleLosslessFormatFlag_32BitSourceData" : [NSNumber numberWithInt:kAppleLosslessFormatFlag_32BitSourceData]
    };

    NSString *result = @"";
    
    for (NSString *key in flags) {
      NSNumber *nsValue = [flags objectForKey:key];
      int value = [nsValue intValue];
      
      if ((iAudioFormatFlags & value) == value) {
        result = [result stringByAppendingFormat:@"\t\t%@\n", key];
      }
    }
    
    NSPrint(@"Flags: \n%@\n", result);
  }
}

