//
//  ProfileViewController.h
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//



#import <UIKit/UIKit.h>
#import "User.h"
#import "BabyFeedBackViewController.h"
#import "SettingVC.h"


@class profileCell;

@interface ProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
}
@property (retain, nonatomic)   IBOutlet UITableView    *table;
@property (retain, nonatomic)   IBOutlet UIImageView    *avatarImageView;
@property (retain, nonatomic)   IBOutlet UIImageView    *genderIamgeView;
@property (retain, nonatomic)   IBOutlet UILabel        *nameLabel;
@property (retain, nonatomic)   IBOutlet UIButton       *followButton;
@property (retain, nonatomic)   IBOutlet UIButton       *fansButton;
@property (retain, nonatomic)   IBOutlet UIButton       *idolButton;
@property (retain, nonatomic)   IBOutlet UIButton       *weiboButton;
@property (retain, nonatomic)   IBOutlet UIButton       *topicButton;
@property (retain, nonatomic)   IBOutlet UIView         *tableHeaderView;
@property (nonatomic,retain)    NSString *screenName;
@property (nonatomic, retain)   User *user;
@property (retain, nonatomic)   IBOutlet profileCell *verifiedProfileCell;
@property (retain, nonatomic)   IBOutlet profileCell *locationProfileCell;
@property (retain, nonatomic)   IBOutlet profileCell *descriptionProfileCell;

@property (nonatomic,retain)    NSArray *topicsArr;

@property (nonatomic, copy)     NSString                *userID;


@end

@interface profileCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *contentLabel;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@end
