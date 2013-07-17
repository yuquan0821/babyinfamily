/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "UIImageView+Resize.h"
#import <objc/runtime.h>

static char SCALSESIZE_IDENTIFER;
@implementation UIImageView (WebCache)
@dynamic scaleSize;

- (void)setScaleSize:(CGSize)scaleSize
{
    objc_setAssociatedObject(self, &SCALSESIZE_IDENTIFER, NSStringFromCGSize(scaleSize), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGSize)scaleSize
{
    NSString * string = objc_getAssociatedObject(self, &SCALSESIZE_IDENTIFER);
    if (string) {
        return CGSizeFromString(string);
    }
    return CGSizeZero;
}

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder scaleSize:(CGSize)size
{
    self.scaleSize = size;
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    if (self.scaleSize.width > 0) {
        self.image = [UIImage imageWithImage:image scaledToSizeWithSameAspectRatio:self.scaleSize];
    }else{
        self.image = image;
    }
}

@end
