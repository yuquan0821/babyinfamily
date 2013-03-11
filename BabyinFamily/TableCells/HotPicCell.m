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

@synthesize label, reuseIdentifier;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect bgFrame = CGRectInset(self.bounds, 0.0f, 0.0f);
        UIView *bgView = [[UIView alloc] initWithFrame:bgFrame];
        bgView.layer.borderColor = [UIColor blackColor].CGColor;
        bgView.layer.borderWidth = 2.0f;
        [self addSubview:bgView];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgFrame.size.width, 20)];
        label.center = CGPointMake(self.frame.size.width/ 2, self.frame.size.height/2);
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [self addSubview:label];
    }
    
    return self;
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

@end
