//
//  AboutViewController.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-5-9.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize timer;
@synthesize coinview;
@synthesize counter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关于";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
BOOL didTimeOut = NO;

int      counter = 0;


- (IBAction)buttonPressed:(id)sender {
    if (!didTimeOut) {
        counter ++;
        [NSTimer scheduledTimerWithTimeInterval:1.0f
                                         target:self
                                       selector:@selector(timedOut)
                                       userInfo:nil
                                        repeats:NO
         ];
        if (counter == 5) {
            coinview = [[coinView alloc]initWithFrame:[[UIScreen mainScreen] bounds] withNum:arc4random() % 10000];
            coinview.coindelegate = self;
            [self.view addSubview:coinview];
        }
        
    } else  {
        if (didTimeOut) {
            counter = 0;
            didTimeOut = NO;
        }
    }
    
    
    NSLog(@"counter is %d",counter);
    
    
    //[self buttonClicked:bt];
    
}

- (void)timedOut {
    didTimeOut = YES;
}

-(void)coinAnimationFinished
{
    [coinview removeFromSuperview];
    coinview = nil;
}


- (void)dealloc
{
    [coinview release];
    //[counter rlease];
    [timer invalidate];
    timer =nil;
    [super dealloc];
    
}
@end
