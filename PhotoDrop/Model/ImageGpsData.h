//
// Created by Josh Freed on 5/1/15.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ImageGpsData : NSObject
@property(nonatomic, strong) NSDictionary *gpsData;

- (id)initWithLocation:(CLLocation *)location;
@end