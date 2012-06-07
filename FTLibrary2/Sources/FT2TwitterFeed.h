//
//  FT2TwitterFeed.h
//  FTLibrary2
//
//  Created by Francesco on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FT2JSONCollection.h"

#define twitter_URL             @"https://api.twitter.com/statuses/user_timeline.json?screen_name=%@&include_rts=%d"
#define thumbnail_format        @"https://api.twitter.com/1/users/profile_image?screen_name=%@&size=normal"
#define twitter_date_format     @"eee MMM dd HH:mm:ss zzzz yyyy"

@interface FT2TwitterFeed : FT2JSONCollection

+ (void)collectionForFeedID:(NSString *)feedID includeReTweets:(BOOL)retweets completed:(finishedDataDownload)block;

+ (void)thumbnailForFeedID:(NSString *)feedID completed:(finishedDataDownload)block;

@end
