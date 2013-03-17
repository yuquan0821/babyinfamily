//
//  HotViewController.m
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//

#import <QuartzCore/QuartzCore.h>
#import "HotViewController.h"
#import "AsyncImageView.h"

#define NUMBER_OF_COLUMNS 3

@interface HotViewController ()
@property (nonatomic,retain) NSMutableArray *imageUrls;
@property (nonatomic,readwrite) int currentPage;
@end

@implementation HotViewController
@synthesize imageUrls=_imageUrls;
@synthesize currentPage=_currentPage;
@synthesize statuesArr;
@synthesize imageDictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //init data
        defaultNotifCenter = [NSNotificationCenter defaultCenter];
        manager = [WeiBoMessageManager getInstance];
        self.title = @"热门";
        NSString *fullpath = [NSString stringWithFormat:@"sourcekit.bundle/image/%@", @"tabbar_hot"];
        self.tabBarItem.image = [UIImage imageNamed:fullpath];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    flowView = [[WaterflowView alloc] initWithFrame:self.view.frame];
    flowView.flowdatasource = self;
    flowView.flowdelegate = self;
    [self.view addSubview:flowView];
    
    self.currentPage = 1;
    
}

- (void)dealloc
{
    self.imageUrls = nil;
    self.statuesArr = nil;
    self.imageDictionary = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [flowView reloadData];  //safer to do it here, in case it may delay viewDidLoad
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [defaultNotifCenter addObserver:self selector:@selector(didGetHomeLine:)    name:MMSinaGotHomeLine          object:nil];
    [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:1 feature:2];
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)getImages
{
    self.imageUrls = [NSMutableArray arrayWithCapacity:20];
    NSString *url;
    //开始加载图片
    for(int i=0;i<[statuesArr count];i++)
    {
        Status * status=[statuesArr objectAtIndex:i];
        NSNumber *indexNumber = [NSNumber numberWithInt:i];
        
        //下载博文图片
        if (status.thumbnailPic && [status.thumbnailPic length] != 0)
        {
            url = status.thumbnailPic;
            [self.imageUrls addObject:url];
        }
        else
        {
            [imageDictionary setObject:[NSNull null] forKey:indexNumber];
        }
        
    }
    NSLog(@"member urls is %@",self.imageUrls);
    NSLog(@"count is %d",statuesArr.count);
    
}

-(void)didGetHomeLine:(NSNotification*)sender
{
    
    self.statuesArr = sender.object;
    [[SHKActivityIndicator currentIndicator] hide];
    [self getImages];
    [flowView reloadData];

}

#pragma mark-
#pragma mark- WaterflowDataSource

- (NSInteger)numberOfColumnsInFlowView:(WaterflowView *)flowView
{
    return NUMBER_OF_COLUMNS;
}

- (NSInteger)flowView:(WaterflowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    return 6;
}

- (WaterFlowCell *)flowView:(WaterflowView *)flowView_ cellForRowAtIndex:(NSInteger)index
{
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		
		AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectZero];
		[cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.layer.borderColor = [[UIColor blackColor] CGColor];
		imageView.layer.borderWidth = 2;
		[imageView release];
		imageView.tag = 1001;
	}
    
    float height = [self flowView:nil heightForCellAtIndex:index];
    
    AsyncImageView *imageView  = (AsyncImageView *)[cell viewWithTag:1001];
	imageView.frame = CGRectMake(0, 0, self.view.frame.size.width / NUMBER_OF_COLUMNS, height);
    
    [imageView loadImage:[self.imageUrls objectAtIndex:index ]];
	
	return cell;
    
}

- (WaterFlowCell*)flowView:(WaterflowView *)flowView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		
		AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectZero];
		[cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.layer.borderColor = [[UIColor blackColor] CGColor];
		imageView.layer.borderWidth = 1;
		[imageView release];
		imageView.tag = 1001;
	}
	
	float height = [self flowView:nil heightForRowAtIndexPath:indexPath];
	
	AsyncImageView *imageView  = (AsyncImageView *)[cell viewWithTag:1001];
	imageView.frame = CGRectMake(0, 0, self.view.frame.size.width / 3, height);
    [imageView loadImage:[self.imageUrls objectAtIndex:(indexPath.row + indexPath.section)]];
	
	return cell;
    
}

#pragma mark-
#pragma mark- WaterflowDelegate

- (CGFloat)flowView:(WaterflowView *)flowView heightForCellAtIndex:(NSInteger)index
{
    float height = 0;
	switch (index  % 5) {
		case 0:
			height = 127;
			break;
		case 1:
			height = 100;
			break;
		case 2:
			height = 87;
			break;
		case 3:
			height = 114;
			break;
		case 4:
			height = 140;
			break;
		case 5:
			height = 158;
			break;
		default:
			break;
	}
	
	return height;
}

-(CGFloat)flowView:(WaterflowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	float height = 0;
	switch ((indexPath.row + indexPath.section )  % 5) {
		case 0:
			height = 127;
			break;
		case 1:
			height = 100;
			break;
		case 2:
			height = 87;
			break;
		case 3:
			height = 114;
			break;
		case 4:
			height = 140;
			break;
		case 5:
			height = 158;
			break;
		default:
			break;
	}
	
	height += indexPath.row + indexPath.section;
	
	return height;
    
}

- (void)flowView:(WaterflowView *)flowView didSelectAtCell:(WaterFlowCell *)cell ForIndex:(int)index
{
    
}

- (void)flowView:(WaterflowView *)_flowView willLoadData:(int)page
{
    [flowView reloadData];
}

@end

