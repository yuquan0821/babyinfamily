//
//  BabyPositionViewController.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-30.
//
//

#import <UIKit/UIKit.h>
#import "POI.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "WeiBoMessageManager.h"

@protocol BabyPositionViewControllerDelegate <NSObject>

-(void)poisCellDidSelected:(POI*)poi;

@end

@interface BabyPositionViewController : UITableViewController<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    
    CLLocationCoordinate2D _coordinate;
    WeiBoMessageManager *_manager;
    NSArray *_poisArr;
    id<BabyPositionViewControllerDelegate> _delegate;
}

@property (nonatomic,retain)CLLocationManager *locationManager;

@property (nonatomic,assign)CLLocationCoordinate2D coordinate;
@property (nonatomic,assign)id<BabyPositionViewControllerDelegate> delegate;

@end
