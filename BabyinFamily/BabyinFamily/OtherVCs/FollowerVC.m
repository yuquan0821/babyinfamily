//
//  FollowerVC.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-4-25.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "FollowerVC.h"
#import "User.h"
#import "WeiBoMessageManager.h"
#import "LPFriendCell.h"
#import "HHNetDataCacheManager.h"
#import "SHKActivityIndicator.h"
#import "ProfileViewController.h"

@interface FollowerVC ()
-(void)loadData;
-(void)refreshVisibleCellsImages;
@end

@implementation FollowerVC
@synthesize userArr = _userArr;
@synthesize isFollowingViewController = _isFollowingViewController;
@synthesize followerCellNib = _followerCellNib;
@synthesize user = _user;
@synthesize table;

-(void)dealloc
{
    self.table = nil;
    self.userArr = nil;
    self.followerCellNib = nil;
    self.user = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isFollowingViewController = NO;
        _manager = [WeiBoMessageManager getInstance];
        _fansCursor = 0;
        _followCursor = 0;
    }
    return self;
}


-(UINib*)followerCellNib
{
    if (_followerCellNib == nil)
    {
        self.followerCellNib = [LPFriendCell nib];
    }
    return _followerCellNib;
}

- (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib {
    NSString *cellID = NSStringFromClass([LPFriendCell class]);
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
        cell = [nibObjects objectAtIndex:0];
    }
    else {
        [(LPBaseCell *)cell reset];
    }
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = table.frame;
    frame.size.height = frame.size.height + REFRESH_FOOTER_HEIGHT;
    table.frame = frame;
    self.tableView.contentInset = UIEdgeInsetsOriginal;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
    if (_isFollowingViewController) {
        [notifCenter addObserver:self selector:@selector(gotFollowUserList:) name:MMSinaGotFollowingUserList object:nil];
    }
    else {
        [notifCenter addObserver:self selector:@selector(gotFollowUserList:) name:MMSinaGotFollowedUserList object:nil];
    }
    [notifCenter addObserver:self selector:@selector(gotAvatar:) name:HHNetDataCacheNotification object:nil];
    [notifCenter addObserver:self selector:@selector(gotFollowResult:) name:MMSinaFollowedByUserIDWithResult object:nil];
    [notifCenter addObserver:self selector:@selector(gotUnfollowResult:) name:MMSinaUnfollowedByUserIDWithResult object:nil];
    [notifCenter addObserver:self selector:@selector(mmRequestFailed:) name:MMSinaRequestFailed object:nil];
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
    if (_isFollowingViewController) {
        [notifCenter removeObserver:MMSinaGotFollowingUserList];
    }
    else {
        [notifCenter removeObserver:MMSinaGotFollowedUserList];
    }
    [notifCenter removeObserver:self name:HHNetDataCacheNotification object:nil];
    [notifCenter removeObserver:self name:MMSinaFollowedByUserIDWithResult object:nil];
    [notifCenter removeObserver:self name:MMSinaUnfollowedByUserIDWithResult object:nil];
    [notifCenter removeObserver:self name:MMSinaRequestFailed object:nil];
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
}

-(void)refreshVisibleCellsImages
{
    NSArray *cellArr = [self.table visibleCells];
    for (LPFriendCell *cell in cellArr) {
        NSIndexPath *inPath = [self.table indexPathForCell:cell];
        if (!cell.headerView.image) {
            User *user = [_userArr objectAtIndex:inPath.row];
            if (!user.avatarImage || [user.avatarImage isEqual:[NSNull null]])
            {
                [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileImageUrl withIndex:inPath.row];
            }
            else {
                cell.headerView.image = user.avatarImage;
            }
        }
    }
}


-(void)gotFollowUserList:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    NSArray *arr = [dic objectForKey:@"userArr"];
    NSNumber *cursor = [dic objectForKey:@"cursor"];
    User *tempUser = [arr lastObject];
    User *lastUser = [_userArr lastObject];
    
    if (![tempUser.screenName isEqualToString:lastUser.screenName]) {
        if (_userArr == nil || _userArr.count == 0 || _followCursor == 0) {
            self.userArr = [NSMutableArray arrayWithArray:arr];
        }
        else {
            [_userArr addObjectsFromArray:arr];
        }
        if (_isFollowingViewController) {
            
            _fansCursor   = cursor.intValue;
        }
        else {
            _followCursor = cursor.intValue;
        }
        [self.table reloadData];
    }
    else {
        self.refreshFooterView.hidden = YES;
        
    }
    [self stopLoading];
    [[SHKActivityIndicator currentIndicator] hide];
    
    [self refreshVisibleCellsImages];
    
}


-(void)gotFollowResult:(NSNotification*)sender
{
    NSLog(@"sender.objet = %@",sender.object);
    NSDictionary *dic = sender.object;
    NSString *uid = [dic objectForKey:@"uid"];
    
    if (uid == nil) {
        return;
    }
    
    for (int i = 0;i<[_userArr count];i++) {
        User *user = [_userArr objectAtIndex:i];
        
        if (user.userId == [uid longLongValue])
        {
            user.following = YES;
            LPFriendCell *cell = (LPFriendCell *)[self.table cellForRowAtIndexPath:user.cellIndexPath];
            [cell.invitationBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        }
    }
}

-(void)gotUnfollowResult:(NSNotification*)sender
{
    NSLog(@"sender.objet = %@",sender.object);
    NSDictionary *dic = sender.object;
    NSString *uid = [dic objectForKey:@"uid"];
    
    if (uid == nil) {
        return;
    }
    
    for (int i = 0;i<[_userArr count];i++) {
        User *user = [_userArr objectAtIndex:i];
        
        if (user.userId == [uid longLongValue])
        {
            user.following = NO;
            LPFriendCell *cell = (LPFriendCell *)[self.table cellForRowAtIndexPath:user.cellIndexPath];
            [cell.invitationBtn setTitle:@"关注" forState:UIControlStateNormal];
        }
    }
}



-(void)gotAvatar:(NSNotification*)sender
{
    NSDictionary * dic = sender.object;
    NSString * url          = [dic objectForKey:HHNetDataCacheURLKey];
    NSNumber *indexNumber   = [dic objectForKey:HHNetDataCacheIndex];
    NSInteger index         = [indexNumber intValue];
    NSData *data            = [dic objectForKey:HHNetDataCacheData];
    
    if (indexNumber == nil || index == -1) {
        return;
    }
    
    if (index >= [_userArr count]) {
        return;
    }
    
    User *user = [_userArr objectAtIndex:index];
    
    //得到的是头像图片
    if ([url isEqualToString:user.profileImageUrl])
    {
        UIImage * image     = [UIImage imageWithData:data];
        user.avatarImage    = image;
        
        LPFriendCell *cell = (LPFriendCell*)[self.table cellForRowAtIndexPath:user.cellIndexPath];
        if (!cell.headerView.image) {
            cell.headerView.image = user.avatarImage;
        }
    }
}

-(void)mmRequestFailed:(id)sender
{
    [self stopLoading];
    [[SHKActivityIndicator currentIndicator] hide];
}

- (void)refresh
{
    [self loadData];
}

-(void)loadData
{
    NSString *userID = nil;
    if (_user) {
        userID = [NSString stringWithFormat:@"%lld",_user.userId];
    }
    else {
        userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    }
    if (_isFollowingViewController) {
        [_manager getFollowingUserList:[userID longLongValue] count:50 cursor:_fansCursor];
    }
    else {
        [_manager getFollowedUserList:[userID longLongValue] count:50 cursor:_followCursor];
    }
    if (self.userArr == nil) {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..."];
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_userArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    LPFriendCell *cell = [self cellForTableView:self.table fromNib:self.followerCellNib];
    cell.lpCellIndexPath = indexPath;
    cell.delegate = self;
    
    if (row >= [_userArr count]) {
        return cell;
    }
    
    User *user = [_userArr objectAtIndex:row];
    cell.nameLabel.text = user.screenName;
    user.cellIndexPath = indexPath;
    
    if (self.table.dragging == NO && self.table.decelerating == NO)
    {
        if (!user.avatarImage || [user.avatarImage isEqual:[NSNull null]]) {
            [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileImageUrl withIndex:row];
        }
    }
    
    cell.headerView.image = user.avatarImage;
    
    if (user.following == NO) {
        [cell.invitationBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    else {
        [cell.invitationBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshVisibleCellsImages];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate)
	{
        [self refreshVisibleCellsImages];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    User *user = [_userArr objectAtIndex:row];
    ProfileViewController *profile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    profile.user = user;
    profile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profile animated:YES];
    [profile release];
}

-(void)lpCellDidClicked:(LPFriendCell*)cell
{
    NSInteger index = cell.lpCellIndexPath.row;
    
    if (index >= [_userArr count]) {
        return;
    }
    
    User *user = [_userArr objectAtIndex:index];
    
    if (user.following) {
        [_manager unfollowByUserID:user.userId inTableView:@"table"];
    }
    else {
        [_manager followByUserID:user.userId inTableView:@"table"];
    }
}

@end

