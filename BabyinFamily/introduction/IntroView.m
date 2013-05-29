#import "IntroView.h"

@implementation IntroView

- (id)initWithFrame:(CGRect)frame model:(IntroModel*)model
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setText:model.titleText];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [titleLabel setShadowColor:[UIColor blackColor]];
        [titleLabel setShadowOffset:CGSizeMake(1, 1)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel sizeToFit];
        [titleLabel setCenter:CGPointMake(frame.size.width/2, frame.size.height-145)];
        [self addSubview:titleLabel];
        [titleLabel release];
       
        float x = DEVICE_IS_IPHONE5 ? 420 : 330;
        UITextView *descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(40, x + 5, 240, 60)];
        descriptionTextView.scrollEnabled = NO;
        descriptionTextView.backgroundColor = [UIColor clearColor];
        descriptionTextView.textAlignment = NSTextAlignmentLeft;
        descriptionTextView.textColor = [UIColor whiteColor];
        descriptionTextView.font = [UIFont boldSystemFontOfSize:16.0f];
        descriptionTextView.text = model.descriptionText;

        descriptionTextView.editable = NO;
        descriptionTextView.userInteractionEnabled = NO;
        [self addSubview:descriptionTextView];
        [descriptionTextView release];
     
    }
    return self;
}
@end
