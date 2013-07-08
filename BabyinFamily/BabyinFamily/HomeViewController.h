//
//  HomeViewController.h
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//


#import <UIKit/UIKit.h>
#import "StatusViewControllerBase.h"

@interface HomeViewController : StatusViewControllerBase
{
    NSString *userID;
    int _page;
    long long _maxID;
    BOOL _shouldAppendTheDataArr;
}

@property (nonatomic, copy)     NSString *userID;
//@property (nonatomic, retain) NSTimer *timer;

@end