//
//  HomeViewController.h
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//


#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "ImageBrowser.h"
#import "WeiBoMessageManager.h"
#import "Status.h"
#import "User.h"
#import "ASIHTTPRequest.h"
#import "HHNetDataCacheManager.h"
#import "GifView.h"
#import "SHKActivityIndicator.h"
#import "UIImageView+Resize.h"
#import "AddComment.h"
#import "BabyStatusCellHeadView.h"
#import "UIImageView+WebCache.h"
#import "BabyStatusCell.h"
#import "BabyAddCommentViewController.h"



@interface HomeViewController : PullRefreshTableViewController<EGORefreshTableHeaderDelegate,ImageBrowserDelegate,UIActionSheetDelegate,BabyStatusCellHeadClickDelegate,SDWebImageManagerDelegate,BabyStatusCellDelegate>
{
    UITableView                 *table;
    NSMutableArray              *statuesArr;
    BOOL                        isFirstCell;
    WeiBoMessageManager         *manager;
	EGORefreshTableHeaderView   *_refreshHeaderView;
    NSString                    *userID;
    int                         _page;
    long long                   _maxID;
    BOOL                        _shouldAppendTheDataArr;
    NSNotificationCenter        *defaultNotifCenter;
    ImageBrowser                *browserView;
    BOOL                        shouldShowIndicator;
    BOOL                        shouldLoad;
	BOOL                        _reloading;
}
@property (retain,nonatomic)    UITableView             *table;
@property (nonatomic, copy)     NSString                *userID;
@property (nonatomic, retain)   NSMutableArray          *statuesArr;
@property (nonatomic, retain)   ImageBrowser            *browserView;
@property (nonatomic, retain)   Status                  *clickedStatus;


- (void)doneLoadingTableViewData;


@end