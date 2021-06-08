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

void OpenAudioFile(const char *fileName, AudioFileID *audioFile) {
  CheckError(AudioFileOpenURL((__bridge CFURLRef) CharPointerFilenameToNSURLp(fileName),
                              kAudioFileReadPermission,
                              0,
                              audioFile), "Opening the audio file");
}
