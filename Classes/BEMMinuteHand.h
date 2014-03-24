//
//  BEMMinuteHand.h
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
@interface BEMMinuteHand : UIView <BEMAnimationDelegate>

@property (nonatomic) float minuteDegree;

@property (nonatomic) bool enableMinuteHandShadow;

@property (strong, nonatomic) UIColor *colorM;
@property (nonatomic) CGFloat alphaM;
@property (nonatomic) CGFloat widthM;
@property (nonatomic) CGFloat lengthM;
@property (nonatomic) CGFloat OffsetLengthM;

@end
