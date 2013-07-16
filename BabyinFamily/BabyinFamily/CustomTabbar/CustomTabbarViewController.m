//
//  CustomTabbarViewControllertomTabbarViewController.m
//  Yunho2
//
//  Created by l on 13-6-4.
//
//

#import "CustomTabbarViewController.h"


#import "CustomTabbarView.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface CustomTabbarViewController ()

@end

@implementation CustomTabbarViewController
@synthesize tabbar = _tabbar;
@synthesize arrayViewcontrollers = _arrayViewcontrollers;
@synthesize arrayBarButtons = _arrayBarButtons;
- (void)dealloc
{
    [_tabbar release];
    [_arrayViewcontrollers release];
    [_arrayBarButtons release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGFloat orginHeight = self.view.frame.size.height- 60;
    if (iPhone5) {
        orginHeight = self.view.frame.size.height- 60 + addHeight;
    }
    self.tabbar = [[[CustomTabbarView alloc]initWithFrame:CGRectMake(0,  orginHeight, 320, 60)] autorelease];
    _tabbar.delegate = self;
    [self.view addSubview:_tabbar];
    self.arrayBarButtons = [NSArray arrayWithObjects:_tabbar.button_1,_tabbar.button_2,_tabbar.button_center,_tabbar.button_3,_tabbar.button_4, nil];
    [self touchBtnAtIndex:1];
}
//3:自定义tabBar时候，由tabBarController管理的
//隐藏tabBar
- (void)hideTabBar:(BOOL)hidden{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    
    
    if (hidden) {
        [_tabbar setFrame:CGRectMake(_tabbar.frame.origin.x, iPhone5?568:480, _tabbar.frame.size.width, _tabbar.frame.size.height)];
        //[_tabbar setFrame:CGRectMake(0-320, _tabbar.frame.origin.y, _tabbar.frame.size.width, _tabbar.frame.size.height)];
    } else {
        [_tabbar setFrame:CGRectMake(_tabbar.frame.origin.x, iPhone5?568-80:480-80, _tabbar.frame.size.width, _tabbar.frame.size.height)];
        // [_tabbar setFrame:CGRectMake(0, _tabbar.frame.origin.y, _tabbar.frame.size.width, _tabbar.frame.size.height)];
    }
    
    [UIView commitAnimations];
}

-(void)removeBar
{
    [_tabbar removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchBtnAtIndex:(NSInteger)index
{
    UIViewController *viewController = [_arrayViewcontrollers objectAtIndex:index];
    if (viewController) {
        UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
        [currentView removeFromSuperview];
        
        CustomBarButton *btn = [self.arrayBarButtons objectAtIndex:index];
        for (CustomBarButton *tempBtn in self.arrayBarButtons) {
            if (tempBtn == btn) {
                tempBtn.selected = YES;
                self.tabbar.selectedButton = tempBtn;
            }else{
                tempBtn.selected = NO;
            }
        }
        
        
        viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
        viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
        
        [self.view insertSubview:viewController.view belowSubview:_tabbar];
    }
    
}


@end

