//
//  PNMemManController.m
//  Penn
//
//  Created by emoji on 2018/8/6.
//  Copyright © 2018年 PENN. All rights reserved.
/*
 内存管理
 
 */

#import "PNMemManController.h"

//ARC: C语言结构体包含对象必须使用__unsafe_unretained修饰
//因为:C语言的内存管理由编译器完成,ARC默认把内存的管理工作分配给编译器
struct Data{
    NSMutableArray __unsafe_unretained * arr;
};

extern void _objc_autoreleasePoolPrint(void);
uintptr_t _objc_rootRetainCount(id obj);

@interface PNMemManController ()

@property (nonatomic, strong) NSArray * arr;
//unsafe_unretained, weak, assign are mutually exclusive(三者互斥)
//@property (nonatomic, unsafe_unretained, weak, assign) UIImage * image;

@end


@implementation PNMemManController
{
    //成员变量可以这样声明
    id __weak weakObj;
    id __strong strongObj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testAutoreleasingOtherSample];

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




#pragma mark - Test Func

- (void)testRetainCount{
    //在ARC中可以通过此调试非公开函数查看引用计数
    //但是,此函数在输出已经释放的对象或不正确的对象地址也可能输出1;另外,在多线程中使用,因为存在竞争条件的问题,输出的值也不一定可信.
    //_objc_rootRetainCount(nil);
    
    {//__weak修饰不增加引用计数
        id obj = [NSObject new];
        NSLog(@"%lu",_objc_rootRetainCount(obj));//1
        id __weak obj_weak = obj;
        NSLog(@"%@",[obj_weak class]);
        NSLog(@"%lu",_objc_rootRetainCount(obj));//1
    }
    
    {//__autoreleasing向自动释放池中注册变量所引用的对象,引用计数加1
        @autoreleasepool {
            id obj = [[NSObject alloc] init];
            id __autoreleasing obj_auto = obj;
            NSLog(@"%lu",_objc_rootRetainCount(obj));//2
        }
    }
    
    {// __autoreleasing和__strong都会使引用计数加1,pop自动释放池后,pool对其中对象发送release消息.计数减1,强引用还存在最终为2.
        id obj = [[NSObject alloc] init];
        id obj_str = nil;
        @autoreleasepool {//push
            id __autoreleasing obj_auto = obj;
            NSLog(@"%lu",_objc_rootRetainCount(obj));//2
            obj_str = obj;
            NSLog(@"%lu",_objc_rootRetainCount(obj));//3
        }//pop
        NSLog(@"%lu",_objc_rootRetainCount(obj));//2

    }
    
    {//强引用指针超出作用域,强指针和__autoreleasing变量都使引用计数减1
        id obj = [[NSObject alloc] init];
        @autoreleasepool {
            id __autoreleasing obj_auto = obj;
            NSLog(@"%lu",_objc_rootRetainCount(obj));//2
            id obj_str = obj;
            NSLog(@"%lu",_objc_rootRetainCount(obj));//3
        }
        //因为obj_str超出作用域,不再持有对象-1, 自动释放池对其中的对象进行一此release操作-1
        NSLog(@"%lu",_objc_rootRetainCount(obj));//1
        
    }
    
    {//强引用变量在出池后超出作用域,强引用失效,自动释放自己持有的对象;
        //引用计数出池前后都为1
        id obj = [[NSObject alloc] init];
        @autoreleasepool {
            {
                id obj_auto = obj;
                NSLog(@"%lu",_objc_rootRetainCount(obj));//2
                id obj_str = obj;
                NSLog(@"%lu",_objc_rootRetainCount(obj));//3
            }
             NSLog(@"%lu",_objc_rootRetainCount(obj));//1
        }
        NSLog(@"%lu",_objc_rootRetainCount(obj));//1
        
    }
    
    {//__autoreleasing 向pool中注册对象,引用计数增加,超出变量作用域之后依然不能释放,直到出池才释放注册在池中的对象
        id obj = [[NSObject alloc] init];
        @autoreleasepool {
            {
                id __autoreleasing obj_auto = obj;
                NSLog(@"%lu",_objc_rootRetainCount(obj));//2
                id __autoreleasing obj_str = obj;
                NSLog(@"%lu",_objc_rootRetainCount(obj));//3
            }
            NSLog(@"%lu",_objc_rootRetainCount(obj));//3
        }
        NSLog(@"%lu",_objc_rootRetainCount(obj));//1
        
    }
    
    {
        @autoreleasepool {
            id __strong obj = [[NSObject alloc] init];
            _objc_autoreleasePoolPrint();
            id __weak obj_weak = obj;
            NSLog(@"%lu",_objc_rootRetainCount(obj));//1
            NSLog(@"class:%@",[obj_weak class]);
            NSLog(@"%lu",_objc_rootRetainCount(obj));//1 书中显示此处为2.因为使用过obj_weak后会向pool中注册其引用的对象,
            _objc_autoreleasePoolPrint();
        }
    }
    
    
}

- (void)testWeakReleasePool{
    //(void)[[[NSObject alloc] init] hash];
    _objc_autoreleasePoolPrint();//输出当前自动释放池中的对象.
    
    id obj = [[NSObject alloc]init];
    
    {
        //汇编命令
        //clang -fobjc-arc -S  <文件名.m>
        
        //通过汇编后的代码可以看出这里调用了5次_objc_loadWeakRetained和_objc_release,即被__weak修饰的变量被注册到pool中5次
        //通过obj_strong再次引用后,调用obj_strong的方法五次只会调用_objc_loadWeakRetained一次,_objc_release没有调用
        //_objc_loadWeakRetained函数取出附有__weak修饰符的变量所引用的对象并retain
        //_objc_release函数将对象注册到autoreleasepool中
        
        id __weak obj_weak = obj;
        //id obj_strong = obj_weak;
        NSLog(@"1%@",obj_weak);
        NSLog(@"2%@",obj_weak);
        NSLog(@"3%@",obj_weak);
        NSLog(@"4%@",obj_weak);
        NSLog(@"5%@",obj_weak);
         _objc_autoreleasePoolPrint();//ios9前可以看到5次obj_weak,之后苹果对此做了优化,两种情况都看不到输出的NSObject的对象.
    }
   
    
}
//CF--CoreFoundation
//F--Foundation

- (void)testCoreFoun_Foun{
    CFMutableArrayRef ref = NULL;
    {
        id obj = [[NSMutableArray alloc] init];
        // ref = CFBridgingRetain(obj);//与下面相同,但是现在有警告⚠️,不推荐使用
        ref = (__bridge_retained CFMutableArrayRef)obj;
        CFShow(ref);//输出(),即空数组
        printf("retainCount=%ld\n", (long)CFGetRetainCount(ref));//2
    }
    printf("out of scope retainCount=%ld\n", (long)CFGetRetainCount(ref));//1
    CFRelease(ref);
}

- (void)testFoun_CoreFoun{
    CFMutableArrayRef ref = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
    printf("%ld\n", (long)CFGetRetainCount(ref));
    //    id obj = CFBridgingRelease(ref);//retainCount=2,与书中介绍(为1)有别,不推荐使用
    id obj = (__bridge_transfer id)(ref);
    printf("%ld\n", (long)CFGetRetainCount(ref));//1
    NSLog(@"%@\n%@", obj,[obj class]);
}


//显式转换id与void*
- (void)testTypeConversion{
    //id类型或者对象类型赋值给void*或者逆向赋值都需要进行特定的转换.
    {
        //如果只是想单纯的赋值,可以使用__bridge
        
        //1.__bridge
        id obj = [[NSObject alloc]init];
        //转换为void *的__bridge变换其安全性与__unsafe_unretained相近或更低.容易造成野指针.
        void *p = (__bridge void *)(obj);
        
        id o = (__bridge id)(p);
    }
    
    void *p = 0;
    {
        //2.__bridge_retained(同时持有)与__bridge_transfer(转换接管)
        id obj = [[NSObject alloc] init];
        
        p = (__bridge_retained void*)obj;//p对对象进行强引用,引用计数+1
        //相当于MRC下
        /*
         void *p_m = obj;
         [(id)p_m retain];
         */
        
        
        id obj_p = (__bridge_transfer id)p;
        //相当于MRC下
        /*
         id obj_p = (id)p;
         [obj_p retain];
         [(id)p release];
         */
    }
    
    {
        //arc不推荐这样使用:不使用变量
        void *pp = (__bridge_retained void *)[[NSObject alloc]init];
        NSLog(@"%@", [(__bridge id)pp class]);
        (void)(__bridge_transfer id)pp;
        //相当于MRC下:
        /*
         id pp = [[NSObject alloc]init];
         NSLog(@"%@", [pp class]);
         [pp release];
         */
    }
    
}


- (void)testAutoreleasingOtherSample{
    // __weak修饰的变量,实际上也必定会访问注册到autoreleaspool的对象
    id obj0 = [[NSObject alloc]init];
    
    id __weak obj1 = obj0;
    NSLog(@"class=%@",[obj1 class]);
    //下面与上面等效
    id __weak obj2 = obj0;
    id __autoreleasing tmp = obj2;
    NSLog(@"class=%@", [tmp class]);

    
    
    NSError *error = nil;
    //1.错误用法
    // 下面编译错误:❎Pointer to non-const type 'NSError *' with no explicit ownership
    // 因为类型不一致,error默认为NSError __strong *类型
    // NSError **pError = &error;
    
    //2.正确示例
    NSError * __strong *p = &error;//这样正确
    
    //3. Cocoa框架很多此类用法
    //error参数类型:(NSError * _Nullable __autoreleasing * _Nullable)
    // 此处传入参数为NSError __string *却没有问题是因为编译器自动进行了转换
    NSError __autoreleasing *tmpError = error;
    [NSString stringWithContentsOfFile:@"someFile" encoding:NSUTF8StringEncoding error:&tmpError];
    [self performOperationWithError:&tmpError];
    error = tmpError;
    //与上面等效
    [NSString stringWithContentsOfFile:@"someFile" encoding:NSUTF8StringEncoding error:&error];
    [self performOperationWithError:&error];
    

    NSError *e1 = nil;
    [self performOperationWithComparison1Error:e1];
    NSLog(@"%@", e1);//(null)
    
    //通过与上面两种情况对比可知:
    //1.此处若使用二级指针可以起到传值作用
    //2.__autoreleasing,
    NSError *e2 = nil;
    [self performOperationWithComparison2Error:&e2];
    NSLog(@"%@", e2);//Error Domain=NSNetServicesErrorDomain Code=403 "(null)" UserInfo={key=value}
}
//自定义示例
- (void)performOperationWithError:(NSError * __autoreleasing *)error{
    NSError * e = [[NSError alloc] initWithDomain:NSNetServicesErrorDomain code:404 userInfo:@{@"key":@"value"}];
    *error = e;
}
- (void)performOperationWithComparison1Error:(NSError *)error{
    NSError * e = [[NSError alloc] initWithDomain:NSNetServicesErrorDomain code:403 userInfo:@{@"key":@"value"}];
    error = e;
}
//默认是__strong, 可以省去
//像这样,对象不注册到自动释放池也能够传递.但是内存管理的规则是:
//只有作为alloc/new/copy/mutableCopy方法返回而取得的对象时,能够自己生成并持有对象.其他情况均为"取得非自己生成并持有的对象".
//为了在使用参数取得对象时,贯彻内存管理的思考方式,我们要将参数声明为附有__autoreleasing修饰符的对象指针类型.
//另外,虽然可以非显式地指定__autoreleasing修饰符,但是在显式的指定__autoreleasing修饰符时,必须注意对象变量要为自动变量(局部变量,函数以及方法参数)
- (void)performOperationWithComparison2Error:(NSError * __strong*)error{
    NSError * e = [[NSError alloc] initWithDomain:NSNetServicesErrorDomain code:402 userInfo:@{@"key":@"value"}];
    *error = e;
}

- (void)test__Strong__Weak{
    // __strong是默认的,不用写,此处为测试使用
    // __strong 在ARC中代替MRC中的retain,保证对象在超出作用域之时,即该变量被废弃时,会释放其修饰的对象
    NSObject * obj = [NSMutableArray array];
    id oid = [NSMutableArray array];
    id __strong oid1 = [[NSObject alloc] init];
    
    //__weak可以破除循环引用
    id  oidweak = [[NSObject alloc]init];
    id __weak objweak = oidweak;
    
    
    NSLog(@"%@%@%@%@", obj, oid, oid1, objweak);
}

- (void)testWeakAndUnsafeUnretained{
    id __weak obj_weak0 = nil;
    {
        id obj_weak1 = [[NSObject alloc] init];
        obj_weak0 = obj_weak1;
        NSLog(@"0:%p", obj_weak0);
        NSLog(@"0:%@", obj_weak0);
    }
    NSLog(@"0:%p", obj_weak0);
    NSLog(@"0:%@", obj_weak0);
    
    
    
    id __unsafe_unretained obj_uu0 = nil;
    {
        id  obj_uu1 = [[NSObject alloc] init];
        obj_uu0 = obj_uu1;
        NSLog(@"0:%p", obj_uu0);
        NSLog(@"0:%@", obj_uu0);
        //至此,两者仍没有区别
    }
    NSLog(@"0:%p", obj_uu0);
    //此处obj_uu0已经被释放,再次访问会发生EXC_BAD_ACCESS
    NSLog(@"0:%@", obj_uu0);
    
    /*
     2018-08-06 17:03:24.147371+0800 Penn[9526:710854] 0:0x60c00000fa80
     2018-08-06 17:03:24.596913+0800 Penn[9526:710854] 0:<NSObject: 0x60c00000fa80>
     2018-08-06 17:03:25.386054+0800 Penn[9526:710854] 0:0x0
     2018-08-06 17:03:25.674568+0800 Penn[9526:710854] 0:(null)
     2018-08-06 17:03:26.800733+0800 Penn[9526:710854] 0:0x60800001b020
     2018-08-06 17:03:27.104909+0800 Penn[9526:710854] 0:<NSObject: 0x60800001b020>
     2018-08-06 17:03:27.847196+0800 Penn[9526:710854] 0:0x60800001b020
     此处崩溃没有输出：Thread 1: EXC_BAD_ACCESS (code=EXC_I386_GPFLT)
     */
}

- (void)testAutorelease{
    //如果在循环中大量创建对象,函数返回前无发释放,会占用大量的内存空间;
    //可以使用autoreleasePool
    for (NSInteger i = 0; i < 100000; i++) {
        //ARC
        @autoreleasepool{
            //使用__autoreleasing修饰的对象相当于MRC中调用autorelease方法,对象会注册到自动释放池中
            id  obj_i = [UIImage imageNamed:@"card"];
            NSLog(@"%p",obj_i);
        }
        //MRC
        /*
         NSAutoreleasePool * pool = [[NSAutoreleasePool alloc]init];
         id obj_m = [[NSObject alloc] init];
         [obj_m autorelease];
         [pool drain];
         */
        
    }
}


@end
