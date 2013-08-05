//
//  BabyPostViewController.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-30.
//
//

#import "BabyPostViewController.h"
#import "Status.h"
#import "SHKActivityIndicator.h"

@interface BabyPostViewController ()

@end

@implementation BabyPostViewController
@synthesize textView;
@synthesize toolBar;
@synthesize date;
@synthesize btnDatePicker;

- (void)dealloc
{
    [self.textView dealloc];
    [self.toolBar dealloc];
    [self.btnDatePicker dealloc];
    [self.date dealloc];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"记录";
        keyboardIsShow=YES;
        self.view.backgroundColor = [UIColor whiteColor];
        manager = [WeiBoMessageManager getInstance];        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(actionBtnBack)];
    self.navigationItem.leftBarButtonItem = btnBack;
    [btnBack release];

    textView = [[BabyPlaceHolderTextView alloc]initWithFrame:CGRectMake(0, 6, 320, 115)];
    textView.scrollEnabled = YES;
    textView.backgroundColor = [UIColor whiteColor];
    [self.textView setPlaceholderText:@"记录宝宝的美丽瞬间，从这里开始！"];
    self.textView.delegate= self;
    self.textView.font = [UIFont systemFontOfSize:13.0f];
    [self.textView becomeFirstResponder];
    //  [self.textView setReturnKeyType:UIReturnKeySend];
    [self.view addSubview:textView];
    
    btnDatePicker = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDatePicker.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    self.date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy年MM月dd日"];
    btnDatePicker.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [btnDatePicker setTitle:[df stringFromDate:self.date] forState:UIControlStateNormal];
    [self.view addSubview:btnDatePicker];
    
    /* UIView *dateview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - KEYBOARDHEIGHT, 300, 220)];
     [btnDatePicker handleControlEvents:UIControlEventTouchUpInside withBlock:^(void){
     toolBar.frame = CGRectMake(0,  self.view.bounds.size.height - TOOLBARHEIGHT - KEYBOARDHEIGHT, toolBar.frame.size.width, toolBar.frame.size.height);
     dateview.hidden = NO;
     
     if (keyboardIsShow == YES) {
     [self dismissKeyBoard];
     
     }else
     {
     
     }
     [[UIDatePickerCtrl shareInstance] showDatePicker:YES date:[NSDate date] parent:dateview delegate:self selector:@selector(updateDate:)];
     }];
     
     [self.view addSubview:dateview];
     dateview.hidden = YES;*/
    //添加toolBar
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,self.view.bounds.size.height - TOOLBARHEIGHT - KEYBOARDHEIGHT,self.view.bounds.size.width,TOOLBARHEIGHT)];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    UIEdgeInsets insets = UIEdgeInsetsMake(40, 0, 40, 0);
    [toolBar setBackgroundImage:[[UIImage imageNamed:@"keyBoardBack"] resizableImageWithCapInsets:insets] forToolbarPosition:0 barMetrics:0];
    [toolBar setBarStyle:UIBarStyleBlack];
    
    //第一次按钮（备用），目前不显示
    btnFirstTime = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFirstTime.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    [btnFirstTime setBackgroundImage:[UIImage imageNamed:@"Voice"] forState:UIControlStateNormal];
    [btnFirstTime addTarget:self action:@selector(disFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
    btnFirstTime.frame = CGRectMake(5,toolBar.bounds.size.height-38.0f,BUTTONWH + 50,BUTTONWH);
    btnFirstTime.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btnFirstTime setTitle:@"第一次" forState:UIControlStateNormal];
    btnFirstTime.hidden = YES;
    [toolBar addSubview:btnFirstTime];
    
    //@按钮
    btnAtSomeOne = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAtSomeOne.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    [btnAtSomeOne setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    [btnAtSomeOne addTarget:self action:@selector(goToAtSomeBody) forControlEvents:UIControlEventTouchUpInside];
    btnAtSomeOne.frame = CGRectMake(btnFirstTime.frame.origin.x + btnFirstTime.frame.size.width + 50,toolBar.bounds.size.height-38.0f,BUTTONWH,BUTTONWH);
    btnAtSomeOne.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [btnAtSomeOne setTitle:@"@" forState:UIControlStateNormal];
    [toolBar addSubview:btnAtSomeOne];
    
    //地址按钮
    btnLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLocation.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    [btnLocation addTarget:self action:@selector(getLocations) forControlEvents:UIControlEventTouchUpInside];
    btnLocation.frame = CGRectMake(btnAtSomeOne.frame.origin.x + btnAtSomeOne.frame.size.width + 30,toolBar.bounds.size.height-38.0f,BUTTONWH + 5,BUTTONWH);
    btnLocation.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btnLocation setTitle:@"地址" forState:UIControlStateNormal];
    [toolBar addSubview:btnLocation];
    
    //发送按钮
    btnSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnSend.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    btnSend.enabled=NO;
    [btnSend addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    btnSend.frame = CGRectMake(btnLocation.frame.origin.x + btnLocation.frame.size.width +30,toolBar.bounds.size.height-38.0f,BUTTONWH + 5,BUTTONWH);
    btnSend.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [toolBar addSubview:btnSend];

    //创建第一次键盘，（备用）
    if (scrollView==nil) {
        scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, KEYBOARDHEIGHT)];
        [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
        for (int i=0; i<9; i++) {
            /* FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+320*i, 15, facialViewWidth, facialViewHeight)];
             [fview setBackgroundColor:[UIColor clearColor]];
             [fview loadFacialView:i size:CGSizeMake(33, 43)];
             fview.delegate=self;
             [scrollView addSubview:fview];
             [fview release];*/
        }
    }
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    scrollView.contentSize=CGSizeMake(320*9, KEYBOARDHEIGHT);
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    [scrollView release];
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(98, self.view.frame.size.height-120, 150, 30)];
    [pageControl setCurrentPage:0];
    // pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
    //pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
    pageControl.numberOfPages = 9;//指定页面个数
    [pageControl setBackgroundColor:[UIColor clearColor]];
    pageControl.hidden=YES;
    [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    [pageControl release];
    [self.view addSubview:toolBar];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
    pageControl.currentPage = page;//pagecontroll响应值的变化
}
//pagecontroll的委托方法

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;//获取当前pagecontroll的值
    [scrollView setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}


- (void)actionBtnBack
{
    [self dismissModalViewControllerAnimated:YES ];
    [self retain];
    [self release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //给键盘注册通知

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPost:) name:MMSinaGotPostResult object:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    //给键盘注册通知

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // Remove all observer.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)updateDate:(NSString *)update
{
    NSString *selectDate = [NSString stringWithFormat:@"%@", update];
    [btnDatePicker setTitle:selectDate forState:UIControlStateNormal];
}


//备用

-(void)disFaceKeyboard{
    //如果直接点击表情，通过toolbar的位置来判断
    if (toolBar.frame.origin.y== self.view.bounds.size.height - TOOLBARHEIGHT&&toolBar.frame.size.height==TOOLBARHEIGHT) {
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.view.frame.size.height-KEYBOARDHEIGHT-TOOLBARHEIGHT,  self.view.bounds.size.width,TOOLBARHEIGHT);
        }];
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.view.frame.size.height-KEYBOARDHEIGHT,self.view.frame.size.width, KEYBOARDHEIGHT)];
        }];
        [pageControl setHidden:NO];
        [btnFirstTime setBackgroundImage:[UIImage imageNamed:@"Text"] forState:UIControlStateNormal];
        return;
    }
    //如果键盘没有显示，点击表情了，隐藏表情，显示键盘
    if (!keyboardIsShow) {
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.view.frame.size.height , self.view.frame.size.width, KEYBOARDHEIGHT)];
        }];
        [textView becomeFirstResponder];
        [pageControl setHidden:YES];
        
    }else{
        
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.view.frame.size.height-KEYBOARDHEIGHT-toolBar.frame.size.height,  self.view.bounds.size.width,toolBar.frame.size.height);
        }];
        
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.view.frame.size.height-KEYBOARDHEIGHT,self.view.frame.size.width, KEYBOARDHEIGHT)];
        }];
        [pageControl setHidden:NO];
        [textView resignFirstResponder];
    }
    
}

#pragma mark 隐藏键盘
-(void)dismissKeyBoard{
    //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
    [UIView animateWithDuration:Time animations:^{
        toolBar.frame = CGRectMake(0, self.view.frame.size.height-KEYBOARDHEIGHT-toolBar.frame.size.height,  self.view.bounds.size.width,toolBar.frame.size.height);
    }];
    
    [UIView animateWithDuration:Time animations:^{
        [scrollView setFrame:CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width, KEYBOARDHEIGHT)];
    }];
    [pageControl setHidden:YES];
    [textView resignFirstResponder];
    [btnFirstTime setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
}
#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    
    // Get KeyBoard CGRect.
    NSDictionary *info = [notification userInfo];
    NSValue *keyValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [keyValue CGRectValue].size;
    
    // New toolBar position.
    NSInteger toolBarY = self.view.frame.size.height - keyboardSize.height - toolBar.frame.size.height;
    NSLog(@"toolBarY: %d", toolBarY);
    
    // Set new position to textView.
    textView.frame = CGRectMake(0, 0, textView.frame.size.width, toolBarY - 30);
    btnDatePicker.frame = CGRectMake(10, toolBarY - 25, 100, 20);
    
    // Set new position to toolBar.
    toolBar.frame = CGRectMake(0, toolBarY, toolBar.frame.size.width, toolBar.frame.size.height);
    
    keyboardIsShow=YES;
    [pageControl setHidden:YES];
}
-(void)inputKeyboardWillHide:(NSNotification *)notification{
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    keyboardIsShow=YES;

}

//跳转到At页面
- (void)goToAtSomeBody
{
    BabyAtTableViewController *babyAt = [[BabyAtTableViewController alloc] initWithStyle:UITableViewStylePlain];
    babyAt.delegate = self;
    [self.navigationController pushViewController:babyAt animated:YES];
    [babyAt release];
}
-(void)atTableViewControllerCellDidClickedWithScreenName:(NSString*)name
{
    textView.text = [textView.text stringByAppendingFormat:@"@%@",name];
}
//跳转到At页面
-(void)getLocations
{
    BabyPositionViewController *babyPosition = [[BabyPositionViewController alloc] init];
    babyPosition.hidesBottomBarWhenPushed = YES;
    babyPosition.delegate = self;
    [self.navigationController pushViewController:babyPosition animated:YES];
    [babyPosition release];
    
}
-(void)poisCellDidSelected:(POI *)poi
{
    textView.text = [textView.text stringByAppendingFormat:@"我在这里：#%@#",poi.title];
}
#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textV
{
    if (textV.text.length == 0) {
        btnSend.enabled = NO;
    }
    else {
        btnSend.enabled = YES;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textV
{
    NSString *temp = textV.text;
    if (temp.length != 0) {
        btnSend.enabled = YES;
    }
    else {
        btnSend.enabled = NO;
    }
    
    if (temp.length > 140) {
        textView.text = [temp substringToIndex:140];
    }
  //  countLabel.text = [NSString stringWithFormat:@"%d",140 - textView.text.length];
}
#pragma mark - Tool Methods

- (void)send:(id)sender
{
    NSString *content = textView.text;
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        if (content != nil && [content length] != 0)
        {
            [manager postWithText:content];
            [[SHKActivityIndicator currentIndicator] displayActivity:@"发送中，请稍后..." inView:self.view];

        }
    }
}

-(void)didPost:(NSNotification*)sender
{
    Status *sts = sender.object;
    if (sts.text != nil && [sts.text length] != 0) {
        [[SHKActivityIndicator currentIndicator] hide];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [[SHKActivityIndicator currentIndicator] hide];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    }
}

@end
