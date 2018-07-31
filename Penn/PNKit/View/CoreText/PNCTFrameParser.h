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

+ (NSMutableDictionary *)attributesWithConfig:(PNCTFrameParserConfig *)config;
+ (PNCoreTextData *)parserContext:(NSString *)context config:(PNCTFrameParserConfig *)config;
+ (PNCoreTextData *)paraserAttributesContext:(NSAttributedString *)context config:(PNCTFrameParserConfig *)config;
+ (PNCoreTextData *)parserTemplateFile:(NSString *)path config:(PNCTFrameParserConfig *)config;

@end
