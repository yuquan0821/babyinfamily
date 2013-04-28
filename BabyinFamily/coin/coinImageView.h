//
//  coinImageView.h
//  CoinDemoUikit
//
//  Created by gump on 8/31/12.
//  Copyright (c) 2012 gump. All rights reserved.
//
#define IMAGEVIEW_WIDTH 30.0f

@interface coinImageView : UIImageView
{
    int iindex;
}

@property (retain,nonatomic)    UIImage*    coinImage;

-(void)tick;

@end
