//
//  NSMutableArray+PNAdd.m
//  Penn
//
//  Created by pinn on 2018/5/16.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "NSMutableArray+PNAddE.h"

@implementation NSMutableArray (PNAddE)

#pragma mark - 以下都是错误示范
//===================================================
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
//重写方法不管用,不会调用,why???????
// 因为NSArray是类簇.
// NSString, NSArray, NSDictionary, NSNumber, NSData,等
//================1====
/*
- (void)addObject:(id)anObject{
    if (!anObject) {
        // 具体实现....balabala
        return;
    }
}
 
#pragma clang diagnostic pop
// 同上
// 重写本类父类的方法没有警告
- (id)objectAtIndex:(NSUInteger)index{
    // 具体实现....balabala
    return @"this is m-c";
}
*/

//================2====
// 正确的实现方法是使用method swizzling
// 但是又不管用?
// 还是因为类簇, NSMutableArray不是addObject:方法对应的原类
/*
+ (void)load{
    // 1. YYKit中的方法
    // [[self class] swizzleClassMethod:@selector(addObject:) with:@selector(pn_addObject:)];
    
    // 2. 自己实现
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalM = class_getInstanceMethod(self, @selector(addObject:));
        Method swizzledM = class_getInstanceMethod(self, @selector(pn_maddObject:));
        method_exchangeImplementations(originalM, swizzledM);
    });
}
- (void)pn_maddObject:(id)anObject{
    if(nil == anObject){
        NSLog(@"添加nil对象到数组中......失败");
        return;
    }else{
        [self pn_maddObject:anObject];
    }
}
 */
//===================================================

@end
