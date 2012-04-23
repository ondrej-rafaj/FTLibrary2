//
//  FTFileSystemTests.m
//  FTLibrary2
//
//  Created by Francesco on 18/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FT2FileSystemTests.h"
#import "FT2FileSystem.h"

#define TEST_TEXT @"this is atest to check data\n"

@implementation FT2FileSystemTests

- (void)testDetectDirectoryPaths {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [paths objectAtIndex:0];
    STAssertTrue((libPath && libPath.length > 0), @"Path not found");
}

- (void)testReadWriteDataToDocuments {
    NSString *docName = @"document.txt";
    NSData *data = [TEST_TEXT dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    [FT2FileSystem writeData:data toDocumentsWithName:docName error:&error];
    STAssertNil(error, @"Problem writing file");
    data = nil;
    data = [FT2FileSystem dataFromDocumentsWithName:docName checkBundleFirst:NO];
    STAssertNotNil(data, @"Data is Nil");
}

- (void)testReadWriteDataToLibrary {
    NSString *docName = @"document.txt";
    NSData *data = [TEST_TEXT dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    [FT2FileSystem writeData:data withName:docName forDirectoryType:NSLibraryDirectory error:&error];
    STAssertNil(error, @"Problem writing file");
    data = nil;
    data = [FT2FileSystem dataWithName:docName checkBundleFirst:NO forDirectoryType:NSLibraryDirectory];
    STAssertNotNil(data, @"Data is Nil");    
}

- (void)testReadWriteDataToDocumentsBundleFirst {
    NSString *docName = @"document.txt";
    NSData *data = [TEST_TEXT dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    [FT2FileSystem writeData:data toDocumentsWithName:docName error:&error];
    STAssertNil(error, @"Problem writing file");
    data = nil;
    data = [FT2FileSystem dataFromDocumentsWithName:docName checkBundleFirst:YES];
    STAssertNotNil(data, @"Data is Nil");    
}

- (void)testReadWriteDataToLibraryBundleFirst {
    NSString *docName = @"document.txt";
    NSData *data = [TEST_TEXT dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    [FT2FileSystem writeData:data withName:docName forDirectoryType:NSLibraryDirectory error:&error];
    STAssertNil(error, @"Problem writing file");
    data = nil;
    data = [FT2FileSystem dataWithName:docName checkBundleFirst:YES forDirectoryType:NSLibraryDirectory];
    STAssertNotNil(data, @"Data is Nil");      
}

@end
