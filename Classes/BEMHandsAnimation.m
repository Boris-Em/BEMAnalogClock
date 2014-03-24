//
//  BEMHandsAnimation.m
//  BEMAnalogClockView
//
//  Created by Boris Emorine on 3/9/14.
//  Copyright (c) 2014 Boris Emorine. All rights reserved.
//

#import "BEMHandsAnimation.h"

@implementation BEMHandsAnimation

- (void)rotateHand:(UIView *)view rotationDegree:(float)degree{
    [UIView animateWithDuration:1.0
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.transform = CGAffineTransformMakeRotation((degree)*(M_PI/180));
                     } completion:^(BOOL finished) {
                     }];
}

@end