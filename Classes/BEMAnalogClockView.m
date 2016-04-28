//
//  BEMAnalogClockView.m
//  BEMAnalogClockView
//
//  Created by Boris Emorine on 2/23/14.
//  Copyright (c) 2014 Boris Emorine. All rights reserved.
//

#import "BEMAnalogClockView.h"

#if !__has_feature(objc_arc)
// Add the -fobjc-arc flag to enable ARC for only these files, as described in the ARC documentation: http://clang.llvm.org/docs/AutomaticReferenceCounting.html
#error BEMSimpleLineGraph is built with Objective-C ARC. You must enable ARC for these files.
#endif

@interface BEMAnalogClockView () {

    /// Flag used to detect if all of the subviews should be drawn/redrawn or not. Default value is YES.
    BOOL shouldUpdateSubviews;

    /// Flag used to detect if there is already a NSTimer that updates every second for the property realTime. Default value is NO.
    BOOL timerAlreadyInAction;
    
    /// Skip one cycle when the real time feature is on. Here to avoid animation conflicts.
    BOOL skipOneCycle;
}

/// Private property for the graduations' color of the clock. Default value is blackColor. Gets its value from calling graduationColorForIndex:
@property (weak, nonatomic) UIColor *graduationColor;

/// Private property for the graduations' alpha of the clock. Default value is 1.0. Gets its value from calling graduationAlphaForIndex:
@property (nonatomic) CGFloat graduationAlpha;

/// Private property for the graduations' width of the clock. Default value is 1.0. Gets its value from calling graduationWidthForIndex:
@property (nonatomic) CGFloat graduationWidth;

/// Private property for the graduations' Length of the clock. Default value is 5.0. Gets its value from calling graduationLengthForIndex:
@property (nonatomic) CGFloat graduationLength;

/// Private property for the graduations' offset (from the outside circled border) of the clock. Default value is 10.0. Gets its value from calling graduationOffsetForIndex:
@property (nonatomic) CGFloat graduationOffset;

/// The previous value of the minute hand. Used to detect when the minute hand goes from 59 to 0 (and vice versa) minute with the touch gesture. The hour value is then adjusted accordingly (+1 or -1).
@property (nonatomic, assign) NSInteger oldMinutes;

/// The minute hand. Subclass of UIView.
@property (nonatomic, strong) KSMHand *hourHand;

/// The minute hand. Subclass of UIView.
@property (nonatomic, strong) KSMHand *minuteHand;

/// The second hand. Subclass of UIView.
@property (nonatomic, strong) KSMHand *secondHand;

@end

@implementation BEMAnalogClockView

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // Do any initialization that's common to both -initWithFrame: and -initWithCoder: in this method
    
    // DEFAULT VALUES
    _hours = 10;
    _minutes = 10;
    _seconds = 0;
    
    _enableShadows = YES;
    _enableGraduations = YES;
    _enableDigit = NO;
    _enableHub = NO;
    _realTime = NO;
    _currentTime = NO;
    _setTimeViaTouch = NO;
    
    _faceBackgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    _faceBackgroundAlpha = 0.95;
    
    _borderColor = [UIColor whiteColor];
    _borderAlpha = 1.0;
    _borderWidth = 3;
    
    _hourHandColor = [UIColor whiteColor];
    _hourHandAlpha = 1.0;
    _hourHandWidth = 4;
    _hourHandLength = 30;
    _hourHandOffsideLength = 10;
    
    _minuteHandColor = [UIColor whiteColor];
    _minuteHandAlpha = 1.0;
    _minuteHandWidth = 3;
    _minuteHandLength = 55;
    _minuteHandOffsideLength = 20;
    
    _secondHandColor = [UIColor whiteColor];
    _secondHandAlpha = 1.0;
    _secondHandWidth = 1;
    _secondHandLength = 60;
    _secondHandOffsideLength = 20;

    _hubColor = [UIColor whiteColor];
    _hubAlpha = 1.0;
    _hubRadius = 3.0;

    _digitColor = [UIColor whiteColor];
    _digitFont  = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    _digitOffset = 0.0;
    
    self.backgroundColor = [UIColor clearColor];
    shouldUpdateSubviews = YES;
    timerAlreadyInAction = NO;
    skipOneCycle = NO;
    _realTimeIsActivated = NO;
    _militaryTime = NO;
}

- (void)layoutSubviews {
    if (shouldUpdateSubviews == YES) {
        
        if ([self.delegate respondsToSelector:@selector(clockDidBeginLoading:)])
            [self.delegate clockDidBeginLoading:self];
        
        if ([self.delegate respondsToSelector:@selector(dateFormatterForClock:)] && [self.delegate respondsToSelector:@selector(timeForClock:)])
            [self getTimeFromString];
        
        if (self.currentTime == YES) {
            [self setClockToCurrentTimeAnimated:YES];
        }
        
        [self timeFormatVerification];
        
        self.hourHand = [[KSMHand alloc] initWithFrame:self.bounds];
        self.hourHand.degree = [self degreesFromHour:self.hours andMinutes:self.minutes];
        self.hourHand.color = self.hourHandColor;
        self.hourHand.alpha = self.hourHandAlpha;
        self.hourHand.width = self.hourHandWidth;
        self.hourHand.length = self.hourHandLength;
        self.hourHand.offsetLength = self.hourHandOffsideLength;
        [self addSubview:self.hourHand];
        
        self.minuteHand = [[KSMHand alloc] initWithFrame:self.bounds];
        self.minuteHand.degree = [self degreesFromMinutes:self.minutes];
        self.minuteHand.color = self.minuteHandColor;
        self.minuteHand.alpha = self.minuteHandAlpha;
        self.minuteHand.width = self.minuteHandWidth;
        self.minuteHand.length = self.minuteHandLength;
        self.minuteHand.offsetLength = self.minuteHandOffsideLength;
        [self addSubview:self.minuteHand];
        
        self.secondHand = [[KSMHand alloc] initWithFrame:self.bounds];
        self.secondHand.degree = [self degreesFromMinutes:self.seconds];
        self.secondHand.color = self.secondHandColor;
        self.secondHand.alpha = self.secondHandAlpha;
        self.secondHand.width = self.secondHandWidth;
        self.secondHand.length = self.secondHandLength;
        self.secondHand.offsetLength = self.secondHandOffsideLength;
        [self addSubview:self.secondHand];
        
        if (self.enableShadows == NO) {
            self.hourHand.shadowEnabled = NO;
            self.minuteHand.shadowEnabled = NO;
            self.secondHand.shadowEnabled = NO;
        }
        
        if (self.realTime == YES && timerAlreadyInAction == NO) {
            _realTimeIsActivated = YES;
            timerAlreadyInAction = YES;
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(updateEverySecond)
                                           userInfo:nil
                                            repeats:YES];
        }
        
#if !(TARGET_OS_TV)
        if (self.setTimeViaTouch == YES) {
            UIView *panView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            panView.backgroundColor = [UIColor clearColor];
            [self.viewForBaselineLayout addSubview:panView];
            
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            panGesture.delegate = self;
            [panGesture setMaximumNumberOfTouches:1];
            [panView addGestureRecognizer:panGesture];
        }
#endif
        
        if ([self.delegate respondsToSelector:@selector(currentTimeOnClock:Hours:Minutes:Seconds:)]) {
        [self.delegate currentTimeOnClock:self Hours:[NSString stringWithFormat:@"%li", (long)self.hours] Minutes:[NSString stringWithFormat:@"%li", (long)self.minutes] Seconds:[NSString stringWithFormat:@"%li", (long)self.seconds]];
        }
        shouldUpdateSubviews = NO;
    
        if ([self.delegate respondsToSelector:@selector(clockDidFinishLoading:)])
            [self.delegate clockDidFinishLoading:self];
    }
}

#pragma mark - Real Time

- (void)updateEverySecond {
    if (_realTimeIsActivated == YES) {
        self.seconds = self.seconds + 1;
        if (skipOneCycle == YES) {
            skipOneCycle = NO;
        } else {
            [self timeFormatVerification];
            
            [self.secondHand setDegree:[self degreesFromMinutes:self.seconds] animated:YES];
            if ([self.delegate respondsToSelector:@selector(currentTimeOnClock:Hours:Minutes:Seconds:)]) {
                [self.delegate currentTimeOnClock:self Hours:[NSString stringWithFormat:@"%li", (long)self.hours] Minutes:[NSString stringWithFormat:@"%li", (long)self.minutes] Seconds:[NSString stringWithFormat:@"%li", (long)self.seconds]];
            }
        }
    }
}

#pragma mark - Update/Reload

- (void)reloadClock {
    for (UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    shouldUpdateSubviews = YES;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)updateTimeAnimated:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(dateFormatterForClock:)] && [self.delegate respondsToSelector:@selector(timeForClock:)])
        [self getTimeFromString];
    
    [self timeFormatVerification];
    
    skipOneCycle = animated;
    [self.minuteHand setDegree:[self degreesFromMinutes:self.minutes] animated:animated];
    [self.hourHand   setDegree:[self degreesFromHour:self.hours andMinutes:self.minutes] animated:animated];
    [self.secondHand setDegree:[self degreesFromMinutes:self.seconds] animated:animated];

    if ([self.delegate respondsToSelector:@selector(currentTimeOnClock:Hours:Minutes:Seconds:)]) {
        [self.delegate currentTimeOnClock:self Hours:[NSString stringWithFormat:@"%li", (long)self.hours] Minutes:[NSString stringWithFormat:@"%li", (long)self.minutes] Seconds:[NSString stringWithFormat:@"%li", (long)self.seconds]];
    }
}

- (void)setClockToCurrentTimeAnimated:(BOOL)animated {
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh"];
    NSString *currentHour = [dateFormatter stringFromDate: currentTime];
    [dateFormatter setDateFormat:@"mm"];
    NSString *currentMinute = [dateFormatter stringFromDate: currentTime];
    [dateFormatter setDateFormat:@"ss"];
    NSString *currentSecond = [dateFormatter stringFromDate: currentTime];
    
    self.hours = [currentHour integerValue];
    self.minutes = [currentMinute integerValue];
    self.seconds = [currentSecond integerValue];
    
    skipOneCycle = animated;
    [self.minuteHand setDegree:[self degreesFromMinutes:self.minutes] animated:animated];
    [self.hourHand   setDegree:[self degreesFromHour:self.hours andMinutes:self.minutes] animated:YES];
    [self.secondHand setDegree:[self degreesFromMinutes:self.seconds] animated:YES];

    if ([self.delegate respondsToSelector:@selector(currentTimeOnClock:Hours:Minutes:Seconds:)]) {
    [self.delegate currentTimeOnClock:self Hours:[NSString stringWithFormat:@"%li", (long)self.hours] Minutes:[NSString stringWithFormat:@"%li", (long)self.minutes] Seconds:[NSString stringWithFormat:@"%li", (long)self.seconds]];
    }
}

- (void)startRealTime {
    _realTimeIsActivated = YES;
    if (self.realTime == YES && timerAlreadyInAction == NO) {
        timerAlreadyInAction = YES;
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(updateEverySecond)
                                       userInfo:nil
                                        repeats:YES];
    }
}

- (void)stopRealTime {
    _realTimeIsActivated = NO;
}

#pragma mark - Touch Gestures

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer locationInView:self];
    CGFloat angleInRadians = atan2f(translation.y - self.frame.size.height/2, translation.x - self.frame.size.width/2);
    self.oldMinutes = self.minutes;
    self.minutes = ((atan2f((translation.x - self.frame.size.height/2), (translation.y - self.frame.size.width/2)) * -(180/M_PI) + 180))/6;
    
    if (self.oldMinutes > 45 && self.minutes < 15) { // If the user drags the minute hand from 59 to 00, updates the hour on the clock.
        self.hours++;
    }
    else if (self.oldMinutes < 15 && self.minutes > 45) { // If the user drags the minute hand from 00 to 59, updates the hour on the clock.
        self.hours--;
    }
    if (self.militaryTime == NO) {
        if (self.hours >= 13) {
            self.hours = 1;
        } else if (self.hours <= 0) {
            self.hours = 12;
        }
    } else {
        if (self.hours >= 24) {
            self.hours = 00;
        } else if (self.hours <= 0) {
            self.hours = 23;
        }
    }
    self.minuteHand.transform = CGAffineTransformMakeRotation(angleInRadians + M_PI/2);
    self.hourHand.transform = CGAffineTransformMakeRotation(([self degreesFromHour:self.hours andMinutes:self.minutes])*(M_PI/180));
    
    if ([self.delegate respondsToSelector:@selector(currentTimeOnClock:Hours:Minutes:Seconds:)]) {
        [self.delegate currentTimeOnClock:self Hours:[NSString stringWithFormat:@"%li", (long)self.hours] Minutes:[NSString stringWithFormat:@"%li", (long)self.minutes] Seconds:[NSString stringWithFormat:@"%li", (long)self.seconds]];
    }
}

#pragma mark - Conversions/Calculations

- (void)timeFormatVerification {
    if (self.hours > 12 && self.militaryTime == NO) // If the time has been set to military time, converts it to 12-hour clock.
        self.hours = self.hours - 12;
    
    if (self.seconds >= 60) {
        self.seconds = 0;
        self.minutes = self.minutes + 1;
        [self.minuteHand setDegree:[self degreesFromMinutes:self.minutes] animated:YES];
        [self.hourHand   setDegree:[self degreesFromHour:self.hours andMinutes:self.minutes] animated:YES];
    }
    else if (self.seconds < 0) {
        self.seconds = 59;
        self.minutes = self.minutes - 1;
        [self.minuteHand setDegree:[self degreesFromMinutes:self.minutes] animated:YES];
        [self.hourHand   setDegree:[self degreesFromHour:self.hours andMinutes:self.minutes] animated:YES];
    }
    
    if (self.minutes >= 60) {
        self.minutes = 0;
        self.hours = self.hours + 1;
    }
    else if (self.minutes < 0) {
        self.minutes = 59;
        self.hours = self.hours - 1;
    }
    if (self.militaryTime == NO) {
        if (self.hours >= 13) {
            self.hours = 1;
        } else if (self.hours <= 0) {
            self.hours = 12;
        }
    } else {
        if (self.hours >= 24) {
            self.hours = 00;
        } else if (self.hours < 0) {
            self.hours = 23;
        }
    }
}

- (float)degreesFromHour:(NSInteger)hour andMinutes:(NSInteger)minutes {
    float degrees = (hour*30) + (minutes/10)*6;
    return degrees;
}

- (float)degreesFromMinutes:(NSInteger)minutes {
    float degrees = minutes*6;
    return degrees;
}

- (void)getTimeFromString {
    NSString * stringDateFormatter = [self.delegate dateFormatterForClock:self];
    NSString * stringTime = [self.delegate timeForClock:self];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:stringDateFormatter];
    NSDate *time = [dateFormatter dateFromString:stringTime];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit) fromDate: time];
    
    NSInteger hours = [components hour];
    NSInteger minutes = [components minute];
    NSInteger seconds = [components second];
    
    self.hours = hours;
    self.minutes = minutes;
    self.seconds = seconds;
}

#pragma mark - Drawings

- (void)drawRect:(CGRect)rect {
    // CLOCK'S FACE
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetFillColorWithColor(ctx, self.faceBackgroundColor.CGColor);
    CGContextSetAlpha(ctx, self.faceBackgroundAlpha);
    CGContextFillPath(ctx);
    
    // CLOCK'S BORDER
    CGContextAddEllipseInRect(ctx, CGRectMake(rect.origin.x + self.borderWidth/2, rect.origin.y + self.borderWidth/2, rect.size.width - self.borderWidth, rect.size.height - self.borderWidth));
    CGContextSetStrokeColorWithColor(ctx, self.borderColor.CGColor);
    CGContextSetAlpha(ctx, self.borderAlpha);
    CGContextSetLineWidth(ctx,self.borderWidth);
    CGContextStrokePath(ctx);

    // HUB
    if (self.enableHub == YES) {
        CGContextSetFillColorWithColor(ctx, self.hubColor.CGColor);
        CGContextSetAlpha(ctx, self.hubAlpha);
        CGPoint center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
        CGContextAddArc(ctx, center.x, center.y, self.hubRadius, 0, 2 * M_PI, 0);
        CGContextFillPath(ctx);
    }

    // CLOCK'S GRADUATION
    if (self.enableGraduations == YES) {
        for (int i = 0; i<60; i++) {
            if ([self.delegate respondsToSelector:@selector(analogClock:graduationColorForIndex:)]) {
                self.graduationColor = [self.delegate analogClock:self graduationColorForIndex:i];
            } else self.graduationColor = [UIColor whiteColor];
        
            if ([self.delegate respondsToSelector:@selector(analogClock:graduationAlphaForIndex:)]) {
                self.graduationAlpha = [self.delegate analogClock:self graduationAlphaForIndex:i];
            } else self.graduationAlpha = 1.0;
        
            if ([self.delegate respondsToSelector:@selector(analogClock:graduationWidthForIndex:)]) {
                self.graduationWidth = [self.delegate analogClock:self graduationWidthForIndex:i];
            } else self.graduationWidth = 1.0;
        
            if ([self.delegate respondsToSelector:@selector(analogClock:graduationLengthForIndex:)]) {
                self.graduationLength = [self.delegate analogClock:self graduationLengthForIndex:i];
            } else self.graduationLength = 5.0;
        
            if ([self.delegate respondsToSelector:@selector(analogClock:graduationOffsetForIndex:)]) {
                self.graduationOffset = [self.delegate analogClock:self graduationOffsetForIndex:i];
            } else self.graduationOffset = 10.0;
        
            CGPoint P1 = CGPointMake((self.frame.size.width/2 + ((self.frame.size.width - self.borderWidth*2 - self.graduationOffset) / 2) * cos((6*i)*(M_PI/180)  - (M_PI/2))), (self.frame.size.width/2 + ((self.frame.size.width - self.borderWidth*2 - self.graduationOffset) / 2) * sin((6*i)*(M_PI/180)  - (M_PI/2))));
            CGPoint P2 = CGPointMake((self.frame.size.width/2 + ((self.frame.size.width - self.borderWidth*2 - self.graduationOffset - self.graduationLength) / 2) * cos((6*i)*(M_PI/180)  - (M_PI/2))), (self.frame.size.width/2 + ((self.frame.size.width - self.borderWidth*2 - self.graduationOffset - self.graduationLength) / 2) * sin((6*i)*(M_PI/180)  - (M_PI/2))));
        
            CAShapeLayer  *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path1 = [UIBezierPath bezierPath];
            shapeLayer.path = path1.CGPath;
            [path1 setLineWidth:self.graduationWidth];
            [path1 moveToPoint:P1];
            [path1 addLineToPoint:P2];
            path1.lineCapStyle = kCGLineCapSquare;
            [self.graduationColor set];
        
            [path1 strokeWithBlendMode:kCGBlendModeNormal alpha:self.graduationAlpha];
        }
    }
    
    // DIGIT DRAWING

    if (self.enableDigit == YES) {
        CGPoint center = CGPointMake(rect.size.width/2.0f, rect.size.height/2.0f);
        CGFloat markingDistanceFromCenter = rect.size.width/2.0f - self.digitFont.lineHeight/4.0f - 15 + self.digitOffset;
        NSInteger offset = 4;
        
        for(unsigned i = 0; i < 12; i ++){
            NSString *hourNumber = [NSString stringWithFormat:@"%@%d", [NSString stringWithFormat:@"%@", i+1<10 ? @" ": @""] , i + 1 ];
            CGFloat labelX = center.x + (markingDistanceFromCenter - self.digitFont.lineHeight/2.0f) * cos((M_PI/180)* (i+offset) * 30 + M_PI);
            CGFloat labelY = center.y + - 1 * (markingDistanceFromCenter - self.digitFont.lineHeight/2.0f) * sin((M_PI/180)*(i+offset) * 30);
            [hourNumber drawInRect:CGRectMake(labelX - self.digitFont.lineHeight/2.0f,labelY - self.digitFont.lineHeight/2.0f,self.digitFont.lineHeight,self.digitFont.lineHeight) withAttributes:@{NSForegroundColorAttributeName: self.digitColor, NSFontAttributeName: self.digitFont}];
        }
    }
}

@end
