//
//  HotViewController.m
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//

#import "HotViewController.h"
#import "HotPicCell.h"

static int MaxPage = 1;

@implementation HotViewController
@synthesize stylizedView;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    randomSizes = [[NSMutableArray alloc] initWithCapacity:100];
    for (int i = 0; i < 100; i++) {
        CGFloat h = arc4random() % 200 + 100.f;
        CGFloat w = arc4random() % 200 + 100.f;
        [randomSizes addObject:[NSValue valueWithCGSize:CGSizeMake(w, h)]];
    }
    stylizedView.scrollsToTop = YES;
    
}

- (void)viewDidUnload
{
    [self setStylizedView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[stylizedView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfCellsInStylizedView:(CHStylizedView *)stylizedView {
    
    return [randomSizes count];
}


- (UIView<CHResusableCell> *)stylizedView:(CHStylizedView *)aStylizedView cellAtIndex:(NSInteger)index {
    
    NSString *CellID =  @"HotPicCell";
    
    HotPicCell *cell;
    
    cell = (HotPicCell *)[aStylizedView dequeueReusableCellWithIdentifier:CellID];
    
    if (cell == nil) {
        cell = [[HotPicCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        cell.reuseIdentifier = CellID;
    }
    
    cell.label.text = [NSString stringWithFormat:@"%d",index];
    
    return cell;
}

- (CGSize)stylizedView:(CHStylizedView *)stylizedView sizeForCellAtIndex:(NSInteger)index {
    NSValue *value = [randomSizes objectAtIndex:index];
    return value.CGSizeValue;
}

- (UIView *)headerForStylizedView:(CHStylizedView *)stylizedView
{
    HotPicCell *header = [[HotPicCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - CELL_PADDING * 2, 60)];
    header.label.text = @"This is the header";
    
    return header;
}

- (UIView *)footerForStylizedView:(CHStylizedView *)stylizedView
{
    if (page <= MaxPage) {
        HotPicCell *footer = [[HotPicCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - CELL_PADDING * 2, 60)];
        footer.label.text = @"This is the footer";
        
        return footer;
    } else {
        return nil;
    }
}


- (void)didSelectCellInStylizedView:(CHStylizedView *)aStylizedView celAtIndex:(NSInteger)index withInfo:(CHStylizedViewCellInfo *)info {
    
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect imgFrame = [window convertRect:info.frame fromView:aStylizedView];
    
    CHDemoView *blackView = [[CHDemoView alloc] initWithFrame:imgFrame];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.originRect = imgFrame;
    [window addSubview:blackView];
    
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         blackView.frame = window.frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
}






- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    ScrollDirection scrollDirection;
    
    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= scrollView.contentSize.height - self.view.frame.size.height) {
        if (self.lastContentOffsetY > scrollView.contentOffset.y) {
            scrollDirection = ScrollDirectionUp;
            //Show navigation bar
            if (self.navigationController.navigationBarHidden) {
                [self.navigationController setNavigationBarHidden:NO animated:YES];
            }
            
        }
        else if (self.lastContentOffsetY < scrollView.contentOffset.y) {
            scrollDirection = ScrollDirectionDown;
            if (!self.navigationController.navigationBarHidden) {
                [self.navigationController setNavigationBarHidden:YES animated:YES];
            }
            
        }
        
        self.lastContentOffsetY = scrollView.contentOffset.y;
    }
    
    
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (ABS(scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y) < 3
//        && page <= MaxPage) {
//        for (int i = 0; i < 100; i++) {
//            CGFloat h = arc4random() % 200 + 50.f;
//            [randomHeights addObject:[NSNumber numberWithFloat:h]];
//        }
//
//        page++;
//
//        [stream reloadData];
//    }
//}
//
- (void)dealloc
{
    [stylizedView release];
    [super dealloc];
}
@end
