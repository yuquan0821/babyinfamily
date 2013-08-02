//
//  GTTabBar.h
//  GTTabBarDemo
//
//  Created by GTL on 13-6-5.
//  Copyright (c) 2013年 phisung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTTabBarDelegate;

@interface GTTabBar : UIView
{
    id __unsafe_unretained _delegate;
}

@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, unsafe_unretained) id<GTTabBarDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)removeTabAtIndex:(NSInteger)index;
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;
- (void)setBackgroundImage:(UIImage *)img;

@end

@protocol GTTabBarDelegate<NSObject>
@optional
- (void)tabBar:(GTTabBar *)tabBar didSelectIndex:(NSInteger)index;
@end
