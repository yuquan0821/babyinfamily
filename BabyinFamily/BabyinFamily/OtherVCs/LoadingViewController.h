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
    UIButton *_loadButton;
    
}

@property (retain, nonatomic) UIButton *loadButton;


@property (retain, nonatomic) UILabel       *titleLabel;

- (void) addButton;

- (void) login:(UIButton*) sender;




@end