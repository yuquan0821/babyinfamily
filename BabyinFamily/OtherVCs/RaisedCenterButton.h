//
//  RaisedCenterButton.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-1-30.
//
//

#import <UIKit/UIKit.h>

@interface RaisedCenterButton : UIButton

@property (copy, nonatomic) UIImage *buttonImage;

+ (id)buttonWithImage:(UIImage *)image forTabBarController:(UITabBarController *)tabBarController;

@end
