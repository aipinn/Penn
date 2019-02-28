//
//  PNOperationController.m
//  Penn
//
//  Created by emoji on 2019/2/20.
//  Copyright © 2019 PENN. All rights reserved.
//

#import "PNOperationController.h"

@interface PNOperationController ()

@end

@implementation PNOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

#pragma mark - NSBlockOperation

- (void)blockOperation {
    
    NSBlockOperation *blkOpera = [[NSBlockOperation alloc]init];
    [blkOpera addExecutionBlock:^{
        NSLog(@"11:%@", [NSThread currentThread]);
    }];
    [blkOpera addExecutionBlock:^{
        NSLog(@"12:%@", [NSThread currentThread]);
    }];
    [blkOpera addExecutionBlock:^{
        NSLog(@"13:%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *blkOpera1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"21:%@", [NSThread currentThread]);
    }];
    [blkOpera1 addExecutionBlock:^{
        NSLog(@"22:%@", [NSThread currentThread]);
    }];
    [blkOpera1 addExecutionBlock:^{
        NSLog(@"23:%@", [NSThread currentThread]);
    }];
    
    [blkOpera start];
    [blkOpera1 start];
    
    //调用 Start 方法后数组中的所有的 Block 会并发执行，第一个 Block 在当前线程执行，其余会在新建的子线程执行。直到所有 Block 都执行完毕，NSBlockOperation 才算完成。
}

#pragma mark - NSInvocationOperation

- (void)invocationOperation {
    //NSInvocationOperation 通过 Invocation 的形式管理单个任务的执行。只能通过 initWithTarget:selector:object:的形式在初始化的时候指定 Targrt-Action。
    //它实现了非并发的 Operation。
    NSInvocationOperation *invOpera1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(doSome:) object:@"pp-invocationOpera1"];

    [invOpera1 start];
    

}

- (void)doSome:(NSString *)str {
    
}

#pragma mark - NSOperationQueue

- (void)operationQueue {
    
    //将 NSOperation 添加到 NSOperationQueue 中后就会在子线程自动执行
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //queue.maxConcurrentOperationCount = 3;

    
    [queue addOperationWithBlock:^{
        NSLog(@"1:%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"2:%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"3:%@", [NSThread currentThread]);
    }];
    
    
}
// 操作依赖
- (void)operationDependency {
    //将 NSOperation 添加到 NSOperationQueue 中后就会在子线程自动执行
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //queue.maxConcurrentOperationCount = 3;
    
    NSBlockOperation *blkOpera1 = [[NSBlockOperation alloc]init];
    [blkOpera1 addExecutionBlock:^{
        NSLog(@"11:%@", [NSThread currentThread]);
    }];
    NSBlockOperation *blkOpera2 = [[NSBlockOperation alloc]init];
    [blkOpera2 addExecutionBlock:^{
        NSLog(@"12:%@", [NSThread currentThread]);
    }];
    NSBlockOperation *blkOpera3 = [[NSBlockOperation alloc]init];
    [blkOpera3 addExecutionBlock:^{
        NSLog(@"13:%@", [NSThread currentThread]);
    }];
    
    [blkOpera2 addDependency:blkOpera3];
    
    [queue addOperation:blkOpera1];
    [queue addOperation:blkOpera2];
    [queue addOperation:blkOpera3];
    
}

@end
