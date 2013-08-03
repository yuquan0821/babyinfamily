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
#import "SVStatusHUD.h"
#import "UIImageView+Resize.h"
#import "ProfileViewController.h"
#import "SVStatusHUD.h"
#import "BabyStatusDetailViewController.h"
#define kTextViewPadding            16.0
#define kLineBreakMode              UILineBreakModeWordWrap
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface HomeViewController()
@end

@implementation HomeViewController
@synthesize userID;
@synthesize table;
@synthesize statuesArr;
@synthesize browserView;
@synthesize clickedStatus;

-(void)dealloc
{
    self.statuesArr = nil;
    self.browserView = nil;
    _refreshHeaderView=nil;
    [table release];
    table = nil;
    [clickedStatus release];
    self.userID = nil;
    [super dealloc];
}

-(void)setup
{
    
    self.title = @"主页";
    self.navigationItem.title = @"家贝";
    NSString *fullpath = [NSString stringWithFormat:@"sourcekit.bundle/image/%@", @"tabbar_home"];
    self.tabBarItem.image = [UIImage imageNamed:fullpath];
    
    CGRect frame = table.frame;
    frame.size.height = frame.size.height + REFRESH_FOOTER_HEIGHT;
    table.frame = frame;
    
    //init data
    isFirstCell = YES;
    shouldLoad = NO;
    shouldShowIndicator = YES;
    manager = [WeiBoMessageManager getInstance];
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}


-(void)setUpRefreshView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = [view retain];
		[view release];
	}
    //  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    refreshFooterView.hidden = NO;
    _page = 1;
    _maxID = -1;
    _shouldAppendTheDataArr = NO;
    [self setUpRefreshView];
    self.tableView.contentInset = UIEdgeInsetsOriginal;
    refreshFooterView.hidden = YES;
    NSLog(@" sts base table = %@,delegate = %@",self.tableView,self.tableView.delegate);
    NSLog(@"navigation is height %f",self.navigationController.navigationBar.frame.size.height);
    self.table = self.tableView;
    
    [defaultNotifCenter addObserver:self selector:@selector(didGetUserID:)                 name:MMSinaGotUserID            object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetHomeLine:)               name:MMSinaGotHomeLine          object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetUserInfo:)               name:MMSinaGotUserInfo          object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(relogin)                       name:NeedToReLogin              object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(mmRequestFailed:)              name:MMSinaRequestFailed object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(loginSucceed)                  name:DID_GET_TOKEN_IN_WEB_VIEW object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(receiveDeletePicNotification:) name:@"DeletedPic" object:nil];
    
  //  [self loadVisuableImage:self.table];
    
    
}

-(void)viewDidUnload
{
    [defaultNotifCenter removeObserver:self name:MMSinaRequestFailed        object:nil];
    [defaultNotifCenter removeObserver:self name:DID_GET_TOKEN_IN_WEB_VIEW  object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaGotUserID            object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaGotHomeLine          object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaGotUserInfo          object:nil];
    [defaultNotifCenter removeObserver:self name:NeedToReLogin              object:nil];
    
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
            [self.table reloadData];
            [self loadVisuableImage:self.table];
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
        if (!statuesArr || statuesArr.count == 0) {
            [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:1 feature:2];
            [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
        }
        
        [manager getUserID];
        [self.table reloadData];
        
    }
}

#pragma mark - Methods
-(void)loginSucceed
{
    shouldLoad = YES;
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
    
    NSArray * newStatus = (NSArray *)sender.object;
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
        [statuesArr addObjectsFromArray:newStatus];
    }
    //newStatus的count大于0的时候，认为是有下一页的
    if (newStatus.count > 0) {
        _page++;
        
        [self.tableView reloadData];
        [self loadVisuableImage:self.tableView];
        
    }else{
        refreshFooterView.hidden = YES;
    }
    
    [[SHKActivityIndicator currentIndicator] hide];
}

-(void)mmRequestFailed:(id)sender
{
    [self stopLoading];
    [self doneLoadingTableViewData];
    [[SHKActivityIndicator currentIndicator] hide];
    
}

//如果保证平滑
//为是么用异步， 就是为了肥皂滑 ui流畅
//1.图片数据异步从网络上下载
//2.tableview中图片是需要的时候（滚动停下来 可见的cell）才加载
//3.下载完的图片 缓存起来
//加载可见图片
-(void)loadVisuableImage:(UITableView *)scrollView
{
    NSArray *array  = [scrollView visibleCells];
    
    for ( BabyStatusCell *cell  in array) {
        NSIndexPath *path =  [scrollView indexPathForCell:cell];
        
        Status *weibo  = [statuesArr objectAtIndex:path.section];
        //        StatusHead *head =(StatusHead *) [self tableView:_weiboTable viewForHeaderInSection:path.section];
        //        NSLog(@"head section %d", path.section);
        //        NSLog(@"head %@", head);
        //        NSLog(@"status user name%@", weibo.user.name);
        //使用SDWebImageManager类：可以进行一些异步加载的工作。
        SDWebImageManager *sdManager = [SDWebImageManager sharedManager];
        
        //        //下载头像
        //        head.userName.text = [weibo.user name];
        //        [head.userImg setImageWithURL:[NSURL URLWithString:weibo.user.profileImageUrl]];
        //        [head.userImg.layer setMasksToBounds:YES];
        //        [head.userImg.layer setCornerRadius:5];
        //
        //        NSLog(@"head - user - name :%@", head.userName.text);
        //        [head setNeedsDisplay];
        //下载微博图片
        if (cell.contentImage.image == [UIImage imageNamed:@"weibo.bundle/WeiboImages/touxiang_40x40.png"] ||
            cell.repostContentImage.image == [UIImage imageNamed:@"weibo.bundle/WeiboImages/touxiang_40x40.png"])
        {
            if (cell.contentImage.hidden == NO) {
                //判断是否有本地缓存
                NSURL *imgURL = [NSURL URLWithString:weibo.bmiddlePic];
                UIImage *cachedImage = [sdManager imageWithURL:imgURL];
                //CGSize size = CGSizeMake(300, 300);
                //cachedImage = [UIImage imageWithImage:cachedImage scaledToSizeWithSameAspectRatio:size];

                if (cachedImage) {
                    //如果cache命中，则直接利用缓存的图片进行有关操作
                    // CGSize size = CGSizeMake(300, 300);
                    //cachedImage = [UIImageView imageWithImage:cachedImage scaledToSizeWithSameAspectRatio:size];
                    [UIView animateWithDuration:0.3 animations:^{
                        cell.contentImage.alpha = 0.0f;
                    } completion:^(BOOL finished) {
                        cell.contentImage.alpha = 1.0f;
                        [cell.contentImage setImage:cachedImage];
                    }];
                }else{
                    //如果没有命中，则去指定url下载图片
                    //增加进度条
                    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                    [cell.contentImage addSubview:loading];
                    loading.center = cell.contentImage.center;
                    [loading startAnimating];
                    [UIView animateWithDuration:0.3 animations:^{
                        cell.contentImage.alpha = 0.0f;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.3 animations:^{
                            CGSize size = CGSizeMake(300, 300);
                            cell.contentImage.alpha = 1.0f;
                            [cell.contentImage setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"weibo.bundle/WeiboImages/touxiang_40x40.png"]scaleSize:size ];
                            
                            [loading stopAnimating];
                            [loading removeFromSuperview];
                            [loading release];
                        } ];
                    }];
                }
            }
            if (cell.repostContentImage.hidden == NO) {
                NSURL *imgURL = [NSURL URLWithString:weibo.retweetedStatus.bmiddlePic];
                UIImage *cachedImage = [sdManager imageWithURL:imgURL];
                if (cachedImage) {
                    CGSize size = CGSizeMake(300, 300);
                    cachedImage = [UIImage imageWithImage:cachedImage scaledToSizeWithSameAspectRatio:size];
                    [UIView animateWithDuration:0.3 animations:^{
                        cell.contentImage.alpha = 0.0f;
                    } completion:^(BOOL finished) {
                        cell.contentImage.alpha = 1.0f;
                        [cell.repostContentImage setImage:cachedImage];
                    }];
                }
                else{
                    cell.repostContentImage.image =  [ UIImage imageNamed:@"weibo.bundle/WeiboImages/touxiang_40x40.png"];
                    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                    [cell.contentImage addSubview:loading];
                    loading.center = cell.contentImage.center;
                    [loading startAnimating];
                    [UIView animateWithDuration:0.3 animations:^{
                        cell.repostContentImage.alpha = 0.0f;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.3 animations:^{
                            cell.repostContentImage.alpha = 1.0f;
                            [cell.repostContentImage setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"weibo.bundle/WeiboImages/touxiang_40x40.png"]];
                            [loading stopAnimating];
                            [loading removeFromSuperview];
                            [loading release];
                        }];
                    }];
                }
            }
        }
        [cell setNeedsDisplay];
    }
}




#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [statuesArr count];
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 52;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//页眉
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    BabyStatusCellHeadView *head = [[BabyStatusCellHeadView alloc]initWithFrame:CGRectMake(0, 0, 320, 52)];
    Status *status = [statuesArr objectAtIndex:section];
    NSLog(@"status user name%@", status.user.name);
    head.userNameLabel.text = [status.user name];
    [head.avatarImage setImageWithURL:[NSURL URLWithString:status.user.profileLargeImageUrl]];
    [head.timeLabel setText:status.timestamp];
    head.locationLabel.text = status.user.location;
    head.user = status.user;
    head.delegate = self;
    return head;
}


//add statusCell to sectionrows
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"babyStatusCell";
    
    BabyStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Status *weibo  = [statuesArr objectAtIndex:indexPath.section];
    NSLog(@"---------- 微博:%@", weibo.text);
    NSLog(@"---------- 转发:%@", weibo.retweetedStatus.text);
    if (cell == nil) {
        cell = [[BabyStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell updateCellWith:weibo];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.contentImage.image = [UIImage imageNamed:@"weibo.bundle/WeiboImages/touxiang_40x40.png"];
    cell.repostContentImage.image = [UIImage imageNamed:@"weibo.bundle/WeiboImages/touxiang_40x40.png"];
    
    // [cell.userNameButton addTarget:self action:@selector(goToProfile:) forControlEvents:UIControlEventTouchUpInside];
    //不能在这个地方来下载图片
    //如果这个函数cellForRowAtIndexPath
    //如果从0行翻到999行，这个函数就会至少调用1000次
    //NSLog(@"section %d ",indexPath.section);
    // [cell updateCellWith:[listData objectAtIndex:row]];
    
    [cell updateCellWith:weibo];
    cell.delegate =self;
    return cell;
    
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger  row = indexPath.section;
    static NSString *cellIdentifier = @"babyStatusCell";
    Status *status = [statuesArr objectAtIndex:row];
    BabyStatusCell *cell = [[[BabyStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
    [cell updateCellWith:status];
    return cell.cellHeight;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    BabyStatusDetailViewController* Detail = [[BabyStatusDetailViewController alloc] init];
//    Detail.weibo = [statuesArr objectAtIndex:indexPath.section];
//    [self.navigationController pushViewController:Detail animated:YES];
//    [Detail release];
//}


#pragma mark - StatusCellDelegate

-(void)browserDidGetOriginImage:(NSDictionary*)dic
{
    NSString * url=[dic objectForKey:HHNetDataCacheURLKey];
    if ([url isEqualToString:browserView.bigImageURL])
    {
        [[SHKActivityIndicator currentIndicator] hide];
        shouldShowIndicator = NO;
        
        UIImage * img=[UIImage imageWithData:[dic objectForKey:HHNetDataCacheData]];
        [browserView.imageView setImage:img];
        [browserView zoomToFit];
        
        NSLog(@"big url = %@",browserView.bigImageURL);
        if ([browserView.bigImageURL hasSuffix:@".gif"])
        {
            CGFloat zoom = 320.0/browserView.imageView.image.size.width;
            CGSize size = CGSizeMake(320.0, browserView.imageView.image.size.height * zoom);
            
            CGRect frame = browserView.imageView.frame;
            frame.size = size;
            frame.origin.x = 0;
            CGFloat y = (480.0 - size.height)/2.0;
            frame.origin.y = y >= 0 ? y:0;
            browserView.imageView.frame = frame;
            if (browserView.imageView.frame.size.height > 480) {
                browserView.aScrollView.contentSize = CGSizeMake(320, browserView.imageView.frame.size.height);
            }
            
            GifView *gifView = [[GifView alloc]initWithFrame:frame data:[dic objectForKey:HHNetDataCacheData]];
            
            gifView.userInteractionEnabled = NO;
            gifView.tag = GIF_VIEW_TAG;
            [browserView addSubview:gifView];
            [gifView release];
        }
    }
}

#pragma mark - imageClick
-(void)statusImageClicked:(Status *)theStatus
{
    shouldShowIndicator = YES;
    NSLog(@"click is running");
    
    if ([theStatus.cellIndexPath section] > [statuesArr count]) {
        return ;
    }
    UIApplication *app = [UIApplication sharedApplication];
    CGRect frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    if (browserView == nil) {
        self.browserView = [[[ImageBrowser alloc]initWithFrame:frame] autorelease];
        [browserView setUp];
    }
    [browserView.imageView setImageWithURL:[NSURL URLWithString:theStatus.originalPic]];
    browserView.theDelegate = self;
    [app.keyWindow addSubview:browserView];
    app.statusBarHidden = YES;
    NSLog(@"URLWithString:theStatus.middleImageUrl:%@",theStatus.originalPic);
    if (shouldShowIndicator == YES && browserView) {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:browserView];
    }
    else shouldShowIndicator = YES;
    
}


#pragma mark -
#pragma mark  - Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
}

//调用此方法来停止。
- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	refreshFooterView.hidden = NO;
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y <-65) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }else if(scrollView.contentOffset.y >-65 ){
        [super scrollViewDidScroll:scrollView];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadVisuableImage:(UITableView *)scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    // [self refreshVisibleCellsImages];
    // [self loadVisuableImage:(UITableView *)scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate)
	{
     [self loadVisuableImage:(UITableView *)scrollView];
        
    }
    
    if (scrollView.contentOffset.y < 200)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

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
        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
        _shouldAppendTheDataArr = NO;
        
    }
}



- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}
#pragma mark - Action Methods
//clicked morebutton

- (void)statusMoreButtonClicked:(Status*)status
{
    UIActionSheet *sheet;
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USER_STORE_USER_ID];
    
    if (status.user.userId == userId.longLongValue) {
        sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"保存", nil];
    }else{
        sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存",nil];
    }
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [sheet showInView:window];
    [sheet release];
}
//save picture

- (void)savePicture
{
    NSIndexPath * clickedIndexPath = clickedStatus.cellIndexPath;
    StatusCell *cell = (StatusCell *)[self.table cellForRowAtIndexPath:clickedIndexPath];
    if (clickedStatus.statusImage == nil)
    {
        [[HHNetDataCacheManager getInstance] getDataWithURL:clickedStatus.bmiddlePic withIndex:clickedIndexPath.section];
    }
    
    cell.contentImage.image = clickedStatus.statusImage;
    UIImageWriteToSavedPhotosAlbum(cell.contentImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

//destroy status

- (void)deletePicture
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *weiboID =[NSString stringWithFormat:@"%lld",clickedStatus.statusId];
        [manager destroyAstatus:weiboID];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:weiboID,@"weiboID", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DeletedPic" object:nil userInfo:userInfo];
            [userInfo release];
        });
    });
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    NSString *userId = [[NSUserDefaults standardUserDefaults]stringForKey:USER_STORE_USER_ID];
    if (clickedStatus.user.userId == userId.longLongValue) {
        //0：删除 1：保存 2：取消
        switch (buttonIndex) {
            case 0:
                [self deletePicture];
                break;
            case 1:
                [self savePicture];
                break;
            case 2:
                break;
            default:
                break;
        }
    }else{
        //0：保存 1：取消
        switch (buttonIndex) {
            case 0:
                [self savePicture];
                break;
            case 1:
                break;
            default:
                break;
        }
    }
}

//查看图片的评论和做出评理

- (void)statusCommentButtonClicked:(Status*)status
{
    BabyStatusDetailViewController* Detail = [[BabyStatusDetailViewController alloc] init];
    Detail.weibo = status;
    Detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Detail animated:YES];
    [Detail release];
}


//跳转到用户介绍页面
- (void)babyStatusCellHeadImageClicked:(User *)user
{
    ProfileViewController *profile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    profile.user = user;
    profile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profile animated:YES];
    [profile release];
}

- (void)StatusShareButtonClicked:(Status*)status
{
}
//监听保存结果

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:nil
                                           message:@"保存失败！"
                                          delegate:self cancelButtonTitle:@"确认"
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:nil
                                           message:@"保存成功"
                                          delegate:self cancelButtonTitle:@"确认"
                                 otherButtonTitles:nil];
    [alert show];
    [alert release];
}

//监听完成删除后的，主页的刷新操作

- (void)receiveDeletePicNotification:(NSNotification *)notification
{
    long long deletedWeiboID = [[notification.userInfo objectForKey:@"weiboID"]longLongValue];
    NSLog(@"receiveDeletePicNotification, deleted:%lld",deletedWeiboID);
    int index = -1;
    for (int i=0; i<self.statuesArr.count; i++) {
        Status *status = [self.statuesArr objectAtIndex:i];
        if (status.statusId == deletedWeiboID) {
            index = i;
            break;
        }
    }
    if (index==-1) {
        return;
    }
    [self.statuesArr removeObjectAtIndex:index];
    [self.table reloadData];
    
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

@end