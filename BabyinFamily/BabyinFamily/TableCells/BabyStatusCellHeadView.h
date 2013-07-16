//
//  BabyStatusCellHeadView.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-10.
//
//

#import <UIKit/UIKit.h>
#import "User.h"
@protocol BabyStatusCellHeadClickDelegate<NSObject>

-(void)babyStatusCellHeadImageClicked:(id)sender;

@end

@interface BabyStatusCellHeadView : UIView
{
    id<BabyStatusCellHeadClickDelegate> _delegate;
    User *_user;
}

@property (nonatomic, retain)UIImageView *avatarImageBackGround;
@property (nonatomic, retain)UIImageView *avatarImage;
@property (nonatomic, retain)UILabel     *userNameLabel;
@property (nonatomic, retain)UIImageView *locationImage;
@property (nonatomic, retain)UILabel     *locationLabel;
@property (nonatomic, retain)UILabel     *timeLabel;
@property (nonatomic, retain)UIButton    *gotoProfileButton;
@property (nonatomic, assign) id<BabyStatusCellHeadClickDelegate> delegate;
@property (nonatomic, retain)User         *user;


@end
