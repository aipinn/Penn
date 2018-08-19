//
//  PNRuntimeController.m
//  Penn
//
//  Created by emoji on 2018/7/19.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNRuntimeController.h"
#import "PNMsgForward.h"
#import "PNDynamicMethod.h"
#import "PNAutoDictionary.h"
#import "PNSon.h"

@interface PNRuntimeController ()

@end

@implementation PNRuntimeController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self dynamicCreateInstanceTest];
}


#pragma mark - 动态创建对象
void showBigbongIMPTest(id self, SEL _cmd) {
   
    NSLog(@"self:%p",self);
    NSLog(@"%@, %@", [self class],[self superclass]);
    Class curClass = [self class];
    for (NSInteger i = 0; i < 5; i++) {
        NSLog(@"i:%ld \tp:%p class:\t%@",(long)i, curClass, curClass);
        curClass = object_getClass(curClass);
    }
    NSLog(@"UIView-Class:%p \tUIView-Meta-Class:%p", [UIView class], object_getClass([UIView class]));
    NSLog(@"NSObject-Class:%p \tNSObject-Meta-Class:%p",[NSObject class], object_getClass([NSObject class]));
  /*
   2018-07-26 17:56:57.553776+0800 Penn[8089:680014] self:0x7f99a1d2ee60   "实例"
   2018-07-26 17:56:57.553965+0800 Penn[8089:680014] PennDynamicView, UIView
   2018-07-26 17:56:57.554029+0800 Penn[8089:680014] i:0     p:0x6000002436c0 class:    PennDynamicView "自定义PennDynamicView类"
   2018-07-26 17:56:57.554129+0800 Penn[8089:680014] i:1     p:0x600000244470 class:    PennDynamicView "自定义PennDynamicView类的元类"
   2018-07-26 17:56:57.554228+0800 Penn[8089:680014] i:2     p:0x10750be58 class:    NSObject "NSObject的元类"
   2018-07-26 17:56:57.554312+0800 Penn[8089:680014] i:3     p:0x10750be58 class:    NSObject
   2018-07-26 17:56:57.554839+0800 Penn[8089:680014] i:4     p:0x10750be58 class:    NSObject
   2018-07-26 17:56:57.554920+0800 Penn[8089:680014] UIView-Class:0x109ac9fd8     UIView-Meta-Class:0x109aca140
   2018-07-26 17:56:57.555016+0800 Penn[8089:680014] NSObject-Class:0x10750bea8     NSObject-Meta-Class:0x10750be58
   */
}

- (void)dynamicCreateInstanceTest{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

    // 创建类
    Class newClass = objc_allocateClassPair([UIView class], "PennDynamicView", 0);
    // 动态添加方法
    class_addMethod(newClass, @selector(showBigbong), (IMP)showBigbongIMPTest, "v@:");
    // 注册类
    objc_registerClassPair(newClass);
    // 创建实例
    id instanceNew = [[newClass alloc] init];
    // 调用添加的方法
    [instanceNew performSelector:@selector(showBigbong)];

#pragma clang diagnostic pop
}

#pragma mark - 消息转发测试
/*
 1. 动态解析
 2. 转发
 3. 重定向
 */
- (void)msgForwordTest{
    
    UIButton * btn = [UIButton new];
    btn.titleLabel.text = @"消息转发测试";
    btn.backgroundColor = [UIColor whiteColor];
    btn.frame = CGRectMake(0, 100, 100, 60);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(testMsgForward) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)testMsgForward{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    PNDynamicMethod * dynamic = [PNDynamicMethod new];
    [dynamic performSelector:@selector(doSomething)];
#pragma clang diagnostic pop
    
}
#pragma mark - Instrument测试循环引用
- (void)memberCycleTest{
    NSMutableArray * arr1 = [NSMutableArray array];
    NSMutableArray * arr2 = [NSMutableArray array];
    [arr1 addObject:arr2];
    [arr2 addObject:arr1];
}


#pragma mark - Dynamic method resolution
- (void)dynamicMethodResolution{
    //动态解析实现自定义字典通过点语法存取数据
    PNAutoDictionary * dict = [PNAutoDictionary new];
    dict.date = [NSDate dateWithTimeIntervalSinceNow:1000];
    dict.string = @"Beijing";
    dict.number = @12;
    dict.opaqueObject = @{@"key":@"value"};
    NSLog(@"%@\n%@\n%@\n%@", dict.date, dict.string, dict.number, dict.opaqueObject);
}



@end
