//
//  FT2Data.m
//  FTLibrary2
//
//  Created by Francesco on 18/04/2012.
//  Copyright (c) 2012 Fuerteint.com. All rights reserved.
//

#import "FT2Data.h"
#import "FT2Error.h"
#import "FT2FileSystem.h"


@implementation FT2Data

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize storedObjects = _storedObjects;
@synthesize mediaInQueue = _mediaInQueue;

static dispatch_queue_t _queue = NULL;
static dispatch_queue_t _managedContextQueue = NULL;

static NSString * __managedObjectModelName;
static NSString * __databaseName;

#pragma mark --
#pragma mark - Init

- (void)removeMediaInQueueObject:(id)object {
    [_mediaInQueue removeObject:object];
    if (_mediaInQueue.count == 0) {
        [self saveContext];
    }
}

- (id)init {
    // This class cannot be initialized without a managed object name
    NSAssert(nil, @"FT2Data initialized without Manajed Object Name, use initWithManagedObjectName: instead");
    return nil;
}

- (id)initWithManagedObjectName:(NSString *)managedObjectName {
    self = [super init];
    if (self) {
        //init Core Data
        NSAssert((managedObjectName || managedObjectName.length == 0), @"FT2Data initialized without Manajed Object Name");
        __managedObjectModelName = managedObjectName;
        __databaseName = [managedObjectName stringByAppendingString:@".sqlite"];

        
        //init queues
        _queue = dispatch_queue_create("com.fuerte.internetQueue",0); 
		_managedContextQueue = dispatch_queue_create("com.fuerte.managedContext",0); 

    }
    return self;
}

- (NSArray *)entitiesForName:(NSString *)entityName withSortDescriptors:(NSArray *)sortDescriptors {
    __block NSArray *entities = nil;
    [self performBlockOnContextAndWait:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
        
        if (!entity && entityName.length > 2) {
            NSString *pathName = [entityName stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
            entity = [NSEntityDescription entityForName:pathName inManagedObjectContext:[self managedObjectContext]];
        }
        [request setEntity:entity];
        
        // Order by indexPath
        if (sortDescriptors && sortDescriptors.count > 0) {
            [request setSortDescriptors:sortDescriptors];
        }
        
        // Execute the fetch
        NSError *error = nil;
        entities = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    }];
    
    return entities;
}

- (NSArray *)entitiesForName:(NSString *)entityName orderedBy:(NSString *)orderKey {
    NSArray *descriptors = nil;
    if (orderKey && orderKey.length > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:orderKey ascending:YES selector:@selector(compare:)];
        descriptors = [NSArray arrayWithObject:sortDescriptor];
    }
    return [self entitiesForName:entityName withSortDescriptors:descriptors];
}


- (id)entityForName:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
    __block NSManagedObject *entity = nil;
    [self performBlockOnContextAndWait:^{
        
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
        
        if (!predicate) {
            entity = [[NSManagedObject alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:self.managedObjectContext];
            return;
        }
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        [request setPredicate:predicate];
        [request setFetchLimit:1];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *entities = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
        if (entities.count > 0) entity = [entities objectAtIndex:0];
        else entity = [[NSManagedObject alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:self.managedObjectContext];
    }];

    return entity;
}

- (id)entityForName:(NSString *)entityName withUID:(id)uid {
    static NSString *uidKey = @"uid";
    NSString *stringUID = ([uid isKindOfClass:[NSNumber class]])? [(NSNumber *)uid stringValue] : uid;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", uidKey, stringUID];
    id entity = [self entityForName:entityName withPredicate:predicate];

    if (![[entity valueForKey:uidKey] isEqual:stringUID]) {
        [entity setValue:stringUID forKey:uidKey];
    }
    return entity;
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
    if (__managedObjectContext != nil) return __managedObjectContext;
    
    [self performBlockOnContextAndWait:^{
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil)
        {
            __managedObjectContext = [[NSManagedObjectContext alloc] init];
            [__managedObjectContext setPersistentStoreCoordinator:coordinator];
        }    
    }];
    
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
    [self performBlockOnContextAndWait:^{
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:__managedObjectModelName withExtension:@"momd"];
        __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }];
    
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
    
    [self performBlockOnContextAndWait:^{
        
        //copy database if first time
        NSString *dbBundlePath = [FT2FileSystem pathForFileName:__databaseName checkBundleFirst:YES forDirectoryType:NSDocumentDirectory];        
        NSString *dbDocPath = [FT2FileSystem pathForFileName:__databaseName checkBundleFirst:NO forDirectoryType:NSDocumentDirectory];
        if (![FT2FileSystem existsAtPath:dbDocPath] && [FT2FileSystem existsAtPath:dbBundlePath]) {
            NSError *error;
            [FT2FileSystem writeData:[FT2FileSystem dataFromDocumentsWithName:dbBundlePath checkBundleFirst:YES]
                            withName:__databaseName
                    forDirectoryType:NSDocumentDirectory
                               error:&error];
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
    }];
    
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


#pragma mark --
#pragma mark stored object

/**
 *  wrapper to easely save data to sandboxed NSUserDefaults
 *  Use storedObjectForKey: and storeObject:forKey: for retrieve and set data
 *  Example:
 *      [self storeObejct:@"sometext" forKey:@"aKey"];
 *      NSString *text = [self storedObjectForKey:@"aKey"];
 */

static NSString *_storedObjectKey = @"FTStoredObjectKey";

- (NSMutableDictionary *)storedObjects {
    if (!_storedObjects) _storedObjects = [[NSUserDefaults standardUserDefaults] objectForKey:_storedObjectKey];
    if (!_storedObjects) _storedObjects = [NSMutableDictionary dictionary];
    return _storedObjects;

}

- (id)storedObjectForKey:(NSString *)key {
    return [self.storedObjects objectForKey:key];
}

- (void)storeObejct:(id)object forKey:(NSString *)key {
    [self.storedObjects setObject:object forKey:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.storedObjects forKey:_storedObjectKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
