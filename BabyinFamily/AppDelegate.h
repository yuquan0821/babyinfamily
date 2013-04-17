//
//  AppDelegate.h
//  BabyinFamily
//
//  Created by quan dong on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthWebView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) UITabBarController *tabBarController;

@property (retain, nonatomic) OAuthWebView  *oauthWebView;



- (void) logout;
- (void) showFirstRunViewWithAnimate:(BOOL)animated;
- (void) prepareToMainViewControllerWithAnimate:(BOOL)animate;

@end
