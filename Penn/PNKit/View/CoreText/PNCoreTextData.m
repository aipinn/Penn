//
//  PNCoreTextData.m
//  Penn
//
//  Created by emoji on 2018/7/30.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNCoreTextData.h"

@implementation PNCoreTextData

- (void)setCtFrame:(CTFrameRef)ctFrame{
    if (_ctFrame != ctFrame) {
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

- (void)dealloc{
    if (!_ctFrame) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    [self fillImagePosition];
}



/**
 
 ---------------------------------------
 |在CTFrame内部，是由多个CTLine组成的,每个  \
 |CTLine代表一行,每个CTLine又是由多个CTRun \
 |来组成,每个CTRun代表一组风格一致的文本.我们 \
 |不用手工管理CTLine和CTRun的创建过程。     \
 --------------------------------------|
 
 */
- (void)fillImagePosition{
    if (self.imageArray.count == 0) {
        return;
    }
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    NSInteger lineCount = lines.count;
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    int imgIndex = 0;
    PNCTImageData *imageData = self.imageArray[0];
    for (int i = 0; i < lineCount; i++) {
        if (!imageData) {
            break;
        }
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray *runAttributes = (NSArray *)CTLineGetGlyphRuns(line);
        for (id runObj in runAttributes) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary * runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (!delegate) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent, descent;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent+descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            imageData.imagePosition = delegateBounds;
            imgIndex++;
            if (imgIndex == self.imageArray.count) {
                imageData = nil;
                break;
            } else {
                imageData = self.imageArray[imgIndex];
            }
            
        }
    }
    
}

@end
