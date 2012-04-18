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

+ (void)performBlockInBackground:(void (^)(void))block priority:(FTTaskPriority)priority;
+ (void)performBlockInBackground:(void (^)(void))block;

+ (void)performBlockOnMainQueue:(void (^)(void))block;
+ (void)performBlockOnMainQueue:(void (^)(void))block andWait:(BOOL)wait;

+ (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
