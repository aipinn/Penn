//
//  PNCTFrameParser.m
//  Penn
//
//  Created by emoji on 2018/7/30.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNCTFrameParser.h"

@implementation PNCTFrameParser

+ (NSDictionary *)attributesWithConfig:(PNCTFrameParserConfig *)config {

    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", config.fontSize, NULL);
    CGFloat lineSpace = config.lineSpace;
    CTParagraphStyleSetting setting[3] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpace },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpace },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpace }
    };
    
    CTParagraphStyleRef styleRef = CTParagraphStyleCreate(setting, 3);
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:(__bridge id)fontRef forKey:(id)kCTFontAttributeName];
    [dict setObject:(__bridge id)(styleRef) forKey:(id)kCTParagraphStyleAttributeName];
    [dict setObject:(id)config.textColor.CGColor forKey:(id)kCTForegroundColorAttributeName];

    CFRelease(styleRef);
    CFRelease(fontRef);
    return dict;
}

+ (PNCoreTextData *)parserContext:(NSString *)context config:(PNCTFrameParserConfig *)config{
    
    NSDictionary * attr = [self attributesWithConfig:config];
    NSAttributedString * attributeString = [[NSAttributedString alloc] initWithString:context
                                                                           attributes:attr];
    return [self paraserAttributesContext:attributeString config:config];
}

+ (PNCoreTextData *)paraserAttributesContext:(NSAttributedString *)context config:(PNCTFrameParserConfig *)config{
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)context);
    
    CGFloat textHeight = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(config.width, CGFLOAT_MAX), nil).height;
    
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    PNCoreTextData * data = [[PNCoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    
    CFRelease(frame);
    CFRelease(framesetter);
    
    return data;
}

+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                  config:(PNCTFrameParserConfig *)config
                                  height:(CGFloat)height{
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    CTFrameRef ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return ctFrame;
}



@end
