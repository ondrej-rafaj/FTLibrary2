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
#define twitter_date_format     @"ddd MMM dd HH:mm:ss zzz yyyy"

@interface FT2TwitterFeed : FT2JSONCollection

+ (void)collectionForFeedID:(NSString *)feedID includeReTweets:(BOOL)retweets completed:(finishedDataDownload)block;

@end
