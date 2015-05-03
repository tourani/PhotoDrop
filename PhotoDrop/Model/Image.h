//
// Created by Sanjay Tourani on 5/1/15.
//

#import <UIKit/UIKit.h>

@interface Image : NSObject
- (id)initWithUIImage:(UIImage *)image;
- (void)writeToFile:(NSString*)fileName withGpsData:(NSDictionary *)gpsData;
@end