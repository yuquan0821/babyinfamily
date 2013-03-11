//
//  HotViewController.h
//  BabyinFamily
//
//  Created by dong quan on 12-11-8.
//
//

#import <UIKit/UIKit.h>
#import "CHStylizedView.h"

@interface HotViewController : UIViewController <CHStylizedViewDelegate>

{
    NSMutableArray *randomSizes;
    int page;
}

@property ( nonatomic ,retain) IBOutlet CHStylizedView *stylizedView;
@property (nonatomic,assign)float lastContentOffsetY;
@end