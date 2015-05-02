//
// Created by Josh Freed on 5/2/15.
//

#import <UIKit/UIKit.h>

@interface ImageItem : NSObject

- (NSString*)thumbPath;
- (NSString*)localPath;

@property NSString *name;
@property NSString *remotePath;
@property BOOL isThumbnailLoaded;

@end