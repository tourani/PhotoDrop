//
//  AppDelegate.h
//  PhotoDrop
//
//  Created by Josh Freed on 5/1/15.
//
//

#import <UIKit/UIKit.h>

@class AppDependencies;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AppDependencies *dependencies;

@end

