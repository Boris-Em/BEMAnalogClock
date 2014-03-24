//
//  ViewController.m
//  BEMAnalogClockView
//
//  Created by Boris Emorine on 2/23/14.
//  Copyright (c) 2014 Boris Emorine. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myClock1.enableShadows = YES;
    self.myClock1.realTime = YES;
    self.myClock1.currentTime = YES;
    self.myClock1.setTimeViaTouch = YES;
    self.myClock1.borderColor = [UIColor whiteColor];
    self.myClock1.borderWidth = 3;
    self.myClock1.faceBackgroundColor = [UIColor whiteColor];
    self.myClock1.faceBackgroundAlpha = 0.0;
    self.myClock1.delegate = self;
    
    self.myClock2.setTimeViaTouch = NO;
    self.myClock2.enableGraduations = NO;
    self.myClock2.realTime = YES;
    self.myClock2.currentTime = YES;
    self.myClock2.faceBackgroundAlpha = 0;
    self.myClock2.enableShadows = NO;
    self.myClock2.borderColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    self.myClock2.hourHandColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    self.myClock2.minuteHandColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    self.myClock2.borderWidth = 1;
    self.myClock2.hourHandWidth = 1.0;
    self.myClock2.hourHandLength = 10;
    self.myClock2.minuteHandWidth = 1.0;
    self.myClock2.minuteHandLength = 15;
    self.myClock2.minuteHandOffsideLength = 0;
    self.myClock2.hourHandOffsideLength = 0;
    self.myClock2.secondHandAlpha = 0;
    self.myClock2.delegate = self;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    [panGesture setMaximumNumberOfTouches:1];
    [self.panView addGestureRecognizer:panGesture];
}

- (CGFloat)analogClock:(BEMAnalogClockView *)clock graduationLengthForIndex:(NSInteger)index {
    if (clock.tag == 1) {
        if (!(index % 5) == 1) { // Every 5 graduation will be longer.
            return 20;
        } else {
            return 5;
        }
    }
    else return 0;
}

- (UIColor *)analogClock:(BEMAnalogClockView *)clock graduationColorForIndex:(NSInteger)index {
    if (!(index % 15) == 1) { // Every 15 graduation will be blue.
        return [UIColor blueColor];
    } else {
        return [UIColor whiteColor];
    }
}

- (void)currentTimeOnClock:(BEMAnalogClockView *)clock Hours:(NSString *)hours Minutes:(NSString *)minutes Seconds:(NSString *)seconds {
    if (clock.tag == 1) {
        self.myLabel.text = [NSString stringWithFormat:@"%@:%@:%@", hours, minutes, seconds];
     }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer locationInView:self.view];
    self.myClock1.minutes = translation.x / 5.33333;
    [self matchHoursClock1ToClock2];
    [self.myClock1 updateTimeAnimated:NO];
    [self.myClock2 updateTimeAnimated:NO];
}

- (IBAction)pushRefreshButton:(id)sender {
    self.myClock1.hours = arc4random() % 12;
    self.myClock1.minutes = arc4random() % 60;
    self.myClock1.seconds = arc4random() % 60;
    [self matchHoursClock1ToClock2];
    [self.myClock1 updateTimeAnimated:YES];
    [self.myClock2 updateTimeAnimated:YES];
}

- (IBAction)pushCurrentTimeButton:(id)sender {
    [self.myClock1 setClockToCurrentTime:YES];
    [self.myClock2 setClockToCurrentTime:YES];
}

- (void)matchHoursClock1ToClock2 {
    self.myClock2.hours = self.myClock1.hours;
    self.myClock2.minutes = self.myClock1.minutes;
    self.myClock2.seconds = self.myClock1.seconds;
}


/*
 These two methods are commented out because the time on the clock is set up by directly giving values to the 'hours' and 'minutes' properties (see 'viewDidLoad').
 However, the code remains as an example to set up the time on the clock with these two methods.
 
 - (NSString *)dateFormatterForClock:(BEMAnalogClockView *)clock {
 return @"MM, dd yyyy HH:mm:ss";
 }
 
 - (NSString *)timeForClock:(BEMAnalogClockView *)clock {
 return @"11, 03 1982 22:34:22";
 } */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
