//
// Created by Josh Freed on 5/1/15.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface DropboxService : NSObject
- (void)uploadFile:(NSString *)filePath;
- (void)loadImageFiles:(void (^)(DBMetadata*))fileLoaded;
- (void)loadThumbnail:(NSString*)path toPath:(NSString*)toPath complete:(void (^)(NSString*))complete;
- (void)loadFile:(NSString*)path toPath:(NSString *)toPath callback:(void (^)(NSString*))complete;
@end