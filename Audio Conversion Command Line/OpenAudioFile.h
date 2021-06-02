//
//  OpenAudioFile.h
//  Audio Conversion Command Line
//
//  Created by Panayotis Matsinopoulos on 29/5/21.
//

#ifndef OpenAudioFile_h
#define OpenAudioFile_h

#import <AudioToolbox/AudioFile.h>

void OpenAudioFile(const char *fileName, AudioFileID *audioFile);

#endif /* OpenAudioFile_h */
