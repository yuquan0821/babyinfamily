//
//  HotViewController.m
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//

#import "HotViewController.h"
#import "HotPicCell.h"

//static int MaxPage = 1;
@interface HotViewController()
- (void)getDataFromCD;
@end
@implementation HotViewController
@synthesize stylizedView,statuesArr,browserView;


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
    defaultNotifCenter = [NSNotificationCenter defaultCenter];

    return self;
}

-(void)getDataFromCD
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"hotPageMaxID"];
    if (number) {
        _maxID = number.longLongValue;
    }
    
    dispatch_queue_t readQueue = dispatch_queue_create("read from db", NULL);
    dispatch_async(readQueue, ^(void){
        if (!statuesArr || statuesArr.count == 0) {
            statuesArr = [[NSMutableArray alloc] initWithCapacity:70];
            NSArray *arr = [[CoreDataManager getInstance] readStatusesFromCD];
            if (arr && arr.count != 0) {
                for (int i = 0; i < arr.count; i++)
                {
                    StatusCoreDataItem *s = [arr objectAtIndex:i];
                    Status *sts = [[Status alloc]init];
                    [sts updataStatusFromStatusCDItem:s];
                    if (i == 0) {
                        sts.isRefresh = @"YES";
                    }
                    [statuesArr insertObject:sts atIndex:s.index.intValue];
                    [sts release];
                }
            }
        }
        [[CoreDataManager getInstance] cleanEntityRecords:@"StatusCoreDataItem"];
        [[CoreDataManager getInstance] cleanEntityRecords:@"UserCoreDataItem"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.stylizedView reloadData];
        });
        dispatch_release(readQueue);
    });
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _maxID = -1;

    randomSizes = [[NSMutableArray alloc] initWithCapacity:26];
    for (int i = 0; i < 26; i++) {
        CGFloat h = arc4random() % 200 + 100.f;
        CGFloat w = arc4random() % 200 + 100.f;
        [randomSizes addObject:[NSValue valueWithCGSize:CGSizeMake(w, h)]];
    }
    stylizedView.scrollsToTop = YES;
    [defaultNotifCenter addObserver:self selector:@selector(getAvatar:)         name:HHNetDataCacheNotification object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetHomeLine:)    name:MMSinaGotHomeLine          object:nil];

    
}

- (void)viewDidUnload
{
    [self setStylizedView:nil];
    [defaultNotifCenter removeObserver:self name:HHNetDataCacheNotification object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaGotHomeLine          object:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:1 feature:2];
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];

    //[stylizedView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //如果未授权，则调入授权页面。
   
    [self getDataFromCD];
        
    if (!statuesArr || statuesArr.count == 0) {
        [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:1 feature:2];
        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
    }
        
}

//上拉
-(void)refresh
{
    [manager getHomeLine:-1 maxID:_maxID count:-1 page:page baseApp:1 feature:2];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//得到图片
-(void)getAvatar:(NSNotification*)sender
{
    NSDictionary * dic      = sender.object;
    NSString * url          = [dic objectForKey:HHNetDataCacheURLKey];
    NSNumber *indexNumber   = [dic objectForKey:HHNetDataCacheIndex];
    NSInteger index         = [indexNumber intValue];
    NSData *data            = [dic objectForKey:HHNetDataCacheData];
    UIImage * image         = [UIImage imageWithData:data];
    
    if (data == nil) {
        NSLog(@"data == nil");
    }
    //当下载大图过程中，后退，又返回，如果此时收到大图的返回数据，会引起crash，在此做预防。
    if (indexNumber == nil || index == -1) {
        NSLog(@"indexNumber = nil");
        return;
    }
    
    if (index >= [statuesArr count]) {
        NSLog(@"statues arr error ,index = %d,count = %d",index,[statuesArr count]);
        return;
    }
    
    Status *sts = [statuesArr objectAtIndex:index];
    
    HotPicCell *cell = (HotPicCell *)sts;
    //得到的是博文图片
    if([url isEqualToString:sts.bmiddlePic])
    {
        sts.statusImage =image;
        cell.contentImage.image = sts.statusImage;
    }
    
    
}

- (NSInteger)numberOfCellsInStylizedView:(CHStylizedView *)stylizedView {
    
    return [randomSizes count];
}


- (UIView<CHResusableCell> *)stylizedView:(CHStylizedView *)aStylizedView cellAtIndex:(NSInteger)index {
    
    NSString *CellID =  @"HotPicCell";
    
    HotPicCell *cell= (HotPicCell *)[aStylizedView dequeueReusableCellWithIdentifier:CellID];
    
    if (cell == nil) {
        cell = [[HotPicCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        cell.reuseIdentifier = CellID;
    }

    Status *status = [statuesArr objectAtIndex:index];
    NSLog(@"status arr are %@",statuesArr);

    NSLog(@"status is %@",status);
    cell.index = index;
   // [cell upDateCell:status];
    if (status.statusImage == nil)
    {
        [[HHNetDataCacheManager getInstance] getDataWithURL:status.bmiddlePic withIndex:index];
    }
   
   // cell.contentImage.image = status.statusImage;
    
   // cell.label.text = [NSString stringWithFormat:@"%d",index];
    
    return cell;
}

- (CGSize)stylizedView:(CHStylizedView *)stylizedView sizeForCellAtIndex:(NSInteger)index {
    NSValue *value = [randomSizes objectAtIndex:index];
    return value.CGSizeValue;
}

-(void)didGetHomeLine:(NSNotification*)sender
{
    
    if (statuesArr == nil || _maxID < 0) {
        self.statuesArr = sender.object;
        Status *sts = [statuesArr objectAtIndex:0];
        _maxID = sts.statusId;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:_maxID] forKey:@"hotPageMaxID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        page = 1;
    }
    else {
        [statuesArr addObjectsFromArray:sender.object];
    }
    page++;
    [[SHKActivityIndicator currentIndicator] hide];
    
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

- (void)dealloc
{
    [statuesArr release];
    [stylizedView release];
    [browserView release];
    [super dealloc];
}
@end
