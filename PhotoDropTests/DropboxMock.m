//
//  DropboxMock.m
//  PhotoDrop
//
//  Created by Josh Freed on 5/2/15.
//
//

#import "DropboxMock.h"

@implementation DropboxMock {
    NSMutableArray *imageFiles;
    NSString *fromPath;
    NSString *toPath;
}

- (id)init {
    if (self = [super init]) {
        imageFiles = [NSMutableArray array];
    }
    return self;
}

- (void)addImageFile:(NSString *)filename path:(NSString *)path {
    NSDictionary *dict = @{@"filename": filename, @"path": path};
    [imageFiles addObject:[[DBMetadata alloc] initWithDictionary:dict]];
}

- (void)loadImageFiles:(void (^)(DBMetadata *))fileLoaded {
    for (DBMetadata *metadata in imageFiles) {
        fileLoaded(metadata);
    }
}

- (void)loadThumbnail:(NSString *)path toPath:(NSString *)destPath complete:(void (^)(NSString *))complete {
    fromPath = path;
    toPath = destPath;
    complete(toPath);
}

- (BOOL)loadedThumbnailFor:(NSString *)path toPath:(NSString *)destPath {
    return [fromPath isEqualToString:path] && [toPath isEqualToString:destPath];
}


@end
