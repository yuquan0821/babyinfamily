     //
//  CustomTabbarViewControllertomTabbarViewController.h
//  Yunho2
//
//  Created by l on 13-6-4.
//
//


#import <UIKit/UIKit.h>



#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)
#define addHeight 88


@protocol tabbarDelegate <NSObject>

-(void)touchBtnAtIndex:(NSInteger)index;

@end

@class CustomTabbarView;

@interface CustomTabbarViewController : UIViewController<tabbarDelegate>

@property(nonatomic,retain) CustomTabbarView *tabbar;
@property(nonatomic,retain) NSArray *arrayViewcontrollers;
@property(nonatomic,retain) NSArray *arrayBarButtons;

-(void)removeBar;
- (void)hideTabBar:(BOOL)hidden;
-(void)touchBtnAtIndex:(NSInteger)index;
@end
