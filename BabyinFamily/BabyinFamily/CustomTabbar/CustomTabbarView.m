//
//  CustomTabbarView.m
//  Yunho2
//
//  Created by l on 13-6-4.
//
//

#import "CustomTabbarView.h"

@implementation CustomTabbarView
@synthesize tabbarView = _tabbarView;
@synthesize tabbarViewCenter = _tabbarViewCenter;
@synthesize button_1 = _button_1;
@synthesize button_2 = _button_2;
@synthesize button_3 = _button_3;
@synthesize button_4 = _button_4;
@synthesize button_center = _button_center;
@synthesize delegate;
@synthesize selectedButton;
- (void)dealloc
{
    [_tabbarView release];
    [_tabbarViewCenter release];
    [_button_1 release];
    [_button_2 release];
    [_button_3 release];
    [_button_4 release];
    [_button_center release];
    [selectedButton release];
    self.delegate = nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:frame];
        //        [self setBackgroundColor:[UIColor blueColor]];
        [self layoutView];
    }
    return self;
}

-(void)layoutView
{
    self.tabbarView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1_bg.png"]] autorelease];
    [_tabbarView setFrame:CGRectMake(0, 11, _tabbarView.bounds.size.width, 49)];
    [_tabbarView setUserInteractionEnabled:YES];
    
    self.tabbarViewCenter = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottom_m_bg.png"]] autorelease];
    _tabbarViewCenter.frame = CGRectMake(0, 0, 66, 60);
    _tabbarViewCenter.center = CGPointMake(self.center.x, self.bounds.size.height/2.0);
    
    [_tabbarViewCenter setUserInteractionEnabled:YES];
    
    self.button_center = [CustomBarButton buttonWithType:UIButtonTypeCustom];
    _button_center.adjustsImageWhenHighlighted = NO;
    [_button_center setImage:[UIImage imageNamed:@"box_grey.png"] forState:UIControlStateNormal];
    [_button_center setImage:[UIImage imageNamed:@"box_blue.png"] forState:UIControlStateSelected];
    //[_button_center setImage:[UIImage imageNamed:@"bottom_m_chick.png"] forState:UIControlStateHighlighted];
    [_button_center setFrame:CGRectMake(0, 0, 57, 50)];
    
    _button_center.center =CGPointMake(_tabbarViewCenter.bounds.size.width/2.0, _tabbarViewCenter.bounds.size.height/2.0) ;
    
    _button_center.tag = 105;
    [_button_center addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tabbarViewCenter addSubview:_button_center];
    
    [self addSubview:_tabbarView];
    [self addSubview:_tabbarViewCenter];
    
    [self layoutBtn];
    self.button_center.selected = YES;
    self.selectedButton = self.button_center;
    
}

-(void)layoutBtn
{
    self.button_1 = [CustomBarButton buttonWithType:UIButtonTypeCustom];
    //    [_button_1 setBackgroundColor:[UIColor blueColor]];
    [_button_1 setFrame:CGRectMake(0, 0, 64, 49)];
    [_button_1 setTag:101];
    [_button_1 setImage:[UIImage imageNamed:@"bottom_4nor.png"] forState:UIControlStateNormal];
    [_button_1 setImage:[UIImage imageNamed:@"bottom_4chick.png"] forState:UIControlStateSelected];
    [_button_1 setImage:[UIImage imageNamed:@"bottom_1chick.png"] forState:UIControlStateHighlighted];
    _button_1.contentMode = UIViewContentModeScaleAspectFit;
    _button_1.adjustsImageWhenHighlighted = NO;
    [_button_1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button_2 = [CustomBarButton buttonWithType:UIButtonTypeCustom];
    [_button_2 setFrame:CGRectMake(64, 0, 64, 49)];
    [_button_2 setTag:102];
    [_button_2 setImage:[UIImage imageNamed:@"bottom_4nor.png"] forState:UIControlStateNormal];
    [_button_2 setImage:[UIImage imageNamed:@"bottom_4chick.png"] forState:UIControlStateSelected];
    [_button_2 setImage:[UIImage imageNamed:@"bottom_2chick.png"] forState:UIControlStateHighlighted];
    _button_2.adjustsImageWhenHighlighted = NO;
    _button_2.contentMode = UIViewContentModeScaleAspectFit;
    [_button_2 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button_3 = [CustomBarButton buttonWithType:UIButtonTypeCustom];
    [_button_3 setFrame:CGRectMake(192, 0, 64, 49)];
    [_button_3 setTag:103];
    [_button_3 setImage:[UIImage imageNamed:@"bottom_4nor.png"] forState:UIControlStateNormal];
    [_button_3 setImage:[UIImage imageNamed:@"bottom_4chick.png"] forState:UIControlStateSelected];
    [_button_3 setImage:[UIImage imageNamed:@"bottom_3chick.png"] forState:UIControlStateHighlighted];
    _button_3.adjustsImageWhenHighlighted = NO;
    _button_3.contentMode = UIViewContentModeScaleAspectFit;
    [_button_3 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button_4 = [CustomBarButton buttonWithType:UIButtonTypeCustom];
    [_button_4 setFrame:CGRectMake(256, 0, 64, 49)];
    [_button_4 setTag:104];
    [_button_4 setImage:[UIImage imageNamed:@"bottom_4nor.png"] forState:UIControlStateNormal];
    [_button_4 setImage:[UIImage imageNamed:@"bottom_4chick.png"] forState:UIControlStateSelected];
    [_button_4 setImage:[UIImage imageNamed:@"bottom_4chick.png"] forState:UIControlStateHighlighted];
    _button_4.contentMode = UIViewContentModeScaleAspectFit;
    _button_4.adjustsImageWhenHighlighted = NO;
    [_button_4 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tabbarView addSubview:_button_1];
    [_tabbarView addSubview:_button_2];
    [_tabbarView addSubview:_button_3];
    [_tabbarView addSubview:_button_4];
    
}

-(void)btn1Click:(id)sender
{
    CustomBarButton *btn = (CustomBarButton *)sender;
    if (self.selectedButton != btn) {
        [self.button_1 setSelected:NO];
        [self.button_2 setSelected:NO];
        [self.button_center setSelected:NO];
        [self.button_3 setSelected:NO];
        [self.button_4 setSelected:NO];
        NSLog(@"%i",btn.tag);
        self.selectedButton = btn;
        switch (btn.tag) {
            case 101:
            {
                [self.delegate touchBtnAtIndex:0];
                
                break;
            }
            case 102:
            {
                [self.delegate touchBtnAtIndex:1];
                break;
            }
            case 103:
                [self.delegate touchBtnAtIndex:3];
                break;
            case 104:
                [self.delegate touchBtnAtIndex:4];
                break;
            
            default:
                break;
        }
    }
    
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
