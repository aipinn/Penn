//
//  PNCTFrameParser.h
//  Penn
//
//  Created by emoji on 2018/7/30.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNCoreTextData.h"
#import "PNCTFrameParserConfig.h"

@interface PNCTFrameParser : NSObject
/**
 根据配置信息生成属性字典
 */
+ (NSMutableDictionary *)attributesWithConfig:(PNCTFrameParserConfig *)config;
/**
 解析普通字符串
 */
+ (PNCoreTextData *)parserContext:(NSString *)context config:(PNCTFrameParserConfig *)config;
/**
 解析属性字符串
 */
+ (PNCoreTextData *)paraserAttributesContext:(NSAttributedString *)context config:(PNCTFrameParserConfig *)config;
/**
 解析本地模板文件
 */
+ (PNCoreTextData *)parserTemplateFile:(NSString *)path config:(PNCTFrameParserConfig *)config;

@end
