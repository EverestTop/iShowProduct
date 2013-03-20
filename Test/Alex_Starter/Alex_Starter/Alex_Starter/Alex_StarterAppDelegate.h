//
//  Alex_StarterAppDelegate.h
//  Alex_Starter
//
//  Created by user on 13-3-21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Alex_StarterViewController;

@interface Alex_StarterAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Alex_StarterViewController *viewController;

@end
