//
//  AddComment.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-3-3.
//
//

#import "AddComment.h"
#import "DAKeyboardControl.h"
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

enum{
    kCommentClickActionSheet = 0,
    kStatusReplyActionSheet,
};

enum{
    kReplyComment = 0,
    kViewUserProfile,
    kFollowTheUser,
};

enum  {
    kRetweet = 0,
    kComment,
};

@interface AddComment ()
-(CGRect)getFrameOfImageView:(UIImageView*)imgView;
@end

@implementation AddComment
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(CGRect)getFrameOfImageView:(UIImageView*)imgView
{
    UIImageView *iv = imgView; // your image view
    CGSize imageSize = iv.image.size;
    CGFloat imageScale = fminf(CGRectGetWidth(iv.bounds)/imageSize.width, CGRectGetHeight(iv.bounds)/imageSize.height);
    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
    CGRect imageFrame = CGRectMake(floorf(0.5f*(CGRectGetWidth(iv.bounds)-scaledImageSize.width)), floorf(0.5f*(CGRectGetHeight(iv.bounds)-scaledImageSize.height)), scaledImageSize.width, scaledImageSize.height);
    return imageFrame;
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

    self.title = @"评论";
    //self.user = status.user;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0.0f,
                                                                           0.0f,
                                                                           self.view.bounds.size.width,
                                                                           self.view.bounds.size.height - 40.0f)];
    
    table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                     self.view.bounds.size.height - 40.0f,
                                                                     self.view.bounds.size.width,
                                                                     40.0f)];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:toolBar];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f,
                                                                           6.0f,
                                                                           toolBar.bounds.size.width - 20.0f - 68.0f,
                                                                           30.0f)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [toolBar addSubview:textField];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.frame = CGRectMake(toolBar.bounds.size.width - 68.0f,
                                  6.0f,
                                  58.0f,
                                  29.0f);
    [toolBar addSubview:sendButton];
    
    
    self.view.keyboardTriggerOffset = toolBar.bounds.size.height;
    
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
        CGRect toolBarFrame = toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        toolBar.frame = toolBarFrame;
        
        CGRect tableViewFrame = table.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y;
        table.frame = tableViewFrame;
    }];
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
    [center addObserver:self selector:@selector(didGetComments:) name:MMSinaGotCommentList object:nil];
    [center addObserver:self selector:@selector(didFollowByUserID:) name:MMSinaFollowedByUserIDWithResult object:nil];
    [center addObserver:self selector:@selector(didUnfollowByUserID:) name:MMSinaUnfollowedByUserIDWithResult object:nil];
    [center addObserver:self selector:@selector(mmRequestFailed:) name:MMSinaRequestFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAvatar:)         name:HHNetDataCacheNotification object:nil];
    [center addObserver:self selector:@selector(didCommentAStatus:) name:MMSinaCommentAStatus object:nil];
    if (self.commentArr == nil) {
        [manager getCommentListWithID:status.statusId maxID:nil page:1];
    }
}

- (void)refresh {
    [manager getCommentListWithID:status.statusId maxID:_maxID page:_page];
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
        NSMutableArray *arr = [dic objectForKey:@"commentArrary"];
        
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
            //[self resetCountLBFrame];
        }
        [[SHKActivityIndicator currentIndicator]hide];
        //        [[ZJTStatusBarAlertWindow getInstance] hide];
        [table reloadData];
        //[self stopLoading];
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

-(void)didCommentAStatus:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
}

-(void)didFollowByUserID:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    NSNumber *result = [dic objectForKey:@"result"];
    if (result.intValue == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关注成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(dismissAlert:) userInfo:alert repeats:NO];
    }
    
    if (result.intValue == 0) {//成功
        user.following = YES;
        [self.navigationItem.rightBarButtonItem setTitle:@"取消关注"];
    }
}

-(void)didUnfollowByUserID:(NSNotification *)sender
{
    NSDictionary *dic = sender.object;
    NSNumber *result = [dic objectForKey:@"result"];
    
    if (result.intValue == 0) {//成功
        user.following = NO;
        [self.navigationItem.rightBarButtonItem setTitle:@"关注"];
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
    //[self stopLoading];
    [[SHKActivityIndicator currentIndicator] hide];
    //    [[ZJTStatusBarAlertWindow getInstance] hide];
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
    cell.vipImageView.hidden = !comment.user.verified;
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
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复",@"查看资料",@"关注", nil];
    as.tag = kCommentClickActionSheet;
    [as showInView:self.view];
    [as release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kCommentClickActionSheet) {
        User *theUser = clickedComment.user;
        NSLog(@"%dtheUser name = %@",buttonIndex,theUser.screenName);
        if (buttonIndex == kReplyComment) {
            
        }
        else if (buttonIndex == kViewUserProfile) {
            ProfileViewController *profile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
            profile.user = theUser;
            profile.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:profile animated:YES];
            [profile release];
        }
        else if(buttonIndex == kFollowTheUser){
            [manager followByUserID:theUser.userId inTableView:@""];
        }
    }
    else if (actionSheet.tag == kStatusReplyActionSheet)
    {
        if (buttonIndex == kRetweet) {
           /* TwitterVC *tv = [[TwitterVC alloc]initWithNibName:@"TwitterVC" bundle:nil];
            [self.navigationController pushViewController:tv animated:YES];
            [tv setupForRepost:[NSString stringWithFormat:@"%lld",self.status.statusId]];
            [tv release];*/
        }
        else if(buttonIndex == kComment)
        {
            /*TwitterVC *tv = [[TwitterVC alloc]initWithNibName:@"TwitterVC" bundle:nil];
            [self.navigationController pushViewController:tv animated:YES];
            [tv setupForComment:[NSString stringWithFormat:@"%lld",clickedComment.commentId]
                        weiboID:[NSString stringWithFormat:@"%lld",self.status.statusId]];
            [tv release];*/
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshVisibleCellsImages];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //    [self refreshVisibleCellsImages];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate)
	{
        [self refreshVisibleCellsImages];
    }
}



@end