//
//  BabyCommentCell.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-11.
//
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "User.h"
#import "UIImageView+WebCache.h"



@interface BabyCommentCell : UITableViewCell<SDWebImageManagerDelegate>
{
    UIImageView *_headImageView;
    UILabel     *_commentPersonNameLabel;
    UILabel     *_timeLabel;
    UILabel     *_commentContent;
    CGFloat      _cellHeight;
    Comment     *_weiboDetailCommentInfo;
}

@property(nonatomic, retain)UIImageView    *headImageView;
@property(nonatomic, retain)UILabel        *commentPersonNameLabel;
@property(nonatomic, retain)UILabel        *timeLabel;
@property(nonatomic, retain)UILabel        *commentContent;
@property(nonatomic, assign)CGFloat         cellHeight;
@property(nonatomic, retain)User            *user;
@property(nonatomic, retain)Comment         *weiboDetailCommentInfo;

-(UIView*)createCellView;

@end
