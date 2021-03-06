#import "IntroModel.h"

@implementation IntroModel

@synthesize titleText;
@synthesize descriptionText;
@synthesize image;

- (id) initWithTitle:(NSString*)title description:(NSString*)desc image:(NSString*)imageText {
    self = [super init];
    if(self != nil) {
        self.titleText = title;
        self.descriptionText = desc;
        self.image = [UIImage imageNamed:imageText];
    }
    return self;
}

- (void)dealloc
{
    [titleText release];
    [descriptionText release];
    [image release];
    [super dealloc];
}

@end
