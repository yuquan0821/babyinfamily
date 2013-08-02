//
//  GTTabBarController.h
//  GTTabBarDemo
//
//  Created by GTL on 13-6-5.
//  Copyright (c) 2013年 phisung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTTabBar.h"

@protocol GTTabBarControllerDelegate;

@interface GTTabBarController : UIViewController <GTTabBarDelegate>
{
    id <GTTabBarControllerDelegate> __unsafe_unretained _delegate;
	GTTabBar *tabBar;
	UIView      *containerView;
	UIView		*transitionView;
	
	NSMutableArray *viewControllers;
	NSUInteger selectedIndex;
	
	BOOL tabBarTransparent;
	BOOL tabBarHidden;
    
    NSInteger animateDriect;
}
@property(nonatomic, unsafe_unretained) id<GTTabBarControllerDelegate> delegate;
@property(nonatomic, copy) NSMutableArray *viewControllers;
@property(nonatomic, readonly) UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;

// Apple is readonly
@property (nonatomic, readonly) GTTabBar *tabBar;

// Default is NO, if set to YES, content will under tabbar
@property (nonatomic) BOOL tabBarTransparent;
@property (nonatomic) BOOL tabBarHidden;

@property(nonatomic,unsafe_unretained) NSInteger animateDriect;

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr;

- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated driect:(NSInteger)driect;

// Remove the viewcontroller at index of viewControllers.
- (void)removeViewControllerAtIndex:(NSUInteger)index;

// Insert an viewcontroller at index of viewControllers.
- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;

@end

#pragma mark -
@protocol GTTabBarControllerDelegate <NSObject>
@optional
- (BOOL)tabBarController:(GTTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(GTTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end

#pragma mark -
@interface UIViewController (GTTabBarControllerSupport)
@property(nonatomic, readonly) GTTabBarController *gtTabBarController;
@end
