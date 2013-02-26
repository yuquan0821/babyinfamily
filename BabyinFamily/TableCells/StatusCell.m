//
//  StatusCell.m
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-1-5.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "StatusCell.h"
#import "UIImageView+Resize.h"

@implementation StatusCell
@synthesize countLB;
@synthesize avatarImage;
@synthesize userNameLB;
@synthesize locationLabel;
@synthesize bgImage;
@synthesize contentImage;
@synthesize delegate;
@synthesize cellIndexPath;
@synthesize fromLB;
@synthesize timeLB;
@synthesize moreButton;


-(void)setupCell:(Status *)status  //contentImageData:(NSData *)imageData
{
    countLB.text = [NSString stringWithFormat:@"评论:%d 转发:%d 赞:%d",status.commentsCount,status.retweetsCount,status.attitudesCount];
    fromLB.text = [NSString stringWithFormat:@"来自:%@",status.source];
    userNameLB.text = status.user.screenName;
    locationLabel.text = status.user.location;
    timeLB.text = status.timestamp;

}

//计算cell的高度
-(CGFloat)setCellHeight:(Status *)status contentImageData:(NSData *)imageData
{
    //CGRect frame;
    CGFloat height = 385.0f;
   /*  CGSize size = [self getFrameOfImageView:contentImage].size;
    float zoom = 2 * size.width > size.height ? 250.0/size.width : 300.0/size.height;
    size = CGSizeMake(size.width * zoom, size.height * zoom);
    frame.size = size;
    contentImage.frame = frame;
    contentImage.center = CGPointMake(160, contentImage.center.y);
    frame = contentImage.frame;
    bgImage.frame = CGRectMake(frame.origin.x - 5, frame.origin.y - 5, frame.size.width + 10, frame.size.height + 10);;
    [contentImage layoutIfNeeded];
   if (![imageData isEqual:[NSNull null]])
    {
        UIImage *TempImage= [UIImage imageWithData:imageData];
        //裁剪
       // UIImage *scaledImage = [UIImageView imageWithImage:TempImage scaledToSizeWithSameAspectRatio:CGSizeMake(MAIN_IMAGE_WIDTH, MAIN_IMAGE_HEIGHT)];
        
        self.contentImage.image = TempImage ;
        
         height =  self.contentImage.image.size.height;
    }
    else{*/
        
       // height = self.contentImage.frame.size.height + self.contentImage.frame.origin.y;
    //}

    return height;
}
- (void)report
{
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        ErrorMessage *em = [engine reportPictureStatus:self.pictureStatus.psId];
        if (em!=nil && em.ret==0 && em.errorcode == 0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"举报成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            [alert release];
        }
    });*/
}
- (void)deletePicture
{
    
   /* [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        ErrorMessage *em = [engine deletePictureStatus:self.pictureStatus.psId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (em!=nil && em.ret==0 && em.errorcode == 0) {
                //send notification
                
                NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:self.pictureStatus.psId],@"psId", nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"DeletedPic" object:nil userInfo:userInfo];
                [userInfo release];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:em.errorMsg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        });
    });*/
}

/*- (IBAction)moreButtonOnClick:(id)sender
{
    Status *status;
    UIActionSheet *sheet;
    NSInteger userId = [[NSUserDefaults standardUserDefaults]integerForKey:@"userid"];
    if (status.user.userId == userId) {
        sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"举报", nil];
    }else{
        sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:nil];
    }
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [sheet showInView:window];
    [sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    Status *status;
    NSLog(@"%d",buttonIndex);
    NSInteger userId = [[NSUserDefaults standardUserDefaults]integerForKey:@"userid"];
    if (status.user.userId == userId) {
        //0：删除 1：举报 2：取消
        switch (buttonIndex) {
            case 0:
                [self deletePicture];
                break;
            case 1:
                [self report];
                break;
            case 2:
                break;
            default:
                break;
        }
    }else{
        //0：举报 1：取消
        switch (buttonIndex) {
            case 0:
                [self report];
                break;
            case 1:
                break;
            default:
                break;
        }
    }
}*/



-(IBAction)tapDetected:(id)sender
{
    UITapGestureRecognizer*tap = (UITapGestureRecognizer*)sender;
    
    UIImageView *imageView = (UIImageView*)tap.view;
    if ([imageView isEqual:contentImage]) {
        if ([delegate respondsToSelector:@selector(cellImageDidTaped:image:)]) 
        {
            [delegate cellImageDidTaped:self image:contentImage.image];
        }
    }
   }

- (void)dealloc {
    [avatarImage release];
    [userNameLB release];
    [bgImage release];
    [contentImage release];
    [cellIndexPath release];
    [countLB release];
    [fromLB release];
    [timeLB release];
    [moreButton release];
    [locationLabel release];
    [super dealloc];
}
@end
