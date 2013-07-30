//
//  BabyPlaceHolderTextView.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-29.
//
//

#import <UIKit/UIKit.h>

@interface BabyPlaceHolderTextView : UITextView
{
    UILabel *_placeholder;
}

@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic, retain) UIColor *placeholderColor;

@end
