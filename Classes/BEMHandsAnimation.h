//
//  BEMHandsAnimation.h
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

@protocol BEMAnimationDelegate <NSObject>

@end

/// Class for the animation of the clock's hands.
@interface BEMHandsAnimation : NSObject

@property (assign) id <BEMAnimationDelegate> delegate;

- (void)rotateHand:(UIView *)view rotationDegree:(float)degree;

@end