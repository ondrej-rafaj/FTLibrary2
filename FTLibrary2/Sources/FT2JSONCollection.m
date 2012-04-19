//
//  FT2JSONCollection.m
//  FTLibrary2
//
//  Created by Francesco on 19/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FT2JSONCollection.h"
#import "SBJsonParser.h"
#import "FT2TaskMaker.h"

@implementation FT2JSONCollection

+ (void)collectionFromURL:(NSURL *)url completed:(finishedDataDownload)block {
    //[FT2TaskMaker perf
    [FT2TaskMaker performBlockInBackground:^{
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSStringEncoding encoding = NSUTF8StringEncoding;
        NSError *error = nil;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10];
        NSURLResponse *response;
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSString *dataString = [[NSString alloc] initWithData:data encoding:encoding];
        if (!dataString) {
            [FT2TaskMaker performBlockOnMainQueue:^{
                block(nil, error);
            }];
            return;
        }
        __block id result = [parser objectWithString:dataString error:&error];
        [FT2TaskMaker performBlockOnMainQueue:^{
            block(result, error);
        }];        
    }];
}

@end
