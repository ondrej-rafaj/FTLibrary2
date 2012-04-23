//
//  FTLibrary2Tests.m
//  FTLibrary2Tests
//
//  Created by Francesco on 18/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTLibrary2Tests.h"



@implementation FTLibrary2Tests

@synthesize done = _done;
@synthesize theBlock;

- (void)setDone:(BOOL)done {
    _done = done;
    
    if (done && theBlock) theBlock();
}

- (void)setUp
{
    [super setUp];
    
    self.done = YES;
}

- (void)tearDown
{
    while (!self.done) {
        // This executes another run loop.
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        // Sleep 1/100th sec
        usleep(10000);
    }
    [super tearDown];
}


- (void)performBlockOnceDone:(void (^)(void))block {
    if (block) theBlock = block;
}

@end
