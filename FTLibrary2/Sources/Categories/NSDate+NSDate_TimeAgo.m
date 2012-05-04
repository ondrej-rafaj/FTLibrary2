//
//  NSDate+NSDate_TimeAgo.m
//  FTLibrary2
//
//  Created by Francesco Frison on 04/05/2012.
//  Copyright (c) 2012 Ziofrit.com. All rights reserved.
//

#import "NSDate+NSDate_TimeAgo.h"

@implementation NSDate (NSDate_TimeAgo)

//Constants
#define SECOND 1
#define MINUTE (60 * SECOND)
#define HOUR (60 * MINUTE)
#define DAY (24 * HOUR)
#define MONTH (30 * DAY)
#define YEAR (365 * DAY)



- (NSInteger)timePassedsinceDate:(NSDate *)date ofType:(NSDate_TimeAgeType *)type {
    return [NSDate timePassedWithStartDate:self withEndDate:date ofType:type];
}

- (NSInteger)timePassedSinceNowOfType:(NSDate_TimeAgeType *)type {
    return [self timePassedsinceDate:[NSDate date] ofType:type];
}

+ (NSInteger)timePassedWithStartDate:(NSDate *)start withEndDate:(NSDate *)end ofType:(NSDate_TimeAgeType *)type{
    //Calculate the delta in seconds between the two dates
    NSTimeInterval delta = [end timeIntervalSinceDate:start];
    
    if (delta < 1 * MINUTE) {
        *type = NSDate_TimeAgeTypeSeconds;
        return delta;
    }
    else if (delta < HOUR) {
        *type = NSDate_TimeAgeTypeMinutes;
        return floor(delta / MINUTE);
    }
    else if (delta < DAY) {
        *type = NSDate_TimeAgeTypeHours;
        return floor(delta / HOUR);
    }
    else if (delta < MONTH) {
        *type = NSDate_TimeAgeTypeDays;
        return floor(delta / DAY);
    }
    else if (delta < YEAR) {
        *type = NSDate_TimeAgeTypeMonths;
        return floor(delta / MONTH);
    }
    else {
        *type = NSDate_TimeAgeTypeYears;
        return floor(delta / YEAR);
    }
}

@end
