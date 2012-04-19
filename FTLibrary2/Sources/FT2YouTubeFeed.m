//
//  FT2YouTubeFeed.m
//  FTLibrary2
//
//  Created by Francesco on 19/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FT2YouTubeFeed.h"

@implementation FT2YouTubeFeed

+ (void)collectionForUserName:(NSString *)userName completed:(finishedDataDownload)block {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:youtube_URL, userName]];
    [FT2JSONCollection collectionFromURL:url completed:^(id data, NSError *error) {
        NSArray *result = nil;
        if (!error) result = [[(NSDictionary *)data objectForKey:@"data"] objectForKey:@"items"];
        
        block(result, error);
    }];
}

@end
