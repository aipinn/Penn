//
//  UIButton+Addition.h
//  Penn
//
//  Created by PENN on 2017/11/24.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnClickBlock)(void);

@interface UIButton (Addition)

@property (nonatomic, copy) NSString * title;

@property (nonatomic, strong) NSMutableArray * taps;

@property (nonatomic, copy) BtnClickBlock callBack;

+ (UIButton *)buttonImage:(NSString *)string title:(NSString *)title;

@end
