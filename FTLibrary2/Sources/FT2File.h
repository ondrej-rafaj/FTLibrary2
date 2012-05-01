//
//  FT2File.h
//  FTLibrary2
//
//  Created by Francesco Frison on 01/05/2012.
//  Copyright (c) 2012 Ziofrit.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^fileSaved)(NSError *error);
typedef void (^fileDownloaded)(NSData *data, NSError *error);

@interface FT2File : NSObject

@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSURL *source;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL exists;
@property (nonatomic, strong) NSData *data;

- (void)initializeDataDownloadWithCompletitionBlock:(fileSaved)block;
- (void)initializeDataDownloadInFolder:(NSString *)folder withCompletitionBlock:(fileSaved)block;
+ (void)downloadDataFromURL:(NSURL *)url completed:(fileDownloaded)block;

@end
