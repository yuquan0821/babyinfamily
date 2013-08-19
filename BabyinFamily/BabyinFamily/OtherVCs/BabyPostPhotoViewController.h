//
//  BabyPostPhotoViewController.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-8-1.
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
#import "TakePhotoViewController.h"
#import "AFPhotoEditorController.h"
@class WeiBoMessageManager;
@protocol BabyPostPhotoViewControllerDelegate<NSObject, UINavigationBarDelegate>
- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image;
@end

@interface BabyPostPhotoViewController : UIViewController
<UIScrollViewDelegate,BabyAtTableViewControllerDelegate,BabyPositionViewControllerDelegate,UIGestureRecognizerDelegate,UINavigationBarDelegate,AFPhotoEditorControllerDelegate,UITextViewDelegate>
{
    BabyPlaceHolderTextView *textView;
    WeiBoMessageManager     *manager;
    BOOL           _shouldPostImage;
    UIToolbar     *toolBar;//工具栏
    UIButton      *btnFirstTime;
    UIButton      *btnAtSomeOne;
    UIButton      *btnLocation;
    UIButton      *btnSend;
    BOOL          keyboardIsShow;//键盘是否显示
    UIScrollView  *scrollView;//第一次表情滚动视图
    UIPageControl *pageControl;
    UIImageView   *postImages;
    UIImageView   *iconMark;
    UILabel       *titleLabel;    
}

@property (nonatomic, retain) BabyPlaceHolderTextView *textView;
@property (nonatomic, retain) UIToolbar               *toolBar;
@property (nonatomic, retain) NSDate                  *date;
@property (nonatomic, retain) UIButton                *btnDatePicker;
@property (nonatomic, assign) id<BabyPostPhotoViewControllerDelegate> delegate;
@property (nonatomic, retain) UILabel                  *countLabel;

-(id)initWithImage:(UIImage*)image;

@end
