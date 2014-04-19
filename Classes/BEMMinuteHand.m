//
//  BEMMinuteHand.m
//  BEMAnalogClockView
//
//  Created by Boris Emorine on 2/24/14.
//  Copyright (c) 2014 Boris Emorine. All rights reserved.
//

#import "BEMMinuteHand.h"

@interface BEMMinuteHand (){
 
}

@property (strong, nonatomic) BEMHandsAnimation *animationDelegate;

@end

@implementation BEMMinuteHand

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.enableMinuteHandShadow = YES;
        
        self.animationDelegate = [[BEMHandsAnimation alloc] init];
        self.animationDelegate.delegate = self;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGPoint P1 = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - self.lengthM);
    CGPoint P2 = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + self.OffsetLengthM);

    if (self.enableMinuteHandShadow == YES) {
        UIBezierPath *pathShadow = [UIBezierPath bezierPath];
        [pathShadow setLineWidth:self.widthM];
        [pathShadow moveToPoint:CGPointMake(P1.x - 3, P1.y + 3)];
        [pathShadow addLineToPoint:CGPointMake(P2.x - 3, P2.y + 3)];
        pathShadow.lineCapStyle = kCGLineCapSquare;
        [[UIColor blackColor] set];
        [pathShadow strokeWithBlendMode:kCGBlendModeNormal alpha:self.alphaM/10];
    }
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 setLineWidth:self.widthM];
    [path1 moveToPoint:P1];
    [path1 addLineToPoint:P2];
    path1.lineCapStyle = kCGLineCapSquare;
    [self.colorM set];
    [path1 strokeWithBlendMode:kCGBlendModeNormal alpha:self.alphaM];

    [self.animationDelegate rotateHand:self rotationDegree:self.minuteDegree];
}

@end
