//
//  FeedBackViewController.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-2-4.
//
//

#import "FeedBackViewController.h"
#import "WeiBoMessageManager.h"
#import "Status.h"
#import "UIDeviceHardware.h"
@interface FeedBackViewController ()

@end

@implementation FeedBackViewController
@synthesize theScrollView;
@synthesize theImageView;
@synthesize TVBackView;
@synthesize countLabel;
@synthesize theTextView;
@synthesize mainView;
@synthesize photoButton;
@synthesize weiboID;
@synthesize commentID;
@synthesize ios;
@synthesize iosVision;
@synthesize platform;
@synthesize APPVision;


#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"FeedBackViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _shouldPostImage = NO;
        manager = [WeiBoMessageManager getInstance];
    }
    return self;
}


- (void)dealloc {
    [commentID release];
    [weiboID release];
    [theScrollView release];
    [theImageView release];
    [theTextView release];
    [TVBackView release];
    [mainView release];
    [countLabel release];
    [photoButton release];
    [ios release];
    [iosVision release];
    [platform release];
    [APPVision release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *retwitterBtn = [[UIBarButtonItem alloc]initWithTitle:@"发送"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(send:)];
    self.navigationItem.rightBarButtonItem = retwitterBtn;
    [retwitterBtn release];
    
    theScrollView.contentSize = CGSizeMake(320, 410);
    theTextView.delegate = self;
    self.ios = [[UIDevice currentDevice] systemName];
    self.iosVision = [[[UIDevice currentDevice] systemVersion] stringByAppendingString:@" "];
    self.platform = [[[[[UIDeviceHardware alloc] init] platform] stringByAppendingString:@" " ] stringByAppendingString:[[self.ios stringByAppendingString:@" "] stringByAppendingString:self.iosVision]];
    self.APPVision = [@" 版本:" stringByAppendingString: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    self.theTextView.text = [[[@"#家贝反馈# @fanyanchun " stringByAppendingString: self.APPVision ] stringByAppendingString:@" " ]stringByAppendingString:self.platform];
    countLabel.text = [NSString stringWithFormat:@"%d",140 - theTextView.text.length];
    TVBackView.image = [[UIImage imageNamed:@"weibo.bundle/WeiboImages/input_window.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:15];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [theTextView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPost:) name:MMSinaGotPostResult object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPost:) name:MMSinaGotRepost object:nil];
    
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setTheScrollView:nil];
    [self setTheImageView:nil];
    [self setTheTextView:nil];
    [self setTVBackView:nil];
    [self setMainView:nil];
    [self setCountLabel:nil];
    [self setPhotoButton:nil];
    [super viewDidUnload];
}

#pragma mark - Tool Methods
- (void)addPhoto
{
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.navigationBar.tintColor = [UIColor colorWithRed:72.0/255.0 green:106.0/255.0 blue:154.0/255.0 alpha:1.0];
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = NO;
	[self presentModalViewController:imagePickerController animated:NO];
	[imagePickerController release];
}

- (void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"该设备不支持拍照功能"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"好", nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        [self presentModalViewController:imagePickerController animated:NO];
        [imagePickerController release];
    }
}

-(IBAction)addImageAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"插入图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"系统相册",@"拍摄", nil];
    [alert show];
    [alert release];
}

- (void)send:(id)sender
{
    NSString *content = theTextView.text;
    UIImage *image = theImageView.image;
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
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (keyboardRect.size.height == 252)
    {
        CGRect frame = mainView.frame;
        frame.size.height = 165;
        mainView.frame = frame;
    }
    else if(keyboardRect.size.height == 216)
    {
        CGRect frame = mainView.frame;
        frame.size.height = 165 + 36;
        mainView.frame = frame;
    }
    [UIView commitAnimations];
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.theImageView.image = image;
    _shouldPostImage = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:NO];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index = %d",buttonIndex);
    if (buttonIndex == 1)
    {
        [self addPhoto];
    }
    else if(buttonIndex == 2)
    {
        [self takePhoto];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *temp = textView.text;
    if (temp.length != 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    if (temp.length > 140) {
        textView.text = [temp substringToIndex:140];
    }
    countLabel.text = [NSString stringWithFormat:@"%d",140 - theTextView.text.length];
}


-(void)atTableViewControllerCellDidClickedWithScreenName:(NSString*)name
{
    theTextView.text = [theTextView.text stringByAppendingFormat:@"@%@",name];
}

@end