//
//  FT2YouTubeFeedsTests.m
//  FTLibrary2
//
//  Created by Francesco Frison on 20/04/2012.
//  Copyright (c) 2012 ziofritz.com. All rights reserved.
//

#import "FT2YouTubeFeedsTests.h"
#import "FT2YouTubeFeed.h"

@implementation FT2YouTubeFeedsTests

- (void)testFeeds {
    self.done = NO;
    [FT2YouTubeFeed collectionForUserName:@"cescofry" completed:^(id data, NSError *error) {
        STAssertNil(error, error.description);
        STAssertTrue((data && [(NSArray *)data count] > 0), @"Feeds shouldn't be nill or empty");
        self.done = YES;
    }];
}

@end
