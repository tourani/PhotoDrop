//
// Created by Josh Freed on 5/2/15.
//

#import "ImageItem.h"

@implementation ImageItem

- (NSString*)thumbPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"THUMB_%@", self.name]];
}

- (NSString *)localPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:self.name];
}

@end