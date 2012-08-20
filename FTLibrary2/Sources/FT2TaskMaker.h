//
//  FTTaskMaker.h
//	FTLibrary
//
//  Created by Baldoph Pourprix on 29/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	FTTaskPriorityNormal,
	FTTaskPriorityLow,
	FTTaskPriorityHigh
} FTTaskPriority;

@interface FT2TaskMaker : NSObject


/* the completionBlock is called on the caller's queue. The expiredBlock is called if the task in the background has
 * not finished in time - the "Background Task" mechanism of iOS is automatically handled here. */
+ (void)performBlockInBackground:(void (^)(void))block;
+ (void)performBlockInBackground:(void (^)(void))block priority:(FTTaskPriority)priority;
+ (void)performBlockInBackground:(void (^)(void))block completed:(void (^)(void))completionBlock expired:(void (^)(void))expiredBlock;
+ (void)performBlockInBackground:(void (^)(void))block priority:(FTTaskPriority)priority completed:(void (^)(void))completionBlock expired:(void (^)(void))expiredBlock;

+ (void)performBlockOnMainQueue:(void (^)(void))block;
+ (void)performBlockOnMainQueue:(void (^)(void))block andWait:(BOOL)wait;

+ (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
