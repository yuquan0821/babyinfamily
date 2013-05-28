#import <UIKit/UIKit.h>
#import "IntroView.h"

@interface IntroControll : UIView<UIScrollViewDelegate> {
    UIImageView *backgroundImage1;
    UIImageView *backgroundImage2;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSArray *pages;
    
    NSTimer *timer;
    
    int currentPhotoNum;
}

//fan 修改
/*@property(nonatomic, retain)UIImageView *backgroundImage1;
@property(nonatomic, retain)UIImageView *backgroundImage2;
@property(nonatomic, retain)UIScrollView *scrollView;
@property(nonatomic, retain)UIPageControl *pageControl;
@property(nonatomic, retain)NSArray *pages;
@property(nonatomic, retain)NSTimer *timer;*/

- (id)initWithFrame:(CGRect)frame pages:(NSArray*)pagesArray;


@end
