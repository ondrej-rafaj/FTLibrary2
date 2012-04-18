//
//  FTSystem.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 01/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FT2System : NSObject

//uses the NSString + UUID Category
+ (NSString *)uuid;

+ (BOOL)isTabletIdiom;

+ (float)systemNumber;

+ (BOOL)isInternetPingAvailable;
+ (BOOL)isInternetAvailable;

+ (NSString *)deviceInfo;

+ (void)printAvailableFonts;

@end
