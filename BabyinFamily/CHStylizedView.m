//
//  CHStylizedView.m
//  JustifiedView
//
//  Created by Hang Chen on 1/12/13.
//  Copyright (c) 2013 Hang Chen. All rights reserved.
//

#import "CHStylizedView.h"

#define CELL_MAX_HEIGHT 80

#define FLOAT_CHECK_EQUAL(leftValue,rightValue) (ABS((leftValue)-(rightValue)) < 0.001)

@implementation CHStylizedViewCellInfo

@synthesize frame, index, cell,ratio;

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[CHStylizedViewCellInfo class]]) return NO;
    
    return index == [object index];
}

- (NSUInteger)hash
{
    return index;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: index: %d>",NSStringFromClass([self class]), index];
}

@end



@interface CHStylizedView()

- (void)setup;
- (NSSet *)getVisibleCellInfo;
- (void)layoutCellWithCellInfo:(CHStylizedViewCellInfo *)info;

@property (nonatomic ,retain) NSSet *visibleCellInfo;
@property (nonatomic ,retain) NSMutableDictionary *cellCache;

@end



@implementation CHStylizedView

@synthesize delegate, visibleCellInfo, cellCache;
@synthesize headerView, footerView,contentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat LongerEdge = self.bounds.size.width > self.bounds.size.height? self.bounds.size.width:self.bounds.size.height;
    if (infoForCells.count) {
        if (ABS(longerEdge_ - LongerEdge) < 1) {
            return;
        }
    }
    [self reloadData];
    longerEdge_ = LongerEdge;
}

- (void)reloadData
{
    [infoForCells removeAllObjects];
    [cellCache removeAllObjects];
    [headerView removeFromSuperview];
    [footerView removeFromSuperview];
    
    for (CHStylizedViewCellInfo *cellInfo in visibleCellInfo) {
        [cellInfo.cell removeFromSuperview];
    }
    
    if ([delegate respondsToSelector:@selector(headerForStylizedView:)]) {
        headerView = [delegate headerForStylizedView:self];
        CGRect f = headerView.frame;
        f.origin = CGPointMake(CELL_PADDING, CELL_PADDING);
        headerView.frame = f;
        
        [contentView addSubview:headerView];
    } else {
        headerView = nil;
    }
    
    if ([delegate respondsToSelector:@selector(footerForStylizedView:)]) {
        footerView = [delegate footerForStylizedView:self];
        [contentView addSubview:footerView];
    } else {
        footerView = nil;
    }
    
    // calculate height for all cells
    
    
    NSInteger numberOfCells = [delegate numberOfCellsInStylizedView:self];
    CGFloat lastCellRightX = CELL_PADDING;
    CGFloat rowBottomY = 0;
    CGFloat rowTopY = headerView ? headerView.bounds.size.height + headerView.frame.origin.y + CELL_PADDING : CELL_PADDING;
    CGFloat rowFirstIndex = 0;
    CGFloat rowLastIndex = 0;
    for (int i = 0; i < numberOfCells; i++) {
        
        CGSize size = [delegate stylizedView:self sizeForCellAtIndex:i];
        
        float ratio = size.width/size.height;
        
        CGSize actualSize = CGSizeMake(CELL_MAX_HEIGHT*ratio, CELL_MAX_HEIGHT);
        if (actualSize.width >= self.bounds.size.width - lastCellRightX - CELL_PADDING) {
            actualSize.width = self.bounds.size.width - lastCellRightX - CELL_PADDING;
            actualSize.height = actualSize.width/ratio;
            rowLastIndex = i;
        }

        if (FLOAT_CHECK_EQUAL(lastCellRightX,CELL_PADDING)) {
            rowBottomY = actualSize.height;
            rowFirstIndex = i;
        }
        
        CHStylizedViewCellInfo *info = [CHStylizedViewCellInfo new];
        info.frame = CGRectMake(lastCellRightX, rowTopY, actualSize.width, actualSize.height);
        info.index = i;
        info.ratio = ratio;
        [infoForCells addObject:info];
        
        lastCellRightX+= (actualSize.width + CELL_PADDING);
        if (lastCellRightX >= self.bounds.size.width) {
            
            //We need to adjust the height of the whole row, otherwise the last cell may be shorter.
            if (rowLastIndex > rowFirstIndex) {
                CGFloat ratios = 0.f;
                for (NSInteger jj = rowFirstIndex; jj <= rowLastIndex; jj++) {
                    CHStylizedViewCellInfo *info = [infoForCells objectAtIndex:jj];
                    ratios += info.ratio;

                }
                //Calculate the row height depends on each cell's ratio
                rowBottomY = (self.bounds.size.width - ((rowLastIndex - rowFirstIndex + 2) * CELL_PADDING))/ratios;
               
                lastCellRightX = CELL_PADDING;
                for (NSInteger jj = rowFirstIndex; jj <= rowLastIndex; jj++) {
                    CHStylizedViewCellInfo *info = [infoForCells objectAtIndex:jj];
                    CGRect cellFrame = info.frame;
                    cellFrame.origin.x = lastCellRightX;
                    cellFrame.size.height = rowBottomY;
                    cellFrame.size.width = rowBottomY*info.ratio;
                    info.frame = cellFrame;
                    lastCellRightX += CELL_PADDING + cellFrame.size.width;
                }
            }
            lastCellRightX = CELL_PADDING;
            if (i != numberOfCells - 1) {//We need to start a new line.
                rowTopY += rowBottomY + CELL_PADDING;
            }
            else {//We reached the last item, do not need to start a new line.
                
            }
        }
        
    }
    
    
    // determine the visible cells' range
    visibleCellInfo = [self getVisibleCellInfo];
    
    // draw the visible cells
    
    for (CHStylizedViewCellInfo *info in visibleCellInfo) {
        [self layoutCellWithCellInfo:info];
    }
    
    CGFloat maxHeight = 0;
    
    maxHeight = rowBottomY+rowTopY + CELL_PADDING;
    
    if (footerView) {
        CGRect f = footerView.frame;
        f.origin = CGPointMake(CELL_PADDING, maxHeight);
        footerView.frame = f;
        
        maxHeight += footerView.bounds.size.height + CELL_PADDING;
    }
    
    self.contentSize = CGSizeMake(0.0f, maxHeight);
    CGRect f = contentView.frame;
    f.size.height = maxHeight;
    f.size.width = self.bounds.size.width;
    contentView.frame = f;
    
}

- (id<CHResusableCell>)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    NSMutableArray *cellArray = [cellCache objectForKey:identifier];
    id<CHResusableCell> cell = nil;
    if ([cellArray count] > 0) {
        cell = [cellArray lastObject];
        [cellArray removeLastObject];
    }
    
    return cell;
}



#pragma mark - Private Methods

- (NSSet *)getVisibleCellInfo
{
    CGFloat offsetTop = self.contentOffset.y;
    CGFloat offsetBottom = offsetTop + self.bounds.size.height;
    NSMutableSet *ret = [NSMutableSet setWithCapacity:10];
    
    
    for (CHStylizedViewCellInfo *info in infoForCells) {
         
        CGFloat top = info.frame.origin.y;
        CGFloat bottom = CGRectGetMaxY(info.frame);
        
        if (bottom < offsetTop) { // The cell is above the current view rect
            continue;
        } else if (top > offsetBottom) { // the cell is below the current view rect. stop searching this column
            break;
        } else {
            [ret addObject:info];
        }
        
        
    }
    
    return ret;
}

- (void)layoutCellWithCellInfo:(CHStylizedViewCellInfo *)info
{
    UIView<CHResusableCell> *cell = [delegate stylizedView:self cellAtIndex:info.index];
    cell.frame = info.frame;
    info.cell = cell;
    if ([delegate respondsToSelector:@selector(stylizedView:willDisplayCell:forIndex:)]) {
        [delegate stylizedView:self willDisplayCell:cell forIndex:info.index];
    }
    [contentView addSubview:cell];
}

- (void)setup
{
    delegateObj = [CHStylizedViewUIScrollViewDelegate new];
    delegateObj.stylizedView = self;
    [super setDelegate:delegateObj];
    
    infoForCells = [[NSMutableArray alloc] initWithCapacity:30];

    cellCache = [[NSMutableDictionary alloc] initWithCapacity:20];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
    contentView.autoresizesSubviews = NO;
    [self addSubview:contentView];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if (self.footerView && CGRectContainsPoint([self.footerView frame], location)) {
        if ([self.delegate respondsToSelector:@selector(didSelectCellFooterInStylizedView:)]) {
            [self.delegate didSelectCellFooterInStylizedView:self];
        }
    }
    else if (self.headerView && CGRectContainsPoint([self.headerView frame], location)) {
        if ([self.delegate respondsToSelector:@selector(didSelectCellHeaderInStylizedView:)]) {
            [self.delegate didSelectCellHeaderInStylizedView:self];
        }
    }
    else {

        
        for (CHStylizedViewCellInfo *info in infoForCells) {
            if (CGRectContainsPoint(info.frame, location)) {
                if ([self.delegate respondsToSelector:@selector(didSelectCellInStylizedView:celAtIndex:withInfo:)]) {
                    [self.delegate didSelectCellInStylizedView:self celAtIndex:info.index withInfo:info];
                }
                break;
            }
        }
    }
}



@end


@implementation CHStylizedViewUIScrollViewDelegate

@synthesize stylizedView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSSet *newVisibleCellInfo = [stylizedView getVisibleCellInfo];
    NSSet *visibleCellInfo = stylizedView.visibleCellInfo;
    NSMutableDictionary *cellCache = stylizedView.cellCache;
    
    for (CHStylizedViewCellInfo *info in visibleCellInfo) {
        if (![newVisibleCellInfo containsObject:info]) {
            // info.cell.retainCount: 1
            NSString *cellID = info.cell.reuseIdentifier;
            NSMutableArray *cellArray = [cellCache objectForKey:cellID];
            if (cellArray == nil) {
                cellArray = [NSMutableArray arrayWithCapacity:10];
                [cellCache setObject:cellArray forKey:cellID];
            }
            
            [cellArray addObject:info.cell];
            // info.cell.retainCount: 2
            [info.cell removeFromSuperview];
            // info.cell.retainCount: 1
        }
    }
    
    for (CHStylizedViewCellInfo *info in newVisibleCellInfo) {
        if (![visibleCellInfo containsObject:info]) {
            [stylizedView layoutCellWithCellInfo:info];
        }
    }
    
    stylizedView.visibleCellInfo = newVisibleCellInfo;
    
    if ([stylizedView.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [stylizedView.delegate scrollViewDidScroll:stylizedView];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([stylizedView.delegate respondsToSelector:@selector(scrollViewDidZoom:)])
        [stylizedView.delegate scrollViewDidZoom:stylizedView];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([stylizedView.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [stylizedView.delegate scrollViewWillBeginDragging:stylizedView];
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([stylizedView.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        [stylizedView.delegate scrollViewWillEndDragging:stylizedView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([stylizedView.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [stylizedView.delegate scrollViewDidEndDragging:stylizedView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([stylizedView.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        [stylizedView.delegate scrollViewWillBeginDecelerating:stylizedView];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([stylizedView.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [stylizedView.delegate scrollViewDidEndDecelerating:stylizedView];
    
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([stylizedView.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        [stylizedView.delegate scrollViewDidEndScrollingAnimation:stylizedView];
    
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([stylizedView.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
        return [stylizedView.delegate viewForZoomingInScrollView:stylizedView];
    else
        return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if ([stylizedView.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
        [stylizedView.delegate scrollViewWillBeginZooming:scrollView withView:view];
    
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if ([stylizedView.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
        [stylizedView.delegate scrollViewDidEndZooming:stylizedView withView:view atScale:scale];
    
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if ([stylizedView.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
        return [stylizedView.delegate scrollViewShouldScrollToTop:stylizedView];
    else
        return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([stylizedView.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [stylizedView.delegate scrollViewDidScrollToTop:stylizedView];
    
}



@end
