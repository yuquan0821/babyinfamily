//
//  CustomBarButton.m
//  Yunho2
//
//  Created by l on 13-6-4.
//
//

#import "CustomBarButton.h"
#import <QuartzCore/QuartzCore.h>
@implementation CustomBarButton
@synthesize badgeValue;
@synthesize lbBadgeValue;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.lbBadgeValue = [[[UILabel alloc] initWithFrame:CGRectZero]autorelease];
        self.lbBadgeValue.textAlignment = NSTextAlignmentCenter;
        self.lbBadgeValue.textColor = [UIColor whiteColor];
        self.lbBadgeValue.font = [UIFont boldSystemFontOfSize:11];
        self.lbBadgeValue.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:56.0/255.0 blue:56.0/255.0 alpha:1.0];
        CALayer *layer = self.lbBadgeValue.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 10.0;
        layer.borderColor = [UIColor whiteColor].CGColor;
        layer.borderWidth = 2.0;
        self.lbBadgeValue.hidden = YES;
        [self addSubview:self.lbBadgeValue];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.lbBadgeValue.frame = CGRectMake(frame.size.width-20,0, 20, 20);
}
-(void)setBadgeValue:(NSString *)newbadgeValue
{
    if (badgeValue != newbadgeValue) {
        [badgeValue release];
        [newbadgeValue retain];
        badgeValue = newbadgeValue;
        [self performSelectorOnMainThread:@selector(changeLbBadgaeValue) withObject:nil waitUntilDone:NO];
    }
    
}
-(void)changeLbBadgaeValue
{
    if ([self.badgeValue isEqualToString:@"0"]
        || [self.badgeValue isEqualToString:@""]
        || self.badgeValue == nil) {
        self.lbBadgeValue.hidden = YES;
    }else{
        self.lbBadgeValue.hidden = NO;
        self.lbBadgeValue.text = self.badgeValue;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
