//
//  BabyStickerView.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-8-14.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BabyViewBorder.h"


@protocol BabyStickerViewDelegate;
@interface BabyStickerView : UIView
{
    BabyViewBorder *borderView;
}
@property(nonatomic, retain)UIView      *contentView;
@property(nonatomic, retain)UIImageView *photoControl;
@property(nonatomic, retain)UIImageView *resizingControl;
@property(nonatomic, retain)UIImageView *deleteControl;
@property(nonatomic, assign)BOOL        preventsPositionOutsideSuperview;
@property(nonatomic, assign)BOOL        preventsResizing;
@property(nonatomic, assign)BOOL        preventsDeleting;
@property(nonatomic, assign)BOOL        preventsLayoutWhileResizing;
@property(nonatomic, assign)float       deltaAngle;
@property(nonatomic, assign)CGPoint     prevPoint;
@property(nonatomic, assign)CGAffineTransform startTransform;
@property(nonatomic, assign)CGPoint     touchStart;
@property(nonatomic, assign)CGFloat     minWidth;
@property(nonatomic, assign)CGFloat     minHeight;
@property(nonatomic, assign)id<BabyStickerViewDelegate> delegate;

-(void)hideDelHandle;
-(void)showDelHandle;
-(void)hideEditingHandles;
-(void)showEditingHandles;

@end
@protocol BabyStickerViewDelegate <NSObject>
-(void)stickerViewDidBeginEditing:(BabyStickerView *)sticker;
-(void)stickerViewDidEndEditing:(BabyStickerView *)sticker;
-(void)stickerViewDidCancelEditing:(BabyStickerView *)sticker;
-(void)stickerViewDidClose:(BabyStickerView*)sticker;
-(void)stickerViewAddPhoto:(BabyStickerView*)sticker;
@end