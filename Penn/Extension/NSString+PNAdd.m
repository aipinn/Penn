//
//  NSString+PNAdd.m
//  HomeEconomics
//
//  Created by emoji on 2019/1/8.
//  Copyright © 2019 guanjia. All rights reserved.
//

#import "NSString+PNAdd.h"

@implementation NSString (PNAdd)

/**
 是否是空白:回车 空格 tab
 */
- (BOOL)isBlank{
    NSString *regex = @"\\s+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL ret = [predicate evaluateWithObject:self];
    return ret;
}
/**
 是否是数字
 */
- (BOOL)isNumber {
    NSString *regex = @"[0-9]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL ret = [predicate evaluateWithObject:self];
    return ret;
}
/**
 是否是字母
 */
- (BOOL)isLetter {
    NSString *regex = @"[A-Za-z]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL ret = [predicate evaluateWithObject:self];
    return  ret;
}
/**
 是否是字母或数字
 */
- (BOOL)isLetterOrNumber {
    NSString *regex = @"[A-Za-z0-9]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL ret = [predicate evaluateWithObject:self];
    return  ret;
}

/**
 一定长度范围的数字和字母组合的字符串
 */
- (BOOL)isLetterAndNumberLengthMin:(NSUInteger)min max:(NSUInteger)max {
    NSString *regex = [NSString stringWithFormat:@"^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)[0-9a-zA-Z]{%lu,%lu}", min, max];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL ret = [predicate evaluateWithObject:self];
    return ret;
}

/**
 一定长度范围的必须包含数字和大小字母组合的字符串
 */
- (BOOL)isLowerUpperLetterAndNumberLengthMin:(NSUInteger)min max:(NSUInteger)max {
    NSString *regex = [NSString stringWithFormat:@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{%lu,%lu}", min, max];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL ret = [predicate evaluateWithObject:self];
    return ret;
}


@end
