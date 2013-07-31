//
//  TakePhotoViewController.m
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//

#import "TakePhotoViewController.h"
#import "SendAndSaveViewController.h"

@implementation TakePhotoViewController {
    BOOL isStatic;
    BOOL hasBlur;
    int selectedFilter;
}

@synthesize delegate;
@synthesize imageView;
@synthesize cameraToggleButton;
@synthesize photoCaptureButton;
@synthesize flashToggleButton;
@synthesize cancelButton;
@synthesize retakeButton;
@synthesize libraryToggleButton;
@synthesize photoBar;
@synthesize topBar;
@synthesize outputJPEGQuality;
@synthesize blurOverlayView;

-(id) init {
    self = [super initWithNibName:@"TakePhotoViewController" bundle:nil];
    
    if (self) {
        self.outputJPEGQuality = 1.0;
        self.title = @"拍照";
        NSString *fullpath = [NSString stringWithFormat:@"sourcekit.bundle/image/%@", @"tabbar_camera"];
        self.tabBarItem.image = [UIImage imageNamed:fullpath];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
	[[GPUImageView alloc] initWithFrame:mainScreenFrame];
    self.wantsFullScreenLayout = YES;
    //set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:
                                 [UIImage imageNamed:@"TakePhoto.bundle/UI/micro_carbon"]];
    
    self.photoBar.backgroundColor = [UIColor colorWithPatternImage:
                                     [UIImage imageNamed:@"TakePhoto.bundle/UI/photo_bar"]];
    
    self.topBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TakePhoto.bundle/UI/photo_bar"]];
    //button states
    
    staticPictureOriginalOrientation = UIImageOrientationUp;
    //we need a crop filter for the live video
    cropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
    filter = [[GPUImageRGBFilter alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self setUpCamera];
    });    
}

-(void) viewWillAppear:(BOOL)animated {
   // [stillCamera stopCameraCapture];
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];

}

-(void) setUpCamera {
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        // Has camera
        
        stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
        
        stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        runOnMainQueueWithoutDeadlocking(^{
            [stillCamera startCameraCapture];
            if([stillCamera.inputCamera hasTorch]){
                [self.flashToggleButton setEnabled:YES];
            }else{
                [self.flashToggleButton setEnabled:NO];
            }
            [self prepareFilter];
        });
    } else {
        // No camera
        NSLog(@"No camera");
        runOnMainQueueWithoutDeadlocking(^{
            [self prepareFilter];
        });
    }
    
}



-(void) prepareFilter {
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        isStatic = YES;
    }
    
    if (!isStatic) {
        [self prepareLiveFilter];
    } else {
        [self prepareStaticFilter];
    }
}

-(void) prepareLiveFilter {
    
    [stillCamera addTarget:cropFilter];
    [cropFilter addTarget:filter];
    //blur is terminal filter
    if (hasBlur) {
        [filter addTarget:blurFilter];
        [blurFilter addTarget:self.imageView];
        //regular filter is terminal
    } else {
        [filter addTarget:self.imageView];
    }
    
    [filter prepareForImageCapture];
    
}

-(void) prepareStaticFilter {
    
    if (!staticPicture) {
        // TODO: fix this hack
        //这个地方不可理，不应该指定死延时时间,在内存紧张的情况下，容易发生崩溃,原因是多个presend动作同时执行了
        //可以考虑其它的方式
        [self performSelector:@selector(switchToLibrary:) withObject:nil afterDelay:0.5];
    }
    
    [staticPicture addTarget:filter];
    
    // blur is terminal filter
    if (hasBlur) {
        [filter addTarget:blurFilter];
        [blurFilter addTarget:self.imageView];
        //regular filter is terminal
    } else {
        [filter addTarget:self.imageView];
    }
    
    GPUImageRotationMode imageViewRotationMode = kGPUImageNoRotation;
    switch (staticPictureOriginalOrientation) {
        case UIImageOrientationLeft:
            imageViewRotationMode = kGPUImageRotateLeft;
            break;
        case UIImageOrientationRight:
            imageViewRotationMode = kGPUImageRotateRight;
            break;
        case UIImageOrientationDown:
            imageViewRotationMode = kGPUImageRotate180;
            break;
        default:
            imageViewRotationMode = kGPUImageNoRotation;
            break;
    }
    
    // seems like atIndex is ignored by GPUImageView...
    [self.imageView setInputRotation:imageViewRotationMode atIndex:0];
    
    
    [staticPicture processImage];
}

-(void) removeAllTargets {
    [stillCamera removeAllTargets];
    [staticPicture removeAllTargets];
    [cropFilter removeAllTargets];
    
    //regular filter
    [filter removeAllTargets];
    
    //blur
    [blurFilter removeAllTargets];
}

-(IBAction)switchToLibrary:(id)sender {
    
    if (!isStatic) {
        // shut down camera
        [stillCamera stopCameraCapture];
        [self removeAllTargets];
    }
    
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

-(IBAction)toggleFlash:(UIButton *)button{
    
    [button setSelected:!button.selected];
}


-(IBAction) switchCamera {
    [self.cameraToggleButton setEnabled:NO];
    [stillCamera rotateCamera];
    [self.cameraToggleButton setEnabled:YES];
    self.flashToggleButton.hidden = NO;

    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] && stillCamera) {
        if ([stillCamera.inputCamera hasFlash] && [stillCamera.inputCamera hasTorch]) {
            [self.flashToggleButton setEnabled:YES];
        } else {
            //[self.flashToggleButton setEnabled:NO];
            self.flashToggleButton.hidden = YES;
        }
    }
}


-(void) prepareForCapture {
    [stillCamera.inputCamera lockForConfiguration:nil];
    if(self.flashToggleButton.selected &&
       [stillCamera.inputCamera hasTorch]){
        [stillCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
        [self performSelector:@selector(captureImage)
                   withObject:nil
                   afterDelay:0.25];
    }else{
        [self captureImage];
    }
}


-(void)captureImage {
    UIImage *img = [cropFilter imageFromCurrentlyProcessedOutput];
    [stillCamera.inputCamera unlockForConfiguration];
    [stillCamera stopCameraCapture];
    [self removeAllTargets];
    [self displayEditorForImage:img];
    
    staticPicture = [[GPUImagePicture alloc] initWithImage:img
                                       smoothlyScaleOutput:YES];
    
    staticPictureOriginalOrientation = img.imageOrientation;
    
    [self prepareFilter];
    [self.retakeButton setHidden:NO];
    [self.photoCaptureButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.photoCaptureButton setImage:nil forState:UIControlStateNormal];
    [self.photoCaptureButton setEnabled:YES];
    
}


-(IBAction) takePhoto:(id)sender{
    [self.photoCaptureButton setEnabled:NO];
    
    if (!isStatic) {
        isStatic = YES;
        
        [self.libraryToggleButton setHidden:YES];
        [self.cameraToggleButton setEnabled:NO];
        [self.flashToggleButton setEnabled:NO];
        [self prepareForCapture];
        
    } else {
        
        GPUImageOutput<GPUImageInput> *processUpTo;
        
        if (hasBlur) {
            processUpTo = blurFilter;
        } else {
            processUpTo = filter;
        }
        
        [staticPicture processImage];
        
        UIImage *currentFilteredVideoFrame = [processUpTo imageFromCurrentlyProcessedOutputWithOrientation:staticPictureOriginalOrientation];
        
        NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:
                              UIImageJPEGRepresentation(currentFilteredVideoFrame, self.outputJPEGQuality), @"data", nil];
        [self.delegate imagePickerController:self didFinishPickingMediaWithInfo:info];
    }
}

-(IBAction) retakePhoto:(UIButton *)button {
    [self.retakeButton setHidden:YES];
    [self.libraryToggleButton setHidden:NO];
    staticPicture = nil;
    staticPictureOriginalOrientation = UIImageOrientationUp;
    isStatic = NO;
    [self removeAllTargets];
    [stillCamera startCameraCapture];
    [self.cameraToggleButton setEnabled:YES];
    
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]
       && stillCamera
       && [stillCamera.inputCamera hasTorch]) {
        [self.flashToggleButton setEnabled:YES];
    }
    
    [self.photoCaptureButton setImage:[UIImage imageNamed:@"TakePhoto.bundle/UI/camera-icon"] forState:UIControlStateNormal];
    [self.photoCaptureButton setTitle:nil forState:UIControlStateNormal];
    
    [self setFilter:selectedFilter];
    [self prepareFilter];
}

-(IBAction) cancel:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];

    self.tabBarController.tabBar.hidden = NO;
    [self dismissModalViewControllerAnimated:NO];
}

-(IBAction) handlePan:(UIGestureRecognizer *) sender
{
    if (hasBlur) {
        CGPoint tapPoint = [sender locationInView:imageView];
        GPUImageGaussianSelectiveBlurFilter* gpu =
        (GPUImageGaussianSelectiveBlurFilter*)blurFilter;
        
        if ([sender state] == UIGestureRecognizerStateBegan) {
            //NSLog(@"Start tap");
            [self showBlurOverlay:YES];
            [gpu setBlurSize:0.0f];
            if (isStatic) {
                [staticPicture processImage];
            }
        }
        
        if ([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged) {
            //NSLog(@"Moving tap");
            [gpu setBlurSize:0.0f];
            [self.blurOverlayView setCircleCenter:tapPoint];
            [gpu setExcludeCirclePoint:CGPointMake(tapPoint.x/320.0f, tapPoint.y/320.0f)];
        }
        
        if([sender state] == UIGestureRecognizerStateEnded){
            //NSLog(@"Done tap");
            [gpu setBlurSize:2.0f];
            [self showBlurOverlay:NO];
            if (isStatic) {
                [staticPicture processImage];
            }
        }
    }
}

-(IBAction) handlePinch:(UIPinchGestureRecognizer *) sender
{
    if (hasBlur) {
        CGPoint midpoint = [sender locationInView:imageView];
        GPUImageGaussianSelectiveBlurFilter* gpu =
        (GPUImageGaussianSelectiveBlurFilter*)blurFilter;
        
        if ([sender state] == UIGestureRecognizerStateBegan) {
            //NSLog(@"Start tap");
            [self showBlurOverlay:YES];
            [gpu setBlurSize:0.0f];
            if (isStatic) {
                [staticPicture processImage];
            }
        }
        
        if ([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged) {
            [gpu setBlurSize:0.0f];
            [gpu setExcludeCirclePoint:CGPointMake(midpoint.x/320.0f, midpoint.y/320.0f)];
            self.blurOverlayView.circleCenter = CGPointMake(midpoint.x, midpoint.y);
            CGFloat radius = MAX(MIN(sender.scale*[gpu excludeCircleRadius], 0.6f), 0.15f);
            self.blurOverlayView.radius = radius*320.f;
            [gpu setExcludeCircleRadius:radius];
            sender.scale = 1.0f;
        }
        
        if ([sender state] == UIGestureRecognizerStateEnded) {
            [gpu setBlurSize:2.0f];
            [self showBlurOverlay:NO];
            if (isStatic) {
                [staticPicture processImage];
            }
        }
    }
}

-(void) showBlurOverlay:(BOOL)show{
    if(show){
        [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
            self.blurOverlayView.alpha = 0.6;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.35 delay:0.2 options:0 animations:^{
            self.blurOverlayView.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
}


-(void) flashBlurOverlay {
    [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
        self.blurOverlayView.alpha = 0.6;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 delay:0.2 options:0 animations:^{
            self.blurOverlayView.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

-(void) dealloc {
    [self removeAllTargets];
    stillCamera = nil;
    cropFilter = nil;
    filter = nil;
    blurFilter = nil;
    staticPicture = nil;
    self.blurOverlayView = nil;
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated {
    [stillCamera stopCameraCapture];
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];

}
#pragma mark AFPhotoEditorControllerDelegate
- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    if (image != nil) {
        SendAndSaveViewController* viewController = [[SendAndSaveViewController alloc] initWithImage:image];
       [self.navigationController pushViewController:viewController animated:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        [viewController release];
    }
    //关闭图像选择器
    [self dismissModalViewControllerAnimated:NO];
}
- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    // Handle cancelation here
    [self dismissModalViewControllerAnimated:YES];
    [self retakePhoto:nil];

}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
   
#if 0
    [self dismissModalViewControllerAnimated:NO];
    //UIImage *image = [UIImage imageNamed:@"Default.png"];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSelector:@selector(displayEditorForImage:) withObject:image afterDelay:0.5];
#else
    [self dismissModalViewControllerAnimated:NO];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self displayEditorForImage:image];
#endif
}

- (void)displayEditorForImage:(UIImage *)imageToEdit
{
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:imageToEdit];
    [editorController setDelegate:self];
    [self presentViewController:editorController animated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (isStatic) {
        // TODO: fix this hack
        [self dismissModalViewControllerAnimated:NO];
        [self.delegate imagePickerControllerDidCancel:self];
    } else {
        [self dismissModalViewControllerAnimated:YES];
        [self retakePhoto:nil];
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#endif

@end
