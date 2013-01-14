//
//  HomeViewController.m
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//



#import "HomeViewController.h"
#import "BabyHelper.h"
#import "BabyAlertWindow.h"

@interface HomeViewController()
-(void)timerOnActive;
@end

@implementation HomeViewController
@synthesize userID;
@synthesize timer;

-(void)dealloc
{
    self.userID = nil;
    
    [timer invalidate];
    self.timer = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //如果未授权，则调入授权页面。
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSLog([manager isNeedToRefreshTheToken] == YES ? @"need to login":@"will login");
    if (authToken == nil || [manager isNeedToRefreshTheToken])
    {
        shouldLoad = YES;
        OAuthWebView *webV = [[OAuthWebView alloc]initWithNibName:@"OAuthWebView" bundle:nil];
        webV.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webV animated:NO];
        [webV release];
    }
    else
    {
        [manager getUserID];
        [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:1 feature:2];
        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
        //[[BabyAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
    }
    [defaultNotifCenter addObserver:self selector:@selector(didGetUserID:)      name:MMSinaGotUserID            object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetHomeLine:)    name:MMSinaGotHomeLine          object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetUserInfo:)    name:MMSinaGotUserInfo          object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(relogin)            name:NeedToReLogin              object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetUnreadCount:) name:MMSinaGotUnreadCount       object:nil];
}

-(void)viewDidUnload
{
    [defaultNotifCenter removeObserver:self name:MMSinaGotUserID            object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaGotHomeLine          object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaGotUserInfo          object:nil];
    [defaultNotifCenter removeObserver:self name:NeedToReLogin              object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaGotUnreadCount       object:nil];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (shouldLoad)
    {
        shouldLoad = NO;
        [manager getUserID];
        [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:1 feature:2];
        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
        //[[BabyAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Methods

-(void)timerOnActive
{
    [manager getUnreadCount:userID];
}

-(void)relogin
{
    shouldLoad = YES;
    OAuthWebView *webV = [[OAuthWebView alloc]initWithNibName:@"OAuthWebView" bundle:nil];
    webV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webV animated:NO];
    [webV release];
}

-(void)didGetUserID:(NSNotification*)sender
{
    self.userID = sender.object;
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [manager getUserInfoWithUserID:[userID longLongValue]];
}

-(void)didGetUserInfo:(NSNotification*)sender
{
    User *user = sender.object;
    [BabyHelper getInstance].user = user;
    [[NSUserDefaults standardUserDefaults] setObject:user.screenName forKey:USER_STORE_USER_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)didGetHomeLine:(NSNotification*)sender
{
    if ([sender.object count] == 1) {
        NSDictionary *dic = [sender.object objectAtIndex:0];
        NSString *error = [dic objectForKey:@"error"];
        if (error && ![error isEqual:[NSNull null]]) {
            if ([error isEqualToString:@"expired_token"])
            {
                [[SHKActivityIndicator currentIndicator] hide];
                //[[BabyAlertWindow getInstance] hide];
                shouldLoad = YES;
                OAuthWebView *webV = [[OAuthWebView alloc]initWithNibName:@"OAuthWebView" bundle:nil];
                webV.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webV animated:NO];
                [webV release];
            }
            return;
        }
    }
    
    [self stopLoading];
    [self doneLoadingTableViewData];
    
    [statuesArr removeAllObjects];
    self.statuesArr = sender.object;
    [table reloadData];
    [self.tableView reloadData];
    
    [[SHKActivityIndicator currentIndicator] hide];
    //[[BabyAlertWindow getInstance] hide];
    
    [headDictionary  removeAllObjects];
    [imageDictionary removeAllObjects];
    
    [self getImages];
    
    if (timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(timerOnActive) userInfo:nil repeats:YES];
    }
}

-(void)didGetUnreadCount:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    NSNumber *num = [dic objectForKey:@"status"];
    
    NSLog(@"num = %@",num);
    if ([num intValue] == 0) {
        return;
    }
    
    [[BabyAlertWindow getInstance] showWithString:[NSString stringWithFormat:@"您有%@条新图片",num]];
    [[BabyAlertWindow getInstance] performSelector:@selector(hide) withObject:nil afterDelay:10];
}

@end