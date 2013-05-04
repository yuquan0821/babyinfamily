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
#import "Status.h"
#import "HomeViewController.h"



@interface SendAndSaveViewController ()
@property (retain, nonatomic) UIImage *mainImage;


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
        self.mainImage = image;
    }
    manager = [WeiBoMessageManager getInstance];
    self.title = @"save and send";
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPost:) name:MMSinaGotPostResult object:nil];

    // Do any additional setup after loading the view from its nib.
    self.mainImageView.image = mainImage;
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPost:) name:MMSinaGotPostResult object:nil];
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
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.selectedIndex = 0;
    [self dismissModalViewControllerAnimated:NO];

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:nil
                                           message:@"保存失败！"
                                          delegate:self cancelButtonTitle:@"确认"
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:nil
                                           message:@"保存成功"
                                          delegate:self cancelButtonTitle:@"确认"
                                 otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (IBAction)sendPicture:(id)sender
{
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        [[SHKActivityIndicator currentIndicator] displayActivity:@"发送中，请稍后..." inView:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSString *content =@"#家贝#记录宝贝的每一个瞬间！"  ;
            switch (arc4random() % 5) {
                case 0:
                    content = @"#家贝#记录宝贝的生活点滴！";
                    break;
                case 1:
                    content = @"#家贝#记录宝贝的生活一点一滴！";
                    break;
                case 2:
                    content = @"#家贝#记录家庭的温馨！";
                    break;
                case 3:
                    content = @"#家贝#记录宝贝们奇迹的时刻！";
                    break;
                case 4:
                    content = @"#家贝#记录宝贝的每一个瞬间！";
                    break;
                default:
                    break;
            }
            
            UIImage *image = self.mainImageView.image;
            if (image != nil && content != Nil && content.length !=0) {
//                [[BabyAlertWindow getInstance] showWithString:@"发送中，请稍后..."];
                
                [manager postWithText:content image:image];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sendPicture" object:self];
            });
        });

    }
   

}
-(void)didPost:(NSNotification*)sender
{
    Status *sts = sender.object;
    if (sts.text != nil && [sts.text length] != 0) {
//        [[BabyAlertWindow getInstance] hide];
        [[SHKActivityIndicator currentIndicator] hide];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        self.tabBarController.tabBar.hidden = NO;
        self.tabBarController.selectedIndex = 0;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
//        [[BabyAlertWindow getInstance] hide];
        [[SHKActivityIndicator currentIndicator] hide];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        self.tabBarController.tabBar.hidden = NO;
        self.tabBarController.selectedIndex = 0;
    }
}


- (void)dealloc {
    [saveImageButton release];
    [sendImageButton release];
    [backGroundImageView release];
    [mainImageView release];
    [super dealloc];
}
@end
