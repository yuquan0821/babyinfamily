//
//  HomeViewController.m
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"主页";
        NSString *fullpath = [NSString stringWithFormat:@"sourcekit.bundle/image/%@", @"tabbar_home"];
        self.tabBarItem.image = [UIImage imageNamed:fullpath];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
