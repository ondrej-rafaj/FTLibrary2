//
//  FTError.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 29/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTError.h"
#import "FTTaskMaker.h"

@implementation FTError

+ (void)handleErrorWithString:(NSString *)errorMessage {
	//[NSException raise:errorMessage format:@""];
    NSLog(@"Error: %@", errorMessage);
	//abort();
}

+ (void)handleError:(NSError *)error {
	[self handleErrorWithString:error.localizedDescription];
}

+ (FTError *)errorWithError:(NSError *)error
{
	FTError *newError = [FTError errorWithDomain:error.domain code:error.code userInfo:error.userInfo];
	return newError;
}

+ (FTError *)errorWithTitle:(NSString *)title andDescription:(NSString *)description
{
	FTError *error = [FTError errorWithDomain:(__bridge NSString *)CFBundleGetIdentifier(CFBundleGetMainBundle())
										 code:0
									 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:title, NSLocalizedDescriptionKey,
											   description, NSLocalizedFailureReasonErrorKey, nil]];
	return error;
}

- (void)showAsAlertViewWithDelegate:(id <UIAlertViewDelegate>)delegate
{
	[FTTaskMaker performBlockOnMainQueue:^{
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
