//
//  FTTaskMaker.h
//	FTLibrary
//
//  Created by Baldoph Pourprix on 29/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

/**
 *  Perform task i nthe background and implements handlers for completed and expired task if app has been terminated during the task
 *
 *      [FT2TaskMaker performBlockInBackground:^{
 *           // the task itself
 *       } completed:^{
 *           // background update finished. Finalise changes
 *       } expired:^{
 *           // app terminated before finishing update. Maybe remove changes
 *       }];
 *
 */

#import <Foundation/Foundation.h>

typedef enum {
	FTTaskPriorityNormal,
	FTTaskPriorityLow,
	FTTaskPriorityHigh
} FTTaskPriority;

@interface FT2TaskMaker : NSObject

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;


+ (void)performBlockInBackground:(void (^)(void))block priority:(FTTaskPriority)priority;
+ (void)performBlockInBackground:(void (^)(void))block priority:(FTTaskPriority)priority completed:(void (^)(void))completed expired:(void (^)(void))expired;
+ (void)performBlockInBackground:(void (^)(void))block;
+ (void)performBlockInBackground:(void (^)(void))block completed:(void (^)(void))completed expired:(void (^)(void))expired;

+ (void)performBlockOnMainQueue:(void (^)(void))block;
+ (void)performBlockOnMainQueue:(void (^)(void))block andWait:(BOOL)wait;

+ (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
