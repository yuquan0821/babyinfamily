//
//  StatusCell.m
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-1-5.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "StatusCell.h"

#define IMAGE_VIEW_HEIGHT 200.0f

@implementation StatusCell
@synthesize countLB;
@synthesize avatarImage;
@synthesize userNameLB;
@synthesize bgImage;
@synthesize contentImage;
@synthesize delegate;
@synthesize cellIndexPath;
@synthesize fromLB;
@synthesize timeLB;

//
-(void)setupCell:(Status *)status avatarImageData:(NSData *)avatarData contentImageData:(NSData *)imageData
{
    //self.contentTF.text = status.text;
    self.userNameLB.text = status.user.screenName;
    self.avatarImage.image = [UIImage imageWithData:avatarData];
    countLB.text = [NSString stringWithFormat:@"评论:%d 转发:%d 赞:%d",status.commentsCount,status.retweetsCount,status.attitudesCount];
    fromLB.text = [NSString stringWithFormat:@"来自:%@",status.source];
    timeLB.text = status.timestamp;
        
    if (![imageData isEqual:[NSNull null]])
    {
            self.contentImage.image = [UIImage imageWithData:imageData];
            bgImage.image = [[UIImage imageNamed:@"weibo.bundle/WeiboImages/table_header_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    }
}

//计算cell的高度
-(CGFloat)setCellHeight:(Status *)status contentImageData:(NSData *)imageData
{
    CGFloat height = 0.0f;
    [contentImage layoutIfNeeded];
    CGRect frame = contentImage.frame;
    frame.size.height = IMAGE_VIEW_HEIGHT;
    frame.origin.y = self.avatarImage.frame.size.height + self.avatarImage.frame.origin.y + 9;
    contentImage.frame = frame;
    if (![imageData isEqual:[NSNull null]])
    {
        //UIImage *TempImage;
         self.contentImage.image = [UIImage imageWithData:imageData];
         height =  self.contentImage.image.size.height;
    }
    else{
        
        height = self.contentImage.frame.size.height + self.contentImage.frame.origin.y;
    }
    return height;
}

-(IBAction)tapDetected:(id)sender
{
    UITapGestureRecognizer*tap = (UITapGestureRecognizer*)sender;
    
    UIImageView *imageView = (UIImageView*)tap.view;
    if ([imageView isEqual:contentImage]) {
        if ([delegate respondsToSelector:@selector(cellImageDidTaped:image:)]) 
        {
            [delegate cellImageDidTaped:self image:contentImage.image];
        }
    }
   }

- (void)dealloc {
    [avatarImage release];
    [userNameLB release];
    [bgImage release];
    [contentImage release];
    [cellIndexPath release];
    [countLB release];
    [fromLB release];
    [timeLB release];
    [super dealloc];
}
@end
