//
//  FT2Error.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 29/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FT2Error.h"
#import "FT2TaskMaker.h"

@implementation FT2Error

- (id)init
{
	self = [super init];
	if (self) {
		_userVisible = YES;
	}
	return self;
}

+ (FT2Error *)errorWithError:(NSError *)error
{
	FT2Error *newError;
	if (error) newError = [FT2Error errorWithDomain:error.domain code:error.code userInfo:error.userInfo];
	return newError;
}

+ (FT2Error *)errorWithTitle:(NSString *)title andDescription:(NSString *)description
{
	FT2Error *error = [FT2Error errorWithDomain:(__bridge NSString *)CFBundleGetIdentifier(CFBundleGetMainBundle())
										 code:0
									 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:title, NSLocalizedDescriptionKey,
											   description, NSLocalizedFailureReasonErrorKey, nil]];
	return error;
}

- (void)showAsAlertViewWithDelegate:(id <UIAlertViewDelegate>)delegate
{
	[FT2TaskMaker performBlockOnMainQueue:^{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:self.localizedDescription
														 message:self.localizedFailureReason
														delegate:delegate
											   cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}];
}

- (void)showInConsole
{
	NSLog(@"%@ - %@", self, self.userInfo);
}

@end
