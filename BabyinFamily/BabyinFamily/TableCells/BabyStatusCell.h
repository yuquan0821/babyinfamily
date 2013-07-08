//
//  BabyStatusCell.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-8.
//
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Status.h"
#import "Comment.h"
#import "JSTwitterCoreTextView.h"
#define IMAGE_VIEW_HEIGHT 300.0f
#define CELL_WIDTH 300.0f
#define CONTENT_WIDTH 280.0f
#define PADDING_TOP 5.0
#define PADDING_LEFT 5.0
#define FONT_SIZE 13.0
#define FONT @"Arial"
#define TEXT_VIEW_SIZE CGSizeMake(240, 1000)

@class  BabyStatusCell;
@protocol BabyStatusCellDelegate;

@interface BabyStatusCell : UITableViewCell <UITextViewDelegate, JSCoreTextViewDelegate,UIGestureRecognizerDelegate>
{
    id<BabyStatusCellDelegate>  delegate;
}
@property (nonatomic, assign) id<BabyStatusCellDelegate> delegate;
@property (nonatomic, retain) UIView      *headView;
@property (nonatomic, retain) UIImageView *avatarBackGround;
@property (nonatomic, retain) UIImageView *avatarImageView;
@property (nonatomic, retain) UILabel     *userNameLabel;
@property (nonatomic, retain) UIImageView *locatonImageview;
@property (nonatomic, retain) UILabel     *locationLabel;
@property (nonatomic, retain) UILabel     *timeLabel;

@property (nonatomic, retain) UIImageView *backGround;
@property (nonatomic, retain) UIView      *weiboView;
@property (nonatomic, retain) UIImageView *weiboImage;
@property (nonatomic, retain) JSTwitterCoreTextView *contentText;

@property (nonatomic, retain) UIImageView *repostBackGround;
@property (nonatomic, retain) UIView      *repostView;
@property (nonatomic, retain) UIImageView *repostImage;
@property (nonatomic, retain) JSTwitterCoreTextView *repostText;

@property (nonatomic, retain) UITableView *commentTable;
@property (nonatomic, retain) UIButton    *moreComments;
@property (nonatomic, retain) UIButton    *commentButton;

@property (nonatomic, retain) Status      *status;

//动态更新界面布局
-(void)updateCellWith:(Status *)weibo;

//返回Cell高度
-(CGFloat)contentHeight:(CGFloat )cellHeight;

@end

@protocol BabyStatusCellDelegate <NSObject>

-(void)statusImageClicked:(Status *)theStatus;
//-(void)cellImageDidTaped:(StatusCell *)theCell image:(UIImage*)image;
//-(void)cellLinkDidTaped:(StatusCell *)theCell link:(NSString*)link;
//-(void)cellTextDidTaped:(StatusCell *)theCell;
-(void)customViews;
@end

