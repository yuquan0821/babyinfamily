//
//  StatusCell.m
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-1-5.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "StatusCell.h"

#define IMAGE_VIEW_HEIGHT 80.0f

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


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        self.userNameLB = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.avatarImage = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        self.avatarImage.image = [UIImage imageNamed:@"weibo.bundle/WeiboImages/loadingImage_50x118.png"];
        self.countLB = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.fromLB = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
        self.timeLB = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.bgImage = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        self.bgImage.image = [[UIImage imageNamed:@"weibo.bundle/WeiboImages/table_header_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        self.contentImage = [[[UIImageView alloc]initWithFrame:CGRectZero] autorelease];
        self.contentImage.image = [UIImage imageNamed:@"weibo.bundle/WeiboImages/loadingImage_50x118.png"];
        [self.contentView addSubview: avatarImage];
        [self.contentView addSubview: userNameLB];
        [self.contentView addSubview: countLB];
        [self.contentView addSubview: fromLB];
        [self.contentView addSubview: timeLB];
        [self.contentView addSubview: bgImage];
        [self.contentView addSubview: contentImage];
        
		
    }
    return self;
}
//
-(void)setupCell:(Status *)status avatarImageData:(NSData *)avatarData contentImageData:(NSData *)imageData
{
    CGRect rtText = CGRectMake(5, 6, 22, 22);
    self.avatarImage.frame = rtText;
    self.avatarImage.image = [UIImage imageWithData:avatarData];
    
    rtText =  CGRectMake(35, 0, 165, 28);
    self.userNameLB.frame = rtText;
    self.userNameLB.font= [UIFont boldSystemFontOfSize:17.0f];
    self.userNameLB.textColor = [UIColor brownColor];
    self.userNameLB.text = status.user.screenName;
    
    rtText = CGRectMake(208, 6, 102, 21);
    self.timeLB.frame = rtText;
    //self.timeLB.font = [UIFont systemFontSize:13.0];
    self.timeLB.textAlignment = UITextAlignmentRight;
    self.timeLB.textColor = [UIColor brownColor];
    self.timeLB.text = status.timestamp;
    
    rtText = CGRectMake(60, self.bounds.size.height - 21, 140, 21);
    self.countLB.frame = rtText;
    self.countLB.textAlignment = UITextAlignmentLeft;
    self.countLB.text = [NSString stringWithFormat:@"评论:%d 转发:%d",status.commentsCount,status.retweetsCount];
    
    rtText = CGRectMake(171, self.bounds.size.height - 21, 139, 21);
    self.fromLB.frame = rtText;
    self.fromLB.textAlignment = UITextAlignmentRight;
    fromLB.text = [NSString stringWithFormat:@"来自:%@",status.source];
    
    if (![imageData isEqual:[NSNull null]])
    {
        rtText = CGRectMake(5, 35, 300, 400);
        self.contentView.frame = rtText;
        self.contentMode = UIViewContentModeScaleToFill;
        self.contentImage.image = [UIImage imageWithData:imageData];
    }
        
    NSString *url = status.thumbnailPic;
    self.contentImage.hidden = url != nil && [url length] != 0 ? NO : YES;
    [self setTFHeightWithImage:url != nil && [url length] != 0 ? YES : NO ];//计算cell的高度，以及背景图的处理
    [self setNeedsDisplay];
   [self.contentView layoutIfNeeded];
    
}

//计算cell的高度，以及背景图的处理
-(CGFloat)setTFHeightWithImage:(BOOL)hasImage
{
    [contentImage layoutIfNeeded];
    
    //博文Text
    CGRect frame = contentImage.frame;
    frame.origin.y = contentImage.frame.size.height;
    frame.size.height = IMAGE_VIEW_HEIGHT;
    contentImage.frame = frame;
    
    //背景设置
    return frame.size.height;
}

-(IBAction)tapDetected:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    
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
    [contentTF release];
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
