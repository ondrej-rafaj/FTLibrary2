//
//  FT2GoogleMapsServicesManager.m
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 09/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import "FT2GMapsServices.h"
#import "FT2GMapsDirectionRequest.h"
#import "NSString+Tools.h"
#import "FT2Operation.h"
#import "FT2GMapsDirectionOutput.h"
#import "FT2GMapsReverseGeocodingRequest.h"
#import "FT2GMapsReverseGeocodingOutput.h"

@interface FT2GMapsServices ()

@property (nonatomic) NSOperationQueue *operationQueue;
@property (nonatomic) NSMutableDictionary *requestOperations;

- (id)_executeRequest:(FT2GMapsRequest *)request completion:(void (^)(NSError *error, id parsedJSON))completionBlock;
- (NSError *)_parseError:(NSDictionary *)dict;

@end

@implementation FT2GMapsServices

- (id)init
{
	self = [super init];
	if (self) {
		_operationQueue = [[NSOperationQueue alloc] init];
		_requestOperations = [NSMutableDictionary new];
	}
	return self;
}

- (id)executeDirectionRequest:(FT2GMapsDirectionRequest *)request
				   completion:(void (^)(FT2GMapsDirectionOutput *directionOutput, NSError *error))completionBlock
{
	id opaqueObject = [self _executeRequest:request completion:^(NSError *error, NSDictionary *parsedJSON) {
		
		FT2GMapsDirectionOutput *directionOutput = nil;
		if (error == nil) directionOutput = [[FT2GMapsDirectionOutput alloc] initWithDictionary:parsedJSON];
		completionBlock(directionOutput, error);
	}];
	
	return opaqueObject;
}

- (id)executeReverseGeocodingRequest:(FT2GMapsReverseGeocodingRequest *)request
						  completion:(void (^)(FT2GMapsReverseGeocodingOutput *reverseGeocodingOutput, NSError *error))completionBlock
{
	id opaqueObject = [self _executeRequest:request completion:^(NSError *error, NSDictionary *parsedJSON) {

		FT2GMapsReverseGeocodingOutput *reverseGeocodingOutput = nil;
		if (error == nil && [parsedJSON[@"results"] count] > 0) {
			reverseGeocodingOutput = [[FT2GMapsReverseGeocodingOutput alloc] initWithDictionary:parsedJSON];
		}
		completionBlock(reverseGeocodingOutput, error);
	}];
	
	return opaqueObject;
}

- (void)cancelRequest:(id)key
{
	NSOperation *operation = _requestOperations[key];
	if (operation) {
		[operation cancel];
		[_requestOperations removeObjectForKey:key];
	}
}

- (id)_executeRequest:(FT2GMapsRequest *)request completion:(void (^)(NSError *error, id parsedJSON))completionBlock
{
	NSString *urlPrefix = nil;
	if ([request isMemberOfClass:FT2GMapsDirectionRequest.class]) {
		urlPrefix = @"https://maps.googleapis.com/maps/api/directions/";
	} else 	if ([request isMemberOfClass:FT2GMapsReverseGeocodingRequest.class]) {
		urlPrefix = @"http://maps.googleapis.com/maps/api/geocode/";
	}
	if (urlPrefix) {
		urlPrefix = [urlPrefix stringByAppendingString:@"json?"];
		NSString *urlSuffix = [request.argumentsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		NSString *fullURL = [NSString stringWithFormat:@"%@%@", urlPrefix, urlSuffix];
		
		NSURL *URL = [NSURL URLWithString:fullURL];
		NSLog(@"Will load URL: %@", URL.absoluteString);
		
		NSString *requestId = [NSString randomString];

		FT2Operation *operation = [[FT2Operation alloc] initWithBlock:^(FT2Operation *operationRef) {
			
			NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:URL
															 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
														 timeoutInterval:15.0];
			NSError *error = nil;
			id jsonObject;
			
			NSURLResponse *response = nil;
			NSData *data = [NSURLConnection sendSynchronousRequest:requestURL returningResponse:&response error:&error];
			
			if (operationRef.isCancelled) return;
			
			if (error == nil && data != nil) {

				jsonObject = [NSJSONSerialization JSONObjectWithData:data
																options:0
																  error:&error];
				if (operationRef.isCancelled) return;
			}
			
			if (error == nil && jsonObject) {
				error = [self _parseError:jsonObject];
				
				if (operationRef.isCancelled) return;
			}
			
			dispatch_async(dispatch_get_main_queue(), ^{
				if (operationRef.isCancelled) return;
				
				[self.requestOperations removeObjectForKey:requestId];
				completionBlock(error, jsonObject);
			});
		}];
		
		self.requestOperations[requestId] = operation;
		
		[self.operationQueue addOperation:operation];
		return requestId;
		
	} else {
		NSLog(@"%@ cannot be handled by FT2GMapsServices", request);
		return nil;
	}
}

- (NSError *)_parseError:(NSDictionary *)dict
{
	if (dict[@"status"] && ![dict[@"status"] isEqualToString:@"OK"]) {
		NSString *status = dict[@"status"];
		NSInteger errorCode = FT2GMapsUnkownError;
		if ([status isEqualToString:@"NOT_FOUND"]) errorCode = FT2GMapsNotFound;
		else if ([status isEqualToString:@"ZERO_RESULTS"]) errorCode = FT2GMapsZeroResults;
		else if ([status isEqualToString:@"MAX_WAYPOINTS_EXCEEDED"]) errorCode = FT2GMapsMaxWaypointExceeded;
		else if ([status isEqualToString:@"INVALID_REQUEST"]) errorCode = FT2GMapsInvalideRequest;
		else if ([status isEqualToString:@"OVER_QUERY_LIMIT"]) errorCode = FT2GMapsOverQueryLimit;
		else if ([status isEqualToString:@"REQUEST_DENIED"]) errorCode = FT2GMapsRequestDenied;
		
		NSString *errorMessage = nil;
		switch (errorCode) {
			case FT2GMapsInvalideRequest:
				errorMessage = @"The provided request was invalid.";
				break;
			case FT2GMapsMaxWaypointExceeded:
				errorMessage = @"Too many waypoints were provided.";
				break;
			case FT2GMapsNotFound:
				errorMessage = @"One of the location couldn't be geocoded.";
				break;
			case FT2GMapsOverQueryLimit:
				errorMessage = @"The service cannot receive any more requests for now.";
				break;
			case FT2GMapsRequestDenied:
				errorMessage = @"The service denied the client request.";
				break;
			case FT2GMapsUnkownError:
				errorMessage = @"Unknown error.";
				break;
			case FT2GMapsZeroResults:
				errorMessage = @"No route could be found between the origin and destination";
				break;
		}
		
		NSError *error = [NSError errorWithDomain:@"com.fuerteint.gmaps"
											 code:errorCode
										 userInfo:@{ NSLocalizedDescriptionKey: @"Google Maps Direction error", NSLocalizedFailureReasonErrorKey: errorMessage}];
		return error;
	}
	return nil;
}

@end
