//
//  CustomNavViewController.h
//  Yunho2
//
//  Created by l on 13-6-4.
//
//

#import <UIKit/UIKit.h>
#import "CustomTabbarViewController.h"
@interface CustomNavViewController : UINavigationController
@property (retain,nonatomic) NSMutableArray *flagArray;
@property (retain,nonatomic) CustomTabbarViewController *tabbarViewController;
@property (nonatomic,assign) BOOL canDragBack;

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated tabbarHidden:(BOOL)hidden;
-(void)popToRootViewControllerAnimated:(BOOL)animated;
-(void)popViewControllerAnimated:(BOOL)animated;
@end

