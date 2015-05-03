//
// Created by Sanjay Tourani on 5/1/15.
//

#import <ImageIO/ImageIO.h>
#import "ImageGpsData.h"


@interface ImageGpsData ()

@end

@implementation ImageGpsData

- (id)initWithLocation:(CLLocation *)location {
    if (self = [super init]) {
        self.gpsData = [self GPSDictionaryForLocation:location];
    }
    return self;
}

// Inspired by: http://stackoverflow.com/a/5314634/9849
// Simplified if-statements
// Updated to "modern" syntax
// Support optional CLHeading
// Support degree-of-precision
//
// This dictionary should then be added to the normal metadata using the kCGImagePropertyGPSDictionary key
- (NSDictionary *)GPSDictionaryForLocation:(CLLocation *)location
{
    NSMutableDictionary *gps = [NSMutableDictionary dictionary];

    // Example:
    /*
    "{GPS}" =     {
        Altitude = "41.28771929824561";
        AltitudeRef = 0;
        DateStamp = "2014:07:21";
        ImgDirection = "68.2140221402214";
        ImgDirectionRef = T;
        Latitude = "37.74252";
        LatitudeRef = N;
        Longitude = "122.42035";
        LongitudeRef = W;
        TimeStamp = "15:53:24";
    };
    */

    // GPS tag version
    // According to http://www.cipa.jp/std/documents/e/DC-008-2012_E.pdf,
    // this value is 2.3.0.0
    gps[(NSString *) kCGImagePropertyGPSVersion] = @"2.3.0.0";

    // Time and date must be provided as strings, not as an NSDate object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    formatter.dateFormat = @"HH:mm:ss.SSSSSS";
    gps[(NSString *)kCGImagePropertyGPSTimeStamp] = [formatter stringFromDate:location.timestamp];
    formatter.dateFormat = @"yyyy:MM:dd";
    gps[(NSString *)kCGImagePropertyGPSDateStamp] = [formatter stringFromDate:location.timestamp];

    // Latitude
    CLLocationDegrees latitude = location.coordinate.latitude;
    gps[(NSString *)kCGImagePropertyGPSLatitudeRef] = (latitude < 0) ? @"S" : @"N";
    gps[(NSString *)kCGImagePropertyGPSLatitude] = @(fabs(latitude));

    // Longitude
    CLLocationDegrees longitude = location.coordinate.longitude;
    gps[(NSString *)kCGImagePropertyGPSLongitudeRef] = (longitude < 0) ? @"W" : @"E";
    gps[(NSString *)kCGImagePropertyGPSLongitude] = @(fabs(longitude));

    // Degree of Precision
    gps[(NSString *)kCGImagePropertyGPSDOP] = @(location.horizontalAccuracy);

    // Altitude
    CLLocationDistance altitude = location.altitude;
    if (!isnan(altitude)) {
        gps[(NSString *)kCGImagePropertyGPSAltitudeRef] = (altitude < 0) ? @(1) : @(0);
        gps[(NSString *)kCGImagePropertyGPSAltitude] = @(fabs(altitude));
    }

    // Speed, must be converted from m/s to km/h
    if (location.speed >= 0) {
        gps[(NSString *)kCGImagePropertyGPSSpeedRef] = @"K";
        gps[(NSString *)kCGImagePropertyGPSSpeed] = @(location.speed * (3600.0/1000.0));
    }

    // Direction of movement
    if (location.course >= 0) {
        gps[(NSString *)kCGImagePropertyGPSTrackRef] = @"T";
        gps[(NSString *)kCGImagePropertyGPSTrack] = @(location.course);
    }

    return gps;
}

@end