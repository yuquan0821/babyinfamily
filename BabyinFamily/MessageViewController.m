//
//  MessageViewController.m
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//

#import "MessageViewController.h"

@interface MessageViewController ()
@property(nonatomic,retain)UITableView *tableview;
@property(nonatomic,retain)NSMutableArray *datasource;

- (void)dispachModelToDatasource;

@end

@implementation MessageViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"消息";
        NSString *fullpath = [NSString stringWithFormat:@"sourcekit.bundle/image/%@", @"tabbar_msg"];
        self.tabBarItem.image = [UIImage imageNamed:fullpath];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
}

- (void)dispatchModelToDatasource:(NSArray *)statusarray{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [_tableview release];
    [_datasource release];
}
#pragma mark
#pragma Lazyload
- (UITableView*)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    return _tableview;
}
- (NSMutableArray*)datasource{
    if (!_datasource) {
        _datasource = [[NSMutableArray array] retain];
    }
    return _datasource;
}

@end
