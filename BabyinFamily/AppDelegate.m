//
//  AppDelegate.m
//  BabyinFamily
//
//  Created by quan dong on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "HotViewController.h"
#import "TakePhotoViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "RaisedCenterButton.h"

@implementation AppDelegate
@synthesize window;
@synthesize tabBarController;
@synthesize oauthWebView;
//@synthesize manager;

- (void)dealloc
{
    [window release];
    [tabBarController release];
    [oauthWebView release];
    // [manager release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    WeiBoMessageManager *manager = [WeiBoMessageManager getInstance];
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSLog([manager isNeedToRefreshTheToken] == YES ? @"need to login":@"did login");
    if (authToken == nil || [manager isNeedToRefreshTheToken])
    {
        [self showFirstRunViewWithAnimate:NO];
    }
    else
    {
        [self prepareToMainViewControllerWithAnimate:NO];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void) prepareToMainViewControllerWithAnimate:(BOOL)animate
{
    //reload nib
    HomeViewController *vc1      = [[[HomeViewController alloc] init] autorelease];
    HotViewController *vc2       = [[[HotViewController alloc] init] autorelease];
    TakePhotoViewController *vc3 = [[[TakePhotoViewController alloc] init] autorelease];
    MessageViewController *vc4   = [[[MessageViewController alloc] init] autorelease];
    ProfileViewController *vc5   = [[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil] autorelease];
    vc5.title = @"我的";
    UINavigationController * nav1 = [[[UINavigationController alloc] initWithRootViewController:vc1] autorelease];
    UINavigationController * nav2 = [[[UINavigationController alloc] initWithRootViewController:vc2] autorelease];
    UINavigationController * nav3 = [[[UINavigationController alloc] initWithRootViewController:vc3] autorelease];
    UINavigationController * nav4 = [[[UINavigationController alloc] initWithRootViewController:vc4] autorelease];
    UINavigationController * nav5 = [[[UINavigationController alloc] initWithRootViewController:vc5] autorelease];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = @[nav1, nav2,nav3,nav4,nav5];
    //添加button到tabbar上
    NSString *fullpath = [NSString stringWithFormat:@"sourcekit.bundle/image/%@", @"tabbar_camera"];
    RaisedCenterButton *button = [RaisedCenterButton buttonWithImage:[UIImage imageNamed:fullpath] forTabBarController:self.tabBarController];
    [self.tabBarController.tabBar addSubview:button];
    [[window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [window addSubview:tabBarController.view];
    
    self.window.rootViewController = self.tabBarController;
    
    if (animate) {
        [UIView commitAnimations];
    }
}


- (void) showFirstRunViewWithAnimate:(BOOL)animated
{
    if (oauthWebView != nil) {
        [oauthWebView release];
    }
    oauthWebView = [[OAuthWebView alloc]initWithNibName:@"OAuthWebView" bundle:nil];
    oauthWebView.view.frame = [UIScreen mainScreen].applicationFrame;
    if(animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
		[UIView setAnimationDuration:0.4];
	}
	[[window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[window addSubview:oauthWebView.view];
	if(animated)
		[UIView commitAnimations];
}

-(void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_EXPIRATION_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    WeiBoMessageManager *manager = [WeiBoMessageManager getInstance];
    manager.httpManager.userId =nil;
    manager.httpManager.authToken = nil;
    [self showFirstRunViewWithAnimate:YES];
    
    
}
@end
