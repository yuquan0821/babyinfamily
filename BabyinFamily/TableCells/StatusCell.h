//
//  StatusCell.h
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-1-5.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "LPBaseCell.h"
#import "Status.h"
#import "User.h"

@class StatusCell;

@protocol StatusCellDelegate <NSObject>

-(void)cellImageDidTaped:(StatusCell *)theCell image:(UIImage*)image;

@end

@interface StatusCell : LPBaseCell
{
    id<StatusCellDelegate> delegate;
    
    UIImageView *avatarImage;
    UILabel *userNameLB;
    UIImageView *bgImage;
    UIImageView *contentImage;
    NSIndexPath *cellIndexPath;
}
@property (retain, nonatomic) IBOutlet UILabel *countLB;
//@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;
//@property (retain, nonatomic) IBOutlet UILabel *userNameLB;
@property (retain, nonatomic) IBOutlet UIImageView *bgImage;
@property (retain, nonatomic) IBOutlet UIImageView *contentImage;
@property (assign, nonatomic) id<StatusCellDelegate> delegate;
@property (retain, nonatomic) NSIndexPath *cellIndexPath;
@property (retain, nonatomic) IBOutlet UILabel *fromLB;
//@property (retain, nonatomic) IBOutlet UILabel *timeLB;
//@property (retain, nonatomic) IBOutlet UIButton *moreButton;

-(CGFloat)setCellHeight:(Status *)status contentImageData:(NSData *)imageData;
-(void)setupCell:(Status*)status contentImageData:(NSData*)imageData;
@end
