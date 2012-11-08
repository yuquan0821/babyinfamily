//
//  ProfileViewController.m
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"我的";
        NSString *fullpath = [NSString stringWithFormat:@"sourcekit.bundle/image/%@", @"tabbar_profile"];
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
