//
//  CustomTabbarView.h
//  Yunho2
//
//  Created by l on 13-6-4.
//
//



#import <UIKit/UIKit.h>
#import "CustomTabbarViewController.h"
#import "CustomBarButton.h"
#import "TakePhotoViewController.h"

@interface CustomTabbarView : UIView

@property(nonatomic,retain) UIImageView *tabbarView;
@property(nonatomic,retain) UIImageView *tabbarViewCenter;

@property(nonatomic,retain) CustomBarButton *button_1;
@property(nonatomic,retain) CustomBarButton *button_2;
@property(nonatomic,retain) CustomBarButton *button_3;
@property(nonatomic,retain) CustomBarButton *button_4;
@property(nonatomic,retain) CustomBarButton *button_center;
@property(nonatomic,retain) CustomBarButton *selectedButton;

@property(nonatomic,assign) id<tabbarDelegate> delegate;

@end
