//
//  AskUserForOutputFormat.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 7/6/21.
//

#import <Foundation/Foundation.h>
#import <CoreAudioTypes/CoreAudioBaseTypes.h>
#import "Input.h"
#import "NSPrint.h"

AudioFormatID AskUserForOutputFormat() {
  return kAudioFormatLinearPCM;
  
//  NSPrint(@"Choose the output format: \n");
//  NSPrint(@"...[ 1] for LinearPCM (lpcm)\n");
//  NSPrint(@"...[ 2] for AC3 (ac-3)\n");
//  NSPrint(@"...[ 3] for CAC3 (cac3)\n");
//  NSPrint(@"...[ 4] for Apple IMA4 (ima4)\n");
//  NSPrint(@"...[ 5] for MPEG4 AAC (aac )\n");
//  NSPrint(@"...[ 6] for MPEG4 CELP (celp)\n");
//  NSPrint(@"...[ 7] for MPEG4 HVXC (hvxc)\n");
//  NSPrint(@"...[ 8] for MPEG4 TwinVQ (twvq)\n");
//  NSPrint(@"...[ 9] for MACE3 (mac3)\n");
//  NSPrint(@"...[10] for MACE6 (mac6)\n");
//  NSPrint(@"...[11] for ULaw (ulaw)\n");
//  NSPrint(@"...[12] for ALaw (alaw)\n");
//  NSPrint(@"...[13] for QDMC (QDMC)\n");
//  NSPrint(@"...[14] for QDMC2 (QDM2)\n");
//  NSPrint(@"...[15] for QUALCOMM (Qclp)\n");
//  NSPrint(@"...[16] for MPEG Layer1 (.mp1)\n");
//  NSPrint(@"...[17] for MPEG Layer2 (.mp2)\n");
//  NSPrint(@"...[18] for MPEG Layer3 (.mp3)\n");
//  NSPrint(@"...[19] for Time Code (time)\n");
//  NSPrint(@"...[20] for MIDI Stream (midi)\n");
//  NSPrint(@"...[21] for Parameter Value Stream (apvs)\n");
//  NSPrint(@"...[22] for Apple Lossless (alac)\n");
//  NSPrint(@"...[23] for MPEG4 AAC HE (aach)\n");
//  NSPrint(@"...[24] for MPEG4 AAC LD (aacl)\n");
//  NSPrint(@"...[25] for MPEG4 AAC ELD (aace)\n");
//  NSPrint(@"...[26] for MPEG4 AAC ELD SBR (aacf)\n");
//  NSPrint(@"...[27] for MPEG4 AAC ELD V2 (aacg)\n");
//  NSPrint(@"...[28] for MPEG4 AAC HE V2 (aacp)\n");
//  NSPrint(@"...[29] for MPEG4 AAC Spatial (aacs)\n");
//  NSPrint(@"...[30] for MPEGD USAC (usac)\n");
//  NSPrint(@"...[31] for AMR (samr)\n");
//  NSPrint(@"...[32] for AMR WB (sawb)\n");
//  NSPrint(@"...[33] for Audible (AUDB)\n");
//  NSPrint(@"...[34] for iLBC (ilbc)\n");
//  NSPrint(@"...[35] for DVIIntelIMA (0x6D730011)\n");
//  NSPrint(@"...[36] for MicrosoftGSM (0x6D730031)\n");
//  NSPrint(@"...[37] for AES3 (aes3)\n");
//  NSPrint(@"...[38] for EnhancedAC3 (ec-3)\n");
//  NSPrint(@"...[39] for FLAC (flac)\n");
//  NSPrint(@"...[40] for Opus (opus)\n");
//
//  NSString *userInput = [Input getUserInput];
//
//  if ([userInput isEqualTo:@"1"]) {
//    return kAudioFormatLinearPCM;
//  }
//  else if ([userInput isEqualTo:@"2"]) {
//    return kAudioFormatAC3;
//  }
//  else if ([userInput isEqualTo:@"3"]) {
//    return kAudioFormat60958AC3;
//  }
//  else if ([userInput isEqualTo:@"4"]) {
//    return kAudioFormatAppleIMA4;
//  }
//  else if ([userInput isEqualTo:@"5"]) {
//    return kAudioFormatMPEG4AAC;
//  }
//  else if ([userInput isEqualTo:@"6"]) {
//    return kAudioFormatMPEG4CELP;
//  }
//  else if ([userInput isEqualTo:@"7"]) {
//    return kAudioFormatMPEG4HVXC;
//  }
//  else if ([userInput isEqualTo:@"8"]) {
//    return kAudioFormatMPEG4TwinVQ;
//  }
//  else if ([userInput isEqualTo:@"9"]) {
//    return kAudioFormatMACE3;
//  }
//  else if ([userInput isEqualTo:@"10"]) {
//    return kAudioFormatMACE6;
//  }
//  else if ([userInput isEqualTo:@"11"]) {
//    return kAudioFormatULaw;
//  }
//  else if ([userInput isEqualTo:@"12"]) {
//    return kAudioFormatALaw;
//  }
//  else if ([userInput isEqualTo:@"13"]) {
//    return kAudioFormatQDesign;
//  }
//  else if ([userInput isEqualTo:@"14"]) {
//    return kAudioFormatQDesign2;
//  }
//  else if ([userInput isEqualTo:@"15"]) {
//    return kAudioFormatQUALCOMM;
//  }
//  else if ([userInput isEqualTo:@"16"]) {
//    return kAudioFormatMPEGLayer1;
//  }
//  else if ([userInput isEqualTo:@"17"]) {
//    return kAudioFormatMPEGLayer2;
//  }
//  else if ([userInput isEqualTo:@"18"]) {
//    return kAudioFormatMPEGLayer3;
//  }
//  else if ([userInput isEqualTo:@"19"]) {
//    return kAudioFormatTimeCode;
//  }
//  else if ([userInput isEqualTo:@"20"]) {
//    return kAudioFormatMIDIStream;
//  }
//  else if ([userInput isEqualTo:@"21"]) {
//    return kAudioFormatParameterValueStream;
//  }
//  else if ([userInput isEqualTo:@"22"]) {
//    return kAudioFormatAppleLossless;
//  }
//  else if ([userInput isEqualTo:@"23"]) {
//    return kAudioFormatMPEG4AAC_HE;
//  }
//  else if ([userInput isEqualTo:@"24"]) {
//    return kAudioFormatMPEG4AAC_LD;
//  }
//  else if ([userInput isEqualTo:@"25"]) {
//    return kAudioFormatMPEG4AAC_ELD;
//  }
//  else if ([userInput isEqualTo:@"26"]) {
//    return kAudioFormatMPEG4AAC_ELD_SBR;
//  }
//  else if ([userInput isEqualTo:@"27"]) {
//    return kAudioFormatMPEG4AAC_ELD_V2;
//  }
//  else if ([userInput isEqualTo:@"28"]) {
//    return kAudioFormatMPEG4AAC_HE_V2;
//  }
//  else if ([userInput isEqualTo:@"29"]) {
//    return kAudioFormatMPEG4AAC_Spatial;
//  }
//  else if ([userInput isEqualTo:@"30"]) {
//    return kAudioFormatMPEGD_USAC;
//  }
//  else if ([userInput isEqualTo:@"31"]) {
//    return kAudioFormatAMR;
//  }
//  else if ([userInput isEqualTo:@"32"]) {
//    return kAudioFormatAMR_WB;
//  }
//  else if ([userInput isEqualTo:@"33"]) {
//    return kAudioFormatAudible;
//  }
//  else if ([userInput isEqualTo:@"34"]) {
//    return kAudioFormatiLBC;
//  }
//  else if ([userInput isEqualTo:@"35"]) {
//    return kAudioFormatDVIIntelIMA;
//  }
//  else if ([userInput isEqualTo:@"36"]) {
//    return kAudioFormatMicrosoftGSM;
//  }
//  else if ([userInput isEqualTo:@"37"]) {
//    return kAudioFormatAES3;
//  }
//  else if ([userInput isEqualTo:@"38"]) {
//    return kAudioFormatEnhancedAC3;
//  }
//  else if ([userInput isEqualTo:@"39"]) {
//    return kAudioFormatFLAC;
//  }
//  else if ([userInput isEqualTo:@"40"]) {
//    return kAudioFormatOpus;
//  }
//  else {
//    NSException* exception = [NSException
//            exceptionWithName:@"InvalidAudioFormatSelectedException"
//            reason:@"Format Selected Is Invalid"
//            userInfo:nil];
//    [exception raise];
//  }
//  return 0;
}
