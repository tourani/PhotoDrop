//
// Created by Sanjay Tourani on 5/1/15.
//

#import <UIKit/UIKit.h>

@class ImageItem;

@interface ImageCollectionViewCell : UICollectionViewCell
- (void)configureCell:(ImageItem *)imageItem;
- (void)showThumbnail;
@end