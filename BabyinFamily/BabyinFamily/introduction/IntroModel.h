#import <Foundation/Foundation.h>

@interface IntroModel : NSObject

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *descriptionText;
@property (nonatomic, retain) UIImage *image;

- (id) initWithTitle:(NSString*)title description:(NSString*)desc image:(NSString*)imageText;

@end
