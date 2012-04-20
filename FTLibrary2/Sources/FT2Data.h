//
//  FT2Data.h
//  FTLibrary2
//
//  Created by Francesco on 18/04/2012.
//  Copyright (c) 2012 Fuerteint.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FT2Data : NSObject 

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

- (id)managedObjectFromName:(NSString *)entityName;

- (id)initWithManagedObjectName:(NSString *)managedObjectName;

- (NSArray *)entitiesForName:(NSString *)entityName orderedBy:(NSString *)orderKey;
- (NSArray *)entitiesForName:(NSString *)entityName withSortDescriptors:(NSArray *)sortDescriptors;

- (id)entityForName:(NSString *)entityName withPredicate:(NSPredicate *)predicate;

- (void)performBlockOnContext:(void (^)(void))block;
- (void)performBlockOnContextAndWait:(void (^)(void))block;



@end
