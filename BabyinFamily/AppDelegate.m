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
#import "BabyNavigationController.h"
#import "UIImage+Addition.h"
@implementation AppDelegate
@synthesize window;
@synthesize tabBarController;
@synthesize timer;
@synthesize loadingViewController;
@synthesize sinaWeibo;


- (void)dealloc
{
    [window release];
    [tabBarController release];
    [timer invalidate];
    self.timer = nil;
    [sinaWeibo release];
    [super dealloc];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    sinaWeibo = [[SinaWeibo alloc] initWithAppKey:SINA_APP_KEY appSecret:SINA_APP_SECRET appRedirectURI:SINA_APP_REDIRECT_URI andDelegate:self.loadingViewController];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:USER_STORE_USER_ID]){
        sinaWeibo.accessToken = [defaults objectForKey:USER_STORE_ACCESS_TOKEN];
        
        sinaWeibo.expirationDate = [defaults objectForKey:USER_STORE_EXPIRATION_DATE];
        
        sinaWeibo.userID = [defaults objectForKey:USER_STORE_USER_ID];
    }
    UIImage *navBackgroundImage = [UIImage imageNamed:@"header_bg"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    // Change UINavigationBar appearance by setting the font, color, shadow and offset.
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          
                                                          [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0], UITextAttributeTextColor,
                                                          
                                                          [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8], UITextAttributeTextShadowColor,
                                                          
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                          
                                                          [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], UITextAttributeFont,
                                                          
                                                          nil]];
    
    // Change the UIBarButtonItem apperance by setting a resizable background image for the back button.
    UIImage *backButtonImage = [[UIImage imageNamed:@"navigationBarBackButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // Change the UIBarButtonItem apperance by setting a resizable background image for the edit button.
    UIEdgeInsets insets = {0, 6, 0, 6};// Same as doing this: UIEdgeInsetsMake (top, left, bottom, right)
    UIImage *barButtonImage = [[UIImage imageNamed:@"button_normal"] resizableImageWithCapInsets:insets];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    BOOL authValid = sinaWeibo.isAuthValid;
    
    if (!authValid)
    {
        [self showFirstRunViewWithAnimate];
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
    [self.sinaWeibo applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.sinaWeibo handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.sinaWeibo handleOpenURL:url];
}

- (void) prepareToMainViewControllerWithAnimate:(BOOL)animate
{
    //reload nib
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUnreadCount:) name:MMSinaGotUnreadCount       object:nil];

    HomeViewController *vc1      = [[[HomeViewController alloc] init] autorelease];
    HotViewController *vc2       = [[[HotViewController alloc] init] autorelease];
    TakePhotoViewController *vc3 = [[[TakePhotoViewController alloc] init] autorelease];
    MessageViewController *vc4   = [[[MessageViewController alloc] init] autorelease];
    ProfileViewController *vc5   = [[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil] autorelease];
    vc5.title = @"我的";
    UINavigationController * nav1 = [[[UINavigationController alloc] initWithRootViewController:vc1] autorelease];
    UINavigationController * nav2 = [[[UINavigationController alloc] initWithRootViewController:vc2] autorelease];
    UINavigationController * nav3 = [[[UINavigationController alloc] initWithRootViewController:vc3] autorelease];
    BabyNavigationController * nav4 = [[[BabyNavigationController alloc] initWithRootViewController:vc4] autorelease];
    BabyNavigationController * nav5 = [[[BabyNavigationController alloc] initWithRootViewController:vc5] autorelease];
    
    NSArray *ctrlArr = @[nav1,nav2,nav3,nav4,nav5];
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic setObject:[UIImage imageWithSourceKit:@"TabBar_Image/home@2x.png"] forKey:@"Default"];
	[imgDic setObject:[UIImage imageWithSourceKit:@"TabBar_Image/home@2x.png"] forKey:@"Highlighted"];
	[imgDic setObject:[UIImage imageWithSourceKit:@"TabBar_Image/home-on@2x.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic2 setObject:[UIImage imageWithSourceKit:@"TabBar_Image/topic@2x.png"] forKey:@"Default"];
	[imgDic2 setObject:[UIImage imageWithSourceKit:@"TabBar_Image/topic@2x.png"] forKey:@"Highlighted"];
	[imgDic2 setObject:[UIImage imageWithSourceKit:@"TabBar_Image/topic-on@2x.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic3 setObject:[UIImage imageWithSourceKit:@"TabBar_Image/search@2x.png"] forKey:@"Default"];
	[imgDic3 setObject:[UIImage imageWithSourceKit:@"TabBar_Image/search@2x.png"] forKey:@"Highlighted"];
	[imgDic3 setObject:[UIImage imageWithSourceKit:@"TabBar_Image/search@2x.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic4 setObject:[UIImage imageWithSourceKit:@"TabBar_Image/shoppping@2x.png"] forKey:@"Default"];
	[imgDic4 setObject:[UIImage imageWithSourceKit:@"TabBar_Image/shoppping@2x.png"] forKey:@"Highlighted"];
	[imgDic4 setObject:[UIImage imageWithSourceKit:@"TabBar_Image/shoppping-on@2x.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic5 setObject:[UIImage imageWithSourceKit:@"TabBar_Image/my@2x.png"] forKey:@"Default"];
	[imgDic5 setObject:[UIImage imageWithSourceKit:@"TabBar_Image/my@2x.png"] forKey:@"Highlighted"];
	[imgDic5 setObject:[UIImage imageWithSourceKit:@"TabBar_Image/my-on@2x.png"] forKey:@"Seleted"];
	NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic3,imgDic4,imgDic5,nil];
    
    self.tabBarController = [[GTTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr];
	[self.tabBarController setTabBarTransparent:YES];
    self.tabBarController.delegate = self;
    self.tabBarController.animateDriect = 0;
    
//    //添加button到tabbar上
//    NSString *fullpath = [NSString stringWithFormat:@"sourcekit.bundle/image/%@", @"tabbar_camera"];
//    RaisedCenterButton *button = [RaisedCenterButton buttonWithImage:[UIImage imageNamed:fullpath] forTabBarController:self.tabBarController];
//    [self.tabBarController.tabBar addSubview:button];
//    [[window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [window addSubview:tabBarController.view];
    
    self.window.rootViewController = self.tabBarController;
    [self schedueMessageTimer];

    if (animate) {
        [UIView commitAnimations];
    }
}


- (void) showFirstRunViewWithAnimate
{
    self.loadingViewController = [[[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.loadingViewController;
    [self.window makeKeyAndVisible];
    
}

//退出登陆回调方法
-(void)logout
{
    [timer invalidate];
    SinaWeibo *sinaweibo = [self sinaWeibo];
    [sinaweibo logOut];
    [self showFirstRunViewWithAnimate];
    
}
- (void)schedueMessageTimer
{
    if (timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(timerOnActive) userInfo:nil repeats:YES];
    }
    [timer fire];
}

-(void)timerOnActive
{
    WeiBoMessageManager *manager = [WeiBoMessageManager getInstance];

    [manager getUnreadCount:[[NSUserDefaults standardUserDefaults]stringForKey:USER_STORE_USER_ID]];
}

-(void)didGetUnreadCount:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    NSNumber *num = [dic objectForKey:@"cmt"];
    
    NSLog(@"num = %@",num);
    if ([num intValue] == 0) {
        return;
    }
    
   // [self.tabBarController.tabBar.items objectAtIndex:3];
}
#pragma mark -
#pragma mark GTTabBarControllerDelegate
- (BOOL)tabBarController:(GTTabBarController *)atabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([tabBarController.viewControllers objectAtIndex:2] == viewController) {
        TakePhotoViewController *picker = [[[TakePhotoViewController alloc] init] autorelease];
        UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:picker] autorelease];
        [picker.navigationController setNavigationBarHidden:YES];
        [self.tabBarController presentModalViewController:nav animated:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
        return NO;
    }
    return YES;
}

- (void)tabBarController:(GTTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
}
@end
