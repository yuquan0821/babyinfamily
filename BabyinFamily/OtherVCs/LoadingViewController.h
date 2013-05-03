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

#import "UserGuideVIew.h"


@interface LoadingViewController : UIViewController<SinaWeiboDelegate,SinaWeiboRequestDelegate>
{
    UIButton *_loadButton;
    
    UIActivityIndicatorView *_indicator;
}

@property (strong, nonatomic) UIButton *loadButton;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@property (retain, nonatomic) UserGuideVIew *userGuideView;

@property (retain, nonatomic) UILabel       *titleLabel;

- (void) addButton;

- (void) login:(UIButton*) sender;




@end