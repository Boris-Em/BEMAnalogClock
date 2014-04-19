//
//  BEMHourHand.m
//  BEMAnalogClockView
//
//  Created by Boris Emorine on 2/24/14.
//  Copyright (c) 2014 Boris Emorine. All rights reserved.
//

#import "BEMHourHand.h"

@interface BEMHourHand (){

}

@property (strong, nonatomic) BEMHandsAnimation *animationDelegate;

@end

@implementation BEMHourHand

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.enableHourHandShadow = YES;
        
        self.animationDelegate = [[BEMHandsAnimation alloc] init];
        self.animationDelegate.delegate = self;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGPoint P1 = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - self.lengthH);
    CGPoint P2 = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + self.OffsetLengthH);

    if (self.enableHourHandShadow == YES) {
        UIBezierPath *pathShadow = [UIBezierPath bezierPath];
        [pathShadow setLineWidth:self.widthH];
        [pathShadow moveToPoint:CGPointMake(P1.x - 3, P1.y + 3)];
        [pathShadow addLineToPoint:CGPointMake(P2.x - 3, P2.y + 3)];
        pathShadow.lineCapStyle = kCGLineCapSquare;
        [[UIColor blackColor] set];
        [pathShadow strokeWithBlendMode:kCGBlendModeNormal alpha:self.alphaH/10];
    }
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 setLineWidth:self.widthH];
    [path1 moveToPoint:P1];
    [path1 addLineToPoint:P2];
    path1.lineCapStyle = kCGLineCapSquare;
    [self.colorH set];
    [path1 strokeWithBlendMode:kCGBlendModeNormal alpha:self.alphaH];
    
    [self.animationDelegate rotateHand:self rotationDegree:self.hourDegree];
}

@end