//
//  BabyHelper.h
//  BabyinFamily
//
//  Created by 范艳春 on 12-12-17.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "User.h"
@class BabyHelper;
#define kTextViewPadding            16.0
#define kLineBreakMode              UILineBreakModeWordWrap

@interface BabyHelper : NSObject
{
    
}
@property (nonatomic,retain)User *user;

+(BabyHelper*)getInstance;

+ (NSString *) regularStringFromSearchString:(NSString *)string;


//大小变化动画
+ (CAAnimation *)animationWithScaleFrom:(CGFloat) from To:(CGFloat) to Duration:(CGFloat) duration BeginTime:(CGFloat)beginTime;

//位置变化动画
+ (CAAnimation *)animationMoveFrom:(CGPoint) from To:(CGPoint) to Duration:(CGFloat) duration BeginTime:(CGFloat)beginTime;

//透明度变化动画
+ (CAAnimation *)animationWithOpacityFrom:(CGFloat) from To:(CGFloat) to Duration:(CGFloat) duration BeginTime:(CGFloat)beginTime;


+(CGFloat)getTextViewHeight:(NSString*)contentText with:(CGFloat)with sizeOfFont:(CGFloat)fontSize addtion:(CGFloat)add;


@end
