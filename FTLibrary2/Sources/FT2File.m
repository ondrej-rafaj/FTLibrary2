//
//  FT2File.m
//  FTLibrary2
//
//  Created by Francesco Frison on 01/05/2012.
//  Copyright (c) 2012 Ziofrit.com. All rights reserved.
//

#import "FT2File.h"
#import "FT2FileSystem.h"

@implementation FT2File

@synthesize uid = _uid;
@synthesize path = _path;
@synthesize source = _source;
@synthesize date = _date;
@synthesize exists = _exists;
@synthesize data = _data;

- (void)initializeDataDownloadInFolder:(NSString *)folder withCompletitionBlock:(fileSaved)block {
    if (!self.source) return;
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%d_%@", folder, [self.uid intValue], [self.source.path lastPathComponent]];
    __block NSString *resourcePath = [FT2FileSystem pathForFileName:fileName checkBundleFirst:YES forDirectoryType:NSDocumentDirectory];
    
    [FT2File downloadDataFromURL:self.source completed:^(NSData *data, NSError *error) {
        if (error) {
            FT2Error *ftError = [FT2Error errorWithError:error];
            [ftError showInConsole];
        }
        
        [FT2FileSystem writeData:data toDocumentsWithName:resourcePath error:&error];
        if (error) {
            FT2Error *ftError = [FT2Error errorWithError:error];
            [ftError showInConsole];
        }
        else {
            self.path = resourcePath;
        }
        self.exists = (error != nil);
        self.data = nil;
        
        block(error);
    }];
}

- (void)initializeDataDownloadWithCompletitionBlock:(fileSaved)block {
    [self initializeDataDownloadInFolder:@"" withCompletitionBlock:block];
}

- (BOOL)exists {
    if (!_exists) {
        _exists = (self.data != nil);
    }
    return _exists;
}

- (NSData *)data {
    if (!_data) {
        _data = [FT2FileSystem dataWithName:self.path checkBundleFirst:YES forDirectoryType:NSDocumentDirectory];
    }
    return _data;
}


+ (void)downloadDataFromURL:(NSURL *)url completed:(fileDownloaded)block {
    @autoreleasepool {
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        dispatch_queue_t _queue = dispatch_queue_create("com.fuerte.FT2Library.internetQueue",0);
        dispatch_async(_queue, ^{
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (error) {
                FT2Error *ftError = [FT2Error errorWithError:error];
                [ftError showInConsole];
            }
            
            block(data, error);
            dispatch_release(_queue);
        });
    }
}


@end
