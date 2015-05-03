//
// Created by Sanjay Tourani on 5/1/15.
//

#import "HomeViewModel.h"
#import "DropboxService.h"
#import "Image.h"

@interface HomeViewModel ()
@property (nonatomic, strong) DropboxService *dropbox;
@property NSDictionary* gpsData;
@end

@implementation HomeViewModel

- (id)initWithDropbox:(DropboxService *)service {
    if (self = [super init]) {
        self.dropbox = service;
    }
    return self;
}

- (void)uploadImageToDropBox:(UIImage *)photo {
    NSString *tmpPngFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Temp.png"];

    Image *image = [[Image alloc] initWithUIImage:photo];

    [image writeToFile:tmpPngFile withGpsData:self.gpsData];

    [self.dropbox uploadFile:tmpPngFile];
}

/**
 * Stores the GPS data generated from the user's current location so that we'll have it when the user takes a picture.
 */
- (void)setGpsDataForCurrentLocation:(NSDictionary *)gpsData {
    self.gpsData = gpsData;
}

@end