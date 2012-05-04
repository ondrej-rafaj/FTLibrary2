//
//  NSDate+NSDate_TimeAgo.h
//  FTLibrary2
//
//  Created by Francesco Frison on 04/05/2012.
//  Copyright (c) 2012 Ziofrit.com. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    NSDate_TimeAgeTypeSeconds,
    NSDate_TimeAgeTypeMinutes,
    NSDate_TimeAgeTypeHours,
    NSDate_TimeAgeTypeDays,
    NSDate_TimeAgeTypeMonths,
    NSDate_TimeAgeTypeYears
}NSDate_TimeAgeType;


@interface NSDate (NSDate_TimeAgo)

- (NSInteger)timeIntervalWithStartDate:(NSDate*)start withEndDate:(NSDate*)end ofType:(NSDate_TimeAgeType *)type;

@end
