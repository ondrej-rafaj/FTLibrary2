//
//  FT2File.m
//  FTLibrary2
//
//  Created by Francesco Frison on 01/05/2012.
//  Copyright (c) 2012 Ziofrit.com. All rights reserved.
//

#import "FT2File.h"
#import "FT2Download.h"
#import "FT2FileSystem.h"

@implementation FT2File

@synthesize uid = _uid;
@synthesize path = _path;
@synthesize source = _source;
@synthesize date = _date;
@synthesize shouldOverride = _shouldOverride;
@synthesize type = _type;
@synthesize exists = _exists;
@synthesize data = _data;

@synthesize delegate = _delegate;

- (NSString *)folder {
    NSString *folder;
    switch (self.type) {
        case FT2FileTypeImage:
            folder = @"images";
            break;
        case FT2FileTypeVideo:
            folder = @"videos";
            break;
        case FT2FileTypeDoc:
            folder = @"docs";
            break;
        case FT2FileTypePDF:
            folder = @"pdfs";
            break;
        case FT2FileTypeThumbnail:
            folder = @"thumbnails";
            break;
        default:
            folder = @"files";
            break;
    }
    return folder;
}

- (BOOL)exists {
    if (!_exists) {
        _exists = [FT2FileSystem existsAtPath:self.path];
    }
    return _exists;
}

-(void)setSource:(NSURL *)source {
    _source = source;
    
    if (!_source || _source.path.length == 0) return;
    static NSString *pattern = @"^[http|https|ftp]*://";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:_source.path options:NSMatchingProgress range:NSMakeRange(0, _source.path.length)];
    if (matches.count == 0 && self.delegate && [self.delegate respondsToSelector:@selector(relatedURLForFile:)]) {
        NSURL *baseURL = [self.delegate relatedURLForFile:self];
        _source = [NSURL URLWithString:_source.path relativeToURL:baseURL];
    }
}

- (NSString *)path {
    if (!_path) {
        NSString *fileName = [self.source lastPathComponent];
        NSString *filePath = [FT2FileSystem pathForFileName:fileName checkBundleFirst:YES forDirectoryType:NSDocumentDirectory];
        if (!filePath || self.shouldOverride) {
            fileName = [NSString stringWithFormat:@"%@/%@_%@", [self folder], self.uid, fileName];
            filePath = [FT2FileSystem pathForFileName:fileName checkBundleFirst:NO forDirectoryType:NSDocumentDirectory];
        }
        _path = filePath;
    }
    return _path;
}

- (NSData *)data {
    if (!_data) {
        _data = [NSData dataWithContentsOfFile:self.path];
    }
    return _data;
}

- (void)initializeDataDownloadWithCompletitionBlock:(fileSaved)block {
    if (!self.source) {
        NSError *error = [NSError errorWithDomain:@"com.fuerteint.error" code:404 userInfo:nil];
        block(error);
    }
        
    [FT2Download dataFromURL:self.source completed:^(id data, NSError *error) {
        if (error || !data) {
            FT2Error *ftError = [FT2Error errorWithError:error];
            [ftError showInConsole];
            block(error);
            return;
        }
        
        self.path = nil;
        
        [FT2FileSystem writeData:data toDocumentsWithName:self.path error:&error];
        if (error) {
            FT2Error *ftError = [FT2Error errorWithError:error];
            [ftError showInConsole];
            block(error);
            return;
        }
        
        self.exists = (error == nil);
        self.data = data;
        
        block(error);
    }];
}



@end
