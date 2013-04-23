//
//  LoadingViewController.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-4-20.
//
//

#import "LoadingViewController.h"
#import "AppDelegate.h"
#import "WeiBoHttpManager.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define StateBarHeight 20
#define MainHeight (ScreenHeight - StateBarHeight)
#define MainWidth ScreenWidth


@interface LoadingViewController ()

@end

@implementation LoadingViewController

@synthesize loadButton = _loadButton;
@synthesize indicator = _indicator;
@synthesize userGuideView;

- (SinaWeibo*)sinaWeibo
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.sinaWeibo.delegate = self;
    return delegate.sinaWeibo;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_indicator setFrame:CGRectMake(0, 0, 50, 50)];
    _indicator.center = self.view.center;
    [self.view addSubview:_indicator];
    [self addButton];
    [self addGuideView];
}

- (void) addButton
{
    _loadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [self.loadButton setFrame:CGRectMake(80, MainHeight - 30, 160, 27)];
    
    [self.loadButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    
    [self.loadButton.titleLabel  setTextColor:[UIColor blackColor]];
    
    [self.loadButton setTitle:@"使用新浪微博账号登录" forState:UIControlStateNormal];
    
    [self.loadButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.loadButton];
}

- (void) addGuideView
{
      userGuideView = [[[UINib nibWithNibName:@"UserGuideVIew" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    float height = DEVICE_IS_IPHONE5 ? 568 : 480;
    [userGuideView setFrame:CGRectMake(0, 0, 320, height)];
    
    [userGuideView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:userGuideView];

}


//分享按钮响应方法
- (void) login:(UIButton*) sender
{
    SinaWeibo *sinaWeibo = [self sinaWeibo];
    [sinaWeibo logIn];
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_EXPIRATION_DATE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_REFRESH_TOKEN];
}
- (void)storeAuthData
{
    SinaWeibo *sinaWeibo = [self sinaWeibo];
    
    NSString *accessToken = sinaWeibo.accessToken;
    NSString *userId = sinaWeibo.userID;
    NSDate   *expirationDate = sinaWeibo.expirationDate;
    NSString *refreshToken = sinaWeibo.refreshToken;
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:USER_STORE_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:USER_STORE_EXPIRATION_DATE];
    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:USER_STORE_REFRESH_TOKEN];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//登陆成功后回调方法
- (void) sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
    [[UIApplication sharedApplication].delegate performSelector:@selector(prepareToMainViewControllerWithAnimate:) withObject:[NSNumber numberWithBool:NO]];
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_GET_TOKEN_IN_WEB_VIEW object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}
//注销登录后回调方法
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    userGuideView = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end

