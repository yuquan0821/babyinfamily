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
#import "WeiBoMessageManager.h"
#import "Comment.h"
#import "ProfileViewController.h"
@implementation BabyStatusDetailViewController
@synthesize weibo = _weibo;
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
    WeiBoMessageManager * message = [WeiBoMessageManager getInstance];
    [message getCommentListWithID:self.weibo.statusId maxID:0 page:page];
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

    detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, height) style:UITableViewStylePlain];
    detailTableView.delegate =self;
    detailTableView.dataSource = self;
    
    NSLog(@"self.weibo text :%@",self.weibo.text);
    [self.view addSubview:detailTableView];
    pageCount = 1;
    count = 0;
    [self getComments:pageCount];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter * notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(getCommentsFromNet:) name:MMSinaGotCommentList object:nil];
    //  [self loadVisuableImage:detailTableView];
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
        return 50;
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
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        return 0;
    }
    
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

-(void)dealloc
{
    [self.weibo release];
    [_active release];
    [super release];
    [super dealloc];
}
@end
