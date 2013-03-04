//
//  StatusCell.m
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-1-5.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "StatusCell.h"
#import "UIImageView+Resize.h"

@implementation StatusCell
//@synthesize countLB;
@synthesize avatarImage;
@synthesize userNameLB;
@synthesize locationLabel;
@synthesize bgImage;
@synthesize contentImage;
@synthesize delegate;
@synthesize cellIndexPath;
//@synthesize fromLB;
@synthesize timeLB;
@synthesize moreButton;
@synthesize commentButton;


-(void)setupCell:(Status *)status  //contentImageData:(NSData *)imageData
{
   // countLB.text = [NSString stringWithFormat:@"评论:%d 转发:%d 赞:%d",status.commentsCount,status.retweetsCount,status.attitudesCount];
    //fromLB.text = [NSString stringWithFormat:@"来自:%@",status.source];
    userNameLB.text = status.user.screenName;
    locationLabel.text = status.user.location;
    timeLB.text = status.timestamp;
}

//计算cell的高度
-(CGFloat)setCellHeight:(Status *)status contentImageData:(NSData *)imageData
{
    //CGRect frame;
    CGFloat height = 385.0f;
   /*  CGSize size = [self getFrameOfImageView:contentImage].size;
    float zoom = 2 * size.width > size.height ? 250.0/size.width : 300.0/size.height;
    size = CGSizeMake(size.width * zoom, size.height * zoom);
    frame.size = size;
    contentImage.frame = frame;
    contentImage.center = CGPointMake(160, contentImage.center.y);
    frame = contentImage.frame;
    bgImage.frame = CGRectMake(frame.origin.x - 5, frame.origin.y - 5, frame.size.width + 10, frame.size.height + 10);;
    [contentImage layoutIfNeeded];
   if (![imageData isEqual:[NSNull null]])
    {
        UIImage *TempImage= [UIImage imageWithData:imageData];
        //裁剪
       // UIImage *scaledImage = [UIImageView imageWithImage:TempImage scaledToSizeWithSameAspectRatio:CGSizeMake(MAIN_IMAGE_WIDTH, MAIN_IMAGE_HEIGHT)];
        
        self.contentImage.image = TempImage ;
        
         height =  self.contentImage.image.size.height;
    }
    else{*/
        
       // height = self.contentImage.frame.size.height + self.contentImage.frame.origin.y;
    //}

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
  //  [countLB release];
   // [fromLB release];
    [timeLB release];
    [moreButton release];
    [locationLabel release];
    [commentButton release];
    [super dealloc];
}
@end
