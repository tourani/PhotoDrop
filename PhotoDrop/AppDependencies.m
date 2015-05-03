//
// Created by Sanjay Tourani on 5/1/15.
//

#import "AppDependencies.h"
#import "DropboxService.h"
#import "HomeViewModel.h"
#import "ImageListViewModel.h"

@implementation AppDependencies

- (id)init {
    if (self = [super init]) {
        self.dropbox = [[DropboxService alloc] init];
        self.homeViewModel = [[HomeViewModel alloc] initWithDropbox:self.dropbox];
        self.imageListViewModel = [[ImageListViewModel alloc] initWithDropbox:self.dropbox];
    }
    return self;
}

@end