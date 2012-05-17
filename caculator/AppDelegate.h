//
//  AppDelegate.h
//  caculator
//
//  Created by Weiwu on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    MainViewController *mainViewController;
}

@property (strong, nonatomic) UIWindow *window;

@end
