//
//  ImageListViewModelTest.m
//  PhotoDrop
//
//  Created by Sanjay Tourani on 5/2/15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ImageListViewModel.h"
#import "DropboxMock.h"
#import "KVCMutableArray.h"
#import "ImageItem.h"

@interface ImageListViewModelTest : XCTestCase
@property DropboxMock *dropbox;
@property ImageListViewModel *vm;
@end

@implementation ImageListViewModelTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.dropbox = [[DropboxMock alloc] init];
    self.vm = [[ImageListViewModel alloc] initWithDropbox:self.dropbox];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInsertsNewImageItemsToTheList {
    [self.dropbox addImageFile:@"filename1" path:@"/path/to/filename1"];

    [self.vm loadImageItems];

    XCTAssertEqual(1, [self.vm.imageItems countOfArray]);
    [self assertImageItem:[self.vm.imageItems objectInArrayAtIndex:0] name:@"filename1" remotePath:@"/path/to/filename1"];
}

- (void)testInsertsMultipleNewImageItemsToTheList {
    [self.dropbox addImageFile:@"filename1" path:@"/path/to/filename1"];
    [self.dropbox addImageFile:@"filename2" path:@"/path/to/filename2"];
    [self.dropbox addImageFile:@"filename3" path:@"/path/to/filename3"];

    [self.vm loadImageItems];
    
    XCTAssertEqual(3, [self.vm.imageItems countOfArray]);
    [self assertImageItem:[self.vm.imageItems objectInArrayAtIndex:0] name:@"filename1" remotePath:@"/path/to/filename1"];
    [self assertImageItem:[self.vm.imageItems objectInArrayAtIndex:1] name:@"filename2" remotePath:@"/path/to/filename2"];
    [self assertImageItem:[self.vm.imageItems objectInArrayAtIndex:2] name:@"filename3" remotePath:@"/path/to/filename3"];
}

- (void)testOnlyInsertsItemsNotAlreadyInTheList {
    // First Insert 3
    [self.dropbox addImageFile:@"filename1" path:@"/path/to/filename1"];
    [self.dropbox addImageFile:@"filename2" path:@"/path/to/filename2"];
    [self.dropbox addImageFile:@"filename3" path:@"/path/to/filename3"];
    [self.vm loadImageItems];

    // Running it again will only insert the 4th and not duplicate the first three
    [self.dropbox addImageFile:@"filename4" path:@"/path/to/filename4"];
    [self.vm loadImageItems];

    XCTAssertEqual(4, [self.vm.imageItems countOfArray]);
    [self assertImageItem:[self.vm.imageItems objectInArrayAtIndex:0] name:@"filename1" remotePath:@"/path/to/filename1"];
    [self assertImageItem:[self.vm.imageItems objectInArrayAtIndex:1] name:@"filename2" remotePath:@"/path/to/filename2"];
    [self assertImageItem:[self.vm.imageItems objectInArrayAtIndex:2] name:@"filename3" remotePath:@"/path/to/filename3"];
    [self assertImageItem:[self.vm.imageItems objectInArrayAtIndex:3] name:@"filename4" remotePath:@"/path/to/filename4"];
}

- (void)testClearsThumbnailFlagOnExistingItems {
    [self.dropbox addImageFile:@"filename3" path:@"/path/to/filename3"];
    [self.vm loadImageItems];
    [[self.vm.imageItems objectInArrayAtIndex:0] setValue:@1 forKey:@"isThumbnailLoaded"];

    // Calling it again, won't re-add, but will clear out the thumbnail flag
    [self.vm loadImageItems];

    XCTAssertFalse(((ImageItem *)[self.vm.imageItems objectInArrayAtIndex:0]).isThumbnailLoaded);
}

- (void)testLoadsAThumbnailFromDropbox {
    ImageItem *imageItem = [[ImageItem alloc] init];
    imageItem.name = @"myFileName.png";
    imageItem.remotePath = @"/path/on/dropbox/myFileName.png";

    [self.vm loadThumbnail:imageItem];

    XCTAssertTrue([self.dropbox loadedThumbnailFor:imageItem.remotePath toPath:[imageItem thumbPath]]);
    XCTAssertTrue(imageItem.isThumbnailLoaded);
}



//
// Test Helper methods
//

- (void)assertImageItem:(ImageItem *)item name:(NSString *)name remotePath:(NSString *)remotePath {
    XCTAssertTrue([item isKindOfClass:[ImageItem class]]);
    XCTAssert([item.name isEqualToString:name]);
    XCTAssert([item.remotePath isEqualToString:remotePath]);
}

@end
