//
//  MessageViewController.m
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//

#import "MessageViewController.h"
#import "ZJTCommentCell.h"
#import "BabyHelper.h"
#import "WeiBoMessageManager.h"
#import "Comment.h"
#import "AddCommentVC.h"
#import "SHKActivityIndicator.h"
#import "GifView.h"
#import "HHNetDataCacheManager.h"
#import "NSStringAdditions.h"
#import "ProfileViewController.h"

@interface MessageViewController ()
@end

@implementation MessageViewController
@synthesize table;
@synthesize commentCellNib;
@synthesize status;
@synthesize user;
@synthesize avatarImage;
@synthesize contentImage;
@synthesize commentArr;
@synthesize isFromProfileVC;
@synthesize clickedComment;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        isFromProfileVC = NO;
        shouldShowIndicator = YES;
        _page = 1;
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"消息";
        NSString *fullpath = [NSString stringWithFormat:@"sourcekit.bundle/image/%@", @"tabbar_msg"];
        self.tabBarItem.image = [UIImage imageNamed:fullpath];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)refreshVisibleCellsImages
{
    NSArray *cellArr = [self.table visibleCells];
    for (ZJTCommentCell *cell in cellArr) {
        NSIndexPath *inPath = [self.table indexPathForCell:cell];
        Comment *comment = [commentArr objectAtIndex:inPath.row];
        User *theUser = comment.user;
        
        if (theUser.avatarImage == nil)
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:theUser.profileImageUrl withIndex:inPath.row];
        }
        else {
            cell.avatarImage.image = theUser.avatarImage;
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    manager = [WeiBoMessageManager getInstance];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0.0f,
                                                          0.0f,
                                                          self.view.bounds.size.width,
                                                          self.view.bounds.size.height)];
    
    table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    table.dataSource = self;
    table.delegate = self;
    table = self.tableView;

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    else
        return YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didGetComments:) name:MMSinaToMeCommentList object:nil];
    [center addObserver:self selector:@selector(mmRequestFailed:) name:MMSinaRequestFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAvatar:)         name:HHNetDataCacheNotification object:nil];
    
    if (self.commentArr == nil) {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..."];

        [manager getCommetListToMe:nil page:1];
    }
}

- (void)refresh {
   [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..."];

    [manager getCommetListToMe:_maxID page:_page];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(UINib*)commentCellNib
{
    if (commentCellNib == nil) {
        self.commentCellNib = [ZJTCommentCell nib];
    }
    return commentCellNib;
}

- (void)dealloc {
    [_maxID release];
    _maxID = nil;
    self.clickedComment = nil;
    
    self.table = nil;
    self.commentCellNib = nil;
    self.status = nil;
    self.user = nil;
    self.avatarImage = nil;
    self.contentImage = nil;
    self.commentArr = nil;
    [super dealloc];
}


//计算text field 的高度。
-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
    UIFont * font=[UIFont  systemFontOfSize:14];
    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(with, 300000.0f) lineBreakMode:kLineBreakMode];
    CGFloat height = size.height + 0.;
    return height;
}


#pragma mark HTTP Response
-(void)didGetComments:(NSNotification*)sender
{
    if ([sender.object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic = sender.object;
        NSMutableArray *arr = [dic objectForKey:@"commentArraryToMe"];
        
        if (commentArr == nil) {
            self.commentArr = arr;
        }
        else {
            [commentArr addObjectsFromArray:arr];
        }
        _page++;
        if (_maxID == nil && commentArr.count != 0) {
            Comment *com = [commentArr objectAtIndex:0];
            _maxID = [[NSString stringWithFormat:@"%lld",com.commentId] retain];
        }
        if (commentArr != nil && ![commentArr isEqual:[NSNull null]])
        {
            NSNumber *count = [dic objectForKey:@"count"];
            status.commentsCount = [count intValue];
        }
        [[SHKActivityIndicator currentIndicator]hide];
        [table reloadData];
        [self stopLoading];
        [self performSelector:@selector(refreshVisibleCellsImages) withObject:nil afterDelay:0.5];
    }
}

-(void)dismissAlert:(id)sender
{
    NSTimer *timer = sender;
    if ([timer.userInfo isKindOfClass:[UIAlertView class]]) {
        UIAlertView *alert = timer.userInfo;
        
        if (alert) {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [alert release];
        }
    }
}


//得到图片
-(void)getAvatar:(NSNotification*)sender
{
    NSDictionary * dic = sender.object;
    NSString * url          = [dic objectForKey:HHNetDataCacheURLKey];
    NSNumber *indexNumber   = [dic objectForKey:HHNetDataCacheIndex];
    NSInteger index         = [indexNumber intValue];
    NSData *data            = [dic objectForKey:HHNetDataCacheData];
    UIImage * image     = [UIImage imageWithData:data];
    
    if (data == nil) {
        NSLog(@"data == nil");
    }
    //当下载大图过程中，后退，又返回，如果此时收到大图的返回数据，会引起crash，在此做预防。
    if (indexNumber == nil || index == -1) {
        NSLog(@"indexNumber = nil");
        return;
    }
    
    if (index >= [commentArr count]) {
        //        NSLog(@"statues arr error ,index = %d,count = %d",index,[statuesArr count]);
        return;
    }
    
    Comment  *comment = [commentArr objectAtIndex:index];
    User *theUser = comment.user;
    
    ZJTCommentCell *cell = (ZJTCommentCell *)[self.table cellForRowAtIndexPath:comment.cellIndexPath];
    
    //得到的是头像图片
    if ([url isEqualToString:theUser.profileImageUrl])
    {
        theUser.avatarImage = image;
        cell.avatarImage.image = theUser.avatarImage;
    }
}

-(void)mmRequestFailed:(id)sender
{
    [self stopLoading];
    [[SHKActivityIndicator currentIndicator] hide];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (commentArr == nil || [commentArr isEqual:[NSNull null]]) {
        return 0;
    }
    return [commentArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  row = indexPath.row;
    ZJTCommentCell *cell = [ZJTCommentCell cellForTableView:table fromNib:self.commentCellNib];
    
    if (commentArr == nil || [commentArr isEqual:[NSNull null]]) {
        return cell;
    }
    else if (row >= [commentArr count] || [commentArr count] == 0)
    {
        //        NSLog(@"cellForRowAtIndexPath error ,index = %d,count = %d",row,[commentArr count]);
        return cell;
    }
    
    Comment *comment = [commentArr objectAtIndex:row];
    
    cell.nameLB.text = comment.user.screenName;
    cell.contentLB.text = comment.text;
    comment.cellIndexPath = indexPath;
    
    if (self.table.dragging == NO && self.table.decelerating == NO)
    {
        if (comment.user.avatarImage == nil)
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.user.profileImageUrl withIndex:row];
        }
    }
    cell.avatarImage.image = comment.user.avatarImage;
    
    CGRect frame = cell.contentLB.frame;
    frame.size.height = [self cellHeight:comment.text with:228.];
    cell.contentLB.frame = frame;
    
    cell.timeLB.text = comment.timestamp;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  row = indexPath.row;
    Comment *comment = [commentArr objectAtIndex:row];
    CGFloat height = 0.0f;
    height = [self cellHeight:comment.text with:228.0f] + 42.;
    if (height < 66.) {
        height = 66.;
    }
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    self.clickedComment = [commentArr objectAtIndex:row];
    User *theUser = clickedComment.user;
    ProfileViewController *profile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    profile.user = theUser;
    profile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profile animated:YES];
    [profile release];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshVisibleCellsImages];
}

@end


