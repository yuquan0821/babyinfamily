//
//  AboutViewController.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-5-9.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coinView.h"

@interface AboutViewController : UIViewController<coinViewDelegate>
@property (nonatomic, assign)  int counter;
@property (retain, nonatomic) coinView *coinview;
@property (retain, nonatomic) NSTimer *timer;

- (IBAction)buttonPressed:(id)sender;

@end
