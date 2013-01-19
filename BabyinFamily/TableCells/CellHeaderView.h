//
//  CellHeaderView.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-1-7.
//
//
#import "Status.h"
#import "User.h"

@interface CellHeaderView : UIView

@end
@interface CellHeaderView ()

@property(nonatomic, retain) UIImage *avatarImage;
@property(nonatomic, retain) UIImage *arrowImage;
@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) UILabel *locationLabel;
@property(nonatomic, retain) UIImage *locationIcon;
@property(nonatomic, retain) UILabel *timeLabel;

- (void)initializeState;
- (void)setupHeaderView:(Status *)status avatarImageData:(NSData *)avatarData;
- (void)setUpArrow:(CGRect)frame;
- (void)drawAvatar:(CGContextRef)context;
- (void)drawBackgroundIn:(CGRect)rect context:(CGContextRef)context;

@end