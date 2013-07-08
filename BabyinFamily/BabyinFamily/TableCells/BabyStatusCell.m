//
//  BabyStatusCell.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-8.
//
//

#import "BabyStatusCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation BabyStatusCell
@synthesize delegate;
@synthesize headView;
@synthesize avatarBackGround;
@synthesize avatarImageView;
@synthesize userNameLabel;
@synthesize locatonImageview;
@synthesize locationLabel;
@synthesize timeLabel;

@synthesize weiboView;
@synthesize backGround;
@synthesize weiboImage;
@synthesize contentText;

@synthesize repostBackGround;
@synthesize repostView;
@synthesize repostImage;
@synthesize repostText;

@synthesize commentTable;
@synthesize moreComments;
@synthesize commentButton;

@synthesize status;

typedef enum{
    WeiboImages,
    RepostImages
}_viewTag;

- (void)dealloc
{
    [headView release];
    [avatarBackGround release];
    [avatarImageView release];
    [userNameLabel release];
    [locatonImageview release];
    [locationLabel release];
    [timeLabel release];
    [weiboView release];
    [backGround release];
    [weiboImage release];
    self.contentText = nil;
    [repostBackGround release];
    [repostView release];
    [repostImage release];
    self.repostText = nil;
    [commentTable release];
    [commentButton release];
    [moreComments release];
    [super dealloc];
}

//设计富文本的布局
-(JSTwitterCoreTextView*)GetJSTwitterCoreTextView
{
    
    JSTwitterCoreTextView *coreTextView = [[JSTwitterCoreTextView alloc]initWithFrame:CGRectZero];
    [coreTextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [coreTextView setDelegate:self];
    [coreTextView setFontName:FONT];
    [coreTextView setFontSize:FONT_SIZE];
    [coreTextView setPaddingTop:PADDING_TOP];
    [coreTextView setPaddingLeft:PADDING_LEFT];
    coreTextView.exclusiveTouch = YES;
    coreTextView.userInteractionEnabled = NO;
    coreTextView.backgroundColor = [UIColor whiteColor];
    coreTextView.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
    coreTextView.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
    return [coreTextView autorelease];
}

//点击微博图片
-(void)imageClicked:(UITapGestureRecognizer *)sender
{
    if([sender isKindOfClass:[UITapGestureRecognizer class]]){
        if (sender.numberOfTapsRequired == 1) {
            [delegate statusImageClicked:self.status];
        }
    }
    
    NSLog(@"------------------------ img clicked:%@", sender);
}

//点击转发微博图片
-(void)repostImageClicked:(UITapGestureRecognizer *)sender
{
    
    if([sender isKindOfClass:[UITapGestureRecognizer class]]){
        if (sender.numberOfTapsRequired == 1) {
            [delegate statusImageClicked:self.status.retweetedStatus];
        }
    }
    NSLog(@"图片被点击");
}

//获取富文本框高度
+(CGFloat)getJSHeight:(NSString*)text jsViewWith:(CGFloat)with
{
    CGFloat height = [JSCoreTextView measureFrameHeightForText:text
                                                      fontName:FONT
                                                      fontSize:FONT_SIZE
                                            constrainedToWidth:with - (PADDING_LEFT * 2)
                                                    paddingTop:PADDING_TOP
                                                   paddingLeft:PADDING_LEFT];
    return height;
}

-(void)customViews
{
    //背景图
    //    self.repostBg = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"repost-bg.png"]stretchableImageWithLeftCapWidth:28 topCapHeight:28]];
    //头像
    self.headView = [[UIView alloc] initWithFrame:CGRectZero];
    self.avatarBackGround = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.avatarImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.avatarImageView.backgroundColor = [UIColor clearColor];
    //用户名
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.userNameLabel.textColor = [UIColor brownColor];
    self.userNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.userNameLabel.backgroundColor = [UIColor clearColor];
    //用户地点
    self.locatonImageview = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.locationLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.locationLabel.textColor= [UIColor blackColor];
    self.locationLabel.font = [UIFont systemFontOfSize:12.0f];
    self.locationLabel.backgroundColor = [UIColor clearColor];
    //发布时间
    self.timeLabel= [[UILabel alloc]initWithFrame:CGRectZero];
    self.timeLabel.textColor = [UIColor brownColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.timeLabel.textAlignment =UITextAlignmentRight;
    self.timeLabel.backgroundColor = [UIColor clearColor];
    
    //微博视图
    self.weiboView = [[UIView alloc]initWithFrame:CGRectZero];
    //转发视图
    self.repostView = [[UIView alloc]initWithFrame:CGRectZero];
    self.weiboView.backgroundColor = [UIColor clearColor];
    self.repostView.backgroundColor = [UIColor clearColor];
    
    //微博内容
    // weiboContent = [[JSTwitterCoreTextView alloc]initWithFrame:CGRectZero];
    self.contentText = [self GetJSTwitterCoreTextView];
    self.contentText.backgroundColor = [UIColor clearColor];
    //转发内容
    //repostContent = [[JSTwitterCoreTextView alloc]initWithFrame:CGRectZero];
    self.repostText = [self GetJSTwitterCoreTextView] ;
    self.repostText.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *weiboImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
    
    UITapGestureRecognizer *repostImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(repostImageClicked:)];
    
    //微博图片
    self.weiboImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.weiboImage.layer setMasksToBounds:YES];
    [self.weiboImage.layer setCornerRadius:4];
    self.weiboImage.contentMode = UIViewContentModeScaleAspectFit;
    self.weiboImage.tag = WeiboImages;
    //转发图片
    self.repostImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.repostImage.layer setMasksToBounds:YES];
    [self.repostImage.layer setCornerRadius:4];
    self.repostImage.tag = RepostImages;
    
    //评论列表
    self.commentTable = [[UITableView alloc]initWithFrame:CGRectZero];
    //更多评论按钮
    self.moreComments = [[UIButton alloc]initWithFrame:CGRectZero];
    //评论按钮
    self.commentButton = [[UIButton alloc]initWithFrame:CGRectZero];
    
    self.repostImage.userInteractionEnabled = YES;
    self.repostImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.repostImage addGestureRecognizer:repostImgTap];
    [repostImgTap release];
    repostImgTap = nil;
    
    self.weiboImage.userInteractionEnabled = YES;
    [self.weiboImage addGestureRecognizer:weiboImgTap];
    [weiboImgTap release];
    weiboImgTap = nil;
    
    [self setFrame:CGRectMake(0, 0, 300, 0)];
    [self.layer setCornerRadius:4];
    
    [self addSubview:headView];
    [self addSubview:weiboView];
    [self addSubview:repostView];
    [self addSubview:commentTable];
    [self addSubview:moreComments];
    [self addSubview:commentButton];
    
    [self.headView addSubview:avatarBackGround];
    [self.headView addSubview:avatarImageView];
    [self.headView addSubview:userNameLabel];
    [self.headView addSubview:locatonImageview];
    [self.headView addSubview:locationLabel];
    [self.headView addSubview:timeLabel];
    [self.weiboView setUserInteractionEnabled:YES];
    [self.weiboView addSubview:weiboImage];
    [self.weiboView addSubview:contentText];
    [self.repostView addSubview:repostBackGround];
    [self.repostView addSubview:repostImage];
    [self.repostView addSubview:repostText];
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
