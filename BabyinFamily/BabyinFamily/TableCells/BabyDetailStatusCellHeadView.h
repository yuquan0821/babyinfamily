//
//  BabyDetailStatusCellHeadView.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-8-2.
//
//

#import <UIKit/UIKit.h>
#import "Status.h"

@interface BabyDetailStatusCellHeadView : UIView
{
    Status *weibo;

}
@property (retain, nonatomic)Status   *weibo;
@property (retain, nonatomic) UILabel *commentCount;


@end
