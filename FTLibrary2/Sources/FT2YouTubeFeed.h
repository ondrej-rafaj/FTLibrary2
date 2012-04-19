//
//  FT2YouTubeFeed.h
//  FTLibrary2
//
//  Created by Francesco on 19/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FT2JSONCollection.h"

#define youtube_URL         @"http://gdata.youtube.com/feeds/api/users/%@/uploads?&v=2&alt=jsonc"
#define youtube_date_format     @"yyyy-MM-ddThh:mm:ss.zzzZ"

@interface FT2YouTubeFeed : FT2JSONCollection

+ (void)collectionForUserName:(NSString *)userName completed:(finishedDataDownload)block;

@end
