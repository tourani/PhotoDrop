//
// Created by Josh Freed on 5/1/15.
//

#import "DropboxService.h"

@interface DropboxService () <DBRestClientDelegate>
@property (nonatomic, strong) DBRestClient *restClient;
@property NSMutableDictionary *thumbnailCallbacks;
@end

@implementation DropboxService {
    void (^loadFileCallback)(NSString *);
    void (^fileMetaDataCallback)(DBMetadata *);
}

- (id)init {
    if (self = [super init]) {
        self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        self.restClient.delegate = self;
        self.thumbnailCallbacks = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)uploadFile:(NSString *)filePath {
    [self.restClient uploadFile:@"photo.png" toPath:@"/" withParentRev:nil fromPath:filePath];
}

- (void)loadImageFiles:(void (^)(DBMetadata *))fileLoaded {
    fileMetaDataCallback = fileLoaded;
    [self.restClient loadMetadata:@"/"];
}

- (void)loadFile:(NSString*)path toPath:(NSString *)toPath callback:(void (^)(NSString*))complete {
    loadFileCallback = complete;
    [self.restClient loadFile:path intoPath:toPath];
}

- (void)loadThumbnail:(NSString *)path toPath:(NSString *)toPath complete:(void (^)(NSString *))complete {
    [self.thumbnailCallbacks setValue:complete forKey:toPath];
    [self.restClient loadThumbnail:path ofSize:@"s" intoPath:toPath];
}

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath {
    NSLog(@"Upload complete: %@", destPath);
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        for (DBMetadata *file in metadata.contents) {
            if (fileMetaDataCallback) {
                fileMetaDataCallback(file);
            }
        }
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath {
    if (loadFileCallback != nil) {
        loadFileCallback(destPath);
    }
}

-(void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {

}

-(void)restClient:(DBRestClient *)client loadedThumbnail:(NSString *)destPath {
    if (self.thumbnailCallbacks[destPath]) {
        void (^callback)(NSString *) = [self.thumbnailCallbacks valueForKey:destPath];
        callback(destPath);
        [self.thumbnailCallbacks removeObjectForKey:destPath];
    }
}

@end