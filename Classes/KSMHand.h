//
//  KSMHand.h
//  AwesomeAlarm
//
//  Created by Kieraj Mumick on 4/25/14.
//  Copyright (c) 2014 KSM. All rights reserved.
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

@interface KSMHand : UIView

#pragma mark Public Properties

/// The color of the the hand instance
@property (strong, nonatomic) UIColor *color;

/// The widgth of the hand instance
@property (nonatomic) CGFloat width;

/// The length of the hand instance
@property (nonatomic) CGFloat length;

/// The length on the short side of the hand instance.
@property (nonatomic) CGFloat offsetLength;

/// Is there a shadow behind the hand
@property (nonatomic) BOOL shadowEnabled;

// The degree the hand should be rotated by.
@property (nonatomic) float degree;

- (void)setDegree:(float)degree animated:(BOOL)animated;

@end
