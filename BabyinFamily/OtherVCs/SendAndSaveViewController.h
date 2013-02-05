//
//  SendAndSaveViewController.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-1-9.
//
//

#import <UIKit/UIKit.h>
#import "AFPhotoEditorController.h"
@class WeiBoMessageManager;
@protocol SendAndSaveViewControllerDelegate <NSObject, UINavigationBarDelegate>

- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image;

@end

@interface SendAndSaveViewController : UIViewController<UIImagePickerControllerDelegate>
{
    WeiBoMessageManager *manager;
    BOOL _shouldPostImage;
}
@property (retain, nonatomic) IBOutlet UIButton *saveImageButton;
@property (retain, nonatomic) IBOutlet UIButton *sendImageButton;
@property (retain, nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (retain, nonatomic) IBOutlet UIImageView *mainImageView;
@property (nonatomic,assign) id<SendAndSaveViewControllerDelegate> delegate;

-(id)initWithImage:(UIImage*)image;

@end
