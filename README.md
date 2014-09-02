# BEMAnalogClock

[![Build Status](https://travis-ci.org/Boris-Em/BEMAnalogClock.svg?branch=master)](https://travis-ci.org/Boris-Em/BEMAnalogClock)

<p align="center"><img src="http://s18.postimg.org/hsff40p5l/BEMAnalog_Clock_Main.png"/></p>

<p align="center">
<b>BEMAnalogClock</b> makes it easy to create and customize clocks for iOS.
</p>

## Table of Contents

* [**Project Details**](#project-details)
  * [Requirements](#requirements)
  * [License](#license)
  * [Contributions](#contributions)
  * [Sample App](#sample-app)
  * [Support](#support)
* [**Documentation**](#documentation)
  * [Installation](#installation)
  * [Setup](#setup)
  * [Setting up the time on the clock](#setting-up-the-time-on-the-clock)
  * [Reloading the clock](#reloading-the-clock) 
  * [Updating the time on the clock](#updating-the-time-on-the-clock)
  * [Current time](#current-time)
  * [Real time](#real-time)
  * [Time reporting](#time-reporting)
  * [Adjusting the time on the clock via touch](#adjusting-the-time-on-the-clock-via-touch)
  * [Customization](#customization)
  * [Military Time](#military-time-24-hours)
  * [Status reporting](#status-reporting)

## Project Details
Learn more about the BEMAnalogClock project requirements, licensing, and contributions.

### Requirements
- Requires iOS 6 or later. The sample project is optimized for iOS 7.
- Requires Automatic Reference Counting (ARC).
- Optimized for ARM64 Architecture

### License
See the [License]( https://github.com/Boris-Em/BEMAnalogClock/blob/master/LICENSE). You are free to make changes and use this in either personal or commercial projects. Attribution is not required, but it is appreciated. A little Thanks! (or something to that affect) would be much appreciated. If you use BEMAnalogClock in your app, let us know.

### Contributions
Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub. 

### Sample App
The iOS Sample App included with this project demonstrates how to correctly setup and use BEMAnalogClock. You can refer to the sample app for an understanding of how to use and setup BEMAnalogClock.

### Support
[![Gitter chat](https://badges.gitter.im/Boris-Em/BEMAnalogClock.png)](https://gitter.im/Boris-Em/BEMAnalogClock)   
Join us on [Gitter]( https://gitter.im/Boris-Em/BEMAnalogClock) if you need any help or want to talk about the project.

## Documentation
All methods, properties, types, and delegate methods available on the BEMAnalogClock class are documented below. If you're using Xcode 5 with BEMAnalogClock, documentation is available directly within Xcode (just Option-Click any method for Quick Help).

### Installation
The easiest way to install BEMAnalogClock is to use <a href="http://cocoapods.org/" target="_blank">CocoaPods</a>. To do so, simply add the following line to your `Podfile`:
	<pre><code>pod 'BEMAnalogClock'</code></pre>
	
The other way to install BEMAnalogClock, is to drag and drop the *Classes* folder into your Xcode project. When you do so, check the "*Copy items into destination group's folder*" box. 

### Setup
Setting up BEMAnalogClock in your project is simple. Follow the steps below to get everything up and running.

 1. Import `"BEMAnalogClockView.h"` to the header of your view controller:

         #import "BEMAnalogClockView.h"

 2. Implement the `BEMAnalogClockDelegate` to the same view controller:

         @interface YourViewController : UIViewController <BEMAnalogClockDelegate>

 3.  BEMAnalogClockView can be initialized in one of two ways. You can either add it directly to your interface (storyboard file) OR through code. Both ways provide the same initialization, just different ways to do the same thing. Use the method that makes sense for your app or project.

     **Interface Initialization**  
     1 - Add a UIView to your UIViewController  
     2 - Change the class type of the UIView to `BEMAnalogClockView`  
     3 - Link the view to your code using an `IBOutlet`. You can set the property to `weak` and `nonatomic`.  
     4 - Select the Connect the `BEMAnalogClockView` in your interface. Connect the delegate property to your ViewController.  

     **Code Initialization**  
     Just add the following code to your implementation (usually the `viewDidLoad` method).

         BEMAnalogClockView *myClock = [[BEMAnalogClockView alloc] initWithFrame:CGRectMake(105, 100, 100, 100)];
         myGraph.delegate = self;
         [self.view addSubview:myClock];

### Setting up the time on the clock
By default, the clock will display [10:10](http://en.wikipedia.org/wiki/Watch#Analog). There are two ways to initialize the clock with a custom time.

**By directly attributing values to the time properties**  
The easiest way is to change the values of the NSInteger properties `hours`, `minutes` and `seconds`. For example in `viewDidLoad`, the time on the clock could be set up this way:  

    self.myClock.hours = 7;
    self.myClock.minutes = 37;
    self.myClock.seconds = 10;

**By conforming to these two methods**  
The other way to set up the time on the clock is by using the methods ` timeForClock:` and ` dateFormatterForClock:`.
`timeForClock:` should return a string containing the time you want the clock to be set up at.
`dateFormatterForClock:` should return the date format (string) used by the string for the time.
Here is an example on how these methods are used on a ViewController:

    - (NSString *)timeForClock:(BEMAnalogClockView *)clock {
        return @"11, 03 1982 07:37:10"; // The string containing the time
    }

    - (NSString *)dateFormatterForClock:(BEMAnalogClockView *)clock {
        return @"MM, dd yyyy HH:mm:ss"; // The date format used by the string in “timeForClock”.
    }



### Reloading the clock
BEMAnalogClock has a `reloadClock` method. Calling it will completely reload/reinitialize the clock. `layoutSubviews` will be called again as well as all of the properties. The clock will be entirely redrawn.

    - (void)anyMethodInYourOwnController {
        // Change clock properties
        [self.myClock reloadClock]; // Reload the clock
    }

### Updating the time on the clock
The method `updateTimeAnimated:` is here to change the time on the clock after it’s been initialized. The parameter `animated` controls if the hands on the clock should go to the new position with an animation or simply “jump” there. Here is an example of how to use it:  

    -(void)anyMethodInYourOwnController {
      // Update the time on the clock
      self.myClock.hours = arc4random() % 12 // Random value between 1 and 12
      self.myClock.minutes = arc4random() % 60 // Random value between 1 and 60 
      self.myClock.seconds = arc4random() % 60 // Random value between 1 and 60
      [self.myClock updateTimeAnimated:YES] // Update the time on the clock
    }
  
<p align="center"><img src="http://s18.postimg.org/awr1qjm8p/BEMAnalog_Clock_Animation.gif"/></p>


### Current time
BEMAnalogClock makes it possible to set the time on the clock to the time of the user’s device. There are two ways to do so.
When initializing the clock, you can set the property `currentTime` to YES (default value is NO).

  	myClock.currentTime = YES;


Or you can call the method `setClockToCurrentTimeAnimated:`. The parameter `animated` is similar to the one of `updateTimeAnimated`. It controls if the hands of the clock should move with an animation to the new position or not.

    - (void)anyMethodInYourOwnController {
        [self.myClock setClockToCurrentTimeAnimated:YES]; // Set the time on the clock to the one on the user's device
    }


### Real time
The clock can be updated in real time. Meaning that the second hand will move every second, the minute one every minute and the hour one every hour. 
To do so, you can either set the property `realTime` to YES (default value is NO) when initializing the graph.

    myClock.realTime = YES;
    
Or you can use the methods `startRealTime` and `stopRealTime` to start/stop the real time feature:

    [self.myGraph startRealTime]; // The clock will start being updated in real time.
    [self.myGraph stopRealTime]; // The clock will stop being updated in real time.
    
The property `realTimeIsActivated` (read only) reports if the clock is currently using the real time feature or not.

### Time reporting
The method `currentTimeOnClock:` is here to get the time currently displayed on the clock. It gets called every time the clock is updated. The parameters `hours`, `minutes` and `seconds` are strings of the hours, minutes and seconds currently displayed on the clock.  
Here is an example on how to use the method:

    - (void)currentTimeOnClock:(BEMAnalogClockView *)clock Hours:(NSString *)hours Minutes:(NSString *)minutes 
        NSLog(@"Hours: %@", hours); // The hours currently displayed on the clock by the hour hand.
        NSLog(@"Minutes: %@", minutes); // The minutes currently displayed on the clock by the minute hand.
        NSLog(@"Seconds: %@", seconds); // The seconds currently displayed on the clock by the second hand.
    }
    
### Adjusting the time on the clock via touch

The BOOL property `setTimeViaTouch`, when set to YES, provides a way to adjust the time on the clock via touch input. The minute hand will follow the user's finger around the clock. The default value of this property is NO.


### Customization

Thankfully, BEMAnalogClock is highly customizable.

<p align="center"><img src="http://s24.postimg.org/qtdne4ih1/Legende.png"/></p>

#### Customization of the hands
Different properties are here to customize the hands of a clock created with BEMAnalogClock.  
`hourHandColor`, `minuteHandColor` and `secondHandColor` control the color of the hands.  
`hourHandAlpha`, `minuteHandAlpha` and `secondHandAlpha` control the alpha of the hands.  
`hourHandWidth`, `minuteHandWidth` and `secondHandWidth`control the width of the hands.  
`hourHandLength`, `minuteHandLength` and `secondHandLength` control the length of the hands.  
`hourHandOffsideLength`, `minuteHandOffsideLength` and `secondHandOffsideLength` control the length of the back of the hands.  
If `enableShadows` is set to YES, the hands are going to cast a shadow.

#### Customization of the clock's face
Here are the properties used to customize the clock's face:  
`faceBackgroundColor` defines the background color of the clock.  
`faceBackgroundAlpha` defines the background alpha of the clock.  
`borderColor` defines the color of the border.  
`borderAlpha` defines the alpha of the border.  
`borderWidth` defines the width of the border.

#### Customization of the graduations
Five methods make it easy to customize the graduations of the clock. They all control a parameter (color, alpha, width, length, offset) at a specific graduation. Each graduation is defined by an index going from 0 to 59.  
  1. `graduationColorForIndex:` controls the color of the graduations.
  2. `graduationAlphaForIndex:` controls the alpha of the graduations.
  3. `graduationWidthForIndex:` controls the width of the graduations.
  4. `graduationLengthForIndex:` controls the Length of the graduations.
  5. `graduationOffsetForIndex:` controls the distance from the border of the graduations.  
  
Here is an example on how to use the `graduationLengthForIndex:` method:

    - (CGFloat)analogClock:(BEMAnalogClockView *)clock graduationLengthForIndex:(NSInteger)index {
        if (index == 30) { 
        return 50; // The length of 30th graduation will be 50.
        } else if (!(index % 5) == 1){
        return 20; // The length of one graduation in every five graduation will be 20.
        } else {
        return 5; // The length of the rest of the graduations will be 5.
        }
    }

<p align="center"><img src="http://s18.postimg.org/oxpb0kkjd/BEMAnalog_Clock_Graduation.jpg"/></p>

<p align="center">

And here is the result of the above example. The 30th graduation of the clock is longer than the other ones. One graduation in every five graduation is also longer than the rest.</p>
  
You can use the BOOL property `enableGraduations` to activate or deactivate the graduations on the clock. If it is set to YES the graduations will be visible, if set to NO, they won't (default value is YES).

#### Displaying digits on the clock's face
<p align="center"><img src="http://s22.postimg.org/nd1vaewoh/BEMAnalog_Clock_Digits.jpg"/></p>
<b>BEMAnalogClock</b> gives you the option to display 12 digits on the clock's face (see above image). To do so, simply set the BOOL property `enableDigit` to YES.

    self.myClock.enableDigit = YES;
    
Three properties are here to customize this feature: `digitColor`, `digitFont` and `digitOffset`.

    self.myClock.digitColor = [UIColor whiteColor]; // The color of the digits displayed on the clock.
    self.myClock.digitFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17]; // The font of the digits displayed on the clock.
    self.myClock.digitOffset = 10; // The offset for the position of the digits from the center of the clock.
    
### Military Time (24 Hours)

The BOOL property `militaryTime` gives the option to use the clock with military time.

```Objective-C
self.myClock.militaryTime = YES; //Defaults to NO
```

### Status reporting

When the clock starts or completes loading it will call a delegate method. When it begins reloading the `clockDidBeginLoading:` method is called. When loading is finished, the `clockDidFinishLoading:` method is called (please note that as of now, the animation is not complete when this delegate method is called).

