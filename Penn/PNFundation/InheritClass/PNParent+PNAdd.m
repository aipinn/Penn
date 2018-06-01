//
//  PNParent+PNAdd.m
//  Penn
//
//  Created by pinn on 2018/5/15.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNParent+PNAdd.h"

@implementation PNParent (PNAdd)

//+ (void)load{
//    NSLog(@"load+%s", __FUNCTION__);
//}
//+ (void)initialize
//{
//    if (self == [self class]) {
//        NSLog(@"initialize: %s", __FUNCTION__);
//    }
//}


// 分类重写本类的父类的方法: 本类和父类的实现都不再调用, 没有警告.
- (void)work{
    NSLog(@"category+%s", __FUNCTION__);
}

/*
 分类复写本类的方法,本类对应的方法不在调用, 此处会警告. +laod方法除外.
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)fly{
    NSLog(@"%s", __FUNCTION__);
}
#pragma clang diagnostic pop
@end
