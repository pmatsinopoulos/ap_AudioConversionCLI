//
//  InitializeOutputAudioFile.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 9/6/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>
#import "CharPointerFilenameToNSURLp.h"
#import "CheckError.h"

void InitializeOutputAudioFile (AudioStreamBasicDescription iAudioBasicStreamDescription,
                                const char *iFileName,
                                AudioFileTypeID iAudioFileTypeID,
                                const char *iMessage,
                                AudioFileID *oAudioFileID) {
  CheckError(AudioFileCreateWithURL((__bridge CFURLRef) CharPointerFilenameToNSURLp(iFileName),
                                    iAudioFileTypeID,
                                    &iAudioBasicStreamDescription,
                                    kAudioFileFlags_EraseFile,
                                    oAudioFileID),
             iMessage);
}
