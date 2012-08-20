//
//  FTData.h
//  Skoda
//
//  Created by Baldoph Pourprix on 05/07/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FT2Data : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) BOOL useiOS5PrivateQueue;

- (id)initWithModelName:(NSString *)name;

- (void)saveContext;

/* Call this method before making several changes on the context, like inserting a new object, or
 * changing the values of properties of managed objects */
- (void)beginBatchChanges;

/* Call after the changes have been made. This method implicitely save the context */
- (void)endBatchChanges;

- (void)createNewObjectForEntityName:(NSString *)name setupBlock:(void (^)(NSManagedObject *object))setupBlock;

/* the completionBlock returns object IDs. You can call the convenient method - managedObjectForIDs: or
 * get your managed object as you need them (might be a good solution in case you've got a lot of them */
- (void)executeFetchRequest:(NSFetchRequest *)request completionBlock:(void (^)(NSArray *resultsObjectsIds))completionBlock;

- (NSArray *)managedObjectForIDs:(NSArray *)objectIDs;

- (void)deleteManagedObject:(NSManagedObject *)object;

- (void)deleteDatabase;

@end
