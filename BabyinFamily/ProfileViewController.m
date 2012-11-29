//
//  ProfileViewController.m
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//


#import "ProfileViewController.h"
#import "WeiBoMessageManager.h"
#import "User.h"
#import "ASIHTTPRequest.h"
#import "HHNetDataCacheManager.h"
#import "SHKActivityIndicator.h"
#import "FollowerVC.h"
#import "ZJTHelpler.h"

@interface ProfileViewController ()

- (void)getImages;

@end

@implementation ProfileViewController
@synthesize table;
@synthesize userID;
@synthesize headerView;
@synthesize headerVImageV;
@synthesize headerVNameLB;
@synthesize weiboCount;
@synthesize followerCount;
@synthesize followingCount;
@synthesize user;
@synthesize avatarImage;

-(void)dealloc
{
    self.avatarImage = nil;
    self.user = nil;
    self.userID = nil;
    self.table = nil;
    self.headerVImageV = nil;
    self.headerVNameLB = nil;
    self.weiboCount = nil;
    self.followerCount = nil;
    self.followingCount = nil;
    
    self.headerView = nil;
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //init data
        isFirstCell = YES;
        shouldLoad = NO;
        shouldLoadAvatar = NO;
        shouldShowIndicator = YES;
        manager = [WeiBoMessageManager getInstance];
        defaultNotifCenter = [NSNotificationCenter defaultCenter];
        imageDictionary = [[NSMutableDictionary alloc] initWithCapacity:100];
        
        self.title = @"我的";
        NSString *fullpath = [NSString stringWithFormat:@"sourcekit.bundle/image/%@", @"tabbar_profile"];
        self.tabBarItem.image = [UIImage imageNamed:fullpath];
    }
    return self;
}


- (void)twitter
{
    TwitterVC *tv = [[TwitterVC alloc]initWithNibName:@"TwitterVC" bundle:nil];
    [self.navigationController pushViewController:tv animated:YES];
    [tv release];
}
- (void)setting
{
    SettingVC  *sv = [[SettingVC alloc]initWithNibName:@"SettingVC" bundle:nil];
    [self.navigationController pushViewController:sv animated:YES];
    [sv release];
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   UIBarButtonItem *retwitterBtn = [[UIBarButtonItem alloc]initWithTitle:@"反馈" style:UIBarButtonItemStylePlain target:self action:@selector(twitter)];
    self.navigationItem.rightBarButtonItem = retwitterBtn;
    [retwitterBtn release];
    
    UIBarButtonItem *SettingBtn = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    self.navigationItem.leftBarButtonItem = SettingBtn;
    [SettingBtn release];
    table = self.tableView;
//<<<<<<< HEAD
    [table setTableHeaderView:headerView];
//=======
   // [table setTableHeaderView:headerView];
//>>>>>>> 4ad961d2fb20884ff66ef1aef42b3e12afbcc793

    if (avatarImage) {
        self.headerVImageV.image = avatarImage;
    }
    else {
        [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileLargeImageUrl];
    }
    
    if (userID == nil) {
        userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
        
    }
    if (!user) {
        self.user = [ZJTHelpler getInstance].user;
    }
    self.headerVNameLB.text = user.screenName;
    self.weiboCount.text = [NSString stringWithFormat:@"%d",user.statusesCount];
    self.followerCount.text = [NSString stringWithFormat:@"%d",user.followersCount];
    self.followingCount.text = [NSString stringWithFormat:@"%d",user.friendsCount];
    
    if (![self.title isEqualToString:@"我的微博"]) {
        self.title = user.screenName;
    }
    
    self.tableView.contentInset = UIEdgeInsetsOriginal;
    
    [manager getUserStatusUserID:userID sinceID:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
    //    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..."];
    [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
    
    [defaultNotifCenter addObserver:self selector:@selector(didGetHomeLine:)    name:MMSinaGotUserStatus        object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(getAvatar:)         name:HHNetDataCacheNotification object:nil];
    //    [defaultNotifCenter addObserver:self selector:@selector(didGetUserInfo:)    name:MMSinaGotUserInfo          object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(mmRequestFailed:) name:MMSinaRequestFailed object:nil];
}

-(void)viewDidUnload
{
    [defaultNotifCenter removeObserver:self name:MMSinaGotUserStatus        object:nil];
    [defaultNotifCenter removeObserver:self name:HHNetDataCacheNotification object:nil];
    //    [defaultNotifCenter removeObserver:self name:MMSinaGotUserInfo          object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaRequestFailed object:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (shouldLoad)
    {
        shouldLoad = NO;
        [manager getUserStatusUserID:userID sinceID:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
        //        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..."];
        [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)gotoFollowedVC:(id)sender {
 FollowerVC  *followerVC     = [[FollowerVC alloc]initWithNibName:@"FollowerVC" bundle:nil];
 followerVC.title = [NSString stringWithFormat:@"%@的粉丝",user.screenName];
 followerVC.user = user;
 followerVC.hidesBottomBarWhenPushed = YES;
 
 [self.navigationController pushViewController:followerVC animated:YES];
 [followerVC release];
 }
 
 - (IBAction)gotoFollowingVC:(id)sender
 {
 
 FollowerVC *followingVC    = [[FollowerVC alloc] initWithNibName:@"FollowerVC" bundle:nil];
 
 followingVC.title = [NSString stringWithFormat:@"%@的关注",user.screenName];
 followingVC.isFollowingViewController = YES;
 followingVC.user = user;
 followingVC.hidesBottomBarWhenPushed = YES;
 
 [self.navigationController pushViewController:followingVC animated:YES];
 [followingVC release];
 }

#pragma mark - Methods

//异步加载图片
-(void)getImages
{
    //下载头像图片
    [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileLargeImageUrl];
    
}

//得到图片
-(void)getAvatar:(NSNotification*)sender
{
    NSDictionary * dic = sender.object;
    NSString * url          = [dic objectForKey:HHNetDataCacheURLKey];
    NSNumber *indexNumber   = [dic objectForKey:HHNetDataCacheIndex];
    
    if([url isEqualToString:user.profileLargeImageUrl])
    {
        UIImage * image     = [UIImage imageWithData:[dic objectForKey:HHNetDataCacheData]];
        self.avatarImage = image;
        headerVImageV.image = image;
    }
    
    //当下载大图过程中，后退，又返回，如果此时收到大图的返回数据，会引起crash，在此做预防。
    if (indexNumber == nil) {
        NSLog(@"profile indexNumber = nil");
        return;
    }
    

}

-(void)didGetUserID:(NSNotification*)sender
{
    self.userID = sender.object;
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USER_STORE_USER_ID];
    [manager getUserInfoWithUserID:[userID longLongValue]];
}


-(void)didGetHomeLine:(NSNotification*)sender
{
    [self stopLoading];
    
    shouldLoadAvatar = YES;
   // self.statuesArr = sender.object;
 
    //    [[SHKActivityIndicator currentIndicator] hide];
    [[ZJTStatusBarAlertWindow getInstance] hide];
    
    [imageDictionary removeAllObjects];
    
    [self getImages];
}

-(void)mmRequestFailed:(id)sender
{
    [self stopLoading];
    //    [[SHKActivityIndicator currentIndicator] hide];
    [[ZJTStatusBarAlertWindow getInstance] hide];
}

-(void)refresh
{
    [manager getUserStatusUserID:userID sinceID:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
    //    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..."];
    [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
}

//计算text field 的高度。
-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
    UIFont * font=[UIFont  systemFontOfSize:14];
    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(with - kTextViewPadding, 300000.0f) lineBreakMode:kLineBreakMode];
    CGFloat height = size.height + 44;
    return height;
}


   
@end