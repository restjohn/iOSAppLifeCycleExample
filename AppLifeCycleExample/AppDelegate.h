//
//  AppDelegate.h
//  AppLifecycle-Example
//
//  Created by Robert St. John on 5/11/17.
//  Copyright © 2017 Robert St. John. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property NSOperationQueue *ops;
@property BOOL enableBackground;

@end

