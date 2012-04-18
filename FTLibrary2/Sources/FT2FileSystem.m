//
//  FT2FileSystem.m
//  FTLibrary2
//
//  Created by Francesco on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FT2FileSystem.h"

@implementation FT2FileSystem

#pragma mark get directory path

+ (NSString *)pathForSearchPath:(NSSearchPathDirectory)directory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)documentDirectory {
    return [FT2FileSystem pathForSearchPath:NSDocumentDirectory];
}

+ (NSString *)libraryDirectory {
    return [FT2FileSystem pathForSearchPath:NSLibraryDirectory];
}


#pragma mark write data

+ (BOOL)writeData:(NSData *)data toDocumentsWithName:(NSString *)fileName {
    return [FT2FileSystem writeData:data withName:fileName forDirectoryType:NSDocumentDirectory];
}



+ (BOOL)writeData:(NSData *)data withName:(NSString *)fileName forDirectoryType:(NSSearchPathDirectory)directory {
    NSString *filePath = [[FT2FileSystem pathForSearchPath:directory] stringByAppendingPathComponent:fileName];
    NSDictionary *attr = nil;
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:attr error:&error];
    success = [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:attr];
    return success;    
}


#pragma mark read data

+ (NSData *)dataFromDocumentsWithName:(NSString *)fileName checkBundleFirst:(BOOL)chekcBundle {
    return [FT2FileSystem dataWithName:fileName checkBundleFirst:chekcBundle forDirectoryType:NSDocumentDirectory];
}

+ (NSData *)dataWithName:(NSString *)fileName checkBundleFirst:(BOOL)chekcBundle forDirectoryType:(NSSearchPathDirectory)directory {
    NSString *filePath = [self pathForFileName:fileName checkBundleFirst:chekcBundle forDirectoryType:directory];
    return [NSData dataWithContentsOfFile:filePath];   
}

#pragma mark paths

+ (NSString *)pathForFileName:(NSString *)fileName checkBundleFirst:(BOOL)chekcBundle forDirectoryType:(NSSearchPathDirectory)directory {
    NSString *filePath = [[NSString alloc] init];
    if (chekcBundle) {
        NSString *onlyFile = [fileName lastPathComponent];
        NSString *ext = [onlyFile pathExtension];
        NSString *name = [onlyFile stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", ext] withString:@""];
        filePath = [[NSBundle mainBundle] pathForResource:name ofType:ext];
        
    }
    if (!filePath) {
        filePath = [NSString stringWithString:[[FT2FileSystem pathForSearchPath:directory] stringByAppendingPathComponent:fileName]];
    }
    return filePath;  
}



@end
