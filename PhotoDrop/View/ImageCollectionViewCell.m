//
// Created by Sanjay Tourani on 5/1/15.
//

#import "ImageCollectionViewCell.h"
#import "ImageCollectionViewController.h"
#import "ImageListViewModel.h"
#import "ImageItem.h"

@interface ImageCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property ImageItem *imageItem;
@end

@implementation ImageCollectionViewCell

- (void)configureCell:(ImageItem *)imageItem {
    self.imageItem = imageItem;
}

- (void)showThumbnail {
    UIImage *thumbImage = [UIImage imageWithContentsOfFile:[self.imageItem thumbPath]];
    [self.imageView setImage:thumbImage];
}

@end