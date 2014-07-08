//
//  SquelchViewController.m
//  Squelch
//
//  Created by Alec Huang on 5/25/14.
//  Copyright (c) 2014 Team Nexus. All rights reserved.
//

#import "SquelchViewController.h"

@import CoreLocation;

@interface SquelchViewController ()

@end

// Enable editing of DND
typedef NS_ENUM(NSInteger, BBBehaviorOverrideStatus) {
    BBBehaviorOverrideStatusOn = 1,
    BBBehaviorOverrideStatusOff = 2
};

@interface BBSettingsGateway : NSObject
- (void)setBehaviorOverrideStatus:(BBBehaviorOverrideStatus)status;
- (void)getBehaviorOverridesWithCompletion:(void (^)(BOOL disabled))completion;
- (void)setActiveBehaviorOverrideTypesChangeHandler:(void (^)(BOOL disabled))handler;
@end

@implementation SquelchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Sets DND to OFF when starting
    BBSettingsGateway *_settingsGateway = [[BBSettingsGateway alloc] init];
    [_settingsGateway setBehaviorOverrideStatus:BBBehaviorOverrideStatusOff];
    
    // Background task bypass
    UIBackgroundTaskIdentifier bgTask;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    self.silenceTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self
                                                       selector:@selector(startLocationServices) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Start button activates Do Not Disturb
- (IBAction)buttonStart:(id)sender {
    [[MPMusicPlayerController iPodMusicPlayer] setVolume:0.0];
    BBSettingsGateway *_settingsGateway = [[BBSettingsGateway alloc] init];
    [_settingsGateway setBehaviorOverrideStatus:BBBehaviorOverrideStatusOn];
    NSDate *date = self.datePickerTime.date;
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:date interval:0 target:self selector:@selector(turnOffDND) userInfo:nil repeats:nil];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

// Turns off Do Not Disturb
- (void)turnOffDND
{
    BBSettingsGateway *_settingsGateway = [[BBSettingsGateway alloc] init];
    [_settingsGateway setBehaviorOverrideStatus:BBBehaviorOverrideStatusOff];
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate); // Vibrate
}

// Background task bypass
- (void)startLocationServices {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    
    [locationManager stopUpdatingLocation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
