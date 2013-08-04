//
//  BabyDetailStatusCellHeadView.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-8-2.
//
//

#import "BabyDetailStatusCellHeadView.h"

@implementation BabyDetailStatusCellHeadView
@synthesize commentCount;
@synthesize weibo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customView];
    }
    return self;
}
- (void)customView
{
    self.frame = CGRectMake(0, 0, 320, 44);
    self.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:253.0f/255.0f blue:253.0f/255.0f alpha:0.8];
    self.commentCount = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 160, 21)];
    self.commentCount.textColor = [UIColor brownColor];
    self.commentCount.font = [UIFont boldSystemFontOfSize:13.0f];
    self.commentCount.backgroundColor = [UIColor clearColor];
    [self addSubview:commentCount];
}

@end
