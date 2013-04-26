//
//  FTData.m
//  Skoda
//
//  Created by Baldoph Pourprix on 05/07/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FT2Data.h"
#import "FT2FileSystem.h"

@interface FT2Data () {
	
	NSString *_modelName;
	dispatch_queue_t _privateQueue;
	NSInteger _currentChangingTaskCount;
	NSManagedObjectContext *_privateContextObject;
}

@property (strong, getter = isPerformingBatchChanges) NSNumber *performingBatchChanges;

/* changing tasks change the private managed object context and call save context at the end of
 * their execution */
- (void)performChangingTaskInPrivateQueue:(void (^)(void))block;

- (void)performBlockInPrivateQueue:(void (^)(void))block;

- (void)savePrivateContext;

- (NSManagedObjectContext *)privateContextObject;

@end

@implementation FT2Data 

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize performingBatchChanges = _performingBatchChanges;
@synthesize useiOS5PrivateQueue = _useiOS5PrivateQueue;

#pragma mark - Private Core Data stack

- (void)performChangingTaskInPrivateQueue:(void (^)(void))block
{
	dispatch_async(_privateQueue, ^{
		
		@synchronized(self) {
			_currentChangingTaskCount++;
		}

		block();
		@synchronized(self) {
			_currentChangingTaskCount++;
			if (_currentChangingTaskCount == 0 && !self.isPerformingBatchChanges.boolValue) {
				//no more tasks are queued and this was a single task (not batching) or batching is over (possible cos set in the main queue)
				[self savePrivateContext];
			}
		}
	});
}

- (void)performBlockInPrivateQueue:(void (^)(void))block
{
	dispatch_async(_privateQueue, block);
}

/* can only be called in the private queue */
- (NSManagedObjectContext *)privateContextObject
{
	if (_privateContextObject == nil) {
		NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
		if (coordinator != nil)
		{
			_privateContextObject = [[NSManagedObjectContext alloc] init];
			_privateContextObject.persistentStoreCoordinator = coordinator;
		}
		
	}
	return _privateContextObject;
}

/* can only be called in the private queue */

- (void)savePrivateContext
{
	NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.privateContextObject;
    if (managedObjectContext != nil) {
		if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		} 
    }
}

#pragma mark - Object lifecycle

- (id)initWithModelName:(NSString *)name
{
	self = [super init];
	if (self) {
		_modelName = name;
		self.useiOS5PrivateQueue = NO;
	}
	return self;
}

- (void)setUseiOS5PrivateQueue:(BOOL)useiOS5PrivateQueue
{
	_useiOS5PrivateQueue = useiOS5PrivateQueue;
	if (_useiOS5PrivateQueue) {
		if (_privateQueue) dispatch_release(_privateQueue);
		_privateQueue = NULL;
		[[NSNotificationCenter defaultCenter] removeObserver:self];
	} else {
		if (_privateQueue == NULL) _privateQueue = dispatch_queue_create("com.fuerteint.FTData.private", 0);
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
	}
	self.managedObjectContext = nil;
}

- (void)managedObjectContextDidSaveNotification:(NSNotification *)n
{
	dispatch_async(dispatch_get_main_queue(), ^{
		if (n.object == self.managedObjectContext) {
			//the public context has just saved new content, we update the private context
			[self performBlockInPrivateQueue:^{
				[self.privateContextObject mergeChangesFromContextDidSaveNotification:n];
			}];
		} else {
			[self.managedObjectContext mergeChangesFromContextDidSaveNotification:n];
		}
	});
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	if (_privateQueue) dispatch_release(_privateQueue);
}

#pragma mark - Core Data business

- (void)beginBatchChanges
{
	self.performingBatchChanges = [NSNumber numberWithBool:YES];
}

/* Call after the changes have been made. This method implicitely save the context */
- (void)endBatchChanges
{
	if (self.isPerformingBatchChanges.boolValue == NO) {
		NSLog(@"Call to endBatchChanges before calling beginCatchChanges");
	}
	self.performingBatchChanges = [NSNumber numberWithBool:NO];
	[self saveContext];
	
	@synchronized(self)
	{
		if (_currentChangingTaskCount == 0) {
			[self performBlockInPrivateQueue:^{
				[self savePrivateContext];
			}];
		}
	}
}

- (void)createNewObjectForEntityName:(NSString *)name setupBlock:(void (^)(NSManagedObject *object))setupBlock
{
	[self performChangingTaskInPrivateQueue:^{
		NSEntityDescription *description = [NSEntityDescription entityForName:name inManagedObjectContext:self.privateContextObject];
		NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:description insertIntoManagedObjectContext:self.privateContextObject];
		setupBlock(object);
	}];
}

- (void)executeFetchRequest:(NSFetchRequest *)request completionBlock:(void (^)(NSArray *resultsObjectsIds))completionBlock
{
	NSFetchRequest *requestToUse = request.copy;
	requestToUse.resultType = NSManagedObjectIDResultType;
	[self performBlockInPrivateQueue:^{
		NSError *error = nil;
		NSArray *results = [self.privateContextObject executeFetchRequest:request error:&error];
		dispatch_async(dispatch_get_main_queue(), ^{
			if (error) {
				NSLog(@"Error while fetching with FTData: %@", error);
				completionBlock(nil);
			} else {
				completionBlock(results);
			}
		});
	}];
}

- (NSArray *)managedObjectForIDs:(NSArray *)objectIDs
{
	NSMutableArray *results = [NSMutableArray new];
	for (NSManagedObjectID *objectID in objectIDs) {
		[results addObject:[self.managedObjectContext objectWithID:objectID]];
	}
	return results;
}

- (void)deleteManagedObject:(NSManagedObject *)object
{
	NSManagedObjectID *objectId = object.objectID;
	[self performChangingTaskInPrivateQueue:^{
		NSManagedObject *objectToDelete = [self.privateContextObject objectWithID:objectId];
		[self.privateContextObject deleteObject:objectToDelete];
	}];
}

- (void)deleteDatabase
{
	self.persistentStoreCoordinator = nil;
	self.managedObjectContext = nil;
	self.managedObjectModel = nil;
	
	NSString *extensionName = @"sqlite";
	NSString *fileName = [_modelName stringByAppendingPathExtension:extensionName];
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
	[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Data saving

- (void)saveContext
{
    __block NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
		void(^saveBlock)(void) = ^ {
			if ([managedObjectContext hasChanges]) {
				if (![managedObjectContext save:&error])
				{
					NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
					abort();
				}
			}
		};
		if (_useiOS5PrivateQueue) {
			[managedObjectContext performBlockAndWait:saveBlock];
		} else {
			saveBlock();
		}
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
		if (_useiOS5PrivateQueue) __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
		else __managedObjectContext = [[NSManagedObjectContext alloc] init];
		
		[__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_modelName withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	@synchronized(self) {
		if (__persistentStoreCoordinator != nil)
		{
			return __persistentStoreCoordinator;
		}
		
		NSString *extensionName = @"sqlite";
		
		NSURL *storeURL = nil;
		
		NSString *fileName = [_modelName stringByAppendingPathExtension:extensionName];
		storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
		
		NSString *dbBundlePath = [FT2FileSystem pathForFileName:fileName checkBundleFirst:YES forDirectoryType:NSDocumentDirectory];        
		NSString *dbDocPath = [FT2FileSystem pathForFileName:fileName checkBundleFirst:NO forDirectoryType:NSDocumentDirectory];
		if (![FT2FileSystem existsAtPath:dbDocPath] && [FT2FileSystem existsAtPath:dbBundlePath]) {
			NSError *error;
			NSData *data = [FT2FileSystem dataFromDocumentsWithName:dbBundlePath checkBundleFirst:YES];
			if (data) {
				[FT2FileSystem writeData:data withName:fileName forDirectoryType:NSDocumentDirectory error:&error];
			}
		}
		
		NSError *error = nil;
		NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
								 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
		__persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}    
		
		return __persistentStoreCoordinator;
	}
} 

@end
