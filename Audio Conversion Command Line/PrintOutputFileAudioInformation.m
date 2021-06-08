//
//  PrintOutputFileAudioInformation.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 8/6/21.
//

#import <Foundation/Foundation.h>
#import <CoreAudioTypes/CoreAudioBaseTypes.h>
#import <stdio.h>
#import "AudioConverterSettings.h"
#import "NSPrint.h"
#import "PrintAudioFormatFlags.h"
#import "PrintAudioFormatID.h"
#import "PrintAudioStreamBasicDescription.h"

void PrintOutputFileAudioInformation(const AudioConverterSettings *iAudioConverterSettings) {
  const AudioStreamBasicDescription *lAudioStreamBasicDescription = &iAudioConverterSettings->outputFormat;
    
  PrintAudioStreamBasicDescription(*lAudioStreamBasicDescription);
      
  PrintAudioFormatFlags(lAudioStreamBasicDescription->mFormatFlags);
  
  PrintAudioFormatID(lAudioStreamBasicDescription->mFormatID);    
}
