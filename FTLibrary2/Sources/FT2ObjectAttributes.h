//
//  FT2ObjectAttributes.h
//  FTLibrary2
//
//  Created by Francesco on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FT2ObjectAttributes : NSObject

+ (NSDictionary *)propertiesOfClass:(id)obj;
+ (BOOL)isDictionary:(NSDictionary *)dictionary complaintWithClass:(id)obj;

@end
