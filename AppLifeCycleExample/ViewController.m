//
//  ViewController.m
//  AppLifecycle-Example
//
//  Created by Robert St. John on 5/11/17.
//  Copyright © 2017 Robert St. John. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) AppDelegate *app;
@property (weak, nonatomic) IBOutlet UILabel *opCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *queueSizeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *runTasksSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *enableBackgroundSwitch;

- (IBAction)runTasksSwitchChanged;
- (IBAction)enabledBackgroundSwitchChanged;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"%s", __PRETTY_FUNCTION__);

    self.app = (AppDelegate *)UIApplication.sharedApplication.delegate;
    self.runTasksSwitch.on = !self.app.ops.suspended;
    self.enableBackgroundSwitch.on = self.app.enableBackground;
    self.queueSizeLabel.text = [NSNumber numberWithUnsignedInteger:self.app.ops.operationCount].description;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(opCountChanged:) name:@"OpCountChanged" object:nil];
    [self.app.ops addObserver:self forKeyPath:NSStringFromSelector(@selector(operationCount)) options:0 context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [self.app.ops removeObserver:self forKeyPath:NSStringFromSelector(@selector(operationCount))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)opCountChanged:(NSNotification *)note
{
    self.opCountLabel.text = note.userInfo[@"count"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.queueSizeLabel.text = [NSNumber numberWithUnsignedInteger:self.app.ops.operationCount].description;
    });
}

- (IBAction)runTasksSwitchChanged
{
    self.app.ops.suspended = !self.runTasksSwitch.isOn;
}

- (IBAction)enabledBackgroundSwitchChanged
{
    self.app.enableBackground = self.enableBackgroundSwitch.isOn;
}

@end
