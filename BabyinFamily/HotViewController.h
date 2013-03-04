//
//  HotViewController.h
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//

#import <UIKit/UIKit.h>
#import "BDDynamicGridViewController.h"
@interface HotViewController : BDDynamicGridViewController <BDDynamicGridViewDelegate>{
    NSArray * _items;
}

@end