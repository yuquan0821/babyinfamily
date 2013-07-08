//
//  BabyAlertWindow.h
//  BabyinFamily
//
//  Created by 范艳春 on 12-12-17.
//
//

@interface BabyAlertWindow : NSObject{
    UIWindow        *_window;
    UILabel         *_label;
    UIImage         *_backgroundImage;
    UIImageView     *_backgroundImageView;
    
    NSString        *_displayString;
}

@property (nonatomic,retain)UIWindow        *window;
@property (nonatomic,retain)UILabel         *label;
@property (nonatomic,retain)UIImage         *backgroundImage;
@property (nonatomic,retain)UIImageView     *backgroundImageView;
@property (nonatomic,copy)  NSString        *displayString;

+(BabyAlertWindow *)getInstance;

-(void)showWithString:(NSString*)string;
-(void)hide;

@end
