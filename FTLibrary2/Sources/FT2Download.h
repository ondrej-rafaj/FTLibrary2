//
//  FT2Download.h
//  FTLibrary2
//
//  Created by Francesco Frison on 29/05/2012.
//  Copyright (c) 2012 Ziofrit.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FT2TaskMaker.h"

typedef void (^finishedDataDownload)(id data, NSError *error);

@interface FT2Download : NSObject

+ (NSData *)dataFromURL:(NSURL *)url error:(NSError **)error;
+ (void)dataFromURL:(NSURL *)url completed:(finishedDataDownload)block;

@end
