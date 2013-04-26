//
//  Utility.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-4-26.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <arpa/inet.h>

@interface Utility : NSObject {
    
}

+(NSString *)createMD5:(NSString *)params;
+(NSString *)createPostURL:(NSMutableDictionary *)params;
+(NSString *)getCurrentDate;
+(BOOL) connectedToNetwork;
+(BOOL) hostAvailable: (NSString *) theHost;
+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL)validateEmail:(NSString*)email;
+(BOOL)isValidateString:(NSString *)myString;

@end