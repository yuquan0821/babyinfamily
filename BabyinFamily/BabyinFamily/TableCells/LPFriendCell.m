//
//  LPFriendCell.m
//  HHuan
//
//  Created by yonghongchen on 11-11-17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LPFriendCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation LPFriendCell
@synthesize invitationBtn;
@synthesize nameLabel;
@synthesize headerView;
@synthesize lidStr;
@synthesize type;
@synthesize cellBG;
@synthesize delegate = _delegate;
@synthesize lpCellIndexPath = _lpCellIndexPath;

- (IBAction)cellButtonClicked:(id)sender 
{
    [_delegate lpCellDidClicked:self];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createView];
 //自定义Cell
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
           }
    return self;
}
- (void)createView
{
    self.headerView = [[UIImageView alloc]initWithFrame:CGRectMake(9, 10, 42, 42)];
    [self.headerView.layer  setMasksToBounds:YES];
    [self.headerView.layer  setMasksToBounds:YES];
    [self.headerView.layer  setCornerRadius:5];
    [self addSubview:self.headerView];

}

- (void)dealloc
{
    self.lpCellIndexPath = nil;
    self.invitationBtn = nil;
    self.nameLabel = nil;
    self.headerView = nil;
    self.lidStr = nil;
    self.type = nil;
    self.cellBG = nil;
    [super dealloc];
}
@end
