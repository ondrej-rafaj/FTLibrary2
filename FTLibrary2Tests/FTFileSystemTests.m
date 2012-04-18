//
//  FTFileSystemTests.m
//  FTLibrary2
//
//  Created by Francesco on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FTFileSystemTests.h"
#import "FT2FileSystem.h"

#define TEST_TEXT @"this is atest to check data\n"

@implementation FTFileSystemTests

- (void)testDetectDirectoryPaths {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [paths objectAtIndex:0];
    STAssertTrue((libPath && libPath.length > 0), @"Path not found");
}

- (void)testReadWriteDataToDocuments {
    NSString *docName = @"document.txt";
    NSData *data = [TEST_TEXT dataUsingEncoding:NSUTF8StringEncoding];
    BOOL wrote = [FT2FileSystem writeData:data toDocumentsWithName:docName];
    STAssertTrue(wrote, @"Problem writing file");
    data = nil;
    data = [FT2FileSystem dataFromDocumentsWithName:docName checkBundleFirst:NO];
    STAssertNotNil(data, @"Data is Nil");
}

- (void)testReadWriteDataToLibrary {
    NSString *docName = @"document.txt";
    NSData *data = [TEST_TEXT dataUsingEncoding:NSUTF8StringEncoding];
    BOOL wrote = [FT2FileSystem writeData:data withName:docName forDirectoryType:NSLibraryDirectory];
    STAssertTrue(wrote, @"Problem writing file");
    data = nil;
    data = [FT2FileSystem dataWithName:docName checkBundleFirst:NO forDirectoryType:NSLibraryDirectory];
    STAssertNotNil(data, @"Data is Nil");    
}

@end
