//
//  HotPicCell.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-3-11.
//
//

#import "HotPicCell.h"
#import <QuartzCore/QuartzCore.h>


@interface HotPicCell ()

@end

@implementation HotPicCell

@synthesize  reuseIdentifier, contentImage,index;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect bgFrame = CGRectInset(self.bounds, 0.0f, 0.0f);
        UIView *bgView = [[UIView alloc] initWithFrame:bgFrame];
        bgView.layer.borderColor = [UIColor blackColor].CGColor;
        bgView.layer.borderWidth = 1.0f;
        bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        CGRect contentFrame = CGRectMake(bgView.frame.origin.x + 1, bgView.frame.origin.y + 1, bgView.frame.size.width -2, bgView.frame.size.height -2);
        contentImage = [[UIImageView alloc] initWithFrame:contentFrame];
        contentImage.backgroundColor = [UIColor clearColor];
        contentImage.image = [UIImage imageNamed:@"weibo.bundle/WeiboImages/loadingImage_50x118.png"];
        contentImage.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

        [bgView addSubview:contentImage];
        [self addSubview:bgView];
        
    }
    
    return self;
}

- (void)dealloc
{
    //[index release];
    [contentImage release];
    [super dealloc];
}


@end


@implementation CHDemoView
@synthesize originRect;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        ges.numberOfTapsRequired = 1;
        ges.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:ges];
        
    }
    return self;
}

- (void)singleTapAction:(UITapGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = self.originRect;
        } completion:^(BOOL isFinished){
            [self removeFromSuperview];
        }];
        
        
    }
}
- (void)dealloc
{
    [super dealloc];
}

@end
