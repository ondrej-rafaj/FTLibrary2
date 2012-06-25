//
//  FT2Data.h
//  FTLibrary2
//
//  Created by Francesco on 18/04/2012.
//  Copyright (c) 2012 Fuerteint.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FT2Data : NSObject {
    dispatch_queue_t _queue;
    dispatch_queue_t _managedContextQueue;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSMutableDictionary *storedObjects;
@property (nonatomic, strong) NSMutableArray *mediaInQueue;


- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

- (id)managedObjectFromName:(NSString *)entityName;

- (id)initWithManagedObjectName:(NSString *)managedObjectName;

- (NSArray *)entitiesForName:(NSString *)entityName orderedBy:(NSString *)orderKey;
- (NSArray *)entitiesForName:(NSString *)entityName withSortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)entitiesForName:(NSString *)entityName withPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors;

- (id)entityForName:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (id)entityForName:(NSString *)entityName withUID:(id)uid;

- (void)performBlockOnContext:(void (^)(void))block;
- (void)performBlockOnContextAndWait:(void (^)(void))block;

- (id)storedObjectForKey:(NSString *)key;
- (void)storeObject:(id)object forKey:(NSString *)key;

@end

