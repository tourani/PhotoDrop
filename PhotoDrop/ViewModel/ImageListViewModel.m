//
// Created by Josh Freed on 5/1/15.
//

#import "ImageListViewModel.h"
#import "DropboxService.h"
#import "KVCMutableArray.h"
#import "ImageItem.h"

@interface ImageListViewModel ()
@property(nonatomic, strong) DropboxService *dropbox;
@end

@implementation ImageListViewModel

- (id)initWithDropbox:(DropboxService *)service {
    if (self = [super init]) {
        self.dropbox = service;
        self.imageItems = [[KVCMutableArray alloc] init];
    }
    return self;
}

- (void)loadImageItems {
    [self.dropbox loadImageFiles:^(DBMetadata *metadata) {
        if ([self hasImageItem:metadata.filename]) {
            ImageItem *imageItem = [self getImageItem:metadata.filename];
            [imageItem setValue:@0 forKey:@"isThumbnailLoaded"];
        } else {
            ImageItem *imageItem = [[ImageItem alloc] init];
            imageItem.name = metadata.filename;
            imageItem.remotePath = metadata.path;

            NSUInteger index = [self.imageItems countOfArray];
            [self.imageItems insertObject:imageItem inArrayAtIndex:index];
        }
    }];
}

- (BOOL)hasImageItem:(NSString*)filename {
    NSArray *array = [self.imageItems.array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [((ImageItem *) evaluatedObject).name isEqualToString:filename];
    }]];
    return array.count > 0;
}

- (ImageItem*)getImageItem:(NSString*)filename {
    NSArray *array = [self.imageItems.array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [((ImageItem *) evaluatedObject).name isEqualToString:filename];
    }]];
    return [array firstObject];
}

- (void)loadThumbnail:(ImageItem *)imageItem {
    [self.dropbox loadThumbnail:imageItem.remotePath toPath:[imageItem thumbPath] complete:^(NSString *string) {
        [imageItem setValue:@1 forKey:@"isThumbnailLoaded"];
    }];
}

@end
