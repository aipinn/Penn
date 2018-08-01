//
//  PNCTFrameParserConfig.m
//  Penn
//
//  Created by emoji on 2018/7/30.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNCTFrameParserConfig.h"

@implementation PNCTFrameParserConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _width = [UIScreen mainScreen].bounds.size.width;
        _fontSize = 16.0;
        _lineSpace = 3;
        _textColor = [UIColor blackColor];
        
    }
    return self;
}

@end
