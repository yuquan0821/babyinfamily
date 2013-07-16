//
//  CustomNavViewController.m
//  Yunho2
//
//  Created by l on 13-6-4.
//
//

#import "CustomNavViewController.h"
#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define BackGesture_Mindistance  50

@interface CustomNavViewController ()
{
    CGPoint startTouch;
    
}

@end

@implementation CustomNavViewController
@synthesize flagArray;
@synthesize tabbarViewController;
- (void)dealloc
{
    self.flagArray = nil;
    self.tabbarViewController = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.canDragBack = YES;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *navBackgroundImage = [UIImage imageNamed:@"header_bg"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    // Change UINavigationBar appearance by setting the font, color, shadow and offset.
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          
                                                          [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0], UITextAttributeTextColor,
                                                          
                                                          [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8], UITextAttributeTextShadowColor,
                                                          
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                          
                                                          [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], UITextAttributeFont,
                                                          
                                                          nil]];
    
    // Change the UIBarButtonItem apperance by setting a resizable background image for the back button.
    UIImage *backButtonImage = [[UIImage imageNamed:@"navigationBarBackButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // Change the UIBarButtonItem apperance by setting a resizable background image for the edit button.
    UIEdgeInsets insets = {0, 6, 0, 6};// Same as doing this: UIEdgeInsetsMake (top, left, bottom, right)
    UIImage *barButtonImage = [[UIImage imageNamed:@"button_normal"] resizableImageWithCapInsets:insets];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIPanGestureRecognizer *recognizer = [[[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(paningGestureReceive:)]autorelease];
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
    self.flagArray = [NSMutableArray arrayWithCapacity:0];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated tabbarHidden:(BOOL)hidden
{
    [self.tabbarViewController hideTabBar:hidden];
    [self.flagArray addObject:[NSNumber numberWithBool:hidden]];
    [super pushViewController:viewController animated:animated];
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    [self.tabbarViewController hideTabBar:YES];
    [self.flagArray addObject:[NSNumber numberWithBool:YES]];
    [super pushViewController:viewController animated:animated];
}
-(void)popToRootViewControllerAnimated:(BOOL)animated
{
    [self.tabbarViewController hideTabBar:NO];
    [self.flagArray removeAllObjects];
    [super popToRootViewControllerAnimated:animated];
}

-(void)popViewControllerAnimated:(BOOL)animated
{
    if (self.flagArray.count == 1) {
        [self.tabbarViewController hideTabBar:NO];
    }else if (self.flagArray.count > 1){
        NSNumber *tempNum = [self.flagArray objectAtIndex:self.flagArray.count-2];
        BOOL hidden = [tempNum boolValue];
        [self.tabbarViewController hideTabBar:hidden];
    }
    [self.flagArray removeLastObject];
    [super popViewControllerAnimated:animated];
}
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        startTouch = touchPoint;
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > BackGesture_Mindistance)
        {
            [self popViewControllerAnimated:YES];
        }
        else
        {
            
        }
        return;
        
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
