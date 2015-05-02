//
// Created by Josh Freed on 5/1/15.
//

#import <Foundation/Foundation.h>

@class DropboxService;
@class HomeViewModel;
@class ImageListViewModel;

@interface AppDependencies : NSObject
@property (nonatomic, strong) DropboxService *dropbox;
@property (nonatomic, strong) HomeViewModel *homeViewModel;
@property (nonatomic, strong) ImageListViewModel *imageListViewModel;
@end