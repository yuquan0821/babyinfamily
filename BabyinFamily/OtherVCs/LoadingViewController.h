//
//  LoadingViewController.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-4-20.
//
//

#import <UIKit/UIKit.h>

#import "SinaWeibo.h"

#import "SinaWeiboRequest.h"

@interface LoadingViewController : UIViewController<SinaWeiboDelegate,SinaWeiboRequestDelegate>
{
    UIButton *_shareButton;
    
    UIActivityIndicatorView *_indicator;
}

@property (strong, nonatomic) UIButton *shareButton;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;

- (void) addButton;

- (void) share:(UIButton*) sender;




@end