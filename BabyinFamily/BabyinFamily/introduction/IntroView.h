#import <UIKit/UIKit.h>
#import "IntroModel.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

@interface IntroView : UIView
- (id)initWithFrame:(CGRect)frame model:(IntroModel*)model;
@end
