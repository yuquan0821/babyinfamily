//
//  PullRefreshTableViewController.h
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#define REFRESH_FOOTER_HEIGHT   70.0f

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]

#define startOffset             (scrollView.contentSize.height - scrollView.frame.size.height)
#define contentOffsetY          (scrollView.contentOffset.y + REFRESH_FOOTER_HEIGHT - startOffset)

//#define UIEdgeInsetsOriginal    UIEdgeInsetsMake( 0, 0,-REFRESH_FOOTER_HEIGHT, 0)
//#define UIEdgeInsetsFinal       UIEdgeInsetsMake( 0, 0,0, 0)
//#define UIEdgeInsetsMiddle      UIEdgeInsetsMake(0, 0, -(scrollView.contentOffset.y - startOffset), 0)

//
#import <UIKit/UIKit.h>
#define REFRESH_FOOTER_HEIGHT   70.0f

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]

#define startOffset             (scrollView.contentSize.height - scrollView.frame.size.height)
#define contentOffsetY          (scrollView.contentOffset.y + REFRESH_FOOTER_HEIGHT - startOffset)

//#define UIEdgeInsetsOriginal    UIEdgeInsetsMake( 0, 0,-REFRESH_FOOTER_HEIGHT, 0)
//#define UIEdgeInsetsFinal       UIEdgeInsetsMake( 0, 0,0, 0)
//#define UIEdgeInsetsMiddle      UIEdgeInsetsMake(0, 0, -(scrollView.contentOffset.y - startOffset), 0)

//
#define UIEdgeInsetsOriginal    UIEdgeInsetsMake( 0, 0,-REFRESH_FOOTER_HEIGHT, 0)
#define UIEdgeInsetsFinal       UIEdgeInsetsMake( 0, 0,0, 0)
#define UIEdgeInsetsMiddle      UIEdgeInsetsMake(0, 0, -(scrollView.contentOffset.y - startOffset), 0)

@interface PullRefreshTableViewController : UITableViewController {
    UIView *refreshFooterView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    UILabel *lastUpdatedLabel;
	UILabel *statusLabel;
}

@property (nonatomic, retain) UIView *refreshFooterView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)setupStrings;
- (void)addPullToRefreshFooter;
//- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
@end