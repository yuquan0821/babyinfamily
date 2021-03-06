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
#import "IntroControll.h"
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
@synthesize titleLabel;
- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    self.wantsFullScreenLayout = YES;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    return self;
}

- (SinaWeibo*)sinaWeibo
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.sinaWeibo.delegate = self;
    return delegate.sinaWeibo;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    IntroModel *model1 = [[IntroModel alloc] initWithTitle:nil description:@"如你所知\n        家贝,不止是一款拍照工具" image:@"sourcekit.bundle/image/Introduce/0.jpg"];
    
    IntroModel *model2 = [[IntroModel alloc] initWithTitle:nil description:@"她记录了\n        你与孩子的美丽瞬间" image:@"sourcekit.bundle/image/Introduce/1.jpg"];
    
    IntroModel *model3 = [[IntroModel alloc] initWithTitle:nil description:@"他记录了\n        孩子生活中的点滴" image:@"sourcekit.bundle/image/Introduce/2.jpg"];
    
    IntroModel *model4 = [[IntroModel alloc] initWithTitle:nil description:@"在纷繁的世界中\n        孩子是您永远的牵挂" image:@"sourcekit.bundle/image/Introduce/3.jpg"];
    
    IntroModel *model5 = [[IntroModel alloc] initWithTitle:nil description:@"如你所见\n        家贝,是你一个温馨的家" image:@"sourcekit.bundle/image/Introduce/4.jpg"];

    
    self.view = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight) pages:@[model1, model2, model3,model4, model5]];
    [model1 release];
    [model2 release];
    [model3 release];
    [model4 release];
    [model5 release];

    [self addButton];
    
    //[self addGuideView];
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
    
    [self.view addSubview:_loadButton];
    
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
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)dealloc
{
    [_loadButton release];
    [titleLabel release];
    [super dealloc];
}

@end

