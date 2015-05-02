//
// Created by Josh Freed on 5/1/15.
//

#import <Foundation/Foundation.h>

@class DropboxService;
@class KVCMutableArray;
@class ImageItem;

@interface ImageListViewModel : NSObject

- (id)initWithDropbox:(DropboxService *)service;
- (void)loadImageItems;
- (void)loadThumbnail:(ImageItem*)imageItem;

@property KVCMutableArray *imageItems;

@end