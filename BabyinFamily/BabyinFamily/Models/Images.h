//
//  Images.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-2-18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Images : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * url;

@end

