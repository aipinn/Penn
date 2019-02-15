//
//  NSString+PNAdd.h
//  HomeEconomics
//
//  Created by emoji on 2019/1/8.
//  Copyright © 2019 guanjia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (PNAdd)

/**
 是否是空白:回车 空格 tab
 */
- (BOOL)isBlank;
/**
 是否是数字
 */
- (BOOL)isNumber;
/**
 是否是字母
 */
- (BOOL)isLetter;
/**
 是否是字母或数字
 */
- (BOOL)isLetterOrNumber;

/**
 一定长度范围的数字和字母组合的字符串

 @param min 最短
 @param max 最长
 @return 是否合法
 */
- (BOOL)isLetterAndNumberLengthMin:(NSUInteger)min max:(NSUInteger)max;

/**
 一定长度范围的必须包含数字和大小字母组合的字符串
 
 @param min 最短
 @param max 最长
 @return 是否合法
 */
- (BOOL)isLowerUpperLetterAndNumberLengthMin:(NSUInteger)min max:(NSUInteger)max;

@end

NS_ASSUME_NONNULL_END
