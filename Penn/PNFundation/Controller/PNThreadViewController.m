//
//  PNThreadViewController.m
//  Penn
//
//  Created by emoji on 2019/2/20.
//  Copyright © 2019 PENN. All rights reserved.
//

#import "PNThreadViewController.h"

@interface PNThreadViewController ()

@end

@implementation PNThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.对象方法,需要自己管理线程的生命周期
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        
    }];
    [thread start];
    
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(doSome) object:nil];
    [thread1 start];
    
    //2.类方法,自动调用start,不需要自己管理线程的生命周期
    [NSThread detachNewThreadWithBlock:^{
        
    }];
    [NSThread detachNewThreadSelector:@selector(doSome) toTarget:self withObject:nil];
    
    //3.启动线程
    /*
     
     创建的线程对象后需要手动调用 start 方法才能启动线程。如果我们在创建线程时有制定任务，start 方法就会调用线程的入口方法 - mian。main 方法的默认实现会执行初始化时的 block 或 selector。main 方法只能通过子类重写，不能直接调用。子类化 NSThread 重写 main 方法时不比调用 super，我们可以按照自己的逻辑实现入口方法。
     NSThread生命周期函数
     - (void)main;
     - (void)start;
     - (void)cancle;
     */
    
    //4.派发任务NSObject的一系列类方法:performSelector...
    
    //5. 优先级
    
    //6. 线程休眠
    
    //7. 线程信息
    
    //8. 多线程的状态
    
    //9. 退出线程
    
}
- (void)doSome{}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
