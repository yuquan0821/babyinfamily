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

@synthesize shareButton = _shareButton;
@synthesize indicator = _indicator;

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
}

- (void) addButton
{
    _shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [self.shareButton setFrame:CGRectMake(10, MainHeight - 65, 300, 50)];
    
    [self.shareButton setTitle:@"使用微博账号登陆" forState:UIControlStateNormal];
    
    [self.shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.shareButton];
}


//分享按钮响应方法
- (void) share:(UIButton*) sender
{
    SinaWeibo *sinaWeibo = [self sinaWeibo];
    
    BOOL authValid = sinaWeibo.isAuthValid;
    
    if (!authValid)
    {
        [sinaWeibo logIn];
    }
    else
    {
        [[UIApplication sharedApplication].delegate performSelector:@selector(prepareToMainViewControllerWithAnimate:) withObject:[NSNumber numberWithBool:NO]];

    }
    
}
- (void)storeAuthData
{
    SinaWeibo *sinaWeibo = [self sinaWeibo];
    NSString *accessToken = sinaWeibo.accessToken;
    NSString *userId = sinaWeibo.userID;
    NSDate   *expirationDate = sinaWeibo.expirationDate;
    //NSString *refreshToken = sinaWeibo.refreshToken;
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:USER_STORE_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults]setObject:expirationDate forKey:USER_STORE_EXPIRATION_DATE];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//登陆成功后回调方法
- (void) sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
    [[UIApplication sharedApplication].delegate performSelector:@selector(prepareToMainViewControllerWithAnimate:) withObject:[NSNumber numberWithBool:NO]];
    
}

//退出登陆回调方法
- (void) exitShare:(UIButton*) sender
{
    SinaWeibo *sinaWeibo = [self sinaWeibo];
    
    [sinaWeibo logOut];
        
    NSLog(@"退出登陆");
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end

