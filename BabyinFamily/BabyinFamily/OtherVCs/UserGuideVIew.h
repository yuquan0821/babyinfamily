//
//  UserGuideVIew.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-4-23.
//
//

#import <UIKit/UIKit.h>

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

@interface UserGuideVIew : UIView<UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

@end