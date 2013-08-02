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
+ (UIImage *)imageBundleWithName:(NSString *)imagename BundleName:(NSString *)bundle ofType:(NSString *)imgtype
{
    NSString *fullpath = [NSString stringWithFormat:@"%@/images/%@.%@", bundle,imagename,imgtype];
    return [UIImage imageNamed:fullpath];
}
+ (UIImage *)imageWithName:(NSString *)imagename
{
	return [UIImage imageWithName:imagename ofType:@"png"];
}
+ (UIImage *)imageWithName:(NSString *)imagename ofType:(NSString *)imgtype
{
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imagename ofType:imgtype]];
}
@end