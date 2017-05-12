//
//  AppDelegate.m
//  AppLifecycle-Example
//
//  Created by Robert St. John on 5/11/17.
//  Copyright © 2017 Robert St. John. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property NSTimer *timer;
@property NSUInteger counter;
@property BOOL opsForegroundSuspendedState;
@property UIBackgroundTaskIdentifier bgTask;

@end

NSString *nameOfState(UIApplicationState state) {
    switch (state) {
        case UIApplicationStateActive:
            return @"UIApplicationStateActive";
        case UIApplicationStateInactive:
            return @"UIApplicationStateInactive";
        case UIApplicationStateBackground:
            return @"UIApplicationStateBackground";
    }
    return @"Unknown";
}

@implementation AppDelegate


- (instancetype)init
{
    self = [super init];

    _ops = [[NSOperationQueue alloc] init];
    _bgTask = UIBackgroundTaskInvalid;

    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self start];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"%s op count: %lu", __PRETTY_FUNCTION__, self.ops.operationCount);

    [self stop];

    self.opsForegroundSuspendedState = self.ops.suspended;
    self.ops.suspended = YES;
    if (self.enableBackground) {
        NSLog(@"enabling background tasks; op count: %lu", self.ops.operationCount);
        if (self.bgTask != UIBackgroundTaskInvalid) {
            self.bgTask = [UIApplication.sharedApplication beginBackgroundTaskWithName:@"AppLifecyle-Example" expirationHandler:^{
                self.ops.suspended = YES;
                [self backgroundTaskExpired];
            }];
        }
        self.ops.suspended = NO;
    }
    else if (self.ops.operationCount == 0) {
        [self backgroundTaskExpired];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"%s op count: %lu", __PRETTY_FUNCTION__, self.ops.operationCount);

    self.ops.suspended = self.opsForegroundSuspendedState;

    [self start];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)start
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(addOp) userInfo:nil repeats:YES];
}

- (void)stop
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)backgroundTaskExpired
{
    NSLog(@"background task expired; op count: %lu", self.ops.operationCount);
    [UIApplication.sharedApplication endBackgroundTask:self.bgTask];
    self.bgTask = UIBackgroundTaskInvalid;
}

- (void)addOp
{
    NSLog(@"adding operation; queue size %lu", self.ops.operationCount);
    [self.ops addOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"increment counter from %lu in state %@",
                self.counter, nameOfState(UIApplication.sharedApplication.applicationState));
            self.counter += 1;
            [NSNotificationCenter.defaultCenter postNotificationName:@"OpCountChanged" object:self userInfo:@{
                @"count": [NSNumber numberWithUnsignedInteger:self.counter].description}];
        });
    }];
}

@end
