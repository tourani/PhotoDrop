//
//  DropboxMock.h
//  PhotoDrop
//
//  Created by Sanjay Tourani on 5/2/15.
//
//

#import <Foundation/Foundation.h>
#import "DropboxService.h"

@interface DropboxMock : DropboxService
- (void)addImageFile:(NSString *)filename path:(NSString *)path;
- (BOOL)loadedThumbnailFor:(NSString *)path toPath:(NSString *)destPath;
@end
