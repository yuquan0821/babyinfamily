//
//  BabyViewBorder.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-8-14.
//
//

#import "BabyViewBorder.h"

@implementation BabyViewBorder

#define kSPUserResizableViewGlobalInset 5.0
#define kSPUserResizableViewDefaultMinWidth 36.0
#define kSPUserResizableViewDefaultMinHeight 48.0
#define kSPUserResizableViewInteractiveBorderSize 10.0

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Clear background to ensure the content view shows through.
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddRect(context, CGRectInset(self.bounds, kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewInteractiveBorderSize/2));
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}


@end
