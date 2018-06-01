//
//  UILabel+PNAdd.m
//  Penn
//
//  Created by pinn on 2018/5/23.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "UILabel+PNAdd.h"

@implementation UILabel (PNAdd)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalM = class_getInstanceMethod(self, @selector(setFont:));
        Method swizzledM = class_getInstanceMethod(self, @selector(pn_bigerFont:));
        method_exchangeImplementations(originalM, swizzledM);
    });
}

/**
 label的所有字体大小增加5
 */
- (void)pn_bigerFont:(UIFont *)font{
    UIFont * newFont = [UIFont systemFontOfSize:font.pointSize+5];
    [self pn_bigerFont:newFont];
}

@end
