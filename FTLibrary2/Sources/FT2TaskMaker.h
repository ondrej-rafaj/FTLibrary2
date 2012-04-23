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

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;


+ (void)performBlockInBackground:(void (^)(void))block priority:(FTTaskPriority)priority;
+ (void)performBlockInBackground:(void (^)(void))block priority:(FTTaskPriority)priority completed:(void (^)(void))completed expired:(void (^)(void))expired;
+ (void)performBlockInBackground:(void (^)(void))block;
+ (void)performBlockInBackground:(void (^)(void))block completed:(void (^)(void))completed expired:(void (^)(void))expired;

+ (void)performBlockOnMainQueue:(void (^)(void))block;
+ (void)performBlockOnMainQueue:(void (^)(void))block andWait:(BOOL)wait;

+ (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
