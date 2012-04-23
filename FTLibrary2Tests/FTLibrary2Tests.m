//
//  FTLibrary2Tests.m
//  FTLibrary2Tests
//
//  Created by Francesco on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FTLibrary2Tests.h"

@implementation FTLibrary2Tests

@synthesize done;

- (void)setUp
{
    [super setUp];
    
    self.done = YES;
}

- (void)tearDown
{

    [self performBlockOnceDone:nil];
    [super tearDown];
}


- (void)performBlockOnceDone:(void (^)(void))block {
    while (!self.done) {
        // This executes another run loop.
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        // Sleep 1/100th sec
        usleep(10000);
    }
    if (block) block();
}

@end
