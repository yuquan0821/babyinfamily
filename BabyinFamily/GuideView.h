//
//  GuideView.h
//  
//
//  Created by Cloay on 12-9-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568) 

@interface GuideView : UIView<UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *pageScroll;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) IBOutlet UIButton *closeButton;

- (IBAction)closeButtonDidPressed:(id)sender;
@end
