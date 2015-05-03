//
//  AppDelegate.h
//  PhotoDrop
//
//  Created by Sanjay Tourani on 5/1/15.
//
//

#import <UIKit/UIKit.h>

@class AppDependencies;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AppDependencies *dependencies;

@end

