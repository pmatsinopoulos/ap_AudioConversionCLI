//
//  CharPointerFilenameToNSURLp.m
//  audio_conversion
//
//  Created by Panayotis Matsinopoulos on 31/5/21.
//

#import <Foundation/Foundation.h>

NSURL *CharPointerFilenameToNSURLp(const char *inFilename) {
  NSString *filePath = [[NSString stringWithUTF8String:inFilename] stringByExpandingTildeInPath];
  return [NSURL fileURLWithPath:filePath];
}
