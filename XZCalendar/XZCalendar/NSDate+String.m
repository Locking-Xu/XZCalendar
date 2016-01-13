//
//  NSDate+String.m
//  XZToolKit
//
//  Created by 徐章 on 16/1/11.
//  Copyright © 2016年 xuzhang. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate (String)

/**
 *  根据NSString获得NSDate
 *
 *  @param sDate  NSString
 *  @param format 默认为yyyy-MM-dd HH:mm:ss
 *
 *  @return NSDate
 */
+ (NSDate *)dateFromString:(NSString *)sDate format:(NSString *)format{

    if ([sDate isKindOfClass:[NSNull class]]) {
        
        return nil;
    }
    
    if ([format isEqualToString:@""] || !format) {
        
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:format];
    
    return [dateFormat dateFromString:sDate];
}

/**
 *  根据NSDate获得NSString
 *
 *  @param sDate  NSString
 *  @param format 默认为yyyy-MM-dd HH:mm:ss
 *
 *  @return NSDate
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format{

    if (!date) {
        return @"";
    }
    if ([format isEqualToString:@""] || !format) {
        
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:format];
    
    return [dateFormat stringFromDate:date];
}
@end
