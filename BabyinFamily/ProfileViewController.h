//
//  ProfileViewController.h
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//


#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "User.h"
#import "StatusCell.h"
#import "FeedBackViewController.h"
#import "SettingVC.h"
#import "ImageBrowser.h"


@class WeiBoMessageManager;
@class ImageBrowser;

#define kTextViewPadding            16.0
#define kLineBreakMode              UILineBreakModeWordWrap

@interface ProfileViewController : PullRefreshTableViewController<UITableViewDelegate,UITableViewDataSource,StatusCellDelegate,ImageBrowserDelegate>
{
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    
    UITableView         *table;
    NSString            *userID;
    UINib               *statusCellNib;
    NSMutableArray      *statuesArr;
    NSMutableDictionary *imageDictionary;
    ImageBrowser        *browserView;
    
    
    BOOL                shouldShowIndicator;
    BOOL                shouldLoad;
    BOOL                shouldLoadAvatar;
    BOOL                isFirstCell;

}
@property (retain, nonatomic)   IBOutlet UITableView    *table;
@property (nonatomic, copy)     NSString                *userID;
@property (nonatomic, retain)   UINib                   *statusCellNib;
@property (nonatomic, retain)   NSMutableArray          *statuesArr;
@property (nonatomic, retain)   NSMutableDictionary     *imageDictionary;
@property (nonatomic, retain)   ImageBrowser            *browserView;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) UIImage *avatarImage;
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIImageView *headerVImageV;
@property (retain, nonatomic) IBOutlet UILabel *headerVNameLB;
@property (retain, nonatomic) IBOutlet UILabel *weiboCount;
@property (retain, nonatomic) IBOutlet UILabel *followerCount;
@property (retain, nonatomic) IBOutlet UILabel *followingCount;

@end
