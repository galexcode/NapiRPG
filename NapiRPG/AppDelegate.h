//
//  AppDelegate.h
//  NapiRPG
//
//  Created by Teo Maragakis on 2/4/12.
//  Copyright studio nocturnart 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
