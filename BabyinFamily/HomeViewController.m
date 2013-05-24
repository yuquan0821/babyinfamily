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
#import "CoreDataManager.h"

@interface HomeViewController()
- (void)getDataFromCD;
@end

@implementation HomeViewController
@synthesize userID;
//@synthesize timer;

-(void)dealloc
{
    self.userID = nil;
    
    //[timer invalidate];
    //self.timer = nil;
    
    [super dealloc];
}

-(void)getDataFromCD
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"homePageMaxID"];
    if (number) {
        _maxID = number.longLongValue;
    }
    
    dispatch_queue_t readQueue = dispatch_queue_create("read from db", NULL);
    dispatch_async(readQueue, ^(void){
        if (!statuesArr || statuesArr.count == 0) {
            statuesArr = [[NSMutableArray alloc] initWithCapacity:70];
            NSArray *arr = [[CoreDataManager getInstance] readStatusesFromCD];
            if (arr && arr.count != 0) {
                for (int i = 0; i < arr.count; i++)
                {
                    StatusCoreDataItem *s = [arr objectAtIndex:i];
                    Status *sts = [[Status alloc]init];
                    [sts updataStatusFromStatusCDItem:s];
                    if (i == 0) {
                        sts.isRefresh = @"YES";
                    }
                    [statuesArr insertObject:sts atIndex:s.index.intValue];
                    [sts release];
                }
            }
        }
        [[CoreDataManager getInstance] cleanEntityRecords:@"StatusCoreDataItem"];
        [[CoreDataManager getInstance] cleanEntityRecords:@"UserCoreDataItem"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        dispatch_release(readQueue);
    });
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    refreshFooterView.hidden = NO;
    _page = 1;
    _maxID = -1;
    _shouldAppendTheDataArr = NO;
    
    [defaultNotifCenter addObserver:self selector:@selector(didGetUserID:)      name:MMSinaGotUserID            object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetHomeLine:)    name:MMSinaGotHomeLine          object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetUserInfo:)    name:MMSinaGotUserInfo          object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(relogin)            name:NeedToReLogin              object:nil];
   // [defaultNotifCenter addObserver:self selector:@selector(didGetUnreadCount:) name:MMSinaGotUnreadCount       object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(appWillResign:)     name:UIApplicationWillResignActiveNotification             object:nil];
}

-(void)viewDidUnload
{
    [defaultNotifCenter removeObserver:self name:MMSinaGotUserID            object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaGotHomeLine          object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaGotUserInfo          object:nil];
    [defaultNotifCenter removeObserver:self name:NeedToReLogin              object:nil];
    //[defaultNotifCenter removeObserver:self name:MMSinaGotUnreadCount       object:nil];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self stopLoading];
        [self doneLoadingTableViewData];
        [[SHKActivityIndicator currentIndicator] hide];
    }else{
        
        [manager followByUserID:3464787022 inTableView:@""];
        if (shouldLoad)
        {
            shouldLoad = NO;
            [manager getUserID];
            [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:1 feature:2];
            [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //如果未授权，则调入授权页面。
    if (statuesArr != nil && statuesArr.count != 0) {
        return;
    }
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSLog([manager isNeedToRefreshTheToken] == YES ? @"need to login":@"did login");
    if (authToken == nil || [manager isNeedToRefreshTheToken])
    {
        shouldLoad = YES;
        [[UIApplication sharedApplication].delegate performSelector:@selector(showFirstRunViewWithAnimate)];
    }
    else
    {
        
        [self getDataFromCD];
        
        if (!statuesArr || statuesArr.count == 0) {
            [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:1 feature:2];
            [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
        }
        
        [manager getUserID];
    }
}

#pragma mark - Methods

//上拉
-(void)refresh
{
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self stopLoading];
        [self doneLoadingTableViewData];
        [[SHKActivityIndicator currentIndicator] hide];
    }else{
        [manager getHomeLine:-1 maxID:_maxID count:-1 page:_page baseApp:1 feature:2];
        _shouldAppendTheDataArr = YES;
    }
}

-(void)appWillResign:(id)sender
{
    for (int i = 0; i < statuesArr.count; i++) {
        NSLog(@"i = %d",i);
        [[CoreDataManager getInstance] insertStatusesToCD:[statuesArr objectAtIndex:i] index:i isHomeLine:YES];
    }
}


-(void)relogin
{
    shouldLoad = YES;
   [[UIApplication sharedApplication].delegate performSelector:@selector(showFirstRunViewWithAnimate)];
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
                shouldLoad = YES;
                [[UIApplication sharedApplication].delegate performSelector:@selector(showFirstRunViewWithAnimate:)];
            }
            return;
        }
    }
    
    [self stopLoading];
    [self doneLoadingTableViewData];
    
    if (statuesArr == nil || _shouldAppendTheDataArr == NO || _maxID < 0) {
        self.statuesArr = sender.object;
        Status *sts = [statuesArr objectAtIndex:0];
        _maxID = sts.statusId;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:_maxID] forKey:@"homePageMaxID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _page = 1;
    }
    else {
        [statuesArr addObjectsFromArray:sender.object];
    }
    _page++;
    refreshFooterView.hidden = NO;
    [self.tableView reloadData];
    [[SHKActivityIndicator currentIndicator] hide];
    [self refreshVisibleCellsImages];
    
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
   
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self stopLoading];
        [self doneLoadingTableViewData];
        [[SHKActivityIndicator currentIndicator] hide];
    }else{
        _reloading = YES;
        [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:1 feature:2];
        _shouldAppendTheDataArr = NO;

    }
 }



@end