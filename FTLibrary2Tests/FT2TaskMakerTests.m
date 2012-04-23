//
//  FT2TaskMakerTests.m
//  FTLibrary2
//
//  Created by Francesco Frison on 23/04/2012.
//  Copyright (c) 2012 Ziofrit.com. All rights reserved.
//

#import "FT2TaskMakerTests.h"
#import "FT2TaskMaker.h"

@implementation FT2TaskMakerTests

- (void)testBackGroundTaskWithCompleted {
    self.done = NO;
    __block BOOL task = NO;
    __block BOOL completed = NO;
    [FT2TaskMaker performBlockInBackground:^{
        task = YES;
    } completed:^{
        completed = YES;
        self.done = YES;
    } expired:^{
        // cannot test
    }];
    [self performBlockOnceDone:^{
        STAssertTrue(task, @"Task manager didn't run task");
        STAssertTrue(completed, @"Task manager didn't run completed");
    }];
}

@end
