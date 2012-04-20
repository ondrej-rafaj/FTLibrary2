//
//  FT2FileSystem.h
//  FTLibrary2
//
//  Created by Francesco on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FT2FileSystem : NSObject

+ (NSString *)documentDirectory;
+ (NSString *)libraryDirectory;

+ (void)writeData:(NSData *)data toDocumentsWithName:(NSString *)fileName error:(NSError **)error;
+ (NSData *)dataFromDocumentsWithName:(NSString *)fileName checkBundleFirst:(BOOL)chekcBundle;

+ (void)writeData:(NSData *)data withName:(NSString *)fileName forDirectoryType:(NSSearchPathDirectory)directory error:(NSError **)error;
+ (NSData *)dataWithName:(NSString *)fileName checkBundleFirst:(BOOL)chekcBundle forDirectoryType:(NSSearchPathDirectory)directory;

+ (NSString *)pathForFileName:(NSString *)fileName checkBundleFirst:(BOOL)chekcBundle forDirectoryType:(NSSearchPathDirectory)directory;

@end
