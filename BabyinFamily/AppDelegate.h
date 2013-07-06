//
//  AppDelegate.h
//  BabyinFamily
//
//  Created by quan dong on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewController.h"
#import "SinaWeibo.h"
#import "GTTabBarController.h"


@class LoadingViewController;
@class SinaWeibo;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,GTTabBarControllerDelegate>
{
    UIWindow *_window;
    SinaWeibo *sinaWeibo;
    LoadingViewController *_loadingViewController;
}

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) GTTabBarController *tabBarController;

@property (retain, nonatomic) LoadingViewController *loadingViewController;

@property (retain, nonatomic) SinaWeibo *sinaWeibo;

@property (nonatomic, retain) NSTimer *timer;



- (void) logout;
- (void) showFirstRunViewWithAnimate;
- (void) prepareToMainViewControllerWithAnimate:(BOOL)animate;

@end
