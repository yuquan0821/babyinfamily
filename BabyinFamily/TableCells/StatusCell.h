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
    UITextView *contentTF;
    UILabel *userNameLB;
    UIImageView *bgImage;
    UIImageView *contentImage;
    NSIndexPath *cellIndexPath;
}
@property (retain, nonatomic)  UILabel *countLB;
@property (retain, nonatomic)  UIImageView *avatarImage;
@property (retain, nonatomic)  UILabel *userNameLB;
@property (retain, nonatomic)  UIImageView *bgImage;
@property (retain, nonatomic)  UIImageView *contentImage;
@property (assign, nonatomic)  id<StatusCellDelegate> delegate;
@property (retain, nonatomic)  NSIndexPath *cellIndexPath;
@property (retain, nonatomic)  UILabel *fromLB;
@property (retain, nonatomic)  UILabel *timeLB;

-(CGFloat)setTFHeightWithImage:(BOOL)hasImage;
-(void)setupCell:(Status*)status avatarImageData:(NSData*)avatarData contentImageData:(NSData*)imageData;
@end
