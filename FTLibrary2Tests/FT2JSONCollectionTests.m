//
//  FT2JSONCollectionTests.m
//  FTLibrary2
//
//  Created by Francesco Frison on 20/04/2012.
//  Copyright (c) 2012 ziofritz.com. All rights reserved.
//

#import "FT2JSONCollectionTests.h"
#import "FT2JSONCollection.h"

@implementation FT2JSONCollectionTests

- (void)testNotExistingURL {
    self.done = NO;
    NSURL *url = [NSURL URLWithString:@"http://www.rgesdefrvervewrverv.com"];
    return [FT2JSONCollection collectionFromURL:url completed:^(id data, NSError *error) {
        STAssertNotNil(error, @"Error shoudn't be nil");
        STAssertNil(data, @"Data should be nil");
        self.done = YES;
    }];
}

- (void)testWrongContent {
    self.done = NO;
    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    return [FT2JSONCollection collectionFromURL:url completed:^(id data, NSError *error) {
        STAssertNotNil(error, @"Error shoudn't be nil");
        STAssertNil(data, @"Data should be nil");
        self.done = YES;
    }];
}

- (void)testErrors {
    NSURL *url = [NSURL URLWithString:@""];
    return [FT2JSONCollection collectionFromURL:url completed:^(id data, NSError *error) {
        //
    }];
}

@end
