//
//  BEMHourHand.h
//  BEMAnalogClockView
//
//  Created by Boris Emorine on 2/24/14.
//  Copyright (c) 2014 Boris Emorine. All rights reserved.
//

#if __has_feature(objc_modules)
// We recommend enabling Objective-C Modules in your project Build Settings for numerous benefits over regular #imports
    @import Foundation;
    @import UIKit;
    @import CoreGraphics;
#else
    #import <Foundation/Foundation.h>
    #import <UIKit/UIKit.h>
    #import <CoreGraphics/CoreGraphics.h>
#endif

#import "BEMHandsAnimation.h"

/// Subclass of UIVIew for the minute hand.
@interface BEMHourHand : UIView <BEMAnimationDelegate>

@property (nonatomic) float hourDegree;

@property (nonatomic) bool enableHourHandShadow;

@property (strong, nonatomic) UIColor *colorH;
@property (nonatomic) CGFloat alphaH;
@property (nonatomic) CGFloat widthH;
@property (nonatomic) CGFloat lengthH;
@property (nonatomic) CGFloat OffsetLengthH;

@end
