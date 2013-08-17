//
//  BabyPostImageViewController.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-8-17.
//
//

#import "BabyPostImageViewController.h"

@interface BabyPostImageViewController ()

@end

@implementation BabyPostImageViewController

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
	// Do any additional setup after loading the view.
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(actionBtnBack)];
    self.navigationItem.leftBarButtonItem = btnBack;
    [btnBack release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)actionBtnBack
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
