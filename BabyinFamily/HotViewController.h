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
#import "WaterFlowView.h"
#import "ImageViewCell.h"

@interface HotViewController : UIViewController<WaterFlowViewDelegate,WaterFlowViewDataSource,UIScrollViewDelegate>
{
    int count;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    
    WaterFlowView *waterFlow;
}
@property (nonatomic, retain)   NSMutableArray          *statuesArr;

@property (nonatomic, retain)   NSMutableDictionary     *imageDictionary;

@end