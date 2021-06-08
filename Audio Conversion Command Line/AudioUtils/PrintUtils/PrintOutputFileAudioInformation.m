//
//  PrintOutputFileAudioInformation.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 8/6/21.
//

#import <Foundation/Foundation.h>
#import <CoreAudioTypes/CoreAudioBaseTypes.h>
#import "NSPrint.h"
#import "PrintAudioFormatFlags.h"
#import "PrintAudioFormatID.h"
#import "PrintAudioStreamBasicDescription.h"

void PrintOutputFileAudioInformation(AudioStreamBasicDescription iAudioStreamBasicDescription) {
  PrintAudioStreamBasicDescription(iAudioStreamBasicDescription);
      
  PrintAudioFormatFlags(iAudioStreamBasicDescription.mFormatFlags);
  
  PrintAudioFormatID(iAudioStreamBasicDescription.mFormatID);
}
