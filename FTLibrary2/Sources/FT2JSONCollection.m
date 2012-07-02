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

+ (id)collectionFromData:(NSData *)data error:(NSError **)error {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSStringEncoding encoding = NSUTF8StringEncoding;
    NSError *_error = nil;
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:encoding];
    if (!dataString) {
        *error = _error;
        return nil;
    }
    id result = [parser objectWithString:dataString error:&_error];
    *error = _error;
    
    return result;
}

+ (void)collectionFromURL:(NSURL *)url completed:(finishedDataDownload)block {
    [FT2Download dataFromURL:url completed:^(id data, NSError *error) {
        if (!data || error) {
            block(nil, error);
            return;
        }
        id result = [self collectionFromData:data error:&error];
        block(result, error);
    }];

}

@end
