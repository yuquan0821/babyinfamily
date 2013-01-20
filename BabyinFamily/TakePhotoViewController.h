//
//  TakePhotoViewController.h
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//


#import <Foundation/Foundation.h>
#import "GPUImage.h"
#import "AFPhotoEditorController.h"


@class TakePhotoViewController;

@protocol TakePhotoViewControllerDelegate <NSObject>
@optional
- (void)imagePickerController:(TakePhotoViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(TakePhotoViewController *)picker;

@end

@interface TakePhotoViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,AFPhotoEditorControllerDelegate>
{
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageOutput<GPUImageInput> *blurFilter;
    GPUImageCropFilter *cropFilter;
    GPUImagePicture *staticPicture;
    UIImageOrientation staticPictureOriginalOrientation;
    
}

@property (retain, nonatomic) IBOutlet GPUImageView *imageView;
@property (retain, nonatomic) id <TakePhotoViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *photoCaptureButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;

@property (retain, nonatomic) IBOutlet UIButton *cameraToggleButton;
@property (retain, nonatomic) IBOutlet UIButton *blurToggleButton;
@property (retain, nonatomic) IBOutlet UIButton *libraryToggleButton;
@property (retain, nonatomic) IBOutlet UIButton *flashToggleButton;
@property (retain, nonatomic) IBOutlet UIButton *retakeButton;

@property (retain, nonatomic) IBOutlet UIScrollView *filterScrollView;
@property (retain, nonatomic) IBOutlet UIImageView *filtersBackgroundImageView;
@property (retain, nonatomic) IBOutlet UIView *photoBar;
@property (retain, nonatomic) IBOutlet UIView *topBar;

@property (nonatomic, assign) CGFloat outputJPEGQuality;

@end
