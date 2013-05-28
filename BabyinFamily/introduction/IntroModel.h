#import <Foundation/Foundation.h>

@interface IntroModel : NSObject

@property (nonatomic, retain) NSString *titleText;
@property (nonatomic, retain) NSString *descriptionText;
@property (nonatomic, retain) UIImage *image;

- (id) initWithTitle:(NSString*)title description:(NSString*)desc image:(NSString*)imageText;

@end
