//
//  KSMHand.m
//  AwesomeAlarm
//
//  Created by Kieraj Mumick on 4/25/14.
//  Copyright (c) 2014 KSM. All rights reserved.
//

#import "KSMHand.h"

@implementation KSMHand

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

    // the frame needs to be drawn as if it is in a cartesian plane,
    // with the center of rotation at what is thought of as (0, 0) and
    // the far end to the top of the center, this way when we rotate
    // the view, it will look correct.

    CGPoint const center = self.center;

    // point that is the top of the hand (closes to the edge of the clock)
    CGPoint const top = CGPointMake(center.x, center.y - self.length);
    
    // point at the bottom of the hand, a total distance offsetLength away from
    // the center of rotation.
    CGPoint const bottom = CGPointMake(center.x, center.y + self.offsetLength);
    
    // draw the line from the bottom to the top that has line width self.width.
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:self.width];
    [path moveToPoint:bottom];
    [path addLineToPoint:top];
    [self.color set]; // sets teh color of the hand to be the color of the path
    [path stroke];
}

- (void)setDegree:(float)degree {
    [self setDegree:degree animated:NO];
}

- (void)setDegree:(float)degree animated:(BOOL)animated {
    _degree = degree;
    CGAffineTransform const transform = CGAffineTransformMakeRotation(self.degree * M_PI / 180);

    if (animated) {
        // animate for one second (default best time to animate - for a second hand
        // it will take exactly 1 second to move, and for the other hands it doesn't
        // really matter how long it takes to move.
        [UIView animateWithDuration:1.0
                         animations:^{
                             self.transform = transform;
                         }];
    } else {
        self.transform = transform;
    }
}

@end
