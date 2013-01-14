//
//  UIImageView+AsyncImageContainer.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-1-6.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageDownloader.h"

@interface UIImageView (AsyncImageContainer) <AsyncImageContainer>

/**
 设定UIImageView的图像，通过URL异步载入（同SDWebImage）
 */
- (void)setImageWithUrl:(NSURL *)url;
/**
 设定UIImageView的图像，载入之前使用占位图像，通过URL异步载入（同SDWebImage）
 */
- (void)setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
