
//  ImageCollectionViewController.m
//  PhotoDrop
//
//  Created by Josh Freed on 5/1/15.
//
//

#import "ImageCollectionViewController.h"
#import "AppDelegate.h"
#import "AppDependencies.h"
#import "ImageCollectionViewCell.h"
#import "SingleImageViewController.h"
#import "ImageListViewModel.h"
#import "KVCMutableArray.h"
#import "ImageItem.h"

@interface ImageCollectionViewController ()
@property ImageListViewModel *viewModel;
@end

@implementation ImageCollectionViewController

static NSString * const reuseIdentifier = @"ImageCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewModel = ((AppDelegate *)[UIApplication sharedApplication].delegate).dependencies.imageListViewModel;
}

- (void)viewWillAppear:(BOOL)animated {
    // reattached observers that may have been removed in viewWillDisappear
    [self.viewModel addObserver:self forKeyPath:@"imageItems.array" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    for (ImageItem *item in self.viewModel.imageItems.array) {
        [item addObserver:self forKeyPath:@"isThumbnailLoaded" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }

    // Load the photos in my dropbox
    [self.viewModel loadImageItems];
}

- (void)viewWillDisappear:(BOOL)animated {
    // gotta remove observers when the view disappears or things will crash
    [self.viewModel removeObserver:self forKeyPath:@"imageItems.array"];
    for (ImageItem *item in self.viewModel.imageItems.array) {
        [item removeObserver:self forKeyPath:@"isThumbnailLoaded"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"imageItems.array"]) {
        // called when an item is added to the imageItems list. this happens when dropbox is finished loading files in its directory
        if ([change[@"kind"] isEqual:@2]) {
            NSIndexSet *indexSet = change[@"indexes"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[indexSet firstIndex] inSection:0];
            NSArray *indexPaths = @[indexPath];
            [self.collectionView insertItemsAtIndexPaths:indexPaths];

            ImageItem *item = [self.viewModel.imageItems objectInArrayAtIndex:indexPath.row];
            [item addObserver:self forKeyPath:@"isThumbnailLoaded" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];

            [self.viewModel loadThumbnail:item];
        }
    }

    if ([keyPath isEqualToString:@"isThumbnailLoaded"]) {
        if ([change[@"new"] isEqual:@0]) {
            // If isThumbnailLoaded was changed to false, then we're missing a thumbnail for this photo and need to load it
            [self.viewModel loadThumbnail:(ImageItem *) object];
        } else {
            // If isThumbnailLoaded was changed to tru, then update the view to display the thumbnail image
            ImageItem *item = (ImageItem *) object;
            NSUInteger index = [self.viewModel.imageItems.array indexOfObject:item];
            ImageCollectionViewCell *cell = (ImageCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [cell showThumbnail];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowImage"]) {
        SingleImageViewController *vc = segue.destinationViewController;
        vc.imageItem = (ImageItem*)sender;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.imageItems.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    ImageItem *imageItem = [self.viewModel.imageItems objectInArrayAtIndex:(NSUInteger) indexPath.row];
    [cell configureCell:imageItem];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {

}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowImage" sender:[self.viewModel.imageItems objectInArrayAtIndex:indexPath.row]];
}

@end
