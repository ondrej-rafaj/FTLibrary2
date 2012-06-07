//
//  FT2Download.m
//  FTLibrary2
//
//  Created by Francesco Frison on 29/05/2012.
//  Copyright (c) 2012 Ziofrit.com. All rights reserved.
//

#import "FT2Download.h"

@implementation FT2Download

static dispatch_queue_t _queue;

+ (NSData *)dataFromURL:(NSURL *)url error:(NSError **)error {
    NSError *_error = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10];
    NSURLResponse *response;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&_error];
    *error = _error;
    return data;
}


+ (void)dataFromURL:(NSURL *)url completed:(finishedDataDownload)block  {
    @autoreleasepool {
        __block NSError *error;
        dispatch_queue_t currentQ = dispatch_get_current_queue();
        if (!_queue) _queue = dispatch_queue_create("com.fuerte.FT2Library.internetQueue",0);
        
        dispatch_async(_queue, ^{
            id result = [FT2Download dataFromURL:url error:&error];
            dispatch_async(currentQ, ^{
                block(result, error);
            });  
        });
    }
}

@end
