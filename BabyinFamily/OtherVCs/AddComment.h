//
//  AddComment.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-3-3.
//
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "Status.h"
#import "User.h"
#import "ImageBrowser.h"
#import "StatusCell.h"

@class WeiBoMessageManager;
@class Comment;

@interface AddComment :UIViewController < UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    UINib  *commentCellNib;
    WeiBoMessageManager *manager;
    UIImage             *avatarImage;
    UIImage             *contentImage;
    NSMutableArray      *commentArr;
    
    BOOL shouldShowIndicator;

    int                 _page;
    NSString            *_maxID;
}
@property (retain, nonatomic) UITableView           *table;
@property (retain, nonatomic) UINib                 *commentCellNib;
@property (retain, nonatomic) Status                *status;
@property (retain, nonatomic) User                  *user;
@property (retain, nonatomic) UIImage               *avatarImage;
@property (retain, nonatomic) UIImage               *contentImage;
@property (retain, nonatomic) NSMutableArray        *commentArr;
@property (assign, nonatomic) BOOL                  isFromProfileVC;
@property (retain, nonatomic) Comment *clickedComment;
@property (retain, nonatomic) UIScrollView *theScrollView;
@property (retain, nonatomic) UIButton  *sendButton;
@property (retain, nonatomic) UITextField *textField;

@end
