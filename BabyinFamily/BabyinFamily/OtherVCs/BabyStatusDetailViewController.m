//
//  BabyStatusDetailViewController.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-10.
//
//


#import "BabyStatusDetailViewController.h"
#import "Status.h"
#import "UIImageView+WebCache.h"
#import "BabyCommentCell.h"
#import "Comment.h"
#import "ProfileViewController.h"
#import "DAKeyboardControl.h"

@implementation BabyStatusDetailViewController
@synthesize weibo = _weibo;
@synthesize textField;
@synthesize sendButton;
@synthesize toolBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"详情";

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
    UIFont * font=[UIFont  systemFontOfSize:14];
    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(with, 300000.0f) lineBreakMode: UILineBreakModeWordWrap];
    CGFloat height = size.height + 0.;
    return height;
}

-(void)getComments:(int)page
{
    [_active startAnimating];
    manager = [WeiBoMessageManager getInstance];
    [manager getCommentListWithID:self.weibo.statusId maxID:0 page:page];
}

-(void)getMoreComments
{
    pageCount++;
    [self getComments:pageCount];
}

-(void)getCommentsFromNet:(NSNotification *)noti
{
    NSDictionary * dic = noti.object;
    NSLog(@"Commentsdic:%@",dic);
    NSArray * arr = [dic objectForKey:@"commentArrary"];
    commentsCount = [dic objectForKey:@"count"];
    count += [arr count];
    if (pageCount == 1) {
        [listCommentsArray removeAllObjects];
    }
    [listCommentsArray addObjectsFromArray:arr];
    
    [detailTableView reloadData];
}

-(void)delegateHeadClicked:(id)sender
{
    int  section = ((UIButton *)sender).tag;
    NSLog(@"section tag %d",section);
    flagHeader = !flagHeader;
    [detailTableView beginUpdates];
    [detailTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationRight];
    [detailTableView endUpdates];
    
    if (flagHeader) {
        if (![listCommentsArray count]==0) {
            footerButton.hidden = NO;
        }else{
            footerButton.hidden = YES;
        }
    }else{
        footerButton.hidden = NO;
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    listCommentsArray = [[NSMutableArray alloc]initWithCapacity:0];
    float height = DEVICE_IS_IPHONE5 ? 504 : 416;
    height-=40;
    detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, height) style:UITableViewStylePlain];
    detailTableView.delegate =self;
    detailTableView.dataSource = self;
    
    NSLog(@"self.weibo text :%@",self.weibo.text);
    [self.view addSubview:detailTableView];

    [self createToolBar];
    [self requestCommentlist];
}
- (void)requestCommentlist{
    pageCount = 1;
    count = 0;
    [self getComments:pageCount];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter * notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(getCommentsFromNet:) name:MMSinaGotCommentList object:nil];
    //  [self loadVisuableImage:detailTableView];
    [notification addObserver:self selector:@selector(commentResult:) name: MMSinaCommentAStatus object:nil];


}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
// Remove all observer.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


# pragma  mark -headImageClick

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        ProfileViewController * man = [[ProfileViewController alloc] init];
        man.user = ((Comment *)[listCommentsArray objectAtIndex:indexPath.row]).user;
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USER_STORE_USER_ID];

        if (self.weibo.user.userId == userId.longLongValue)
        {
           man.followButton.hidden = YES;

        }
        man.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:man animated:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return [listCommentsArray count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 52;
    }else{
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"tempCell";
        BabyDetailStatusCell *cell = [[[BabyDetailStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        [cell updateCellWith:self.weibo];

        return cell.cellHeight;
    }else{
        NSInteger row = indexPath.row;
        Comment * commentInfo = [listCommentsArray objectAtIndex:row];
        CGFloat  height = 0.0f;
        height  = [self cellHeight:commentInfo.text with:228.0f]+42;
        NSLog(@"height:%f",height);
        return height;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        BabyStatusCellHeadView *head = [[BabyStatusCellHeadView alloc]initWithFrame:CGRectMake(0, 0, 320, 52)];
        Status *status = _weibo;
        NSLog(@"status user name%@", status.user.name);
        head.userNameLabel.text = [status.user name];
        [head.avatarImage setImageWithURL:[NSURL URLWithString:status.user.profileLargeImageUrl]];
        head.locationLabel.text = status.user.location;
        [head.timeLabel   setText:status.timestamp];
        head.user = status.user;
        head.delegate = self;
        return head;
    }else
    {
        BabyDetailStatusCellHeadView *head = [[BabyDetailStatusCellHeadView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        Status *status = _weibo;
        NSLog(@"status user name%@", status.user.name);
        head.commentCount.text = [NSString stringWithFormat:@"评论:%d",status.commentsCount];
        return head;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"weiboCell";
        
        BabyDetailStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[BabyDetailStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        cell.backgroundColor = [UIColor whiteColor];
        if (cell.contentImage.hidden == NO) {
            [cell.contentImage setImageWithURL:[NSURL URLWithString:self.weibo.bmiddlePic]];
        }if(cell.repostContentImage.hidden == NO){
            [cell.repostContentImage setImageWithURL:[NSURL URLWithString:self.weibo.retweetedStatus.bmiddlePic]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Status * weibo  = self.weibo;
        NSLog(@"weibotext----------:%@", weibo.text);
        //    [cell updateCellWith:[listData objectAtIndex:row]];
        [cell updateCellWith:weibo];
        
        return cell;
    }else{
        static NSString *cellIdentifier = @"commentCell";
        BabyCommentCell  * cell = [[[BabyCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        //填充所有内容
        if ([listCommentsArray count] == 0) {
            NSLog(@"评论没有");
        }else{
            Comment * comment = [listCommentsArray objectAtIndex:indexPath.row];
            cell.weiboDetailCommentInfo = comment;
            CGRect frame = cell.commentContent.frame;
            frame.size.height = [self cellHeight:comment.text with:228.0];
            cell.commentContent.frame = frame;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        }
        
        
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
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

- (void)createToolBar
{
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
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
        
        CGRect toolBarFrame = toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        toolBar.frame = toolBarFrame;
        
        CGRect tableViewFrame = detailTableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y;
        detailTableView.frame = tableViewFrame;
    }];

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
- (void)sendButtonAction
{
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        
        NSString *content = textField.text;
        NSString *weiboID = [NSString stringWithFormat:@"%lld",_weibo.statusId];
        if ( content != Nil && content.length !=0) {
            
            [manager commentAStatus:weiboID content:content];
        }
        self.textField.text = @"";
    }
    
}
-(void)commentResult:(NSNotification *)notification
{
    NSNumber * boo = notification.object;
    BOOL success = [boo boolValue];
    NSLog(@"%d",success);
    if (success) {
        NSLog(@"评论成功");
        [self requestCommentlist];
    }else{
        NSLog(@"评论失败");
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"评论失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [textField resignFirstResponder];
}



-(void)dealloc
{
    [self.weibo release];
    [_active release];
    [textField release];
    [sendButton release];
    [toolBar release];
    [super release];
    [super dealloc];
}
@end
