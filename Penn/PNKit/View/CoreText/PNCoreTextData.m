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

@end
