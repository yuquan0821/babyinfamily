//
//  DetailStatusViewController.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-3-6.
//
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "Status.h"
#import "User.h"
#import "ImageBrowser.h"

#define IMAGES_VIEW_HEIGHT 100.0f

@class WeiBoMessageManager;
@class Comment;

@interface DetailStatusViewController : PullRefreshTableViewController<UITableViewDelegate,UITableViewDataSource,ImageBrowserDelegate,UIActionSheetDelegate>
{
    UIView      *headerView;
    UITableView *table;
    UIImageView *avatarImageV;
    UILabel     *twitterNameLB;
    UIImageView *contentImageV;
    UILabel     *fromLB;
    UILabel     *countLB;
    UINib       *commentCellNib;
    WeiBoMessageManager *manager;
    
    //data
    Status  *status;
    User    *user;
    
    UIImage         *avatarImage;
    UIImage         *contentImage;
    NSMutableArray  *commentArr;
    
    BOOL _hasImage;
    BOOL shouldShowIndicator;
    
    int _page;
    NSString *_maxID;
}
@property (retain, nonatomic) IBOutlet UIImageView  *headerBackgroundView;

@property (retain, nonatomic) IBOutlet UIView       *headerView;
@property (retain, nonatomic) IBOutlet UITableView  *table;
@property (retain, nonatomic) IBOutlet UIImageView  *avatarImageV;
@property (retain, nonatomic) IBOutlet UIImageView  *contentImageV;
@property (retain, nonatomic) IBOutlet UILabel      *countLB;
@property (retain, nonatomic) IBOutlet UILabel *fromLB;
@property (retain, nonatomic) UINib                 *commentCellNib;
@property (retain, nonatomic) Status                *status;
@property (retain, nonatomic) User                  *user;
@property (retain, nonatomic) UIImage               *avatarImage;
@property (retain, nonatomic) UIImage               *contentImage;
@property (retain, nonatomic) NSMutableArray        *commentArr;
@property (assign, nonatomic) BOOL                  isFromProfileVC;
@property (retain, nonatomic) ImageBrowser          *browserView;
@property (retain, nonatomic) IBOutlet UIImageView *contentImageBackgroundView;
@property (retain, nonatomic) Comment *clickedComment;

@end
