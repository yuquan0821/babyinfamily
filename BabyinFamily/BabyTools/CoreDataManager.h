//
//  CoreDataManager.h
//  BabyinFamily
//
//  Created by 范艳春 on 13-2-18.
//
//

#import <UIKit/UIKit.h>
#import "Images.h"
#import "UserCoreDataItem.h"
#import "StatusCoreDataItem.h"
#import "Status.h"

@interface CoreDataManager : NSObject
{
    NSManagedObjectContext         *_managedObjContext;
    NSManagedObjectModel           *_managedObjModel;
    NSPersistentStoreCoordinator   *_persistentStoreCoordinator;
}

@property (nonatomic,retain,readonly) NSManagedObjectContext         *managedObjContext;
@property (nonatomic,retain,readonly) NSManagedObjectModel           *managedObjModel;
@property (nonatomic,retain,readonly) NSPersistentStoreCoordinator   *persistentStoreCoordinator;

+ (CoreDataManager *) getInstance;
- (void)insertImageToCD:(NSData*)data url:(NSString*)url;
- (Images*)readImageFromCD:(NSString*)url;
- (void)insertStatusesToCD:(Status*)sts index:(int)theIndex isHomeLine:(BOOL) isHome;
- (NSArray*)readStatusesFromCD;
-(void)cleanEntityRecords:(NSString*)entityName;
@end
