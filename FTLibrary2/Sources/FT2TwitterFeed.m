//
//  FT2TwitterFeed.m
//  FTLibrary2
//
//  Created by Francesco on 19/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FT2TwitterFeed.h"

@implementation FT2TwitterFeed

+ (void)collectionForFeedID:(NSString *)feedID includeReTweets:(BOOL)retweets  completed:(finishedDataDownload)block{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:twitter_URL, feedID, retweets]];
    [FT2JSONCollection collectionFromURL:url completed:^(id data, NSError *error) {
        block(data, error);
    }];
}

@end
