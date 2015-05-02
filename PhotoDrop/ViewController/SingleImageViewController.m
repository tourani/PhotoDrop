//
//  SingleImageViewController.m
//  PhotoDrop
//
//  Created by Josh Freed on 5/1/15.
//
//

#import "SingleImageViewController.h"
#import "DropboxService.h"
#import "AppDelegate.h"
#import "AppDependencies.h"
#import "ImageItem.h"

@interface SingleImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation SingleImageViewController {
    DropboxService *dropbox;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    dropbox = ((AppDelegate *)[UIApplication sharedApplication].delegate).dependencies.dropbox;

    [dropbox loadFile:self.imageItem.remotePath toPath:[self.imageItem localPath] callback:^(NSString *string) {
        self.imageView.image = [UIImage imageWithContentsOfFile:string];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
