//
//  BabyStatusCell.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-8.
//
//
#import <QuartzCore/QuartzCore.h>
#import "BabyStatusCell.h"
@implementation BabyStatusCell
@synthesize delegate;

@synthesize weiboView;
@synthesize bgImage;
@synthesize contentImage;
@synthesize contentText;

@synthesize repostBackGround;
@synthesize repostMainView;
@synthesize repostContentImage;
@synthesize repostText;

@synthesize status;
@synthesize cellHeight;
@synthesize statusHeight;
//@synthesize commentTableView;
@synthesize more;
@synthesize commentButton;
@synthesize shareButton;

typedef enum{
    WeiboImages,
    RepostImages
}_viewTag;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self customViews]; //自定义Cell
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)customViews
{
    //背景图
    //    self.repostBg = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"repost-bg.png"]stretchableImageWithLeftCapWidth:28 topCapHeight:28]];
    //微博视图
    self.weiboView = [[UIView alloc]initWithFrame:CGRectZero];
    //转发视图
    self.repostMainView = [[UIView alloc]initWithFrame:CGRectZero];
    self.weiboView.backgroundColor = [UIColor clearColor];
    self.repostMainView.backgroundColor = [UIColor clearColor];
    
    //微博内容
    self.contentText = [[UITextView alloc] initWithFrame: CGRectMake(PADDING_LEFT, 0, CELL_WIDTH, 0)];
    self.contentText.font = [UIFont systemFontOfSize:15];
    self.contentText.editable = NO;
    self.contentText.backgroundColor = [UIColor clearColor];
    //转发内容
    self.repostText = [[UITextView alloc] initWithFrame:CGRectMake(PADDING_LEFT, 0, CELL_WIDTH, 0)];
    self.repostText.font = [UIFont systemFontOfSize:15];
    self.repostText.editable = NO;
    self.repostText.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *weiboImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
    
    UITapGestureRecognizer *repostImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(repostImageClicked:)];
    
    //微博图片
    self.contentImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentImage.layer setMasksToBounds:YES];
    [self.contentImage.layer setCornerRadius:4];
    self.contentImage.contentMode = UIViewContentModeScaleToFill;
    self.contentImage.tag = WeiboImages;
    //转发图片
    self.repostContentImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.repostContentImage.layer setMasksToBounds:YES];
    [self.repostContentImage.layer setCornerRadius:4];
    self.repostContentImage.tag = RepostImages;
    //评论列表
    //self.commentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //评论按钮
    self.commentButton = [[UIButton alloc]initWithFrame:CGRectZero];
    self.commentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.commentButton.titleLabel.textColor = [UIColor blackColor];
    [self.commentButton addTarget:self action:@selector(statusCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //分享按钮
    self.shareButton = [[UIButton alloc]initWithFrame:CGRectZero];
    self.shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.shareButton.titleLabel.textColor = [UIColor blackColor];
    [self.shareButton setTitle: @"分享" forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(StatusShareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //更多操作按钮
    self.more = [[UIButton alloc]initWithFrame:CGRectZero];
    self.more = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.more.titleLabel.textColor = [UIColor blackColor];
    [self.more setTitle: @"..." forState:UIControlStateNormal];
    [self.more addTarget:self action:@selector(statusMoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.repostContentImage.userInteractionEnabled = YES;
    self.repostContentImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.repostContentImage addGestureRecognizer:repostImgTap];
    [repostImgTap release];
    repostImgTap = nil;
    
    self.contentImage.userInteractionEnabled = YES;
    [self.contentImage addGestureRecognizer:weiboImgTap];
    [weiboImgTap release];
    weiboImgTap = nil;
    
    [self setFrame:CGRectMake(0, 0, 300, 0)];
    [self.layer setCornerRadius:4];
    
    [self addSubview:weiboView];
    [self addSubview:repostMainView];
    [self addSubview:commentButton];
    //[self addSubview:commentTableView];
    [self addSubview:more];
    //[self addSubview:shareButton];
    
    [self.weiboView setUserInteractionEnabled:YES];
    [self.weiboView addSubview:contentImage];
    [self.weiboView addSubview:contentText];
    [self.repostMainView addSubview:repostBackGround];
    [self.repostMainView addSubview:repostContentImage];
    [self.repostMainView addSubview:repostText];
}
//获取文本框高度
+ (CGFloat)getStstusContentHeight:(NSString*)text contentViewWith:(CGFloat)with
{
    CGFloat height = 1;
    UIFont * font=[UIFont  systemFontOfSize:16];
    CGSize size=[text sizeWithFont:font constrainedToSize:CGSizeMake(with, 300.0f) lineBreakMode:UILineBreakModeWordWrap];
    height = size.height + 7;
    return height;
}

//设置Cell
-(void)setContent:(Status *)weibo
{
    [contentText layoutIfNeeded];
    [repostText layoutIfNeeded];
    contentText.text = weibo.text;
    Status  *repostWeibo = weibo.retweetedStatus;
    CGFloat height = 0;
    height = contentText.contentSize.height;//[[self class] getStstusContentHeight:contentText.text contentViewWith:CONTENTIMAGE_WIDTH] + 0.0f;
    CGRect frame;
    frame =  weiboView.frame;
    frame.origin.y = 4;
    frame.origin.x = 8;
    
    //有weibo图
    if (self.contentImage.hidden == NO) {
        self.contentImage.frame  = CGRectMake(PADDING_LEFT,PADDING_TOP, CELL_WIDTH, IMAGE_VIEW_HEIGHT);
        self.contentText.frame  = CGRectMake(PADDING_LEFT, contentImage.frame.origin.y + contentImage.frame.size.height+2, contentImage.frame.size.width, height+PADDING_TOP);
    }else{
        //无微博图
        self.contentText.frame  = CGRectMake(PADDING_LEFT, PADDING_TOP, CELL_WIDTH, height+PADDING_TOP);
    }
    self.weiboView.frame  = CGRectMake(PADDING_LEFT, PADDING_TOP, CELL_WIDTH, contentText.frame.origin.y + contentText.frame.size.height + PADDING_TOP);
    //有转发
    if (self.repostMainView.hidden == NO) {
        frame =  repostMainView.frame;
        frame.origin.y = weiboView.frame.origin.y + weiboView.frame.size.height-8;
        frame.origin.x = 8;
        frame.size.width = CELL_WIDTH;
        self.repostMainView.frame = frame;
        self.repostText.text = [NSString stringWithFormat:@"@%@:%@",repostWeibo.user.name,repostWeibo.text];
        height = repostText.contentSize.height;//[[self class]getStstusContentHeight:repostText.text contentViewWith:CONTENT_WIDTH];
        //有转发图
        if (self.repostContentImage.hidden ==NO) {
            self.repostContentImage.frame = CGRectMake(PADDING_LEFT,  PADDING_TOP, CONTENT_WIDTH, IMAGE_VIEW_HEIGHT);
            self.repostText.frame  = CGRectMake(PADDING_LEFT, repostContentImage.frame.origin.y + repostContentImage.frame.size.height, CONTENT_WIDTH, height+PADDING_TOP);
            
        }else{
            //无转发图
            self.repostText.frame = CGRectMake(PADDING_LEFT, PADDING_TOP, CONTENT_WIDTH, height+PADDING_TOP);
        }
    
        frame.size.height  = repostText.frame.origin.y + repostText.frame.size.height;
        self.repostMainView.frame = frame;
        self.statusHeight = repostMainView.frame.size.height + repostMainView.frame.origin.y;
     }else{
        //无转发
        self.statusHeight = weiboView.frame.size.height + weiboView.frame.origin.y;
     }
 
    self.commentButton.frame = CGRectMake(10, self.statusHeight + PADDING_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
    if (weibo.commentsCount ==0) {
        [self.commentButton setTitle: @"评论" forState:UIControlStateNormal];

    }else{
        [self.commentButton setTitle: [NSString stringWithFormat:@"评论:%d",weibo.commentsCount] forState:UIControlStateNormal];
    }
    self.shareButton.frame = CGRectMake(110, self.statusHeight +PADDING_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);

    self.more.frame = CGRectMake(210, self.statusHeight + PADDING_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);

    self.cellHeight = commentButton.frame.origin.y + commentButton.frame.size.height + 6;
    
    self.frame = CGRectMake(0, 0, 320, cellHeight);
}


//更新Cell
-(void)updateCellWith:(Status *)weibo
{
    self.status = weibo;
    Status  *repostWeibo = weibo.retweetedStatus;    
    NSString *url = weibo.bmiddlePic;
    //NSLog(@"weibo.thumbnailImageUrl:%@",url);
    //有图
    if (url!=nil) {
        self.contentImage.hidden = NO;
    }else{
        self.contentImage.hidden = YES;
    }
    
    //有转发
    if (repostWeibo && ![repostWeibo isEqual:[NSNull null]])
    {
        self.repostMainView.hidden = NO;
        
        NSString *url = repostWeibo.bmiddlePic;
        //NSLog(@"有转发:weibo.thumbnailImageUrl:%@",url);
        //有图
        if (url!=nil) {
            self.repostContentImage.hidden = NO;
        }else{
            self.repostContentImage.hidden = YES;
        }
    }
    //无转发
    else
    {
        self.repostMainView.hidden = YES;
    }
    
    [self setContent:weibo];
}

//点击微博图片
-(void)imageClicked:(UITapGestureRecognizer *)sender
{
    if([sender isKindOfClass:[UITapGestureRecognizer class]]){
        if (sender.numberOfTapsRequired == 1) {
            [delegate statusImageClicked:self.status];
        }
    }

}

//点击转发微博图片
-(void)repostImageClicked:(UITapGestureRecognizer *)sender
{
    
    if([sender isKindOfClass:[UITapGestureRecognizer class]]){
        if (sender.numberOfTapsRequired == 1) {
            [delegate statusImageClicked:self.status.retweetedStatus];
        }
    }

}

- (void)statusCommentButtonClicked:(id)sender
{
    [delegate statusCommentButtonClicked:self.status];

}

- (void)statusMoreButtonClicked:(id)sender
{
    [delegate statusMoreButtonClicked:self.status];
}

- (void)StatusShareButtonClicked:(id)sender
{
    [delegate StatusShareButtonClicked:self.status];

}

- (void)dealloc
{
    [self.weiboView release];
    [self.bgImage release];
    [self.contentImage release];
    self.contentText = nil;
    [self.repostBackGround release];
    [self.repostMainView release];
    [self.repostContentImage release];
    self.repostText = nil;
    [self.commentButton release];
    [self.more release];
    [self.shareButton release];
    self.status = nil;
    [super dealloc];
}




@end
