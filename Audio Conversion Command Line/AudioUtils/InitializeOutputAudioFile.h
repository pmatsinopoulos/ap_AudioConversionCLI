//
//  InitializeOutputAudioFile.h
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 9/6/21.
//

#ifndef InitializeOutputAudioFile_h
#define InitializeOutputAudioFile_h

void InitializeOutputAudioFile (AudioStreamBasicDescription iAudioBasicStreamDescription,
                                const char *iFileName,
                                AudioFileTypeID iAudioFileTypeID,
                                const char *iMessage,
                                AudioFileID *oAudioFileID);

#endif /* InitializeOutputAudioFile_h */
