//
//  HotViewController.h
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//

#import <UIKit/UIKit.h>
#import "CHStylizedView.h"
#import "Status.h"
#import "WeiBoMessageManager.h"
#import "HHNetDataCacheManager.h"
#import "ImageBrowser.h"
#import "SHKActivityIndicator.h"
#import "CoreDataManager.h"




@class WeiBoMessageManager;

@interface HotViewController : UIViewController <CHStylizedViewDelegate>

{
    WeiBoHttpManager *manager;
    NSNotificationCenter *defaultNotifCenter;

    NSMutableArray *randomSizes;
    long long _maxID;

    int page;
}

@property ( nonatomic ,retain) IBOutlet CHStylizedView *stylizedView;
@property (nonatomic, retain)   NSMutableArray          *statuesArr;
@property (nonatomic,assign)float lastContentOffsetY;
@property (nonatomic, retain)   ImageBrowser            *browserView;


@end