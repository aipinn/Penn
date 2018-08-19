//
//  PNDynamicMethod.m
//  Penn
//
//  Created by emoji on 2018/7/20.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNDynamicMethod.h"
#import "PNMsgForward.h"

@implementation PNDynamicMethod


@end
//-----------------------------------------
//------------Category--------------
//-----------------------------------------
@implementation PNDynamicMethod (PNAdd)

void dynamicMethod(id self, SEL _cmd){
    NSLog(@"add doing");
}

//动态方法解析
//+ (BOOL)resolveInstanceMethod:(SEL)sel{
//
//    if ([NSStringFromSelector(sel) isEqualToString:@"doSomething"]) {//此处可以根据情况自定义条件
//        //"v@:" 参考:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
//        class_addMethod(self, sel, (IMP)dynamicMethod, "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

//备援接受者
- (id)forwardingTargetForSelector:(SEL)aSelector{
    PNMsgForward * forward = [PNMsgForward new];
    return forward;
}

/*
 完整的消息转发机制
 1.必须实现方法签名
 2.进行消息转发
 注意:如果此处只是进行原样转发,可以直接使用备援接收者实现:
 此处的最重要的作用是可以改变消息参数,或者改变selector甚至吞并消息(forwardInvocation:中不invoke方法)
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    PNMsgForward * forward = [PNMsgForward new];
    if ([forward respondsToSelector:anInvocation.selector])
        NSLog(@"Nothing");
    //[anInvocation invokeWithTarget:forward];
    else
        [super forwardInvocation:anInvocation];
    
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    PNMsgForward * forward = [PNMsgForward new];
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        signature = [forward methodSignatureForSelector:selector];
    }
    return signature;
}



@end
