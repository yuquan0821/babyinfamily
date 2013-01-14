//
//  UIImageView+AsyncImageContainer.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-1-6.
//
//
#import "UIImageView+AsyncImageContainer.h"

@implementation UIImageView (AsyncImageContainer)


- (void)setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    self.image = placeholder;
    if (url != nil) {
        AsyncImageDownloader *downloader = [AsyncImageDownloader sharedAsyncImageDownloader];
        [downloader loadImageWithUrl:url AndDelegate:self];
    }
}

- (void)setImageWithUrl:(NSURL *)url
{
    if (url!=nil) {
        AsyncImageDownloader *downloader = [AsyncImageDownloader sharedAsyncImageDownloader];
        [downloader loadImageWithUrl:url Delegate:self scaleSize:self.frame.size];
    }
    
}

- (void)imageDidFinishLoad:(UIImage *)image
{
    //self.alpha = 0.0f;
    self.image = image;
    //[UIView animateWithDuration:1 animations:^(void){self.alpha = 1;}];
    
}

- (void)imageDidFaildLoad:(NSError *)error
{
#warning not implement yet
}

@end
