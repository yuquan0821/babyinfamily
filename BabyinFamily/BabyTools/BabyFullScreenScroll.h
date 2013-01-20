//
//  BabyFullScreenScroll.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-1-8.
//
//

#import <Foundation/Foundation.h>

@interface BabyFullScreenScroll : NSObject <UIScrollViewDelegate>
{
    CGFloat _prevContentOffsetY;
    
    BOOL    _isScrollingTop;
}

@property (strong, nonatomic) UIViewController* viewController;

@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL shouldShowUIBarsOnScrollUp;

- (id)initWithViewController:(UIViewController*)viewController;

- (void)layoutTabBarController; // set on viewDidAppear, if using tabBarController

- (void)showUIBarsWithScrollView:(UIScrollView*)scrollView animated:(BOOL)animated;

@end
