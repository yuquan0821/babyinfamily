//
//  CellHeaderView.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-1-7.
//
//

#import "CellHeaderView.h"
#define ARROW_LEFT_X 26

@implementation CellHeaderView

@synthesize avatarImage ;
@synthesize arrowImage ;
@synthesize nameLabel;
@synthesize locationIcon;
@synthesize locationLabel;
@synthesize timeLabel;

-(void) dealloc
{
    [avatarImage release];
    [arrowImage release];
    [nameLabel release];
    [locationIcon release];
    [locationLabel release];
    [timeLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeState];
        [self setUpArrow:frame];
    }
    return self;
}

- (void)initializeState {

    self.alpha = 0.9;
    self.backgroundColor = [UIColor clearColor];
    
    self.avatarImage = [UIImage imageNamed:@"weibo.bundle/WeiboImages/touxiang_40x40.png"];
    self.arrowImage = [UIImage imageNamed:@"weibo.bundle/WeiboImages/arrow.png"];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 160, 28)];
    self.nameLabel.textColor = [UIColor brownColor];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:17];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    
    self.locationIcon = [UIImage imageNamed:@"weibo.bundle/WeiboImages/compose_locatebutton_background.png"];
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(72,  self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height - 4, 144, 21)];
    self.locationLabel.textColor = [UIColor blackColor];
    self.locationLabel.font = [UIFont systemFontOfSize: 12];
    self.locationLabel.backgroundColor = [UIColor clearColor];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width, 16, 80, 21)];
    self.timeLabel.textColor = [UIColor brownColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textAlignment = UITextAlignmentRight;
    self.timeLabel.backgroundColor = [UIColor clearColor];
        
    [self addSubview:nameLabel];
    [self addSubview:locationLabel];
    [self addSubview:timeLabel];
}

- (void)setupHeaderView:(Status *)status avatarImageData:(NSData *)avatarData
{
    if (![avatarData isEqual:[NSNull null]])
    {
        self.avatarImage= [UIImage imageWithData:avatarData];
    }else{
        self.avatarImage= [UIImage imageNamed:@"weibo.bundle/WeiboImages/loadingImage_50x118.png"];
    }
    self.nameLabel.text = status.user.screenName;
    self.locationLabel.text = status.user.location;
    self.timeLabel.text = status.timestamp;
    
}

- (void)setUpArrow:(CGRect)frame {
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:self.arrowImage];
    arrowImageView.frame = CGRectMake(ARROW_LEFT_X, frame.size.height, self.arrowImage.size.width, self.arrowImage.size.height);
    arrowImageView.alpha = 0.9;
    UIImageView *locationImageView = [[UIImageView alloc] initWithImage:self.locationIcon];
    locationImageView.frame =  CGRectMake(58, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height, 14, 14);
    
    [self addSubview:arrowImageView];
    [self addSubview:locationImageView];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBackgroundIn:rect context:context];
    [self drawAvatar:context];
}

- (void)drawBackgroundIn:(CGRect)rect context:(CGContextRef)context {
    // Draws the dark area which serves as the background of the entire header view. Other views (such as avatar and slider)
    // will be all drawn on top of this.
    CGContextSetFillColorWithColor(context,
                                   [UIColor colorWithRed:39.0 / 255.0 green:39.0 / 255.0 blue:40.0 / 255.0 alpha:1.0].CGColor);
    CGContextAddRect(context, rect);
    CGContextFillPath(context);
}

- (void)drawAvatar:(CGContextRef)context {
    CGRect avatarRect = CGRectMake(10, 3, 42, 42);
    UIBezierPath *avatarPath = [UIBezierPath bezierPathWithRoundedRect:avatarRect cornerRadius:4];
    CGContextAddPath(context, avatarPath.CGPath);
    CGContextClip(context);
    [self.avatarImage drawInRect:avatarRect];
}

@end