//
//  HotViewController+Private.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-2-28.
//
//


#import "HotViewController.h"
#import "Status.h"


@interface HotViewController (Private)
@property (nonatomic, retain)   NSMutableArray          *statuesArr;

- (void) _demoAsyncDataLoading;
- (void) buildBarButtons;

@end