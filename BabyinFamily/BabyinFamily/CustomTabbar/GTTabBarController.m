//
//  GTTabBarController.m
//  GTTabBarDemo
//
//  Created by GTL on 13-6-5.
//  Copyright (c) 2013年 phisung. All rights reserved.
//

#import "GTTabBarController.h"
#import "GTTabBar.h"
#define kTabBarHeight 58.0f

static GTTabBarController *gtTabBarController;

@implementation UIViewController (GTTabBarControllerSupport)

- (GTTabBarController *)gtTabBarController
{
	return gtTabBarController;
}

@end

@interface GTTabBarController (private)
- (void)displayViewAtIndex:(NSUInteger)index;
@end

#pragma mark -
@implementation GTTabBarController
@synthesize delegate;
@synthesize selectedViewController;
@synthesize viewControllers;
@synthesize selectedIndex;
@synthesize tabBarHidden;
@synthesize animateDriect;
@synthesize tabBar;
@synthesize tabBarTransparent;

#pragma mark -
#pragma mark lifecycle
- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr
{
	self = [super init];
	if (self != nil)
	{
		viewControllers = [[NSMutableArray arrayWithArray:vcs] retain];
		containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, containerView.frame.size.height - kTabBarHeight)];
		transitionView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
		tabBar = [[GTTabBar alloc] initWithFrame:CGRectMake(0, containerView.frame.size.height - kTabBarHeight, 320.0f, kTabBarHeight) buttonImages:arr];
		tabBar.delegate = self;
        gtTabBarController = self;
        animateDriect = 0;
        tabBarHidden = NO;
        [tabBar setBackgroundImage:[UIImage imageWithSourceKit:@"TabBar/bg_TabBar.png"]];
	}
	return self;
}

- (void)loadView
{
	[super loadView];
	
	[containerView addSubview:transitionView];
	[containerView addSubview:tabBar];
	self.view = containerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.selectedIndex = 0;
}


#pragma mark - instant methods
- (void)setTabBarTransparent:(BOOL)yesOrNo
{
	if (yesOrNo == YES)
	{
		transitionView.frame = containerView.bounds;
	}
	else
	{
		//transitionView.frame = CGRectMake(0, 0, 320.0f, containerView.frame.size.height - kTabBarHeight);
        transitionView.frame = CGRectMake(0, 0, 320.0f, containerView.frame.size.height - 44);
	}
}

- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated
{
    [self hidesTabBar:yesOrNO animated:animated driect:animateDriect];
}

- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated driect:(NSInteger)driect
{
    // driect: 0 -- 上下  1 -- 左右
    NSLog(@"%i,%i", tabBarHidden, yesOrNO);
    NSInteger kTabBarWidth = [[UIScreen mainScreen] applicationFrame].size.width;
    
	if (yesOrNO == YES)
	{
        if (driect == 0)
        {
            if (self.tabBar.frame.origin.y == self.view.frame.size.height)
            {
                return;
            }
        }
        else
        {
            if (self.tabBar.frame.origin.x == 0 - kTabBarWidth)
            {
                return;
            }
        }
	}
	else
	{
        if (driect == 0)
        {
            if (self.tabBar.frame.origin.y == self.view.frame.size.height - kTabBarHeight)
            {
                return;
            }
        }
        else
        {
            if (self.tabBar.frame.origin.x == 0)
            {
                return;
            }
        }
	}
	
	if (animated == YES)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		if (yesOrNO == YES)
		{
            if (driect == 0)
            {
                self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
            }
            else
            {
                self.tabBar.frame = CGRectMake(0 - kTabBarWidth, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
            }
		}
		else
		{
            if (driect == 0)
            {
                self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
            }
            else
            {
                self.tabBar.frame = CGRectMake(0, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
            }
		}
		[UIView commitAnimations];
	}
	else
	{
		if (yesOrNO == YES)
		{
            if (driect == 0)
            {
                self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
            }
            else
            {
                self.tabBar.frame = CGRectMake(0 - kTabBarWidth, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
            }
		}
		else
		{
            if (driect == 0)
            {
                self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
            }
            else
            {
                self.tabBar.frame = CGRectMake(0, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
            }
		}
	}
    tabBarHidden = yesOrNO;
}

- (NSUInteger)selectedIndex
{
	return selectedIndex;
}
- (UIViewController *)selectedViewController
{
    return [viewControllers objectAtIndex:selectedIndex];
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [self displayViewAtIndex:index];
    [tabBar selectTabAtIndex:index];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    if (index >= [viewControllers count])
    {
        return;
    }
    // Remove view from superview.
    [[(UIViewController *)[viewControllers objectAtIndex:index] view] removeFromSuperview];
    // Remove viewcontroller in array.
    [viewControllers removeObjectAtIndex:index];
    // Remove tab from tabbar.
    [tabBar removeTabAtIndex:index];
}

- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    [viewControllers insertObject:vc atIndex:index];
    [tabBar insertTabWithImageDic:dict atIndex:index];
}


#pragma mark - Private methods
- (void)displayViewAtIndex:(NSUInteger)index
{
    // Before change index, ask the delegate should change the index.
    if ([self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
    {
        if (![self.delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]])
        {
            [self.tabBar selectTabAtIndex:selectedIndex];
            return;
        }
    }
    // If target index if equal to current index, do nothing.
    if (selectedIndex == index && [[transitionView subviews] count] != 0)
    {
        return;
    }
    NSLog(@"Display View.");
    selectedIndex = index;
    
	UIViewController *selectedVC = [self.viewControllers objectAtIndex:index];
	
	selectedVC.view.frame = transitionView.frame;
	if ([selectedVC.view isDescendantOfView:transitionView])
	{
		[transitionView bringSubviewToFront:selectedVC.view];
	}
	else
	{
		[transitionView addSubview:selectedVC.view];
	}
    
    // Notify the delegate, the viewcontroller has been changed.
    if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController::)])
    {
        [self.delegate tabBarController:self didSelectViewController:selectedVC];
    }
    
}

#pragma mark -
#pragma mark tabBar delegates
- (void)tabBar:(GTTabBar *)tabBar didSelectIndex:(NSInteger)index
{
	[self displayViewAtIndex:index];
}

@end

