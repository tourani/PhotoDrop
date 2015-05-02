//
// Created by Josh Freed on 5/1/15.
//

#import "Image.h"
#import <ImageIO/ImageIO.h>

@interface Image ()
@property(nonatomic, strong) UIImage *uiImage;
@end

@implementation Image

- (id)initWithUIImage:(UIImage *)image {
    if (self = [super init]) {
        self.uiImage = image;
    }
    return self;
}

- (void)writeToFile:(NSString*)fileName withGpsData:(NSDictionary *)gpsData {
    NSData *pngData = UIImagePNGRepresentation(self.uiImage);

    // The file has to be written to disk before it can be uploaded to dropbox
    // If we have gps data to attach, write the file w/ gps metadata
    // Otherwise do a simple write to file w/o metadata.
    // There *should* always be gps data at this point.

    if (gpsData != nil) {
        [self writeImageData:pngData toFile:fileName withGpsData:gpsData];
    } else {
        [pngData writeToFile:fileName atomically:NO];
    }
}

- (void)writeImageData:(NSData*)imageData toFile:(NSString*)file withGpsData:(NSDictionary*)gpsData {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef) imageData, NULL);

    // get all the metadata in the image
    NSDictionary *metadata = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, 0, NULL));

    //make the metadata dictionary mutable so we can add properties to it
    NSMutableDictionary *metadataAsMutable = [metadata mutableCopy];

    //add our modified data back into the image’s metadata
    metadataAsMutable[(NSString *) kCGImagePropertyGPSDictionary] = gpsData;

    CFStringRef UTI = CGImageSourceGetType(source); //this is the type of image (e.g., public.jpeg)

    //this will be the data CGImageDestinationRef will write into
    NSMutableData *destData = [NSMutableData data];

    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef) destData, UTI, 1, NULL);

    if (!destination) {
        NSLog(@"***Could not create image destination ***");
    }

    //add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef)metadataAsMutable);

    //tell the destination to write the image data and metadata into our data object.
    //It will return false if something goes wrong
    BOOL success = CGImageDestinationFinalize(destination);

    if (!success) {
        NSLog(@"***Could not create data from image destination ***");
    }

    // Now we have the data ready to go.
    [destData writeToFile:file atomically:YES];

    //cleanup
    CFRelease(destination);
    CFRelease(source);
}

@end