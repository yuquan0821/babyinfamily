//
//  BabyAlbumsViewController.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-8-7.
//
//

#import "BabyAlbumsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BabyAlbumsViewController ()

@end

@implementation BabyAlbumsViewController
@synthesize babyBigAlbumsView;
@synthesize thumbnailListView;
@synthesize selectedSticker;
@synthesize Sticker;
@synthesize Sticker1;
@synthesize stickerviewArray= _stickerviewArray;

- (void)dealloc
{
    [babyBigAlbumsView release];
    [thumbnailListView release];
    [_stickerviewArray release];

    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"图片";
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stickerviewArray = [NSMutableArray array];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(actionBtnBack)];
    self.navigationItem.leftBarButtonItem = btnBack;
    [btnBack release];
    UIBarButtonItem *retwitterBtn = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(finishEdit)];
    self.navigationItem.rightBarButtonItem = retwitterBtn;
    [retwitterBtn release];
	// Do any additional setup after loading the view.
    self.babyBigAlbumsView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 200)];
    self.babyBigAlbumsView.image = [UIImage imageNamed:@"test_001.png"];
    
    self.thumbnailListView = [[ThumbnailListView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height - 150, 320, 69)];
    self.thumbnailListView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    self.thumbnailListView.showsHorizontalScrollIndicator = NO;
    
    self.thumbnailListView.dataSource =self;
    self.thumbnailListView.delegate =self;
    [self.thumbnailListView reloadData];
    [self.thumbnailListView selectAtIndex:0];
    
    CGRect randFrame = CGRectMake(30, 50, 100, 150);
    Sticker = [[BabyStickerView alloc] initWithFrame:randFrame];
    Sticker.preventsPositionOutsideSuperview = NO;
    Sticker.delegate = self;
    [self.stickerviewArray addObject:Sticker];
    [Sticker release];
    
    CGRect randFrame1 = CGRectMake(170, 80, 100, 150);
    Sticker1 = [[BabyStickerView alloc] initWithFrame:randFrame1];
    Sticker1.preventsPositionOutsideSuperview = NO;
    Sticker1.delegate = self;
    [self.stickerviewArray addObject:Sticker1];
    [Sticker1 release];

    
    [self.view addSubview:self.thumbnailListView];
    [self.view addSubview:self.babyBigAlbumsView];
    [self.view addSubview:Sticker];
    [self.view addSubview:Sticker1];
        
}


- (void)actionBtnBack
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//=================================================================================
#pragma mark - ThumbnailListViewDataSource
//=================================================================================
- (NSInteger)numberOfItemsInThumbnailListView:(ThumbnailListView*)thumbnailListView
{
    NSLog(@"%s",__func__);
    return 6;
}

- (UIImage*)thumbnailListView:(ThumbnailListView*)thumbnailListView
				 imageAtIndex:(NSInteger)index
{
    UIImage* thumbnailImage = [UIImage imageNamed:[NSString stringWithFormat:@"test_%03d",index+1]];
    
    return thumbnailImage;
}

//=================================================================================
#pragma mark - ThumbnailListViewDelegate
//=================================================================================
- (void)thumbnailListView:(ThumbnailListView*)thumbnailListView
		 didSelectAtIndex:(NSInteger)index
{
    UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"test_%03d",index+1]];
    self.babyBigAlbumsView.image = image;
}

//=================================================================================
#pragma mark - UIScrollViewDelegate
//=================================================================================
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if( decelerate == NO ){
        [self.thumbnailListView autoAdjustScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.thumbnailListView autoAdjustScroll];
}



- (void)stickerViewAddPhoto:(BabyStickerView *)sticker
{
    self.selectedSticker = sticker;
    UIImagePickerController *imagesPicker =  [[UIImagePickerController alloc]init];
    imagesPicker.delegate = self;
    imagesPicker.allowsEditing = NO;
    imagesPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:imagesPicker animated:NO];
    [imagesPicker release];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image!=nil) {
        self.selectedSticker.contentView = [[UIImageView alloc]initWithImage:image];
        [self.selectedSticker showEditingHandles ];
    }
    [self dismissModalViewControllerAnimated:NO];
    self.selectedSticker = nil;
}
- (void)finishEdit
{
    
}

@end































