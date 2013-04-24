//
//  GuideView.m
//  
//
//  Created by Cloay on 12-9-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GuideView.h"

@implementation GuideView
@synthesize pageScroll;
@synthesize pageControl;
@synthesize closeButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    for (int i=0; i<5; i++) {
        CGRect frame = CGRectMake(pageScroll.frame.size.width * i,
                                  0,
                                  pageScroll.frame.size.width,pageScroll.frame.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i ]]];
        
        [pageScroll addSubview:imageView];
    }
    
    pageScroll.contentSize = CGSizeMake(pageScroll.frame.size.width * 5, pageScroll.frame.size.height);
    
    [self.pageScroll setDelegate:self];
    float y = DEVICE_IS_IPHONE5 ? 510 : 425;
    [self.pageControl setFrame:CGRectMake(110, y, 100, 36)];
}

- (IBAction)closeButtonDidPressed:(id)sender{
    [UIView beginAnimations:@"Close" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [self setAlpha:0.15];
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark scrollview delegate method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}
@end
