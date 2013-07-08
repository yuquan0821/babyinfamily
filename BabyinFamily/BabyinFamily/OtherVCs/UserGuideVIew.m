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
        CGRect imageframe = CGRectMake(scrollView.frame.size.width * i,
                                  0,
                                  scrollView.frame.size.width,scrollView.frame.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageframe];
        
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i ]]];
        float x = DEVICE_IS_IPHONE5 ? 420 : 330;

        UITextView *descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width * i + 40, x + 5, self.scrollView.frame.size.width - 80, 60)];
        descriptionTextView.scrollEnabled = NO;
        descriptionTextView.backgroundColor = [UIColor clearColor];
        descriptionTextView.textAlignment = NSTextAlignmentLeft;
        descriptionTextView.textColor = [UIColor whiteColor];
        descriptionTextView.font = [UIFont boldSystemFontOfSize:16.0f];
        if (i == 0) {
            descriptionTextView.text = @"如你所知\n        家贝不止是一款拍照工具";
        }
        if (i == 1) {
            descriptionTextView.text = @"她记录了\n        你与孩子的美丽瞬间";            
        }
        if (i == 2) {
            descriptionTextView.text = @"他记录了\n        孩子生活中的点滴";            
        }
        if (i == 3) {
            descriptionTextView.text = @"在纷繁的世界中\n        孩子是您永远的牵挂";            
        }
        if (i == 4) {
            descriptionTextView.text = @"如你所见\n        家贝是你一个温馨的家";            
        }
        descriptionTextView.editable = NO;
        descriptionTextView.userInteractionEnabled = NO;
        
        [scrollView addSubview:imageView];
        [scrollView addSubview:descriptionTextView];
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
