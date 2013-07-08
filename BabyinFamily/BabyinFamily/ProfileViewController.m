//
//  ProfileViewController.m
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//


#import "ProfileViewController.h"
#import "HHNetDataCacheManager.h"
#import "FollowerVC.h"
#import "WeiBoMessageManager.h"
#import "BabyHelper.h"

#define kLineBreakMode              UILineBreakModeWordWrap

enum {
    kSinaVerifiedRow = 0,
    kLocationRow,
    kSelfDescriptionRow,
    kDescriptionRowsCount,
};

@interface ProfileViewController ()

-(void)updateWithUser:(User*)theUser;

@end

@implementation ProfileViewController
@synthesize table;
@synthesize avatarImageView;
@synthesize genderIamgeView;
@synthesize nameLabel;
@synthesize followButton;
@synthesize fansButton;
@synthesize idolButton;
@synthesize weiboButton;
//@synthesize topicButton;
@synthesize tableHeaderView;
@synthesize user;
@synthesize verifiedProfileCell;
@synthesize locationProfileCell;
@synthesize descriptionProfileCell;
@synthesize screenName;
@synthesize topicsArr;
@synthesize userID;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *fullpath = [NSString stringWithFormat:@"sourcekit.bundle/image/%@", @"tabbar_profile"];
        self.tabBarItem.image = [UIImage imageNamed:fullpath];
    }
    return self;
}

- (void)feedBack
{
    FeedBackViewController *fb = [[FeedBackViewController alloc]initWithNibName:@"FeedBackViewController" bundle:nil];
    [self.navigationController pushViewController:fb animated:YES];
    [fb release];
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
    
    if(screenName){
        [[WeiBoMessageManager getInstance] getUserInfoWithScreenName:self.screenName];
    }
    
    if ([self.title isEqualToString:@"我的"]) {
        self.user = [BabyHelper getInstance].user;
        UIBarButtonItem *retwitterBtn = [[UIBarButtonItem alloc]initWithTitle:@"反馈" style:UIBarButtonItemStylePlain target:self action:@selector(feedBack)];
        self.navigationItem.rightBarButtonItem = retwitterBtn;
        [retwitterBtn release];
        
        UIBarButtonItem *SettingBtn = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
        self.navigationItem.leftBarButtonItem = SettingBtn;
        [SettingBtn release];
    }
    self.userID = [[NSUserDefaults standardUserDefaults]stringForKey:USER_STORE_USER_ID];

    if (user.userId == userID.longLongValue ) {
        followButton.hidden = YES;
    }
      
        UIImage *normalImage = [UIImage imageNamed:@"weibo.bundle/WeiboImages/details_edit_normal_btn.png"];
        UIImage *pressdImage = [UIImage imageNamed:@"weibo.bundle/WeiboImages/details_edit_normal_pressed.png"];
        [fansButton setBackgroundImage:[normalImage stretchableImageWithLeftCapWidth:71 topCapHeight:16] forState:UIControlStateNormal];
        [fansButton setBackgroundImage:[pressdImage stretchableImageWithLeftCapWidth:71 topCapHeight:16]  forState:UIControlStateHighlighted];
        
        [idolButton setBackgroundImage:[normalImage stretchableImageWithLeftCapWidth:71 topCapHeight:16] forState:UIControlStateNormal];
        [idolButton setBackgroundImage:[pressdImage stretchableImageWithLeftCapWidth:71 topCapHeight:16]  forState:UIControlStateHighlighted];
        
        [weiboButton setBackgroundImage:[normalImage stretchableImageWithLeftCapWidth:71 topCapHeight:16] forState:UIControlStateNormal];
        [weiboButton setBackgroundImage:[pressdImage stretchableImageWithLeftCapWidth:71 topCapHeight:16]  forState:UIControlStateHighlighted];
        
       /* [topicButton setBackgroundImage:[normalImage stretchableImageWithLeftCapWidth:71 topCapHeight:16] forState:UIControlStateNormal];
        [topicButton setBackgroundImage:[pressdImage stretchableImageWithLeftCapWidth:71 topCapHeight:16]  forState:UIControlStateHighlighted];*/
        
        fansButton.titleLabel.numberOfLines = 2;
        idolButton.titleLabel.numberOfLines = 2;
        weiboButton.titleLabel.numberOfLines = 2;
        //topicButton.titleLabel.numberOfLines = 2;
        
        [fansButton.titleLabel setTextAlignment:UITextAlignmentCenter];
        [idolButton.titleLabel setTextAlignment:UITextAlignmentCenter];
        [weiboButton.titleLabel setTextAlignment:UITextAlignmentCenter];
       // [topicButton.titleLabel setTextAlignment:UITextAlignmentCenter];
        
        [self updateWithUser:user];
        [table setTableHeaderView:tableHeaderView];

    
    
}

-(void)updateWithUser:(User*)theUser
{
    if (!user) {
        return;
    }
    if (![self.title isEqualToString:@"我的"]) {
        self.title = user.screenName;
    }
    NSString *title = nil;
    title = [NSString stringWithFormat:@"%d\n粉丝",theUser.followersCount];
    [fansButton setTitle:title forState:UIControlStateNormal];
    
    title = [NSString stringWithFormat:@"%d\n关注",theUser.friendsCount];
    [idolButton setTitle:title forState:UIControlStateNormal];
    
    title = [NSString stringWithFormat:@"%d\n微博",theUser.statusesCount];
    [weiboButton setTitle:title forState:UIControlStateNormal];
    
    //[topicButton setTitle:title forState:UIControlStateNormal];
    
    if (user.following) {
        [followButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    else {
        [followButton setTitle:@"加关注" forState:UIControlStateNormal];
    }
    
    if (user.gender == GenderMale) {
        genderIamgeView.image = [UIImage imageNamed:@"weibo.bundle/WeiboImages/male.png"];
    }
    else if (user.gender == GenderFemale) {
        genderIamgeView.image = [UIImage imageNamed:@"weibo.bundle/WeiboImages/female.png"];
    }
    else {
        genderIamgeView.image = nil;
    }
    
    nameLabel.text = user.screenName;
    CGSize size = [user.screenName sizeWithFont:nameLabel.font];
    
    CGRect frame =  nameLabel.frame;
    if (size.width>125) {
        size.width = 125;
    }
    frame.size = size;
    nameLabel.frame = frame;
    
    frame = genderIamgeView.frame;
    frame.origin.x = nameLabel.frame.origin.x + nameLabel.frame.size.width + 5;
    genderIamgeView.frame = frame;
    
    [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileLargeImageUrl];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAvatar:) name:HHNetDataCacheNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUserInfo:)    name:MMSinaGotUserInfo          object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFollowByUserIDWithResult:) name:MMSinaFollowedByUserIDWithResult object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUnfollowByUserIDWithResult:) name:MMSinaUnfollowedByUserIDWithResult object:nil];

    }
  }

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [table reloadData];

    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setTable:nil];
    [self setAvatarImageView:nil];
    [self setGenderIamgeView:nil];
    [self setNameLabel:nil];
    [self setFollowButton:nil];
    [self setFansButton:nil];
    [self setIdolButton:nil];
    [self setWeiboButton:nil];
  //  [self setTopicButton:nil];
    [self setTableHeaderView:nil];
    [self setLocationProfileCell:nil];
    [self setDescriptionProfileCell:nil];
    [self setVerifiedProfileCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)getAvatar:(NSNotification*)sender
{
    NSDictionary * dic  = sender.object;
    NSString * url      = [dic objectForKey:HHNetDataCacheURLKey];
    NSData *data        = [dic objectForKey:HHNetDataCacheData];
    UIImage * image     = [UIImage imageWithData:data];
    
    if (data == nil) {
        NSLog(@"data == nil");
    }
    
    //得到的是头像图片
    if ([url isEqualToString:user.profileLargeImageUrl])
    {
        user.avatarImage = image;
        self.avatarImageView.image = image;
    }
}

-(void)didGetUserInfo:(NSNotification*)sender
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    if (uid.longLongValue == user.userId) {
        User *theUser = sender.object;
        self.user = theUser;
        [self updateWithUser:user];
        [table reloadData];
        
    }
    
    if ([self.title isEqualToString:@"我的"]) {
        return;
    }
    User *theUser = sender.object;
    self.user = theUser;
    [self updateWithUser:user];
    [table reloadData];
    
}

-(void)didUnfollowByUserIDWithResult:(NSNotification*)sender
{
    NSLog(@"sender.objet = %@",sender.object);
    NSDictionary *dic = sender.object;
    NSString *uid = [dic objectForKey:@"uid"];
    if (uid == nil) {
        return;
    }
    [followButton setTitle:@"加关注" forState:UIControlStateNormal];
}

-(void)didFollowByUserIDWithResult:(NSNotification*)sender
{
    NSLog(@"sender.objet = %@",sender.object);
    NSDictionary *dic = sender.object;
    NSString *uid = [dic objectForKey:@"uid"];
    NSLog(@"dic = %@",dic);
    if (uid == nil) {
        return;
    }
    [followButton setTitle:@"取消关注" forState:UIControlStateNormal];
}

- (IBAction)followButtonClicked:(id)sender {
    UIButton *button = (UIButton*)sender;
    if ([button.titleLabel.text isEqualToString:@"取消关注"]) {
        [[WeiBoMessageManager getInstance] unfollowByUserID:self.user.userId inTableView:@""];
    }
    else if([button.titleLabel.text isEqualToString:@"加关注"]){
        [[WeiBoMessageManager getInstance] followByUserID:self.user.userId inTableView:@""];
    }
}

-(IBAction)gotoUsersStatusesView:(id)sender
{
   /* ProfileVC *profile = [[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil];
    profile.userID = [NSString stringWithFormat:@"%lld",user.userId];
    profile.user = user;
    profile.avatarImage = user.avatarImage;
    profile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profile animated:YES];
    [profile release];*/
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

/*- (IBAction)gotoUserTopicsVC:(id)sender {
    if (self.topicsArr && self.topicsArr.count != 0) {
        HotTrendsVC *h = [[HotTrendsVC alloc] initWithStyle:UITableViewStylePlain];
        h.dataSourceArr = self.topicsArr;
        h.isUserTopics = YES;
        h.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:h animated:YES];
        [h release];
    }
}*/



- (void)dealloc {
    self.topicsArr = nil;
    self.screenName = nil;
    self.user = nil;
    [table release];
    [avatarImageView release];
    [genderIamgeView release];
    [nameLabel release];
    [followButton release];
    [fansButton release];
    [idolButton release];
    [weiboButton release];
    // [topicButton release];
    [userID release];
    [tableHeaderView release];
    [locationProfileCell release];
    [descriptionProfileCell release];
    [verifiedProfileCell release];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kDescriptionRowsCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    if (indexPath.row == kSelfDescriptionRow) {
        height = [self cellHeight:user.description with:206.0f] + 35;
    }
    if (height < 50.) {
        height = 50.;
    }
    return height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    profileCell *cell = nil;
    
    if (indexPath.row == kSinaVerifiedRow) {
        cell = self.verifiedProfileCell;
        cell.titleLabel.text = @"新浪认证:";
        cell.contentLabel.text = user.verifiedReason;
        if (user.verifiedReason == NULL) {
            cell.hidden = YES;
        }
}
    
    else if (indexPath.row == kLocationRow) {
        cell = self.locationProfileCell;
        cell.titleLabel.text = @"位       置:";
        cell.contentLabel.text = user.location;
    }
    
    else if (indexPath.row == kSelfDescriptionRow) {
        cell = self.descriptionProfileCell;
        cell.titleLabel.text = @"自我介绍:";
        cell.contentLabel.text = user.description;
        
        CGRect frame = cell.contentLabel.frame;
        frame.size.height = [self cellHeight:user.description with:206];
        cell.contentLabel.frame = frame;
    }
    return cell;
}

@end


@implementation profileCell
@synthesize contentLabel;
@synthesize titleLabel;

-(void)dealloc
{
    self.titleLabel = nil;
    self.contentLabel = nil;
    [super dealloc];
}


@end