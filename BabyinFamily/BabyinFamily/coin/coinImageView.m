//
//  coinImageView.m
//  CoinDemoUikit
//
//  Created by gump on 8/31/12.
//  Copyright (c) 2012 gump. All rights reserved.
//

#import "coinImageView.h"

@implementation coinImageView

@synthesize coinImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        coinImage = [UIImage imageWithSourceKit:@"coinSource/coin.png"];
        iindex = 0;
    }
    return self;
}

- (void)tick
{
    CGRect rc1 = [self frame];
    rc1.origin.y += 20;
    [self setFrame:rc1];
    
    CGRect rc = CGRectMake(0.0f, IMAGEVIEW_WIDTH * iindex, IMAGEVIEW_WIDTH, IMAGEVIEW_WIDTH);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(coinImage.CGImage,rc);
    UIImage *subImage = [UIImage imageWithCGImage:subImageRef scale:1.0 orientation:coinImage.imageOrientation];
    [self setImage:subImage];
    
    ++iindex;
    
    if(iindex > 6)
    {
        iindex = 0;
    }
}
- (void)dealloc
{
    [coinImage release];
    [super dealloc];
}

@end
