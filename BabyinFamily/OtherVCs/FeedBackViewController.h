//
//  FeedBackViewController.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-2-4.
//
//

#import <UIKit/UIKit.h>

@class WeiBoMessageManager;


@interface FeedBackViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    WeiBoMessageManager *manager;
    BOOL _shouldPostImage;

}
@property (retain, nonatomic) IBOutlet UIScrollView *theScrollView;
@property (retain, nonatomic) IBOutlet UIImageView *theImageView;
@property (retain, nonatomic) IBOutlet UIImageView *TVBackView;

@property (retain, nonatomic) IBOutlet UILabel *countLabel;
@property (retain, nonatomic) IBOutlet UITextView *theTextView;
@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UIButton *photoButton;

@property (nonatomic,retain) NSString *weiboID;
@property (nonatomic,retain) NSString *commentID;
@property (nonatomic,retain) NSString *ios;
@property (nonatomic,retain) NSString *iosVision;
@property (nonatomic,retain) NSString *platform;
@property (nonatomic,retain) NSString *APPVision;

@end
