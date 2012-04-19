//
//  FT2Data.m
//  FTLibrary2
//
//  Created by Francesco on 18/04/2012.
//  Copyright (c) 2012 Fuerteint.com. All rights reserved.
//

#import "FT2Data.h"
#import "FT2Error.h"



@implementation FT2Data

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

static dispatch_queue_t _queue = NULL;
static dispatch_queue_t _managedContextQueue = NULL;

static NSString * __managedObjectModelName;
static NSString * __databaseName;

#pragma mark --
#pragma mark - Init

- (id)init {
    // This class cannot be initialized without a managed object name
    NSAssert(nil, @"FT2Data initialized without Manajed Object Name, use initWithManagedObjectName: instead");
    return nil;
}

- (id)initWithManagedObjectName:(NSString *)managedObjectName {
    self = [super init];
    if (self) {
        NSAssert((managedObjectName || managedObjectName.length == 0), @"FT2Data initialized without Manajed Object Name");
        __managedObjectModelName = managedObjectName;
        __databaseName = [managedObjectName stringByAppendingString:@".sqlite"];
        _queue = dispatch_queue_create("com.fuerte.internetQueue",0); 
		_managedContextQueue = dispatch_queue_create("com.fuerte.managedContext",0); 
    }
    return self;
}

- (NSArray *)entitiesForName:(NSString *)entityName orderedBy:(NSString *)orderKey {
    __block NSArray *entities = nil;
    [self performBlockOnContextAndWait:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
        [request setEntity:entity];
        
        // Order by indexPath
        if (orderKey) {
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:orderKey ascending:YES selector:@selector(compare:)];
            [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            
        }
        
        // Execute the fetch
        NSError *error = nil;
        entities = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    }];
		
    return entities;
}






#pragma mark --
#pragma mark - Core Data stack

- (void)performBlockOnContext:(void (^)(void))block
{
	if (dispatch_get_current_queue() == _managedContextQueue) {
		block();
	}
	else {
		dispatch_async(_managedContextQueue, block);
	}
}

- (void)performBlockOnContextAndWait:(void (^)(void))block
{
	if (dispatch_get_current_queue() == _managedContextQueue) {
		block();
	}
	else {
		dispatch_sync(_managedContextQueue, block);
	}
}

/**
 Returns the managed object context for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:__managedObjectModelName withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:__databaseName];
    
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        
        NSLog(@"Unresolved error %@, %@\n\n", error, [error userInfo]);
        FT2Error *fterror = [FT2Error errorWithError:error];
        [fterror sendToFlurry];
        //abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext
{
	[self performBlockOnContextAndWait:^{
		NSError *error = nil;
		NSManagedObjectContext *aManagedObjectContext = self.managedObjectContext;
		if (aManagedObjectContext != nil)
		{
			BOOL isChanged = [aManagedObjectContext hasChanges];
			if (isChanged && ![aManagedObjectContext save:&error])
			{
				NSLog(@"Unresolved error %@, %@\n\n", error, [error userInfo]);
                FT2Error *fterror = [FT2Error errorWithError:error];
                [fterror sendToFlurry];
				//abort();
			} 
		}		
	}];
}

- (id)managedObjectFromName:(NSString *)entityName
{
	__block NSManagedObject *returnedEntity = nil;
	
	[self performBlockOnContextAndWait:^{
		returnedEntity = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
	}];
    return returnedEntity;
}



@end
