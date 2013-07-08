//
//  StatusCoreDataItem.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-2-18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StatusCoreDataItem, UserCoreDataItem;

@interface StatusCoreDataItem : NSManagedObject

@property (nonatomic, retain) NSString * bmiddlePic;
@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, retain) NSNumber * createdAt;
@property (nonatomic, retain) NSNumber * favorited;
@property (nonatomic, retain) NSNumber * hasImage;
@property (nonatomic, retain) NSNumber * hasReply;
@property (nonatomic, retain) NSNumber * hasRetwitter;
@property (nonatomic, retain) NSNumber * haveRetwitterImage;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * inReplyToScreenName;
@property (nonatomic, retain) NSNumber * inReplyToStatusId;
@property (nonatomic, retain) NSNumber * inReplyToUserId;
@property (nonatomic, retain) NSNumber * isHomeLine;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * originalPic;
@property (nonatomic, retain) NSNumber * retweetsCount;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * sourceUrl;
@property (nonatomic, retain) NSNumber * statusId;
@property (nonatomic, retain) NSNumber * statusKey;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * thumbnailPic;
@property (nonatomic, retain) NSString * timestamp;
@property (nonatomic, retain) NSNumber * truncated;
@property (nonatomic, retain) NSNumber * unread;
@property (nonatomic, retain) StatusCoreDataItem *retweetedStatus;
@property (nonatomic, retain) UserCoreDataItem *user;

@end