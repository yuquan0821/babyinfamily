//
//  BabyStatusDetailViewCont/Users/hanyanchun/Documents/babyfamily/babyinfamily/babyinfamily/BabyinFamily.xcodeprojroller.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-10.
//
//



///*
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BabyStatusCell.h"
#import "BabyStatusCellHeadView.h"
#import "SDWebImageManager.h"


@interface BabyStatusDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,BabyStatusCellHeadClickDelegate,SDWebImageManagerDelegate>
{
    UITableView * detailTableView;
    Status * _weibo;
    NSMutableArray * listCommentsArray;
    NSNumber * commentsCount;
    BOOL  flagHeader;
    UIButton * footerButton;
    int pageCount;
    int count;
    UIActivityIndicatorView * _active;
}
@property (nonatomic,retain) Status * weibo;

@end
