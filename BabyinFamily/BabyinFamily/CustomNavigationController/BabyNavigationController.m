//
//  BabyNavigationController.m
//  BabyinFamily
//
//  Created by dong quan on 13-7-6.
//
//

#import "BabyNavigationController.h"

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define BackGesture_Mindistance  80
@interface BabyNavigationController ()
{
    CGPoint startTouch;
}
@end

@implementation BabyNavigationController

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
    UIImage *navBackgroundImage = [UIImage imageWithSourceKit:@"TabBar/bg_NavigationBar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    // Change UINavigationBar appearance by setting the font, color, shadow and offset.
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          
                                                          [UIColor colorWithRed:85.0 / 255.0 green:154.0 / 255.0 blue:26.0 / 255.0 alpha:1.0], UITextAttributeTextColor,
                                                          
                                                          [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8], UITextAttributeTextShadowColor,
                                                          
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                          
                                                  [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0] , UITextAttributeFont,
                                                          
                                                          nil]];
    
    // Change the UIBarButtonItem apperance by setting a resizable background image for the back button.
    UIImage *backButtonImage = [[UIImage imageWithSourceKit:@"1TabBar/navigationBarBackButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor colorWithRed:0.45 green:0.60 blue:0.16 alpha:1.0]];
    
    // Change the UIBarButtonItem apperance by setting a resizable background image for the edit button.
    UIEdgeInsets insets = {0, 6, 0, 6};// Same as doing this: UIEdgeInsetsMake (top, left, bottom, right)
    UIImage *barButtonImage = [[UIImage imageNamed:@"button_normal"] resizableImageWithCapInsets:insets];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIPanGestureRecognizer *recognizer = [[[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(paningGestureReceive:)]autorelease];
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
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
