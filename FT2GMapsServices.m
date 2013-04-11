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

@interface FT2GMapsServices ()

@property (nonatomic) NSOperationQueue *operationQueue;
@property (nonatomic) NSMutableDictionary *requestOperations;

- (id)_executeRequest:(FT2GMapsRequest *)request completion:(void (^)(NSError *error, id parsedJSON))completionBlock;

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

- (id)executeDirectionRequest:(FT2GMapsDirectionRequest *)request completion:(void (^)(FT2GMapsDirectionOutput *directionOutput, NSError *error))completionBlock
{
	id opaqueObject = [self _executeRequest:request completion:^(NSError *error, NSDictionary *parsedJSON) {
		
		FT2GMapsDirectionOutput *directionOutput = [[FT2GMapsDirectionOutput alloc] initWithDictionary:parsedJSON];
		completionBlock(directionOutput, error);
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

@end
