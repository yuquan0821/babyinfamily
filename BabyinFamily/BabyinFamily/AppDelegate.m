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
#import "BabyNavigationController.h"
#import "BabyPostViewController.h"
#import "BabyAlbumsViewController.h"

@implementation AppDelegate
@synthesize window;
@synthesize tabBarController;
@synthesize loadingViewController;
@synthesize sinaWeibo;
@synthesize menu;


- (void)dealloc
{
    [window release];
    [tabBarController release];
    [sinaWeibo release];
    [menu release];
    [super dealloc];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
    
    // 微博登陆SDK的使用
    sinaWeibo = [[SinaWeibo alloc] initWithAppKey:SINA_APP_KEY appSecret:SINA_APP_SECRET appRedirectURI:SINA_APP_REDIRECT_URI andDelegate:self.loadingViewController];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:USER_STORE_USER_ID]){
        sinaWeibo.accessToken = [defaults objectForKey:USER_STORE_ACCESS_TOKEN];
        
        sinaWeibo.expirationDate = [defaults objectForKey:USER_STORE_EXPIRATION_DATE];
        
        sinaWeibo.userID = [defaults objectForKey:USER_STORE_USER_ID];
    }
    BOOL authValid = sinaWeibo.isAuthValid;
    // 根据是否登陆成功进入不同的流程。
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

    HomeViewController *vc1      = [[[HomeViewController alloc] init] autorelease];
    HotViewController *vc2       = [[[HotViewController alloc] init] autorelease];
    TakePhotoViewController *vc3 = [[[TakePhotoViewController alloc] init] autorelease];
    MessageViewController *vc4   = [[[MessageViewController alloc] init] autorelease];
    ProfileViewController *vc5   = [[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil] autorelease];
    vc5.title = @"我的";
    BabyNavigationController * nav1 = [[[BabyNavigationController alloc] initWithRootViewController:vc1] autorelease];
    nav1.delegate =self;
    BabyNavigationController * nav2 = [[[BabyNavigationController alloc] initWithRootViewController:vc2] autorelease];
    nav2.delegate =self;
    BabyNavigationController * nav3 = [[[BabyNavigationController alloc] initWithRootViewController:vc3] autorelease];
    nav3.delegate =self;
    
    BabyNavigationController * nav4 = [[[BabyNavigationController alloc] initWithRootViewController:vc4] autorelease];
    nav4.delegate =self;
    
    BabyNavigationController * nav5 = [[[BabyNavigationController alloc] initWithRootViewController:vc5] autorelease];
    nav5.delegate =self;
    
    NSArray *ctrlArr = @[nav1,nav2,nav3,nav4,nav5];
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic setObject:[UIImage imageWithSourceKit:@"TabBar/homeNormal_TabBar.png"] forKey:@"Default"];
	[imgDic setObject:[UIImage imageWithSourceKit:@"TabBar/homePressed_TabBar.png"] forKey:@"Highlighted"];
	[imgDic setObject:[UIImage imageWithSourceKit:@"TabBar/homeSelected_TabBar.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic2 setObject:[UIImage imageWithSourceKit:@"TabBar/hotNormal_TabBar.png"] forKey:@"Default"];
	[imgDic2 setObject:[UIImage imageWithSourceKit:@"TabBar/hotPressed_TabBar.png"] forKey:@"Highlighted"];
	[imgDic2 setObject:[UIImage imageWithSourceKit:@"TabBar/hotSelected_TabBar.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic3 setObject:[UIImage imageWithSourceKit:@"TabBar/center_TabBar0.png"] forKey:@"Default"];
	[imgDic3 setObject:[UIImage imageWithSourceKit:@"TabBar/center_TabBar0.png"] forKey:@"Highlighted"];
	[imgDic3 setObject:[UIImage imageWithSourceKit:@"TabBar/center_TabBar0.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic4 setObject:[UIImage imageWithSourceKit:@"TabBar/messageNormal_TabBar.png"] forKey:@"Default"];
	[imgDic4 setObject:[UIImage imageWithSourceKit:@"TabBar/messagePressed_TabBar.png"] forKey:@"Highlighted"];
	[imgDic4 setObject:[UIImage imageWithSourceKit:@"TabBar/messageSelected_TabBar.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic5 setObject:[UIImage imageWithSourceKit:@"TabBar/meNormal_TabBar.png"] forKey:@"Default"];
	[imgDic5 setObject:[UIImage imageWithSourceKit:@"TabBar/mePressed_TabBar.png"] forKey:@"Highlighted"];
	[imgDic5 setObject:[UIImage imageWithSourceKit:@"TabBar/meSelected_TabBar.png"] forKey:@"Seleted"];
	NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic3,imgDic4,imgDic5,nil];
    
    self.tabBarController = [[GTTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr];
	[self.tabBarController setTabBarTransparent:NO];
    self.tabBarController.delegate = self;
    self.tabBarController.animateDriect = 0;

    
    [[window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImage *storyMenuItemImage = [UIImage imageWithSourceKit:@"TabBar/bg_Menu.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageWithSourceKit:@"TabBar/bgHeight_Menu.png"];
    
    UIImage *textImage = [UIImage imageWithSourceKit:@"TabBar/bg_PostText.png"];
    UIImage *photoImage = [UIImage imageWithSourceKit:@"TabBar/bg_PostPhoto.png"];
    UIImage *pictureImage = [UIImage imageWithSourceKit:@"TabBar/bg_PostPicture.png"];

    
    QuadCurveMenuItem *starMenuItem1 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:textImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem2 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:photoImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem3 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:pictureImage
                                                        highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, nil];
    [starMenuItem1 release];
    [starMenuItem2 release];
    [starMenuItem3 release];
    
    
    float height = DEVICE_IS_IPHONE5 ? 520 : 432;
    
    menu = [[QuadCurveMenu alloc] initWithFrame:CGRectMake(160, height, 0, 0) menus:menus];
    menu.delegate = self;
    [tabBarController.view addSubview:menu];
        
    [window  addSubview:tabBarController.view];
    
    self.window.rootViewController = self.tabBarController;
    
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
    SinaWeibo *sinaweibo = [self sinaWeibo];
    [sinaweibo logOut];
    [self showFirstRunViewWithAnimate];
    
}

- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    switch (idx) {
        case 0:
        {
            BabyPostViewController *postView = [[[BabyPostViewController alloc] init] autorelease];
            BabyNavigationController * nav = [[BabyNavigationController alloc] initWithRootViewController:postView];
            [postView.navigationController setNavigationBarHidden:NO];
            [self.tabBarController presentModalViewController:nav animated:NO];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
            break;
        }
        case 1:
        {
            TakePhotoViewController *takePhoto = [[[TakePhotoViewController alloc] init] autorelease];
            BabyNavigationController * nav = [[[BabyNavigationController alloc] initWithRootViewController:takePhoto] autorelease];
            [takePhoto.navigationController setNavigationBarHidden:YES];
            [self.tabBarController presentModalViewController:nav animated:NO];
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
            break;
        }
        case 2:
        {
            [self LocalPhoto];
            break;
        }
            
        default:
            break;
    }
    
}
#pragma mark NavigationDelegate
- (void)navigationController:(BabyNavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController.hidesBottomBarWhenPushed)
    {
        self.tabBarController.tabBarTransparent = YES;
        [self.tabBarController hidesTabBar:YES animated:NO driect:0];
        menu.hidden = YES;
    }
    else
    {
        self.tabBarController.tabBarTransparent = NO;
        [self.tabBarController hidesTabBar:NO animated:NO driect:0];
        menu.hidden = NO;
    }
}

-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.editing = NO;
    [self.tabBarController presentModalViewController:picker animated:YES];
    [picker release];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"image is nil %d",image ==nil);
    BabyPostPhotoViewController* viewController = [[BabyPostPhotoViewController alloc] initWithImage:image];
    BabyNavigationController * nav = [[[BabyNavigationController alloc] initWithRootViewController:viewController] autorelease];
    [self.tabBarController presentModalViewController:nav animated:NO];
    [picker dismissModalViewControllerAnimated:YES];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    
}

@end
