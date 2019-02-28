//
//  PNGCDViewController.m
//  Penn
//
//  Created by emoji on 2018/8/20.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNGCDViewController.h"

typedef void (^block)(void);

@interface PNGCDViewController ()

@end

@implementation PNGCDViewController
{
    dispatch_source_t _timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self gcdDispatchBarrierAsync];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)concurrentAndSerial {
    /*
     
                  同步派发                        异步派发
     串行队列    当前线程串行执行，阻塞当前线程    新建单个线程串行执行，不阻塞当前线程
     并发队列    当前线程并发执行，阻塞当前线程    新建多个线程并发执行，不阻塞当前线程
     主队列      主线程串行执行，阻塞当前线程     主线程串行执行，不阻塞当前线程
     
     */
    dispatch_queue_t my_queue1 = dispatch_queue_create("my_queue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 3; i++) {
        dispatch_sync(my_queue1, ^{
            NSLog(@"task1-%d-%@", i, [NSThread currentThread]);
        });
    }
    NSLog(@"task1-%@", [NSThread currentThread]);
    
    // DISPATCH_QUEUE_CONCURRENT dispatch_async
    // task1-<NSThread: 0x6000016be8c0>{number = 1, name = main}
    // task1-0-<NSThread: 0x600001673900>{number = 4, name = (null)}
    // task1-1-<NSThread: 0x600001626e40>{number = 5, name = (null)}
    // task1-2-<NSThread: 0x600001679c40>{number = 6, name = (null)}
    
    //DISPATCH_QUEUE_CONCURRENT dispatch_sync
    //task1-0-<NSThread: 0x600001a1db80>{number = 1, name = main}
    //task1-1-<NSThread: 0x600001a1db80>{number = 1, name = main}
    //task1-2-<NSThread: 0x600001a1db80>{number = 1, name = main}
    //task1-<NSThread: 0x600001a1db80>{number = 1, name = main}
    //
    
    /*
     派发同步任务,阻塞当前线程(次数为main线程),同步任务会一个挨一个执行,当前线程一直只有一个任务
     这个测试就是许多其他文章认为并发队列在同步派发时是串行执行的依据。这是一个明显的错误，之所以能够看起来串行执行，是因为派发任务的代码都在同一个线程运行，
     当第一个任务同步派发的时候阻塞了当前线程，所以第二个任务并没有立即派发，而是等第一个任务执行完才开始派发，就是说并发队列里任何时候都只有一个任务，那怎么会体现出并发性呢？
     */
    
    // task 2
    dispatch_queue_t my_queue2 = dispatch_queue_create("my_queue", DISPATCH_QUEUE_SERIAL);
    //创建子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //在子线程(并发队列)派发同步任务1
        dispatch_sync(my_queue2, ^{ // block 1
            sleep(2);
            NSLog(@"1-%@", [NSThread currentThread]);
        });
    });
    sleep(0.5);
    //在主线程(并发队列)中派发同步任务2
    dispatch_sync(my_queue2, ^{ // block 2
        dispatch_async(my_queue2, ^{ // block 3
            NSLog(@"2-%@", [NSThread currentThread]);
        });
        sleep(1);
        NSLog(@"3-%@", [NSThread currentThread]);
    });
    
    //主线程被阻塞4-输出比block2晚
    NSLog(@"4-%@", [NSThread currentThread]);
    
    /*
     
     实验结果与假设一致。block1、block2 两个任务被分别同步派发到并行队列，他们在不同线程执行，并且后派发的任务先完成，体现了并发队列的并发性。
     //sleep打开
     2-<NSThread: 0x60000308b980>{number = 4, name = (null)}
     3-<NSThread: 0x600003022380>{number = 1, name = main}
     4-<NSThread: 0x600003022380>{number = 1, name = main}
     1-<NSThread: 0x6000030f8b80>{number = 5, name = (null)}
     */
    
    //下边将 task 2 中的 concurrent 改为 serial 执行结果如下所示。
    /*
     //在住线程和global线程中并发添加任务的顺序存在不确定性.
     在主线程中是顺序执行先执行3在执行4,1和2是异步的顺序不确定
     
     3-<NSThread: 0x600002702400>{number = 1, name = main}
     4-<NSThread: 0x600002702400>{number = 1, name = main}
     2-<NSThread: 0x6000027d3800>{number = 4, name = (null)}
     1-<NSThread: 0x6000027ca880>{number = 5, name = (null)}
     
     */
}

#pragma mark - GCD的实现

/**
 Dispatch Source
 它是BSD内核功能kqueue的包装.
 */
- (void)gcdDispatchSource{
    //Dispatch Source可处理的事件有:
    DISPATCH_SOURCE_TYPE_TIMER;//定时器
    DISPATCH_SOURCE_TYPE_DATA_ADD;//变量增加
    DISPATCH_SOURCE_TYPE_DATA_OR;//变量OR
    if (@available(iOS 11.0, *)) {
        DISPATCH_SOURCE_TYPE_DATA_REPLACE;
    }
    DISPATCH_SOURCE_TYPE_MACH_SEND;//MACH端口发送
    DISPATCH_SOURCE_TYPE_MACH_RECV;//MACH端口接收
    DISPATCH_SOURCE_TYPE_PROC;//检测到与进程相关的事件
    DISPATCH_SOURCE_TYPE_SIGNAL;//接收信号
    DISPATCH_SOURCE_TYPE_VNODE;//文件系统有变更
    DISPATCH_SOURCE_TYPE_WRITE;//可写入文件映像
    DISPATCH_SOURCE_TYPE_READ;//可读取文件映像
    
    //eg:
    //DISPATCH_SOURCE_TYPE_TIMER
    //设定定时器任务在主线程中执行
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    _timer = timer;//self对定时器引用,不然超出作用域timer就会被释放.
    //第二个参数:dispatch_time(DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC) 表示5秒后执行
    //第三个参数:指定为DISPATCH_TIME_FOREVER表示不重复执行
    //第四个参数:允许延时1秒
    //dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 1 * NSEC_PER_SEC);
    //立即执行,之后每5秒执行一次,允许延时1秒
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"-----定时器任务ing-------");
        //可以设置取消,取消后定时器将失效
        //dispatch_source_cancel(timer);
    });
    //取消后执行的任务
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"++++++定时器取消++++++");
        
    });
    //启动Dispatch Source
    dispatch_resume(timer);
    
    
}

#pragma mark - GCD API

/**
 Dispatch IO
 */
- (void)gcdDispatchIO{
    
    //Dispatch IO可以提高文件的读取速度
    //此处省去一万字........
}

/**
 dispatch_once
 */
- (void)gcdDispatchOnce{
    //只执行一次,线程安全
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
}

/**
 dispatch_semaphore
 */
- (void)gcdDispatchSemaphore{
    // 当并行更新数据时会出现数据不一致的情况,甚至导出程序异常.虽然Serial Dispatch Queue 和 dispatch_barrier_asyn可以避免此类问题
    // 但是还有必要进行更细粒度的排他控制
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    //-------
    //设置Dispatch Semaohore的计数初始值为1
    //保证可访问数组的线程同时只能有一个
    //-------
    dispatch_semaphore_t dsema = dispatch_semaphore_create(1);
    for (int i = 0; i < 100; i++) {
        /*
        //如此添加发生内存错误的概率极高
        dispatch_async(queue, ^{
            [arr addObject:@(i)];
        });
         */
        dispatch_async(queue, ^{
            //--------------------
            //等待Dispatch Semaohore
            //直到Dispatch Semaohore的计数值大于等于1
            //-------------------
            long ret_wait = dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER);// 计数值减1
            NSLog(@"ret_wait:%ld", ret_wait);
            //-------------
            //执行到此时,Dispatch Semaohore的计数值恒为0
            //-------------
            [arr addObject:@(i)];
            
            long ret_signal = dispatch_semaphore_signal(dsema);// 计数值加1
            NSLog(@"ret_signal:%ld", ret_signal);
        });
        
    }
    
}

/**
 dispatch_suspend dispatch_resume
 */
- (void)gcdSuspendAndResume{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //......balbalablabala......
    //1. 挂起队列dispatch_suspend
    dispatch_suspend(queue);
    //2. 恢复队列dispatch_resume
    dispatch_resume(queue);
}

/**
 dispatch_apply
 */
- (void)gcdDispatchApply{
    //dispatch_apply是dispatch_sync与Dispatch Group的关联API
    //dispatch_apply按指定的次数执行添加到队列中的指定任务,并等待全部任务执行完成.
    dispatch_apply(10, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        sleep(2);
        NSLog(@"%zu", index);
    });
    NSLog(@"over");//一定是最后执行
    
    //eg:
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++) {
        sleep(0.5);
        [arr addObject:@"abc"];//都在主线程中添加
        NSLog(@"%@",[NSThread currentThread]);

    }
    //简单使用dispatch_apply处理数组
    dispatch_apply(arr.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        NSLog(@"%@ %@", arr[index],[NSThread currentThread]);//多个线程同时执行
    });
    
    //因为dispatch_apply和dispatch_sync一样都会等待任务处理结束,因此推荐在dispatch_asyn函数中异步的执行dispatch_apply函数.
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            dispatch_apply(arr.count, queue, ^(size_t index) {
                NSLog(@"%@ %@", arr[index],[NSThread currentThread]);
            });
            //apply中任务处理完成再执行特定任务
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"over");
            });
        });
    }
}

/**
 dispatch_sync
 */
- (void)gcdDispatchSync{
    // 同步执行,在其中的任务执行完毕前函数不会返回,容易造成死锁,相当于一个简易版的dispatch_group_wait
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    //主线程
    dispatch_sync(queue, ^{ // Thread 1: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
        NSLog(@"blk 死锁");
    });

    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);//主线程
        dispatch_sync(queue, ^{
            NSLog(@"Boom....");
        });
    });
    
    dispatch_queue_t queue_ser = dispatch_queue_create("com.penn.sync", NULL);
    dispatch_async(queue_ser, ^{
        NSLog(@"%@",[NSThread currentThread]);//子线程
        dispatch_sync(queue_ser, ^{
            NSLog(@"Boom.......");
        });
    });
}

/**
 dispatch_barrier_async
 */
- (void)gcdDispatchBarrierAsync{
    //在处理数据库或文件时, 为了防止数据竞争问题, 我们可以使用Serial Dispatch Queue处理. 但是如果多个任务同时在读取就不需要SEQ队列,这样会降低效率.
    //可以将读取任务添加进Concurrent Dispatch Queue队列中,将写入任务添加到所有读取任务都没有执行的Serial Dispatch Queue中,即可提高效率.
    //如此实现会比较麻烦,所以GCD提供了dispatch_barrier_async函数.
    
    dispatch_queue_t queue = dispatch_queue_create("com.penn.barrier", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{NSLog(@"blk1_reading");});
    dispatch_async(queue, ^{NSLog(@"blk2_reading");});
    dispatch_async(queue, ^{sleep(5);NSLog(@"blk3_reading");});
    dispatch_async(queue, ^{NSLog(@"blk4_reading");});
    dispatch_barrier_async(queue, ^{
        NSLog(@"blk_writing");
    });
    dispatch_async(queue, ^{NSLog(@"blk5_reading");});
    dispatch_async(queue, ^{sleep(1); NSLog(@"blk6_reading");});
    dispatch_async(queue, ^{NSLog(@"blk7_reading");});
}

/**
 Dispatch Group
 */
- (void)gcdDispatchGroup{
    //目标:多个任务执行完成之后再执行特定的任务
    //Serial可以按顺序串行执行多个任务,所有任务全部执行完毕之后再统一处理其他事件.
    //但是Concurrent是并发执行的,所有任务执行完成的事件是不确定的,要想达成目标比较困难.
    //使用:dispatch_group
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{sleep(1); NSLog(@"blk1");});
    dispatch_group_async(group, queue, ^{sleep(5); NSLog(@"blk2");});
    dispatch_group_async(group, queue, ^{sleep(3); NSLog(@"blk3");});
    //执行完成之后处理
    //1. dispatch_group_notify
    //第二个参数,不论是什么队列,添加在queue中的任务都已经执行完毕.
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{NSLog(@"all over");});

    //2. dispatch_group_wait
    //可以设置等待时间,根据返回值确定在等待的时间内是否完成了任务
    //等待意味着调用该函数后函数处于调用状态而不返回,在指定的时间到达前或任务全部执行完之前,执行该函数的当前线程停止.
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
    long ret = dispatch_group_wait(group, time/*DISPATCH_TIME_FOREVER*/);//DISPATCH_TIME_FOREVER永久等待中途不能取消
    if (ret == 0) {
        NSLog(@"完成了所有的任务");
        //如果等待时间设置成DISPATCH_TIME_FOREVER,在此任务一定全部执行完成,可以做一些特定的任务,eg:更新UI等.
    }else{
        NSLog(@"任务还在执行中");
    }
    
}
/**
 dispatch_after
 */
- (void)gcdDispatchAfter{
    
    //从现在开始在5秒时候追加/添加任务;任务的确切执行时间是在3+秒之后
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));
    //另一种形式,指定到毫秒等
    dispatch_time_t time_1 = dispatch_time(DISPATCH_TIME_NOW, 50ull * NSEC_PER_MSEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        NSLog(@"我执行的时候距指定时间(DISPATCH_TIME_NOW)已经超过5秒了");
    });
    
    //第一个参数:A struct timespec to add time to. If NULL is passed, then this function uses the result of gettimeofday.
    dispatch_time_t t = dispatch_walltime(NULL, 10ull * NSEC_PER_SEC);
    dispatch_after(t, dispatch_get_main_queue(), ^{
        NSLog(@"我执行的时候距指定时间(gettimeofday)已经超过10秒了");
    });
    
    //dispatch_time_t一般用于指定相对时间,dispatch_walltime一般用于指定绝对时间.
    dispatch_time_t time_wall = getDispatchTimeByDate([NSDate dateWithTimeIntervalSinceNow:15]);
    dispatch_after(time_wall, dispatch_get_main_queue(), ^{
        NSLog(@"我执行的时候距指定时间(dateWithTimeIntervalSinceNow)已经超过15秒了");
    });
}

dispatch_time_t getDispatchTimeByDate(NSDate *date){
    NSTimeInterval interval;
    double second, subsecond;
    struct timespec time;
    dispatch_time_t milestone;
    
    interval = [date timeIntervalSince1970];
    subsecond = modf(interval, &second);
    time.tv_sec = second;
    time.tv_nsec = subsecond * NSEC_PER_SEC;
    milestone = dispatch_walltime(&time, 0);
    return milestone;
};

/**
 Dispatch Target Queue
 */
- (void)gcdDispatchTargetQueue{
    /*
     GCD中队列是有层级的。事实上只有全局系统队列会被调度运行。可以使用dispatch_get_global_queue和优先级常量来访问这些(全局系统队列)队列.
     这些队列都是并行的.GCD会根据可用线程尽可能从高优先级队列调用块.
     系统会根据可用的核心数和负载按需创建或销毁线程.
     开发人员自己创建队列时,队列会附加到某一全局队列(也就是目标队列).当块到达头部时,实际上会移动到目标队列的末尾,当到达全局队列(目标队列)的头部时就会执行.
     用dispatch_set_target_queue可以改变目标队列.
     */
    
    //1. 变更优先级
    //dispatch_queue_create生成的queue都是默认的优先级,如果想更改优先级就需要dispatch_set_target_queue
    dispatch_queue_t myqueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL/*DISPATCH_QUEUE_CONCURRENT*/);
    dispatch_queue_t globalqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    //使myqueue的优先级与globalqueue的优先级相同
    dispatch_set_target_queue(myqueue, globalqueue);
    //注意:
    //如果第一个参数为Main Dispatch Queue或Global Dispatch Queue则不知道会发生什么状况,所以不要这样指定.
    
    //2. 如果用dispatch_set_target_queue方法将多个Serial Dispatch Queue指定到同一个Serial Dispatch Queue,
    //   那么原本应并行执行的多个SDQ在目标SDQ上只能顺序串行执行
    dispatch_queue_t queue_serial_1 = dispatch_queue_create("com.penn.myqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue_serial_2 = dispatch_queue_create("com.penn.myqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue_serial_3 = dispatch_queue_create("com.penn.myqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue_serial_4 = dispatch_queue_create("com.penn.myqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue_serial_5 = dispatch_queue_create("com.penn.myqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(queue_serial_1, myqueue);
    dispatch_set_target_queue(queue_serial_2, myqueue);
    dispatch_set_target_queue(queue_serial_3, myqueue);
    dispatch_set_target_queue(queue_serial_4, myqueue);
    dispatch_set_target_queue(queue_serial_5, myqueue);
    dispatch_async(queue_serial_1, ^{
        NSLog(@"block1, %@", [NSThread currentThread]);
    });
    dispatch_async(queue_serial_2, ^{
//        sleep(2);
        NSLog(@"block2, %@", [NSThread currentThread]);
    });
    dispatch_async(queue_serial_3, ^{
        NSLog(@"block3, %@", [NSThread currentThread]);
    });
    dispatch_async(queue_serial_4, ^{
//        sleep(1);
        NSLog(@"block4, %@", [NSThread currentThread]);
    });
    dispatch_async(queue_serial_5, ^{
        NSLog(@"block5, %@", [NSThread currentThread]);
    });
    /*
     Penn[5162:460809] block1, <NSThread: 0x60000007dcc0>{number = 3, name = (null)}
     //延时2秒
     Penn[5162:460809] block2, <NSThread: 0x60000007dcc0>{number = 3, name = (null)}
     Penn[5162:460809] block3, <NSThread: 0x60000007dcc0>{number = 3, name = (null)}
     //延时1秒
     Penn[5162:460809] block4, <NSThread: 0x60000007dcc0>{number = 3, name = (null)}
     Penn[5162:460809] block5, <NSThread: 0x60000007dcc0>{number = 3, name = (null)}
     */
    
    dispatch_queue_t queue_1 = dispatch_queue_create("low", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue_2 = dispatch_queue_create("high", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(queue_1, queue_2);
    dispatch_async(queue_1, ^{
        NSLog(@"low block:%@", [NSThread currentThread]);
        sleep(3);
    });
    
    dispatch_suspend(queue_1);
    dispatch_async(queue_2, ^{
        NSLog(@"high block:%@", [NSThread currentThread]);
        sleep(3);
        dispatch_resume(queue_1);
    });
    
    dispatch_async(queue_1, ^{
        NSLog(@"low block-2:%@", [NSThread currentThread]);
        sleep(3);
    });

}

/**
 Dispatch Queue
 */
- (void)gcdDispatchQueue{
    /*
     Serial Dispatch Queue:手动控制queue的数量,对应的可以开启对应数量的子线程
     Concurrent Dispatch Queue:系统控制(XNU内核)
     */
    

    
    /*
     Dispatch Queue的创建方式有两种,dispatch_queue_create,
     Serial Dispatch Queue的生成个数注意事项:
     * concurrent可以执行多个任务,serial同时只能执行1个任务,但是queue的个数可以是任意多个.
     * 虽然一个serial中只能执行1个任务,但是可以将多个任务分别加入各个serial队列中,即可同时执行多个任务.
     * 一个很显而易见的问题,concurrent的多个子线程根据系统的资源分配情况,一个子线程可能执行多个任务,但是将多个任务分别加入到对应的多个serial队列中,每个队列只执行自己队列中的那一个任务.
     * 虽然可以生成多个队列,但是并不是越多越好.
     */
    
    //1. dispatch_queue_create: 两个参数都可以传NULL,为serial队列;
    {
        //1. 串行队列,在一个子线程中按顺序串行执行,
        dispatch_queue_t queue_serial = dispatch_queue_create("com.penn.gcd", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue_serial, ^{
            NSLog(@"block1, %@", [NSThread currentThread]);
        });
        dispatch_async(queue_serial, ^{
            sleep(1);
            NSLog(@"block2, %@", [NSThread currentThread]);
        });
        dispatch_async(queue_serial, ^{
            NSLog(@"block3, %@", [NSThread currentThread]);
        });
        dispatch_async(queue_serial, ^{
            sleep(1);
            NSLog(@"block4, %@", [NSThread currentThread]);
        });
        dispatch_async(queue_serial, ^{
            NSLog(@"block5, %@", [NSThread currentThread]);
        });
        
        //2. 并行队列/并发队列, 在多个子线程中执行任务,后一个不需要等待前一个执行完再执行
        dispatch_queue_t queue_concurrent = dispatch_queue_create("com.penn.myqueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue_concurrent, ^{
            NSLog(@"block11, %@", [NSThread currentThread]);
        });
        dispatch_async(queue_concurrent, ^{
            NSLog(@"block22, %@",[NSThread currentThread]);
        });
        dispatch_async(queue_concurrent, ^{
            NSLog(@"block33, %@", [NSThread currentThread]);
        });
        dispatch_async(queue_concurrent, ^{
            NSLog(@"block44, %@", [NSThread currentThread]);
        });
        dispatch_async(queue_concurrent, ^{
            NSLog(@"block55, %@", [NSThread currentThread]);
    });
    /*
     Penn[2550:230900] block1, <NSThread: 0x60800026e4c0>{number = 3, name = (null)}
     Penn[2550:230913] block11, <NSThread: 0x6040002782c0>{number = 4, name = (null)}
     Penn[2550:230912] block22, <NSThread: 0x600000269f40>{number = 5, name = (null)}
     Penn[2550:230906] block33, <NSThread: 0x608000265a00>{number = 6, name = (null)}
     Penn[2550:230904] block44, <NSThread: 0x600000269f00>{number = 7, name = (null)}
     Penn[2550:231132] block55, <NSThread: 0x608000275d80>{number = 8, name = (null)}
     Penn[2550:230900] block2, <NSThread: 0x60800026e4c0>{number = 3, name = (null)}
     Penn[2550:230900] block3, <NSThread: 0x60800026e4c0>{number = 3, name = (null)}
     Penn[2550:230900] block4, <NSThread: 0x60800026e4c0>{number = 3, name = (null)}
     Penn[2550:230900] block5, <NSThread: 0x60800026e4c0>{number = 3, name = (null)}
     */
        {// 串行队列可以并行执行任务
            dispatch_queue_t queue_serial_1 = dispatch_queue_create("com.penn.myqueue", DISPATCH_QUEUE_SERIAL);
            dispatch_queue_t queue_serial_2 = dispatch_queue_create("com.penn.myqueue", DISPATCH_QUEUE_SERIAL);
            dispatch_queue_t queue_serial_3 = dispatch_queue_create("com.penn.myqueue", DISPATCH_QUEUE_SERIAL);
            dispatch_queue_t queue_serial_4 = dispatch_queue_create("com.penn.myqueue", DISPATCH_QUEUE_SERIAL);
            dispatch_queue_t queue_serial_5 = dispatch_queue_create("com.penn.myqueue", DISPATCH_QUEUE_SERIAL);

            dispatch_async(queue_serial_1, ^{
                NSLog(@"block1, %@", [NSThread currentThread]);
            });
            dispatch_async(queue_serial_2, ^{
                NSLog(@"block2, %@", [NSThread currentThread]);
            });
            dispatch_async(queue_serial_3, ^{
                NSLog(@"block3, %@", [NSThread currentThread]);
            });
            dispatch_async(queue_serial_4, ^{
                NSLog(@"block4, %@", [NSThread currentThread]);
            });
            dispatch_async(queue_serial_5, ^{
                NSLog(@"block5, %@", [NSThread currentThread]);
            });
            /*
             Penn[2936:269718] block1, <NSThread: 0x608000275b40>{number = 3, name = (null)}
             Penn[2936:269720] block4, <NSThread: 0x6040002724c0>{number = 5, name = (null)}
             Penn[2936:269725] block2, <NSThread: 0x604000271a00>{number = 4, name = (null)}
             Penn[2936:269726] block3, <NSThread: 0x6080004648c0>{number = 6, name = (null)}
             Penn[2936:270055] block5, <NSThread: 0x604000272680>{number = 7, name = (null)}
             
             */
        }
    }
    
    //2. 获取系统提供的Dispatch Queue
    //Main Dispatch Queue和Global Dispatch Queue
    //主线程只有一条,所以MDQ就是Serial Dispatch Queue
    //对应的GDQ就是Concurrent Dispatch Queue
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        //dispatch_get_global_queue(long identifier, unsigned long flags);
        //第一个参数指定此任务执行的优先级,0为默认的优先级;
        //但是并不能完全保证优先级的实时性,只是大致判断.当任务可有可无时可以使用后台优先级,只能进行这种程度的区分.
        /*
         #define DISPATCH_QUEUE_PRIORITY_HIGH 2
         #define DISPATCH_QUEUE_PRIORITY_DEFAULT 0
         #define DISPATCH_QUEUE_PRIORITY_LOW (-2)
         #define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN
         */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
            
        });
        
    }

}

#pragma mark - 多线程

- (void)multiThread{
    
    //1. GCD
    //2. NSOperation
    //3. NSThread
    
    // 多线程的优点: 异步执行任务 高效
    /* 多线程的问题:
     数据竞争:可以使用Serial Dispatch Queue解决, 一个队列只执行一类相关任务,eg:更新数据库时,一个表生成一个Serial Dispatch Queue
     死锁:线程管理
     消耗内存:管理线程数量
    */
    
    /*
     GCD是异步执行任务的技术之一. 一般将应用程序中的管理线程的代码在系统级实现.开发者只需要将想执行的任务追加到适当的Dispatch Queue中,GCD就能生成必要的线程并执行任务.因为线程管理是作为系统的一部分来实现的,因此可统一管理,执行任务,所以比之前的线程效率更高.
     */
    
}

@end
