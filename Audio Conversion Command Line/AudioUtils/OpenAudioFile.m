//
//  OpenAudioFile.m
//  Audio Conversion Command Line
//
//  Created by Panayotis Matsinopoulos on 29/5/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>
#import "CheckError.h"
#import "CharPointerFilenameToNSURLp.h"

void OpenAudioFile(const char *iFileName, AudioFileID *oAudioFileID) {
  CheckError(AudioFileOpenURL((__bridge CFURLRef) CharPointerFilenameToNSURLp(iFileName),
                              kAudioFileReadPermission,
                              0,
                              oAudioFileID),
             "Opening the audio file");
}
