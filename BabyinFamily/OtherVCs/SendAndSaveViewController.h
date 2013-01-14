//
//  SendAndSaveViewController.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-1-9.
//
//

#import <UIKit/UIKit.h>
@class WeiBoMessageManager;

@interface SendAndSaveViewController : UIViewController<UIImagePickerControllerDelegate>
{
    WeiBoMessageManager *manager;
    BOOL _shouldPostImage;
}
@property (retain, nonatomic) IBOutlet UIButton *saveImageButton;
@property (retain, nonatomic) IBOutlet UIButton *sendImageButton;
@property (retain, nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (retain, nonatomic) IBOutlet UIImageView *mainImageView;
-(id)initWithImage:(UIImage*)image;

@end
