//
//  FTFileSystemTests.h
//  FTLibrary2
//
//  Created by Francesco on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface FT2FileSystemTests : SenTestCase
- (void)testDetectDirectoryPaths;
- (void)testReadWriteDataToDocuments;
- (void)testReadWriteDataToLibrary;
- (void)testReadWriteDataToDocumentsBundleFirst;
- (void)testReadWriteDataToLibraryBundleFirst;

@end
