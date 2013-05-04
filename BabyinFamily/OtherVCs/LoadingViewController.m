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
#define TITLE_FONT [UIFont fontWithName:@"HelveticaNeue-Bold" size:58.0]
#define TITLE_TEXT_COLOR [UIColor whiteColor]


@interface LoadingViewController ()

@end

@implementation LoadingViewController

@synthesize loadButton = _loadButton;
@synthesize indicator = _indicator;
@synthesize userGuideView;
@synthesize titleLabel;

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
    [self addHeaderView];
}

- (void) addButton
{
    _loadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [self.loadButton setFrame:CGRectMake(30, MainHeight - 40, 260, 35)];
    
    [self.loadButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];

    [self.loadButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];

    [self.loadButton setTitle:@"使用新浪微博账号登录" forState:UIControlStateNormal];
    
    [self.loadButton setImage:[UIImage imageNamed:@"weibo.bundle/WeiboImages/Icon-Small"] forState:UIControlStateNormal];
    
    [self.loadButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    
    [self.loadButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) addHeaderView

{
    CGRect panelTitleLabelFrame;
        panelTitleLabelFrame = CGRectMake(10, 45, MainWidth - 20, 60);
        titleLabel = [[UILabel alloc] initWithFrame:panelTitleLabelFrame];
        titleLabel.text = @"家贝";
        titleLabel.font = TITLE_FONT;
        titleLabel.textColor = TITLE_TEXT_COLOR;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:titleLabel];
        
}

- (void) addGuideView
{
      userGuideView = [[[UINib nibWithNibName:@"UserGuideVIew" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    float height = DEVICE_IS_IPHONE5 ? 568 : 480;
    [userGuideView setFrame:CGRectMake(0, 0, 320, height)];
    [userGuideView addSubview:self.loadButton];

    [userGuideView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:userGuideView];

}


//分享按钮响应方法
- (void) login:(UIButton*) sender
{
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        SinaWeibo *sinaWeibo = [self sinaWeibo];
        [sinaWeibo logIn];
    }

}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_EXPIRATION_DATE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_REFRESH_TOKEN];
}
- (void)storeAuthData:(SinaWeibo *)sinaWeibo;
{
    //保存到本地plist
    NSString *accessToken = sinaWeibo.accessToken;
    NSString *userId = sinaWeibo.userID;
    NSDate   *expirationDate = sinaWeibo.expirationDate;
    NSString *refreshToken = sinaWeibo.refreshToken;
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:USER_STORE_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:USER_STORE_EXPIRATION_DATE];
    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:USER_STORE_REFRESH_TOKEN];

    [[NSUserDefaults standardUserDefaults] synchronize];
 
    //更新model
    [self sinaWeibo].accessToken = sinaWeibo.accessToken;
    [self sinaWeibo].userID = sinaWeibo.userID;
    [self sinaWeibo].expirationDate = sinaWeibo.expirationDate;
    [self sinaWeibo].refreshToken = sinaWeibo.refreshToken;
}

//登陆成功后回调方法
- (void) sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData:sinaweibo];
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

