//
//  UserGuideVIew.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-4-23.
//
//

#import "UserGuideVIew.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define StateBarHeight 20
#define MainHeight (ScreenHeight - StateBarHeight)
#define MainWidth ScreenWidth

@interface UserGuideVIew ()

@end

@implementation UserGuideVIew

@synthesize scrollView;
@synthesize pageControl;

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
        CGRect frame = CGRectMake(scrollView.frame.size.width * i,
                                  0,
                                  scrollView.frame.size.width,scrollView.frame.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i ]]];
        
        [scrollView addSubview:imageView];
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 5, scrollView.frame.size.height);
    
    [self.scrollView setDelegate:self];
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    float y = DEVICE_IS_IPHONE5 ? 475 : 380;
    [self.pageControl setFrame:CGRectMake(110, y, 100, 35)];

}

#pragma mark -
#pragma mark scrollview delegate method
- (void)scrollViewDidScroll:(UIScrollView *)sv{
    CGFloat pageWidth = self.frame.size.width;
    int page = floor((sv.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void) dealloc
{
    [scrollView release];
    [pageControl release];
    [super dealloc];
}

@end
