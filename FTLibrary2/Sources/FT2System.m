//
//  FT2System.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 01/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FT2System.h"
#import "Reachability.h"
#import "NSString+UUID.h"

@implementation FT2System

static float systemVersion = -1;

+ (NSString *)uuid
{
	return [NSString stringWithNewUUID];
}

+ (BOOL)isTabletIdiom
{
	return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

+ (float)systemNumber
{
	if (systemVersion == -1) {
		NSString *version = [[UIDevice currentDevice] systemVersion];
		systemVersion = [version floatValue];
	}
	
	return systemVersion;
}

+ (BOOL)isInternetAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    BOOL isConnected = reachability.currentReachabilityStatus != NotReachable;
    return isConnected;
}

+ (BOOL)isInternetPingAvailable
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"http://www.google.com"];
    BOOL isConnected = reachability.currentReachabilityStatus != NotReachable;
    return isConnected;
}

+ (NSString *)deviceInfo {
	NSString *info = [NSString stringWithFormat:@"%@ version: %@\n", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
	info = [info stringByAppendingFormat:@"Model: %@\n", [[UIDevice currentDevice] model]];
	info = [info stringByAppendingFormat:@"Orientation: %d\n", [[UIDevice currentDevice] orientation]];
	info = [info stringByAppendingFormat:@"Bundle version: %@\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
	info = [info stringByAppendingFormat:@"Short version: %@\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
	return info;
}

+ (void)printAvailableFonts
{
	NSMutableString *string = [NSMutableString stringWithString:@"\n"];
	for (NSString *fontFamilyName in [UIFont familyNames]) {
		[string appendFormat:@"\n%@", fontFamilyName];
		for (NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName]) {
			[string appendFormat:@"\n\t%@", fontName];
		}
	}
	NSLog(@"Available Fonts:%@", string);
}

@end
