//
//  FT2JSONCollection.h
//  FTLibrary2
//
//  Created by Francesco on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FT2Download.h"


@interface FT2JSONCollection : NSObject

+ (void)collectionFromURL:(NSURL *)url completed:(finishedDataDownload)block; //asynchronus

@end
