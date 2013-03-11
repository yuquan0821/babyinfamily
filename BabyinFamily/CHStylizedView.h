//
//  CHStylizedView.h
//  JustifiedView
//
//  Created by Hang Chen on 1/12/13.
//  Copyright (c) 2013 Hang Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_PADDING 5

@class CHStylizedView;

typedef enum {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;



@protocol CHResusableCell <NSObject>

@property (nonatomic, retain) NSString *reuseIdentifier;

@end

@interface CHStylizedViewCellInfo : NSObject

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) float ratio;

// You SHOULD ONLY access this property when this object is in visibleCellInfo!
@property (nonatomic, unsafe_unretained) UIView<CHResusableCell> *cell;

@end


@class EKStreamView;


@protocol CHStylizedViewDelegate <UIScrollViewDelegate>

- (NSInteger)numberOfCellsInStylizedView:(CHStylizedView *)stylizedView;
- (UIView<CHResusableCell> *)stylizedView:(CHStylizedView *)stylizedView cellAtIndex:(NSInteger)index;
- (CGSize)stylizedView:(CHStylizedView *)stylizedView sizeForCellAtIndex:(NSInteger)index;

@optional
- (void)didSelectCellInStylizedView:(CHStylizedView*)stylizedView celAtIndex:(NSInteger)index withInfo:(CHStylizedViewCellInfo*)info;
- (void)didSelectCellHeaderInStylizedView:(CHStylizedView*)stylizedView;
- (void)didSelectCellFooterInStylizedView:(CHStylizedView*)stylizedView;
- (UIView *)headerForStylizedView:(CHStylizedView *)stylizedView;
- (UIView *)footerForStylizedView:(CHStylizedView *)stylizedView;
- (void)stylizedView:(CHStylizedView *)stylizedView willDisplayCell:(UIView<CHResusableCell> *)cell forIndex:(NSInteger)index;
@optional

@end


@interface CHStylizedViewUIScrollViewDelegate : NSObject<UIScrollViewDelegate>
@property (nonatomic, unsafe_unretained) CHStylizedView *stylizedView;

@end


@interface CHStylizedView : UIScrollView
{
    NSMutableArray
    *infoForCells;          // 1d
    
    NSMutableDictionary *cellCache; // reuseIdentifier => NSMutableArray
    NSSet *visibleCellInfo;
    CHStylizedViewUIScrollViewDelegate *delegateObj;
    CGFloat longerEdge_;
}

@property (nonatomic, unsafe_unretained) id<CHStylizedViewDelegate> delegate;


@property (nonatomic, readonly) UIView *headerView, *footerView;
@property (nonatomic, readonly) UIView *contentView;


- (id<CHResusableCell>)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)reloadData;

@end
