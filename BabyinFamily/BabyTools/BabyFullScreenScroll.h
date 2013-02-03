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

@property (retain, nonatomic) UIViewController* viewController;

@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL shouldShowUIBarsOnScrollUp;

//
// NOTE:
// BabyFullScreenScroll forces viewController.navigationController's navigationBar/toolbar
// to set translucent=YES (to set navigationController's content size wider for convenience).
//
- (id)initWithViewController:(UIViewController*)viewController; // default: ignoreTranslucent=YES
- (id)initWithViewController:(UIViewController*)viewController ignoreTranslucent:(BOOL)ignoreTranslucent;

- (void)layoutTabBarController; // set on viewDidAppear, if using tabBarController

- (void)showUIBarsWithScrollView:(UIScrollView*)scrollView animated:(BOOL)animated;

@end
