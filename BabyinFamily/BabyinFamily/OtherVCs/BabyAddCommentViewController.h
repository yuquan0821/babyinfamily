//
//  BabyAddCommentViewController.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-8-3.
//
//

#define Time  0.25
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define KEYBOARDHEIGHT 216
#define TOOLBARHEIGHT 44
#define  BUTTONWH 34
#import <UIKit/UIKit.h>
#import "BabyPlaceHolderTextView.h"
#import "BabyAtTableViewController.h"
#import "BabyPositionViewController.h"
#import "Status.h"

@class WeiBoMessageManager;

@interface BabyAddCommentViewController : UIViewController<UIScrollViewDelegate,BabyAtTableViewControllerDelegate,BabyPositionViewControllerDelegate,UIGestureRecognizerDelegate,UINavigationBarDelegate,UITextViewDelegate>
{
    BabyPlaceHolderTextView *textView;
    WeiBoMessageManager *manager;
    UIToolbar *toolBar;//工具栏
    UIButton *btnFirstTime;
    UIButton *btnAtSomeOne;
    UIButton *btnLocation;
    UIButton *btnSend;
    BOOL keyboardIsShow;//键盘是否显示
    UIScrollView *scrollView;//第一次表情滚动视图
    UIPageControl *pageControl;
    
}

@property (nonatomic, retain) BabyPlaceHolderTextView *textView;
@property (nonatomic, retain) UIToolbar               *toolBar;
@property (nonatomic, retain) Status                  *status;


@end

