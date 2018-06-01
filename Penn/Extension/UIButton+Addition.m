//
//  UIButton+Addition.m
//  Penn
//
//  Created by PENN on 2017/11/24.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import "UIButton+Addition.h"

static const char taps_key;
static const char block_key;

@implementation UIButton (Addition)
@dynamic title;

+ (UIButton *)buttonImage:(NSString *)string title:(NSString *)title{

    UIButton * btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

// 1. 本质只是添加方法,借助原来的方法来达到目的, 没有意义
- (void)setTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
}

- (NSString *)title{
    return self.titleLabel.text;
}

// 2. runtime strong
- (void)setTaps:(NSMutableArray *)taps{
    objc_setAssociatedObject(self, &taps_key, taps, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)taps{
    return objc_getAssociatedObject(self, &taps_key);
}

// 3. runtime 添加回调 copy
- (void)setCallBack:(BtnClickBlock)callBack{
    objc_setAssociatedObject(self, @selector(clicked), callBack, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
}

- (BtnClickBlock)callBack{
    return objc_getAssociatedObject(self, @selector(clicked));
}
- (void)clicked{
    if (self.callBack) {
        self.callBack();
    }
}

// 4. _cmd 代表当前方法的selector: 此处_cmd代表@selector(callBack);
//- (void)setCallBack:(BtnClickBlock)callBack{
//    objc_setAssociatedObject(self, @selector(callBack), callBack, OBJC_ASSOCIATION_COPY);
//    [self addTarget:self action:@selector(callBackclicked) forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (BtnClickBlock)callBack{
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)callBackclicked{
//    if (self.callBack) {
//        self.callBack();
//    }
//}


@end
