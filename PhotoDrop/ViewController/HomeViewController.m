//
//  ViewController.m
//  PhotoDrop
//
//  Created by Josh Freed on 5/1/15.
//
//

#import "HomeViewController.h"
#import "HomeViewModel.h"
#import "ImageGpsData.h"
#import "AppDelegate.h"
#import "AppDependencies.h"
#import <DropboxSDK/DropboxSDK.h>

@interface HomeViewController ()
@property CLLocationManager *locationManager;
@property HomeViewModel *viewModel;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }

    self.viewModel = ((AppDelegate *)[UIApplication sharedApplication].delegate).dependencies.homeViewModel;

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    // todo better camera error detection
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(UIButton *)sender {
    // Start the location manager now so it's finding the user's location while he's taking a picture.
    // I need to have the location data already before the user presses the button to take a picture.
    [self.locationManager startUpdatingLocation];

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // We should have the user's current location by now.
    // This upload function assumes we have the location, otherwise GPS data won't be attached to the image.
    [self.viewModel uploadImageToDropBox:info[UIImagePickerControllerEditedImage]];

    // Done with location until the user takes another picture
    [self.locationManager stopUpdatingLocation];

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        ImageGpsData *imageGpsData = [[ImageGpsData alloc] initWithLocation:currentLocation];
        [self.viewModel setGpsDataForCurrentLocation:imageGpsData.gpsData];
    }
}

@end
