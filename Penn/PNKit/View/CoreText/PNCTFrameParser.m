//
//  PNCTFrameParser.m
//  Penn
//
//  Created by emoji on 2018/7/30.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNCTFrameParser.h"
#import "PNCTImageData.h"
#import "PNCTLinkData.h"

@implementation PNCTFrameParser

static CGFloat ascentCallback(void *ref){
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback(void *ref){
    return 0;
}
static CGFloat widthCallback(void *ref){
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
}


+ (NSMutableDictionary *)attributesWithConfig:(PNCTFrameParserConfig *)config {

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
//    [dict setObject:[UIFont systemFontOfSize:config.fontSize] forKey:(id)kCTFontAttributeName];
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
    
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter
                                                 config:config
                                                 height:textHeight];
    
    PNCoreTextData * data = [[PNCoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    
    CFRelease(frame);
    CFRelease(framesetter);
    
    return data;
}

+ (PNCoreTextData *)parserTemplateFile:(NSString *)path config:(PNCTFrameParserConfig *)config{
    NSMutableArray * imageArray = [NSMutableArray array];
    NSMutableArray * linkArray = [NSMutableArray array];
    NSAttributedString * content = [self loadTemplateFile:path
                                                   config:config
                                               imageArray:imageArray
                                                linkArray:linkArray];
    PNCoreTextData *data = [self paraserAttributesContext:content
                                                   config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
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

+ (NSAttributedString *)parserImageDataFromDictonry:(NSDictionary *)dict
                                         config:(PNCTFrameParserConfig *)config{
    CTRunDelegateCallbacks callback;
    memset(&callback, 0, sizeof(CTRunDelegateCallbacks));
    callback.version = kCTRunDelegateVersion1;
    callback.getAscent = ascentCallback;
    callback.getDescent = descentCallback;
    callback.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callback, (__bridge void *)(dict));
    //使用0xFFFC作为空白占位符
    unichar objectRepalcementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectRepalcementChar length:1];
    NSMutableDictionary * attributes = [self attributesWithConfig:config];
    NSMutableAttributedString * space = [[NSMutableAttributedString alloc] initWithString:content
                                                                               attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

/**
 load template file from path

 @param path file path
 @param config content config
 @return attributeString from template file
 */
+ (NSAttributedString *)loadTemplateFile:(NSString *)path
                                  config:(PNCTFrameParserConfig *)config
                              imageArray:(NSMutableArray *)imageArray
                               linkArray:(NSMutableArray *)linkArray{

    NSData * data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString * result = [[NSMutableAttributedString alloc] init];
    if (data) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data
                                                          options:NSJSONReadingMutableContainers
                                                            error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                NSString * type = dict[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString * attrs = [self parserAttributesContentFromDictonry:dict
                                                                                    config:config];
                    [result appendAttributedString:attrs];
                }else if ([type isEqualToString:@"img"]){
                    PNCTImageData * imgData = [[PNCTImageData alloc] init];
                    imgData.name = dict[@"name"];
                    imgData.position = (int)[result length];
                    //保存当前节点图片信息
                    [imageArray addObject:imgData];
                    // 创建空白占位符，并且设置它的CTRunDelegate信息
                    NSAttributedString * attrs = [self parserImageDataFromDictonry:dict
                                                                            config:config];
                    [result appendAttributedString:attrs];
                }else if ([type isEqualToString:@"link"]){
                    NSUInteger startPos = result.length;
                    NSAttributedString *as = [self parserAttributesContentFromDictonry:dict
                                                                                config:config];
                    [result appendAttributedString:as];
                    // 创建 CoreTextLinkData
                    NSUInteger length = result.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, length);
                    PNCTLinkData *linkData = [[PNCTLinkData alloc] init];
                    linkData.title = dict[@"content"];
                    linkData.url = dict[@"url"];
                    linkData.range = linkRange;
                    [linkArray addObject:linkData];
                }
            }
        }
    }
    return result;
}

+ (NSAttributedString *)parserAttributesContentFromDictonry:(NSDictionary *)dict
                                                     config:(PNCTFrameParserConfig *)config{
    NSMutableDictionary * attrs = [self attributesWithConfig:config];
    UIColor * color = [self colorFromTemplate:dict[@"color"]];
    if (color) {
        [attrs setObject:(id)color.CGColor forKey:(id)kCTForegroundColorAttributeName];
    }
    
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        [attrs setObject:(__bridge id)fontRef forKey:(id)kCTFontNameAttribute];
        CFRelease(fontRef);
    }
    NSString *content = dict[@"content"];
    
    return [[NSAttributedString alloc] initWithString:content attributes:attrs];
}

+ (UIColor *)colorFromTemplate:(NSString *)name{
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([name isEqualToString:@"black"]) {
        return [UIColor blackColor];
    } else {
        return nil;
    }
}

@end
