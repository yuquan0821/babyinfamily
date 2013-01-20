//
//  UIView+BabyFullScreenScroll.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-1-8.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// original source from Three20 UIView(TTCategory)
@interface UIView (BabyFullScreenScroll)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;

@end
