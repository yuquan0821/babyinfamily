//
//  HotViewController.h
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//

#import <UIKit/UIKit.h>
#import "Status.h"
#import "WeiBoMessageManager.h"
#import "HHNetDataCacheManager.h"
#import "ImageBrowser.h"
#import "SHKActivityIndicator.h"
#import "CoreDataManager.h"
#import "WaterflowView.h"

@interface HotViewController : UIViewController<WaterflowViewDelegate,WaterflowViewDatasource,UIScrollViewDelegate>
{
    int count;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;

    WaterflowView *flowView;
}
@property (nonatomic, retain)   NSMutableArray          *statuesArr;

@property (nonatomic, retain)   NSMutableDictionary     *imageDictionary;

@end
