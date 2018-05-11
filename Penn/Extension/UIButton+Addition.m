//
//  UIButton+Addition.m
//  Penn
//
//  Created by PENN on 2017/11/24.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import "UIButton+Addition.h"

@implementation UIButton (Addition)

+ (UIButton *)buttonImage:(NSString *)string title:(NSString *)title{
    
    UIButton * btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

@end
