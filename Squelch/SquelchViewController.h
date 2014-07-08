//
//  SquelchViewController.h
//  Squelch
//
//  Created by Alec Huang on 5/25/14.
//  Copyright (c) 2014 Team Nexus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SquelchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelSquelch;

@property (weak, nonatomic) IBOutlet UILabel *labelRestoreAt;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerTime;

@property (weak, nonatomic) IBOutlet UIButton *buttonStart;

// Background task bypass
@property (nonatomic, strong) NSTimer *silenceTimer;

@end
