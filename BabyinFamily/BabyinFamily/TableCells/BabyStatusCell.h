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
#import "ProfileViewController.h"
#define IMAGE_VIEW_HEIGHT 300.0f
#define CELL_WIDTH 300.0f
#define CONTENT_WIDTH 280.0f
#define PADDING_TOP 4.0
#define PADDING_LEFT 4.0
#define FONT_SIZE 13.0
#define FONT @"Arial"
#define TEXT_VIEW_SIZE CGSizeMake(240, 1000)

@class  BabyStatusCell;
@protocol BabyStatusCellDelegate<NSObject>

-(void)statusImageClicked:(Status *)theStatus;

@end

@interface BabyStatusCell : UITableViewCell <UITextViewDelegate, UIGestureRecognizerDelegate>
{
    id<BabyStatusCellDelegate>  delegate;
}
@property (nonatomic, retain) id<BabyStatusCellDelegate> delegate;
//原文
@property (nonatomic, retain) UIImageView *bgImage;
@property (nonatomic, retain) UIView      *weiboView;
@property (nonatomic, retain) UIImageView *contentImage;
@property (nonatomic, retain) UITextView  *contentText;
//转发
@property (nonatomic, retain) UIImageView *repostBackGround;
@property (nonatomic, retain) UIView      *repostMainView;
@property (nonatomic, retain) UIImageView *repostContentImage;
@property (nonatomic, retain) UITextView  *repostText;

@property (nonatomic, retain) Status      *status;
@property (nonatomic, assign) CGFloat     statusHeight;
@property (nonatomic, assign) CGFloat     cellHeight;
@property (nonatomic, retain) UIButton    *more;
@property (nonatomic, retain) UIButton    *commentButton;

//用户设置cell组成
-(void)customViews;

//动态更新界面布局
-(void)updateCellWith:(Status *)weibo;


@end


