//
//  StatusViewControllerBase.m
//  
//
//  Created by 范艳春 on 12-11-27.
//
//

#import "StatusViewControllerBase.h"
#import "UIImageView+Resize.h"
#import "ProfileViewController.h"
#import "SVStatusHUD.h"

#define kTextViewPadding            16.0
#define kLineBreakMode              UILineBreakModeWordWrap


@interface StatusViewControllerBase()
- (void)setup;
- (void)refreshVisibleCellsImages;
@end

@implementation StatusViewControllerBase
@synthesize table;
@synthesize statusCellNib;
@synthesize statuesArr;
@synthesize headDictionary;
@synthesize imageDictionary;
@synthesize browserView;
@synthesize clickedStatus;

-(void)dealloc
{
    self.headDictionary = nil;
    self.imageDictionary = nil;
    self.statusCellNib = nil;
    self.statuesArr = nil;
    self.browserView = nil;
    _refreshHeaderView=nil;
    [table release];
    table = nil;
    [clickedStatus release];
    [super dealloc];
}

-(void)setup
{
   
    self.title = @"主页";
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
    headDictionary = [[NSMutableDictionary alloc] init];
    imageDictionary = [[NSMutableDictionary alloc] init];
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

-(UINib*)statusCellNib
{
    if (statusCellNib == nil)
    {
        [statusCellNib release];
        statusCellNib = [[StatusCell nib] retain];
    }
    return statusCellNib;
}

-(void)setUpRefreshView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
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
    //[self.navigationController.view layoutSubviews];
    [self setUpRefreshView];
    self.tableView.contentInset = UIEdgeInsetsOriginal;
    refreshFooterView.hidden = YES;
    NSLog(@" sts base table = %@,delegate = %@",self.tableView,self.tableView.delegate);
    NSLog(@"navigation is height %f",self.navigationController.navigationBar.frame.size.height);
    self.table = self.tableView;
    [defaultNotifCenter addObserver:self selector:@selector(getAvatar:)         name:HHNetDataCacheNotification object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(mmRequestFailed:)   name:MMSinaRequestFailed object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(loginSucceed)       name:DID_GET_TOKEN_IN_WEB_VIEW object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(receiveDeletePicNotification:) name:@"DeletedPic" object:nil];


}

-(void)viewDidUnload
{
    [defaultNotifCenter removeObserver:self name:HHNetDataCacheNotification object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaRequestFailed        object:nil];
    [defaultNotifCenter removeObserver:self name:DID_GET_TOKEN_IN_WEB_VIEW  object:nil];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.table reloadData];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.table reloadData];
}

#pragma mark - Methods
-(void)loginSucceed
{
    shouldLoad = YES;
}

-(void)refreshVisibleCellsImages
{
    NSArray *cellArr = [self.table visibleCells];
    for (StatusCell *cell in cellArr) {
        NSIndexPath *inPath = [self.table indexPathForCell:cell];
        Status *status = [statuesArr objectAtIndex:inPath.row];
        User *user = status.user;
        
        if (user.avatarImage == nil)
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileImageUrl withIndex:inPath.row];
        }
        else {
            cell.avatarImage.image = user.avatarImage;
        }
        
        if (status.statusImage == nil)
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.bmiddlePic withIndex:inPath.row];
        }
        else {
            cell.contentImage.image = status.statusImage;
        }

    }

}

//得到图片
-(void)getAvatar:(NSNotification*)sender
{
    NSDictionary * dic      = sender.object;
    NSString * url          = [dic objectForKey:HHNetDataCacheURLKey];
    NSNumber *indexNumber   = [dic objectForKey:HHNetDataCacheIndex];
    NSInteger index         = [indexNumber intValue];
    NSData *data            = [dic objectForKey:HHNetDataCacheData];
    UIImage * image         = [UIImage imageWithData:data];
    
    if (data == nil) {
        NSLog(@"data == nil");
    }
    //当下载大图过程中，后退，又返回，如果此时收到大图的返回数据，会引起crash，在此做预防。
    if (indexNumber == nil || index == -1) {
        NSLog(@"indexNumber = nil");
        return;
    }
    
    if (index >= [statuesArr count]) {
        NSLog(@"statues arr error ,index = %d,count = %d",index,[statuesArr count]);
        return;
    }
    
    Status *sts = [statuesArr objectAtIndex:index];
    User *user = sts.user;
    
    StatusCell *cell = (StatusCell *)[self.table cellForRowAtIndexPath:sts.cellIndexPath];
    //得到的是头像图片
    if ([url isEqualToString:user.profileImageUrl])
    {
        user.avatarImage = image;
        cell.avatarImage.image = user.avatarImage;
    }
    
    //得到的是博文图片
    if([url isEqualToString:sts.bmiddlePic])
    {
        CGSize size = CGSizeMake(300, 300);
        image = [UIImageView imageWithImage:[UIImage imageWithData:data] scaledToSizeWithSameAspectRatio:size];
        sts.statusImage =image;
        cell.contentImage.image = sts.statusImage;
    }
    
    //得到的是转发的图片
    if (sts.retweetedStatus && ![sts.retweetedStatus isEqual:[NSNull null]])
    {
        if ([url isEqualToString:sts.retweetedStatus.thumbnailPic])
        {
            sts.statusImage = image;
        }
    }
}

-(void)mmRequestFailed:(id)sender
{
    [self stopLoading];
    [self doneLoadingTableViewData];
    [[SHKActivityIndicator currentIndicator] hide];
    
}

//计算text field 的高度。
-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
    UIFont * font=[UIFont  systemFontOfSize:14];
    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(with - kTextViewPadding, 300000.0f) lineBreakMode:kLineBreakMode];
    CGFloat height = size.height;
    return height ;//= 200.0f;
}

- (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib {
    static NSString *cellID = @"StatusCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSLog(@"statuss cell new");
        
        NSArray *nibObjects = [nib instantiateWithOwner:Nil options:Nil];
        cell = [nibObjects objectAtIndex:0];
    }
    else {
        [(LPBaseCell *)cell reset];
    }
    
    return cell;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [statuesArr count];
}

//add statusCell to sectionrows
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  row = indexPath.row;
    StatusCell *cell = [self cellForTableView:tableView fromNib:self.statusCellNib];
    [cell.moreButton addTarget:self action:@selector(moreButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentButton addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];
    [cell.userNameButton addTarget:self action:@selector(goToProfile:) forControlEvents:UIControlEventTouchUpInside];


    if (row >= [statuesArr count]) {
        return cell;
    }
    
    Status *status = [statuesArr objectAtIndex:row];
    status.cellIndexPath = indexPath;
    cell.delegate = self;
    cell.cellIndexPath = indexPath;
    [cell setupCell:status ];
    if (self.table.dragging == NO && self.table.decelerating == NO) //只有scrollview没有滑动时才加载（节省流量）

    {
        if (status.user.avatarImage == nil)
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.user.profileImageUrl withIndex:row];
        }
        
        if (status.statusImage == nil)
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.bmiddlePic withIndex:row];
        }
    }
    cell.avatarImage.image = status.user.avatarImage;
    cell.contentImage.image = status.statusImage;
    
    //开始绘制第一个cell时，隐藏indecator.
    if (isFirstCell) {
        [[SHKActivityIndicator currentIndicator] hide];
        isFirstCell = NO;
    }
    return cell;

}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 385.0f;
    
    NSInteger  row = indexPath.row;
    
    if (row >= [statuesArr count])
    {
        NSLog(@"heightForRowAtIndexPath error ,index = %d,count = %d",row,[statuesArr count]);
        return 1;
    }
    
    Status *status          = [statuesArr objectAtIndex:row];
    NSString *url = status.bmiddlePic;
    StatusCell *cell = [self cellForTableView:tableView fromNib:self.statusCellNib];
    [cell setupCell:status];
    NSData *imageData = [imageDictionary objectForKey:[NSNumber numberWithInt:[indexPath row]]];
    CGFloat height = 0.0f;
    
    //
    if (url && [url length] != 0)
    {
        height = [cell setCellHeight: status contentImageData:imageData];
        NSLog(@"hight is %f",height);
    }
    return height;
}

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

-(void)cellImageDidTaped:(StatusCell *)theCell image:(UIImage *)image
{
    shouldShowIndicator = YES;
    
    if ([theCell.cellIndexPath row] > [statuesArr count]) {
        //        NSLog(@"cellImageDidTaped error ,index = %d,count = %d",[theCell.cellIndexPath row],[statuesArr count]);
        return ;
    }
    
    Status *sts = [statuesArr objectAtIndex:[theCell.cellIndexPath row]];
    BOOL isRetwitter = sts.retweetedStatus && sts.retweetedStatus.originalPic != nil;
    UIApplication *app = [UIApplication sharedApplication];
    
    CGRect frame = CGRectMake(0, 0, 320, 480);
    if (browserView == nil) {
        self.browserView = [[[ImageBrowser alloc]initWithFrame:frame] autorelease];
        [browserView setUp];
    }
    
    browserView.image = image;
    browserView.theDelegate = self;
    browserView.bigImageURL = isRetwitter ? sts.retweetedStatus.originalPic : sts.originalPic;
    [browserView loadImage];
    [app.keyWindow addSubview:browserView];
    app.statusBarHidden = YES;
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
    
    if (scrollView.contentOffset.y < 200) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    else
        [super scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshVisibleCellsImages];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self refreshVisibleCellsImages];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate)
	{
        [self refreshVisibleCellsImages];
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
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

//clicked morebutton

- (void)moreButtonOnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    StatusCell *cell = (StatusCell *)button.superview.superview;
    NSIndexPath *path = [self.table indexPathForCell:cell];
    Status *status = [self.statuesArr objectAtIndex:path.row];
    self.clickedStatus = status;
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
        [[HHNetDataCacheManager getInstance] getDataWithURL:clickedStatus.bmiddlePic withIndex:clickedIndexPath.row];
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

- (void)addComment:(id)sender
{
    UIButton *button = (UIButton *)sender;
    StatusCell *cell = (StatusCell *)button.superview.superview;
    NSIndexPath *path = [self.table indexPathForCell:cell];
    Status *status = [self.statuesArr objectAtIndex:path.row];
    AddComment *add = [[AddComment alloc]initWithNibName:@"AddComment" bundle:nil];
    add.status = status;
    add.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
    [add release];
}

//跳转到用户介绍页面

- (void)goToProfile:(id)sender
{
    UIButton *button = (UIButton *)sender;
    StatusCell *cell = (StatusCell *)button.superview.superview;
    NSIndexPath *path = [self.table indexPathForCell:cell];
    Status *status = [self.statuesArr objectAtIndex:path.row];
    ProfileViewController *profile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    profile.user = status.user;
    profile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profile animated:YES];
    [profile release];
    
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



@end
