//
//  FT2Download.m
//  FTLibrary2
//
//  Created by Francesco Frison on 29/05/2012.
//  Copyright (c) 2012 Ziofrit.com. All rights reserved.
//

#import "FT2Download.h"

@implementation FT2Download


+ (NSData *)dataFromURL:(NSURL *)url error:(NSError **)error {
    NSError *_error = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10];
    NSURLResponse *response;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&_error];
    *error = _error;
    return data;
}

+ (void)dataFromURL:(NSURL *)url completed:(finishedDataDownload)block {
    __block NSError *error;
    dispatch_queue_t currentQ = dispatch_get_current_queue();

    [FT2TaskMaker performBlockInBackground:^{
        id result = [FT2Download dataFromURL:url error:&error];
        dispatch_sync(currentQ, ^{
            block(result, error);
        });       
    }];

}

@end
