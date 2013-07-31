//
//  BabyPostViewController.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-30.
//
//
#define Time  0.25
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define KEYBOARDHEIGHT 216
#define TOOLBARHEIGHT 44
#define choiceBarHeight 35
#define  facialViewWidth 300
#define facialViewHeight 170
#define  BUTTONWH 34
#import <UIKit/UIKit.h>
#import "BabyPlaceHolderTextView.h"
#import "BabyAtTableViewController.h"
#import "BabyPositionViewController.h"
#import "TakePhotoViewController.h"

@interface BabyPostViewController : UIViewController<UIScrollViewDelegate,BabyAtTableViewControllerDelegate,BabyPositionViewControllerDelegate,UIGestureRecognizerDelegate,UINavigationBarDelegate,AFPhotoEditorControllerDelegate>
{
    BabyPlaceHolderTextView *textView;
    UIToolbar *toolBar;//工具栏
    UIButton *btnFirstTime;
    UIButton *btnAtSomeOne;
    UIButton *btnLocation;
    UIButton *btnSend;
    BOOL keyboardIsShow;//键盘是否显示
    UIScrollView *scrollView;//第一次表情滚动视图
    UIPageControl *pageControl;
    UIImageView   *postImages;
    UIImageView   *iconMark;
    
}

@property (nonatomic, retain) BabyPlaceHolderTextView *textView;
@property (nonatomic, retain) UIToolbar               *toolBar;
@property (nonatomic, retain) NSDate                  *date;
@property (nonatomic, retain) UIButton                *btnDatePicker;

-(void)keyboardChanged:(NSNotification*)notification;
-(id)initWithImage:(UIImage*)image;


@end
