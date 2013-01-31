//
//  SendAndSaveViewController.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-1-9.
//
//

#import "SendAndSaveViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BabyAlertWindow.h"
#import "WeiBoMessageManager.h"


@interface SendAndSaveViewController ()
@property (assign, nonatomic) UIImage *mainImage;


@end

@implementation SendAndSaveViewController
@synthesize saveImageButton;
@synthesize sendImageButton;
@synthesize backGroundImageView;
@synthesize mainImageView;
@synthesize mainImage;
@synthesize delegate;

-(id)initWithImage:(UIImage*)image
{
    if (self = [super initWithNibName:@"SendAndSaveViewController" bundle:nil]) {
        backGroundImageView.image = [UIImage imageNamed:@"weibo.bundle/WeiboImages/detail_image_background.png"];
        mainImage = image;
    }
    manager = [WeiBoMessageManager getInstance];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mainImageView.image = mainImage;
}

- (void)viewDidUnload
{
    [self setSaveImageButton:nil];
    [self setSendImageButton:nil];
    [self setBackGroundImageView:nil];
    [self setMainImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)savePhoto:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(self.mainImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    self.tabBarController.selectedIndex = 0;
    self.tabBarController.tabBar.hidden = NO;
    [self dismissModalViewControllerAnimated:NO];

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                           message:@"保存失败！"
                                          delegate:self cancelButtonTitle:@"确认"
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"成功"
                                           message:@"保存成功"
                                          delegate:self cancelButtonTitle:@"确认"
                                 otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (IBAction)sendPicture:(id)sender
{
    NSString *content = @"#家贝#宝贝每一个瞬间，都由家贝来记录！";
    UIImage *image = self.mainImageView.image;
    if (image != nil ) {
        [[BabyAlertWindow getInstance] showWithString:@"发送中，请稍后..."];
        manager = [WeiBoMessageManager getInstance];
            [manager postWithText:content image:image];
        
           }
    self.tabBarController.selectedIndex = 0;
    self.tabBarController.tabBar.hidden = NO;
}


- (void)dealloc {
    [saveImageButton release];
    [sendImageButton release];
    [backGroundImageView release];
    [mainImageView release];
    [super dealloc];
}
@end
