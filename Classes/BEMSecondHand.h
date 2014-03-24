//
//  BEMSecondHand.h
//  BEMAnalogClockView
//
//  Created by Boris Emorine on 3/9/14.
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

/// Subclass of UIVIew for the second hand.
@interface BEMSecondHand : UIView <BEMAnimationDelegate>

@property (nonatomic) float secondDegree;

@property (nonatomic) bool enableSecondHandShadow;

@property (strong, nonatomic) UIColor *colorS;
@property (nonatomic) CGFloat alphaS;
@property (nonatomic) CGFloat widthS;
@property (nonatomic) CGFloat lengthS;
@property (nonatomic) CGFloat OffsetLengthS;

@end
