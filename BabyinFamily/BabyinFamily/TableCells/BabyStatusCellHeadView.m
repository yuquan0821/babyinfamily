//
//  BabyStatusCellHeadView.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-10.
//
//

#import "BabyStatusCellHeadView.h"
#import <QuartzCore/QuartzCore.h>

@implementation BabyStatusCellHeadView
@synthesize avatarImageBackGround;
@synthesize avatarImage;
@synthesize userNameLabel;
@synthesize locationImage;
@synthesize locationLabel;
@synthesize timeLabel;
@synthesize gotoProfileButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       [self customCellHead];
    }
    return self;
}

- (void)customCellHead
{

    self.backgroundColor = [UIColor clearColor];
    self.avatarImageBackGround = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 50, 50)];
    self.avatarImageBackGround.image = [UIImage imageNamed:@"weibo.bundle/WeiboImages/touxiang_40x40.png"];
    
    self.avatarImage= [[UIImageView alloc]initWithFrame:CGRectMake(avatarImageBackGround.frame.origin.x +4, avatarImageBackGround.frame.origin.y +3, 42, 42)];
   self.avatarImage.backgroundColor = [UIColor clearColor];
    //self.avatarImage.image = [UIImage imageNamed:@"weibo.bundle/WeiboImages/touxiang_40x40.png"];
    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarImageBackGround.frame.origin.x + avatarImageBackGround.frame.size.width + 4, 4, 160, 21)];
    self.userNameLabel.textColor = [UIColor brownColor];
    self.userNameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.userNameLabel.backgroundColor = [UIColor clearColor];
    self.locationImage =  [[UIImageView alloc ]initWithFrame:CGRectMake(avatarImageBackGround.frame.origin.x + avatarImageBackGround.frame.size.width + 4, self.userNameLabel.frame.origin.y + self.userNameLabel.frame.size.height+3, 16, 16)];
    self.locationImage.image = [UIImage imageNamed:@"weibo.bundle/WeiboImages/compose_locatebutton_background.png"];

    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(72,  self.userNameLabel.frame.origin.y + self.userNameLabel.frame.size.height +3, 144, 21)];
    self.locationLabel.textColor = [UIColor blackColor];
    self.locationLabel.font = [UIFont systemFontOfSize: 12];
    self.locationLabel.backgroundColor = [UIColor clearColor];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLabel.frame.origin.x + self.userNameLabel.frame.size.width - 10, 16, 100, 21)];
    self.timeLabel.textColor = [UIColor brownColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textAlignment = UITextAlignmentRight;
    self.timeLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:avatarImageBackGround];
    [self addSubview:avatarImage];
    [self addSubview:userNameLabel];
    [self addSubview:locationImage];
    [self addSubview:locationLabel];
    [self addSubview:timeLabel];
    
}


- (void)dealloc
{
    [avatarImageBackGround release];
    [avatarImage release];
    [userNameLabel release];
    [locationImage release];
    [locationLabel release];
    [timeLabel release];
    [gotoProfileButton release];
    [super dealloc];
}

@end
