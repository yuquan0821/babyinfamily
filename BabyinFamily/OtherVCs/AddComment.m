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
@synthesize theScrollView;
@synthesize sendButton;
@synthesize textField;
@synthesize successAddComment;

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
    self.view.backgroundColor = [UIColor lightGrayColor];
    theScrollView.contentSize = CGSizeMake(320, 410);
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0.0f,
                                                                           0.0f,
                                                                           self.view.bounds.size.width,
                                                                           self.view.bounds.size.height - 40.0f)];
    
    self.table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                     self.view.bounds.size.height - 40.0f,
                                                                     self.view.bounds.size.width,
                                                                     40.0f)];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:toolBar];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f,
                                                                           6.0f,
                                                                           toolBar.bounds.size.width - 20.0f - 68.0f,
                                                                           30.0f)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:13.0];
    textField.textAlignment = UITextAlignmentLeft;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.placeholder = @"请输入评论";
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textField.delegate = self;
    [toolBar addSubview:textField];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.enabled = NO;
    sendButton.frame = CGRectMake(toolBar.bounds.size.width - 68.0f,
                                  6.0f,
                                  58.0f,
                                  29.0f);
    [sendButton addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didComment:) name:MMSinaCommentAStatus object:nil];

    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        if (self.commentArr == nil) {
            [manager getCommentListWithID:status.statusId maxID:nil page:1];
        }

    }
    if (self.commentArr == nil) {
        [manager getCommentListWithID:status.statusId maxID:nil page:1];
    }
}

- (void)refresh {
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
            
        [manager getCommentListWithID:status.statusId maxID:_maxID page:_page];
    }
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
    self.theScrollView = nil;
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

-(void)didFollowByUserID:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    NSNumber *result = [dic objectForKey:@"result"];
    if (result.intValue == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关注成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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

-(void)didComment:(NSNotification*)sender
{
   // NSNumber *num = sender.object;
    self.sendButton.enabled = NO;
    [self.commentArr removeAllObjects];
    [manager getCommentListWithID:status.statusId maxID:nil page:1];
    [self.table reloadData];
    
}

- (void)sendButtonAction
{
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        
        NSString *content = textField.text;
        NSString *weiboID = [NSString stringWithFormat:@"%lld",status.statusId];
        if ( content != Nil && content.length !=0) {
            
            [manager commentAStatus:weiboID content:content];
        }
        self.textField.text = @"";
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
    //[self.table stopLoading];
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

    //UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复",@"查看资料", nil];
    //as.tag = kCommentClickActionSheet;
    //[as showInView:self.view];
    //[as release];
}

/*- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kCommentClickActionSheet) {
        User *theUser = clickedComment.user;
        NSLog(@"%dtheUser name = %@",buttonIndex,theUser.screenName);
        if (buttonIndex == kViewUserProfile) {
            ProfileViewController *profile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
            profile.user = theUser;
            profile.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:profile animated:YES];
            [profile release];
        }
    }
    else if (actionSheet.tag == kStatusReplyActionSheet)
    {
        if(buttonIndex == kComment)
        {
            TwitterVC *tv = [[TwitterVC alloc]initWithNibName:@"TwitterVC" bundle:nil];
            [self.navigationController pushViewController:tv animated:YES];
            [tv setupForComment:[NSString stringWithFormat:@"%lld",clickedComment.commentId]
                        weiboID:[NSString stringWithFormat:@"%lld",self.status.statusId]];
            [tv release];
        }
    }
}

*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshVisibleCellsImages];
}

#pragma mark - UiTextFieldDelegate

- (BOOL)textField:(UITextField *)textField1 shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *newValue = [[textField1.text mutableCopy] autorelease];
    [newValue replaceCharactersInRange:range withString:string];//string是当前输入的字符，newValue是当前输入框中的字符
    if ([newValue length]== 0)
    {
        self.sendButton.enabled = NO;
    }
    else
    {
        self.sendButton.enabled  = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField1
{
    if (textField1.text.length == 0) {
        self.sendButton.enabled = NO;
    }
    else {
        self.sendButton.enabled = YES;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField1
{
    NSString *temp = textField1.text;
    if (temp.length != 0) {
        self.sendButton.enabled = YES;
    }
    else {
        self.sendButton.enabled = NO;
    }
    
    if (temp.length > 140) {
        textField1.text = [temp substringToIndex:140];
    }
}



@end