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
#import "QuadCurveMenu.h"
#import "GTTabBarController.h"
#import "UIImage+Addition.h"

@class LoadingViewController;
@class SinaWeibo;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate,QuadCurveMenuDelegate,GTTabBarControllerDelegate,UIImagePickerControllerDelegate>
{
    UIWindow *_window;
    SinaWeibo *sinaWeibo;
    LoadingViewController *_loadingViewController;
}

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) GTTabBarController *tabBarController;

@property (retain, nonatomic) LoadingViewController *loadingViewController;

@property (retain, nonatomic) SinaWeibo *sinaWeibo;

@property (retain, nonatomic) QuadCurveMenu *menu;



- (void) logout;
- (void) showFirstRunViewWithAnimate;
- (void) prepareToMainViewControllerWithAnimate:(BOOL)animate;

@end
