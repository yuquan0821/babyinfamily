//
//  BabyDetailStatusCell.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-8-2.
//
//


#import <QuartzCore/QuartzCore.h>
#import "BabyDetailStatusCell.h"
@implementation BabyDetailStatusCell
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
    self.contentText = [[UITextView alloc] initWithFrame:CGRectZero];
    self.contentText.font = [UIFont systemFontOfSize:15];
    self.contentText.editable = NO;
    self.contentText.backgroundColor = [UIColor clearColor];
    //转发内容
    self.repostText = [[UITextView alloc] initWithFrame:CGRectZero];
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
    height = [[self class] getStstusContentHeight:contentText.text contentViewWith:CONTENT_WIDTH];
    CGRect frame;
    frame =  weiboView.frame;
    frame.origin.y = 4;
    frame.origin.x = 8;
    
    //有weibo图
    if (self.contentImage.hidden == NO) {
        self.contentImage.frame  = CGRectMake(8,2, CONTENT_WIDTH, IMAGE_VIEW_HEIGHT);
        self.contentText.frame  = CGRectMake(8, contentImage.frame.origin.y + contentImage.frame.size.height+2, contentImage.frame.size.width, height+2);
    }else{
        //无微博图
        self.contentText.frame  = CGRectMake(8, 2, CONTENT_WIDTH, height+2);
    }
    self.weiboView.frame  = CGRectMake(12, 2, CELL_WIDTH, contentText.frame.origin.y + contentText.frame.size.height + 2);
    
    //有转发
    if (self.repostMainView.hidden == NO) {
        frame =  repostMainView.frame;
        frame.origin.y = weiboView.frame.origin.y + weiboView.frame.size.height-8;
        frame.origin.x = 8;
        frame.size.width = CELL_WIDTH;
        self.repostMainView.frame = frame;
        self.repostText.text = [NSString stringWithFormat:@"@%@:%@",repostWeibo.user.name,repostWeibo.text];
        height = [[self class]getStstusContentHeight:repostText.text contentViewWith:CONTENT_WIDTH];
        //有转发图
        if (self.repostContentImage.hidden ==NO) {
            self.repostContentImage.frame = CGRectMake(12,  2, CONTENT_WIDTH, IMAGE_VIEW_HEIGHT);
            self.repostText.frame  = CGRectMake(8, repostContentImage.frame.origin.y + repostContentImage.frame.size.height, CONTENT_WIDTH, height+2);
            
        }else{
            //无转发图
            self.repostText.frame = CGRectMake(8, 2, CONTENT_WIDTH, height+2);
        }
        
        frame.size.height  = repostText.frame.origin.y + repostText.frame.size.height;
        self.repostMainView.frame = frame;
        //        self.repostBg.frame = CGRectMake(2, 0, 300, repostView.frame.size.height);
        self.cellHeight = repostMainView.frame.size.height + repostMainView.frame.origin.y + 6;
    }else{
        //无转发
        self.cellHeight = weiboView.frame.size.height + weiboView.frame.origin.y + 6 ;
    }
    
    
    self.frame = CGRectMake(0, 0, 320, cellHeight);
}


//更新Cell
-(void)updateCellWith:(Status *)weibo
{
    self.status = weibo;
    Status  *repostWeibo = weibo.retweetedStatus;
    NSString *url = weibo.bmiddlePic;
    NSLog(@"weibo.thumbnailImageUrl:%@",url);
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
        NSLog(@"有转发:weibo.thumbnailImageUrl:%@",url);
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
    self.status = nil;
    [super dealloc];
}




@end