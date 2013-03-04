//
//  HotViewController.m
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//

#import "HotViewController.h"
#import "HotViewController+Private.h"
#import "BDRowInfo.h"

@interface HotViewController ()
@end

@implementation HotViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"热门";
        NSString *fullpath = [NSString stringWithFormat:@"sourcekit.bundle/image/%@", @"tabbar_hot"];
        self.tabBarItem.image = [UIImage imageNamed:fullpath];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    self.onLongPress = ^(UIView* view, NSInteger viewIndex){
        NSLog(@"Long press on %@, at %d", view, viewIndex);
    };
    
    self.onDoubleTap = ^(UIView* view, NSInteger viewIndex){
        NSLog(@"Double tap on %@, at %d", view, viewIndex);
    };
    [self _demoAsyncDataLoading];
    [self buildBarButtons];
}

- (void)animateReload
{
    _items = [NSArray new];
    [self _demoAsyncDataLoading];
}

- (NSUInteger)numberOfViews
{
    return _items.count;
}

-(NSUInteger)maximumViewsPerCell
{
    return 5;
}

- (UIView *)viewAtIndex:(NSUInteger)index rowInfo:(BDRowInfo *)rowInfo
{
    UIImageView * imageView = [_items objectAtIndex:index];
    return imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //Call super when overriding this method, in order to benefit from auto layout.
    [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    return YES;
}

- (CGFloat)rowHeightForRowInfo:(BDRowInfo *)rowInfo
{
    //    if (rowInfo.viewsPerCell == 1) {
    //        return 125  + (arc4random() % 55);
    //    }else {
    //        return 100;
    //    }
    return 55 + (arc4random() % 125);
}

@end
