//
//  FT2GMapsDirectionOutput.m
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 10/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import "FT2GMapsDirectionOutput.h"
#import "FT2GMapsRoute.h"

@interface FT2GMapsDirectionOutput ()

@property (nonatomic, readwrite) NSError *error;

@property (nonatomic, readwrite) FT2GMapsRoute *route; //return the first object of |routes|
@property (nonatomic, readwrite) NSArray *routes;

@end

@implementation FT2GMapsDirectionOutput

#pragma mark - Object lifecycle

- (id)initWithDictionary:(NSDictionary *)dict
{
	self = [super init];
	if (self) {
		
		NSMutableArray *routes = [NSMutableArray new];
		NSArray *routesArray = dict[@"routes"];
		[routesArray enumerateObjectsUsingBlock:^(NSDictionary *routeDict, NSUInteger idx, BOOL *stop) {
			FT2GMapsRoute *route = [[FT2GMapsRoute alloc] initWithDictionary:routeDict];
			[routes addObject:route];
		}];
		_routes = routes.copy;
	}
	return self;
}

#pragma mark - Getters

- (FT2GMapsRoute *)route
{
	return _routes.count > 0 ? _routes[0] : nil;
}

@end
