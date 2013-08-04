//
//BabyinFamily.xcodeprojroller.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-10.
//
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BabyStatusCellHeadView.h"
#import "SDWebImageManager.h"
#import "BabyDetailStatusCell.h"
#import "BabyDetailStatusCellHeadView.h"
#import "WeiBoMessageManager.h"

@interface BabyStatusDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,BabyStatusCellHeadClickDelegate,SDWebImageManagerDelegate,UITextFieldDelegate>
{
    WeiBoMessageManager    *manager;
    UITableView            * detailTableView;
    Status                 * _weibo;
    NSMutableArray         * listCommentsArray;
    NSNumber               * commentsCount;
    BOOL                   flagHeader;
    UIButton               * footerButton;
    int                     pageCount;
    int                     count;
    UIActivityIndicatorView * _active;
}
@property (nonatomic,retain) Status       * weibo;
@property (retain, nonatomic) UITextField *textField;
@property (retain, nonatomic) UIButton    *sendButton;
@property (nonatomic, retain) UIToolbar   *toolBar;




@end
