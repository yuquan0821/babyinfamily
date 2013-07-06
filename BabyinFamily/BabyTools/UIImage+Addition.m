//
//  UIImage+Addition.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-1-4.
//
//
#import "UIImage+Addition.h"

@implementation UIImage (Addition)

/**
 来源与sourcekit的图片
 */
+(UIImage*)imageWithSourceKit:(NSString *)imagename{
    NSString *fullpath = [NSString stringWithFormat:@"sourcekit.bundle/image/%@", imagename];
    return [UIImage imageNamed:fullpath];
}
@end