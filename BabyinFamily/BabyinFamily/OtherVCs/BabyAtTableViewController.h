//
//  BabyAtTableViewController.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-30.
//
//

#import <UIKit/UIKit.h>
#import "LPFriendCell.h"
#import "PullRefreshTableViewController.h"

@class WeiBoMessageManager;
@class User;

@protocol BabyAtTableViewControllerDelegate <NSObject>

-(void)atTableViewControllerCellDidClickedWithScreenName:(NSString*)name;

@end

@interface BabyAtTableViewController : PullRefreshTableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSMutableArray *_userArr;
    WeiBoMessageManager *_manager;
    UINib *_followerCellNib;
    User *_user;
    int _fansCursor;
    
}
@property (nonatomic,retain) NSMutableArray *userArr;
@property (nonatomic,retain) NSMutableArray *filteredUserArr;
@property (nonatomic,retain) UINib *followerCellNib;
@property (nonatomic,retain) User *user;
@property (nonatomic,assign) id<BabyAtTableViewControllerDelegate> delegate;
@property (nonatomic,retain) UISearchBar *searchBar;
@property (nonatomic,retain) UISearchDisplayController *searchDisplayCtrl;

@end