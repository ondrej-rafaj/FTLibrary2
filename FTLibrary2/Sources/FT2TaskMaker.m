//
//  FTTaskMaker.m
//	FTLibrary
//
//  Created by Baldoph Pourprix on 29/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FT2TaskMaker.h"

@implementation FT2TaskMaker

@synthesize backgroundTaskIdentifier = _backgroundTaskIdentifier;

+ (void)performBlockInBackground:(void (^)(void))block priority:(FTTaskPriority)priority completed:(void (^)(void))completed expired:(void (^)(void))expired {
    dispatch_queue_priority_t dispatchPriority;
	switch (priority) {
		case FTTaskPriorityNormal:
			dispatchPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT;
			break;
		case FTTaskPriorityHigh:
			dispatchPriority = DISPATCH_QUEUE_PRIORITY_HIGH;
			break;
		case FTTaskPriorityLow:
			dispatchPriority = DISPATCH_QUEUE_PRIORITY_LOW;
			break;
	}	
    FT2TaskMaker *instance = [[FT2TaskMaker alloc] init];
    if (expired) instance.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:expired];
    dispatch_async(dispatch_get_global_queue(dispatchPriority, 0), ^{
        if (block) block();
        if (instance.backgroundTaskIdentifier) [[UIApplication sharedApplication] endBackgroundTask:instance.backgroundTaskIdentifier];
        if (completed) completed();
    });
}

+ (void)performBlockInBackground:(void (^)(void))block priority:(FTTaskPriority)priority
{
    [self performBlockInBackground:block priority:priority completed:nil expired:nil];
}

+ (void)performBlockInBackground:(void (^)(void))block completed:(void (^)(void))completed expired:(void (^)(void))expired {
    [self performBlockInBackground:block priority:FTTaskPriorityNormal completed:completed expired:expired];
}

+ (void)performBlockInBackground:(void (^)(void))block
{
	[self performBlockInBackground:block priority:FTTaskPriorityNormal];
}

+ (void)performBlockOnMainQueue:(void (^)(void))block
{
	[self performBlockOnMainQueue:block andWait:NO];
}

+ (void)performBlockOnMainQueue:(void (^)(void))block andWait:(BOOL)wait
{
	if (wait) {
		dispatch_sync(dispatch_get_main_queue(), block);
	}
	else {
		dispatch_async(dispatch_get_main_queue(), block);
	}
}

+ (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_current_queue(), block);
}

@end
