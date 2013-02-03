//
//  RaisedCenterButton.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-1-30.
//
//

#import "RaisedCenterButton.h"
#import "TakePhotoViewController.h"

@interface RaisedCenterButton ()

@property (strong, nonatomic) UITabBarController *tabBarController;

- (void)buttonAction;

@end

@implementation RaisedCenterButton

@synthesize tabBarController = _tabBarController;
@synthesize buttonImage = _buttonImage;

+ (id)buttonWithImage:(UIImage *)image forTabBarController:(UITabBarController *)tabBarController
{
    RaisedCenterButton *button = [RaisedCenterButton buttonWithType:UIButtonTypeCustom];
    
    // we use this to center our button and take action when the button is used.
    [button setTabBarController:tabBarController];
    [button setButtonImage:image];
    
    return button;
}

- (void)setButtonImage:(UIImage *)buttonImage
{
    if (buttonImage != _buttonImage) {
        _buttonImage = buttonImage;
        
        self.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
        [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
        self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        CGFloat heightDifference = buttonImage.size.height - self.tabBarController.tabBar.frame.size.height;
        if (heightDifference < 0)
            self.center = self.tabBarController.tabBar.center;
        else
        {
            CGPoint center = self.tabBarController.tabBar.center;
            center.y = center.y - self.tabBarController.tabBar.frame.origin.y - heightDifference/2.0;
            self.center = center;
        }
        [self addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

// replicating the action of touching the center button on the tab bar.
- (void)buttonAction
{
    //fixed: presss takephoto button again,the page can not init
    TakePhotoViewController *picker = [[[TakePhotoViewController alloc] init] autorelease];
    UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:picker] autorelease];
    [picker.navigationController setNavigationBarHidden:YES];
    [self.tabBarController presentModalViewController:nav animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}


@end

