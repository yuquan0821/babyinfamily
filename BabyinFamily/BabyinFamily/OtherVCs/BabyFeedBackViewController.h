//
//  BabyFeedBackViewController.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-30.
//
//

#define KEYBOARDHEIGHT 216
#define TOOLBARHEIGHT 44
#define BUTTONWH 34
#import <UIKit/UIKit.h>
@class WeiBoMessageManager;

@interface BabyFeedBackViewController :UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>
{
    WeiBoMessageManager *manager;
    BOOL _shouldPostImage;
    UIButton *btnPicture;
    UIButton *btnSend;
    UIImageView *postImages;
    UIImageView * iconMark;
    
    
}
@property (retain, nonatomic) UILabel *countLabel;
@property (retain, nonatomic) UITextView *theTextView;
@property (nonatomic,retain) NSString *weiboID;
@property (nonatomic,retain) NSString *ios;
@property (nonatomic,retain) NSString *iosVision;
@property (nonatomic,retain) NSString *platform;
@property (nonatomic,retain) NSString *APPVision;
@property (nonatomic,retain) UIToolbar*toolBar;


@end
