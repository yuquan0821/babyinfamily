//
//  ImageViewCell.h
//  WaterFlowViewDemo
//
//  Created by Smallsmall on 12-6-12.
//  Copyright (c) 2012年 activation group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WaterFlowViewCell.h"

@interface ImageViewCell : WaterFlowViewCell
{
    UIImageView *imageView;
}

-(void)setImage:(UIImage *)image;
-(void)setImageWithData:(NSData *)imageData;
-(void)relayoutViews;

@end
