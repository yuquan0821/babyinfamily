//
//  HomeViewController.h
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//


#import <UIKit/UIKit.h>
#import "StatusViewControllerBase.h"
#import "OAuthWebView.h"

@interface HomeViewController : StatusViewControllerBase
{
    NSString *userID;
}

@property (nonatomic, copy)     NSString *userID;
@property (nonatomic, retain) NSTimer *timer;

@end