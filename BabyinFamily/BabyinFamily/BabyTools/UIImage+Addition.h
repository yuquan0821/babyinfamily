//
//  UIImage+Addition.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-1-4.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)

/**
   来源与sourcekit的图片
 */
+ (UIImage*)imageWithSourceKit:(NSString *)imagename;
+ (UIImage *)imageBundleWithName:(NSString *)imgname BundleName:(NSString *)bundle ofType:(NSString *)imgtype;
+ (UIImage *)imageWithName:(NSString *)imgname;
+ (UIImage *)imageWithName:(NSString *)imgname ofType:(NSString *)imgtype;

@end