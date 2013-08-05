//
//  BabyFeedBackViewController.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-30.
//
//

#import "BabyFeedBackViewController.h"
#import "WeiBoMessageManager.h"
#import "Status.h"
#import "UIDeviceHardware.h"
#import <QuartzCore/QuartzCore.h>



@interface BabyFeedBackViewController ()

@end

@implementation BabyFeedBackViewController
@synthesize countLabel;
@synthesize theTextView;
@synthesize weiboID;
@synthesize ios;
@synthesize iosVision;
@synthesize platform;
@synthesize APPVision;
@synthesize toolBar;


#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _shouldPostImage = NO;
        manager = [WeiBoMessageManager getInstance];
    }
    return self;
}


- (void)dealloc {
    [weiboID release];
    [theTextView release];
    [countLabel release];
    [ios release];
    [iosVision release];
    [platform release];
    [APPVision release];
    [toolBar release];
    [super dealloc];
}

-(void)postImagesAnimation
{
    CGRect frame = theTextView.frame;
    frame.size.width = 196;
    [UIView animateWithDuration:0.5 animations:^{
        postImages.hidden = NO;
        postImages.frame = CGRectMake(212, 32, 100, 80);
        postImages.alpha = 1.0;
        theTextView.frame = frame;
    }  completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            iconMark.hidden = NO;
            iconMark.frame = CGRectMake(72, -8, 26, 20);
            postImages.transform = CGAffineTransformRotate(CGAffineTransformMakeRotation(0), -M_PI/30.0);
            iconMark.transform = CGAffineTransformMakeRotation(M_PI/20);
        }];
    }];
}
-(void)postImagesRemoveAnimation{
    CGRect frame = theTextView.frame;
    frame.size.width = 300;
    [UIView animateWithDuration:0.25 animations:^{
        iconMark.transform = CGAffineTransformMakeRotation(0);
        iconMark.frame = CGRectMake(50, -60, 26, 20);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            iconMark.hidden = YES;
            postImages.transform = CGAffineTransformMakeRotation(0);
            postImages.frame = CGRectMake(400, 300, 0, 0);
            theTextView.frame = frame;
        }completion:^(BOOL finished){
            postImages.hidden = YES;
        }];
    }];
}

-(void)removeImages:(id)sender
{
    [self postImagesRemoveAnimation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    theTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 6, 320, 115)];
    theTextView.scrollEnabled = YES;
    //theTextView.backgroundColor = [UIColor clearColor];
    theTextView.font = [UIFont systemFontOfSize:13.0f];
    theTextView.delegate = self;
    //发送图片
    iconMark  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainFaceIconMark"]];
    iconMark.frame = CGRectMake(50, -12, 26, 20);
    iconMark.hidden = YES;
    iconMark.userInteractionEnabled = YES;
    
    postImages = [[UIImageView alloc]initWithFrame:CGRectMake(400, 300, 0, 0)];
    postImages.hidden = YES;
    postImages.backgroundColor = [UIColor blackColor];
    [postImages.layer setBorderColor:[UIColor clearColor].CGColor];
    [postImages.layer setBorderWidth:2.0];
    [postImages.layer setShadowColor:[UIColor blackColor].CGColor];
    [postImages.layer setShadowOffset:CGSizeMake(1, 2)];
    [postImages.layer setShadowOpacity:0.8];
    [postImages.layer setShadowRadius:2.0];
    postImages.layer.shouldRasterize = YES;
    
    [postImages addSubview:iconMark];
    postImages.image = [UIImage imageNamed:@"testimg.jpg"];
    //删除图片
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeImages:)];
    tapRecognizer.delegate = self;
    postImages.userInteractionEnabled = YES;
    [iconMark addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    
    self.ios = [[UIDevice currentDevice] systemName];
    self.iosVision = [[[UIDevice currentDevice] systemVersion] stringByAppendingString:@" "];
    self.platform = [[[[[UIDeviceHardware alloc] init] platform] stringByAppendingString:@" " ] stringByAppendingString:[[self.ios stringByAppendingString:@" "] stringByAppendingString:self.iosVision]];
    self.APPVision = [@" 版本:" stringByAppendingString: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    self.theTextView.text = [[[@"#家贝反馈# @家贝2013 " stringByAppendingString: self.APPVision ] stringByAppendingString:@" " ]stringByAppendingString:self.platform];
    countLabel.text = [NSString stringWithFormat:@"%d",140 - theTextView.text.length];
    //添加toolBar
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,self.view.bounds.size.height - TOOLBARHEIGHT - KEYBOARDHEIGHT,self.view.bounds.size.width,TOOLBARHEIGHT)];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    UIEdgeInsets insets = UIEdgeInsetsMake(40, 0, 40, 0);
    [toolBar setBackgroundImage:[[UIImage imageNamed:@"keyBoardBack"] resizableImageWithCapInsets:insets] forToolbarPosition:0 barMetrics:0];
    [toolBar setBarStyle:UIBarStyleBlack];
    
    //照片
    btnPicture = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPicture.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    [btnPicture setBackgroundImage:[UIImage imageNamed:@"Voice"] forState:UIControlStateNormal];
    [btnPicture addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    btnPicture.frame = CGRectMake(5,toolBar.bounds.size.height-38.0f,BUTTONWH + 50,BUTTONWH);
    btnPicture.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btnPicture setTitle:@"图片" forState:UIControlStateNormal];
    [toolBar addSubview:btnPicture];
    
    //发送按钮
    btnSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnSend.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    btnSend.enabled=YES;
    [btnSend addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    btnSend.frame = CGRectMake(270,toolBar.bounds.size.height-38.0f,BUTTONWH + 5,BUTTONWH);
    btnSend.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [toolBar addSubview:btnSend];
    [self.view addSubview:postImages];
    [self.view bringSubviewToFront:postImages];
    [self.view addSubview:toolBar];
    [self.view addSubview:theTextView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [theTextView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPost:) name:MMSinaGotPostResult object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setTheTextView:nil];
    [self setCountLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Tool Methods

- (void)send:(id)sender
{
    NSString *content = theTextView.text;
    UIImage *image = postImages.image;
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        if (content != nil && [content length] != 0)
        {
            if (!_shouldPostImage) {
                [manager postWithText:content];
            }
            else {
                [manager postWithText:content image:image];
            }
        }
    }
}


#pragma mark -

#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    // Get KeyBoard CGRect.
    NSDictionary *info = [notification userInfo];
    NSValue *keyValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [keyValue CGRectValue].size;
    
    // New toolBar position.
    NSInteger toolBarY = self.view.frame.size.height - keyboardSize.height - toolBar.frame.size.height;
    
    NSLog(@"toolBarY: %d", toolBarY);
    
    // Set new position to textView.
    theTextView.frame = CGRectMake(0, 0, theTextView.frame.size.width, toolBarY );
    
    countLabel.frame = CGRectMake(200, toolBarY - 25, 100, 20);
    
    // Set new position to toolBar.
    toolBar.frame = CGRectMake(0, toolBarY, toolBar.frame.size.width, toolBar.frame.size.height);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    
}

-(void)didPost:(NSNotification*)sender
{
    Status *sts = sender.object;
    if (sts.text != nil && [sts.text length] != 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    postImages.image = image;
    [picker dismissModalViewControllerAnimated:NO];
    [self postImagesAnimation];
}


- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //取消按钮
    if (buttonIndex == 2) {
        if (postImages.hidden == NO) {
            [self postImagesAnimation];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //调用
    UIImagePickerController *imagesPicker =  [[UIImagePickerController alloc]init];
    imagesPicker.delegate = self;
    imagesPicker.allowsEditing = NO;
    
    switch (buttonIndex) {
        case 0:
        {
            //调用系统相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                imagesPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSLog(@"UIImagePickerControllerSourceTypePhotoLibrary Clicked");
                [self presentModalViewController:imagesPicker animated:NO];
                [imagesPicker release];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"访问图片库错误"
                                      message:@""
                                      delegate:nil
                                      cancelButtonTitle:@"OK!"
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
            
            break;
        case 1:
        {
            //调用系统相机
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                imagesPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                NSLog(@"UIImagePickerControllerSourceTypeCamera Clicked");
                [self presentModalViewController:imagesPicker animated:NO];
                [imagesPicker release];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"访问相机错误"
                                      message:@""
                                      delegate:nil
                                      cancelButtonTitle:@"OK!"
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            
        }
            break;
        default:
            break;
    }
    
    
}
-(void)btnClicked
{
    CGRect frame = theTextView.frame;
    frame.size.width = 300;
    [UIView animateWithDuration:0.25 animations:^{
        iconMark.transform = CGAffineTransformMakeRotation(0);
        iconMark.frame = CGRectMake(50, -60, 26, 20);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            iconMark.hidden = YES;
            postImages.transform = CGAffineTransformMakeRotation(0);
            postImages.frame = CGRectMake(400, 300, 0, 0);
            theTextView.frame = frame;
        }];
    }];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"系统相册" otherButtonTitles:@"相机", nil];
    actionSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:NO];
}


#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        btnSend.enabled = NO;
    }
    else {
        btnSend.enabled = YES;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *temp = textView.text;
    if (temp.length != 0) {
        btnSend.enabled = YES;
    }
    else {
        btnSend.enabled = NO;
    }
    
    if (temp.length > 140) {
        textView.text = [temp substringToIndex:140];
    }
    countLabel.text = [NSString stringWithFormat:@"%d",140 - theTextView.text.length];
}


@end