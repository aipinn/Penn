//
//  PNButton.m
//  Penn
//
//  Created by SanRong on 2017/11/4.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "PNButton.h"

@implementation PNButton

// 每次点击会触发此方法, 将按钮添加到视图上时会调用
-(void)layoutSubviews{
    [super layoutSubviews];

}




//供子类调用, 不会改变自身size的大小, 子类重写此方法可以限制返回的view的大小
//默认返回自身大小
//- (CGSize)sizeThatFits:(CGSize)size{
//    return self.frame.size;
//}

@end
