//
//  StatusViewControllerBase.h
//  
//
//  Created by 范艳春 on 12-11-27.
//
//

#import <UIKit/UIKit.h>
#import "StatusCell.h"
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


@class WeiBoMessageManager;

@interface StatusViewControllerBase : PullRefreshTableViewController<EGORefreshTableHeaderDelegate,StatusCellDelegate,ImageBrowserDelegate,UIActionSheetDelegate,BabyStatusCellHeadClickDelegate,SDWebImageManagerDelegate,BabyStatusCellDelegate>{
    
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    
    UITableView         *table;
    UINib               *statusCellNib;
    NSMutableArray      *statuesArr;
    NSMutableDictionary *headDictionary;
    NSMutableDictionary *imageDictionary;
    ImageBrowser        *browserView;
    
    BOOL                shouldShowIndicator;
    BOOL                shouldLoad;
    
    BOOL                isFirstCell;
    
	EGORefreshTableHeaderView *_refreshHeaderView;
    
	BOOL _reloading;
}

@property (retain, nonatomic) IBOutlet UITableView *table;

@property (nonatomic, retain)   UINib                   *statusCellNib;
@property (nonatomic, retain)   NSMutableArray          *statuesArr;
@property (nonatomic, retain)   NSMutableDictionary     *headDictionary;
@property (nonatomic, retain)   NSMutableDictionary     *imageDictionary;
@property (nonatomic, retain)   ImageBrowser            *browserView;
@property (nonatomic, retain)   Status                  *clickedStatus;


- (void)doneLoadingTableViewData;
- (void)refreshVisibleCellsImages;
- (void)moreButtonOnClick:(id)sender;


@end