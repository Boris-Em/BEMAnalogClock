//
//  ViewController.h
//  BEMAnalogClockView
//
//  Created by Boris Emorine on 2/23/14.
//  Copyright (c) 2014 Boris Emorine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMAnalogClockView.h"

@interface ViewController : UIViewController <BEMAnalogClockDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet BEMAnalogClockView *myClock1; // The big, main clock.
@property (weak, nonatomic) IBOutlet BEMAnalogClockView *myClock2; // The smaller clock.
@property (strong, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *currentTimeButton;
@property (weak, nonatomic) IBOutlet UIView *panView;

- (IBAction)pushRefreshButton:(id)sender;
- (IBAction)pushCurrentTimeButton:(id)sender;

@end
