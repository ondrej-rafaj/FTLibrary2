//
//  FTLibrary2Tests.h
//  FTLibrary2Tests
//
//  Created by Francesco on 18/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

typedef void (^blockOnYes)();

@interface FTLibrary2Tests : SenTestCase

@property (nonatomic, assign) BOOL done;
@property (copy) blockOnYes theBlock;

- (void)performBlockOnceDone:(void (^)(void))block;

@end
