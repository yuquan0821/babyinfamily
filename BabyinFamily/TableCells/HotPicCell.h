//
//  HotPicCell.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-3-11.
//
//

#import <UIKit/UIKit.h>
#import "CHStylizedView.h"

@interface HotPicCell : UIView<CHResusableCell>
{
    NSString *reuseIdentifier;
}

@property (nonatomic, readonly) UILabel *label;

@end

@interface CHDemoView : UIView
- (void)singleTapAction:(UITapGestureRecognizer*)ges;
@property (nonatomic,assign)CGRect originRect;
@end