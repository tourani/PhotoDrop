//
// Created by Sanjay Tourani on 5/1/15.
//

#import <UIKit/UIKit.h>

@class DropboxService;

@interface HomeViewModel : NSObject
- (void)uploadImageToDropBox:(UIImage*)photo;

- (id)initWithDropbox:(DropboxService *)service;

- (void)setGpsDataForCurrentLocation:(NSDictionary *)gpsData;
@end