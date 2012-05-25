//
//  FT2JSONCollection.m
//  FTLibrary2
//
//  Created by Francesco on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FT2JSONCollection.h"
#import "SBJsonParser.h"
#import "FT2TaskMaker.h"

@implementation FT2JSONCollection

+ (void)collectionFromURL:(NSURL *)url completed:(finishedDataDownload)block {
    //[FT2TaskMaker perf
    dispatch_queue_t currentQ = dispatch_get_current_queue();
    if (currentQ == dispatch_get_main_queue()) {
        [FT2TaskMaker performBlockInBackground:^{
            NSError *error;
            id result = [self collectionFromURL:url error:&error];
            [FT2TaskMaker performBlockOnMainQueue:^{
                block(result, error);
            }];        
        }];
    }
    else{
        NSError *error;
        id result = [self collectionFromURL:url error:&error];
        block(result, error);
    }
    

}

+ (id)collectionFromURL:(NSURL *)url error:(NSError **)error {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSStringEncoding encoding = NSUTF8StringEncoding;
    NSError *_error = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10];
    NSURLResponse *response;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&_error];
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:encoding];
    if (!dataString) {
        *error = _error;
        return nil;
    }
    return [parser objectWithString:dataString error:&_error];
}

@end
