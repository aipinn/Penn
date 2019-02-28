//
//  PNRunLoopController.m
//  Penn
//
//  Created by emoji on 2019/2/20.
//  Copyright © 2019 PENN. All rights reserved.
//

#import "PNRunLoopController.h"

@interface PNRunLoopController ()

@end

@implementation PNRunLoopController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1. RunLoop的概念
    //SX/iOS 系统中，提供了两个这样的对象：NSRunLoop 和 CFRunLoopRef。

    //2. RunLoop与线程的关系
    int mainT = pthread_main_np();
    [NSThread mainThread];
    
    pthread_t curT = pthread_self();
    [NSThread currentThread];
    

    /*
     线程和 RunLoop 之间是一一对应的，其关系是保存在一个全局的 Dictionary 里。线程刚创建时并没有 RunLoop，如果你不主动获取，那它一直都不会有。
     RunLoop 的创建是发生在第一次获取时，RunLoop 的销毁是发生在线程结束时。你只能在一个线程的内部获取其 RunLoop（主线程除外）。
     */
    
    //3.
    CFRunLoopSourceRef source0 = CFRunLoopSourceCreate(NULL, 0, nil);
    CFRunLoopSourceSignal(source0);
    CFRunLoopWakeUp(CFRunLoopGetCurrent());
    
    //GCD中dispatch到main queue的block被分发到main RunLoop执行
    

//    [self performSelector:@selector(setImage:) withObject:[UIImage new] afterDelay:0];
    
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    NSArray *allModes = CFBridgingRelease(CFRunLoopCopyAllModes(runloop));
    while (1) {
        for (NSString *mode in allModes) {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    
 
    
}



@end
