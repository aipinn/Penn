//
//  PNBlockViewController.m
//  Penn
//
//  Created by emoji on 2018/8/13.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNBlockViewController.h"

typedef void (^blk_obj)(id obj);

@interface PNBlockViewController ()

@property (nonatomic, copy) blk_obj block_obj;
@property (nonatomic, strong) NSMutableArray * arr;

@end

@implementation PNBlockViewController
{
    blk_obj _blk;
    id _obj;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self blockRetainCycle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Test

- (void)referencingBlock{
    setButtonCallbacks(10);
    
}
#pragma mark - C语言指针调用函数

int func(int count){
    return count;
}
- (void)referencingCPragram{
    //直接调用
    int ret = func(10);
    //通过函数指针调用,前提仍然需要知道函数名
    int (*funcptr)(int) = &func;
    int retp = (*funcptr)(100);
    printf("%d\n%d\n",ret, retp); //10  100
    //Block是匿名函数就是不需要函数名称就可以调用函数
}

#pragma mark - 引入block.与C语言对比回调.

int buttonId = 0;
void buttonCallback(int event){
    printf("id:%d\tevent:%d\n", event, buttonId);
}
void setButtonCallback(int bid, void (*funcptr)(int)){
    (*funcptr)(bid);
}
void setButtonCallbackUsingBlock(int e, void (^block)(int event)){
    block(e);
}
void setButtonCallbacks(int max){
    for (int i = 0; i < max; i++) {
        buttonId = i;
        //C 语言
        setButtonCallback(i, &buttonCallback);
        //引入block
        setButtonCallbackUsingBlock(i, ^(int event){
            printf("id:%d\tevent:%d\n", event, i);
        });
    }
}
#pragma mark - block语法
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
#pragma clang diagnostic ignored "-Wunused-variable"
- (void)blockSyntax{

    //-------------------------|
    // ^ 返回值类型 参数列表 表达式 |
    //-------------------------|
    
    //1. 无返回值无参数
    ^void(void){
        
    };
    // 无返回值无参数省略方式
    ^{
        printf("省略参数和返回值");
    };
    
    //2. 无返回值有参数
    ^void (int event){
        
    };
    //void可以省略
    ^(int event){
        
    };
    
    //3.有返回值有参数
    ^int (int count){
      return count+1;
    };
    //返回值类型可以省略,当表达式中含有多个返回值时,所有返回值类型必须一致.
    ^(int count){
        if(count){
            return count;
        }else{
            return count+1;
            //return @"string type"; // 错误类型
        }
    };

}

#pragma mark - Block类型变量
//C语言含数指针变量
int funcAdd(int count){
    return count+1;
}
int (*funcAddptr)(int) = &funcAdd;

void (^block_global)(void);

static void (^block_static_global)(void);
//Block类型变量
- (void)blockTypeVar{

    //声明一个block变量
    //仅仅是将声明函数指针类型变量的*变为^.
    //所以,block可以像C语言的变量一样使用,可以作为:
    /*
     1. 自动变量(局部变量)
     2. 函数参数
     3. 静态变量
     4. 静态全局变量
     5. 全局变量
     */
    int (^block)(int);
    
    block_global = ^{};
    
    static int (^block_static)(int);
    
    block_static_global = ^{};
    
    //赋值
    int (^blk)(int) = ^(int count){
        return count+1;
    };
    //调用
    block = blk;
    blk(0);
    block(1);
    [self callBack:^(int count) {
        printf("%d", count);
    }];

}
// Block作为参数
- (void)callBack:(void (^)(int count))callBack{
    callBack(1);
}

#pragma mark - Block 捕获变量/值
static int static_global_val = 10;
int global_val = 10;
- (void)blockInterceptAndCaptureVar{

    //1.可以修改指针指向的数据的值.
    id arr = [[NSMutableArray alloc] init];
    void (^blk)(void) = ^{
        id obj = [NSObject new];
        [arr addObject:obj];
    };
    blk();
    NSLog(@"%@", arr);
    //2.__block修饰的变量可以修改指针指向
    __block id array = [[NSMutableArray alloc] init];
    void (^block)(void) = ^{
        array = [NSMutableArray arrayWithObjects:@"123", nil];
    };
    block();
    NSLog(@"%@", arr);
    //3.使用C语言数组时必须小心使用其指针
    {
        const char text[] = "hello";
        void (^block)(void) = ^{
//            printf("%c",text[2]);//编译错误:Cannot refer to declaration with an array type inside block
        };
    }
    //4.改进3
    {
        const char *text = "hello";
        void (^block)(void) = ^{
            printf("%c\n", text[2]); //l
        };
        block();
    }
    /*5
     * C语言中的几种类型的变量可以在block中改变, 因为它们存放的区域不在栈上
     * 1. 静态变量
     * 2. 静态全局变量
     * 3. 全局变量
     */
    
    void (^blk_1)(void) = nil;
    {

        static int static_val = 10;
        static NSString *str = @"123";
        void (^block)(void) = ^{
            static_val = 20;
            str = @"234";
            static_global_val = 20;
            global_val = 20;
            printf("%d", static_global_val);
        };
        block();
        NSLog(@"%d\n%@\n", static_val, str);//20 234
        blk_1 = ^{
            static_val = 30;
        };
        printf("out_static_val:%d", static_val);
    }
    blk_1();
    
    /*
     1. block不可修改外部局部变量:block仅仅捕获到了变量的值
     2. 可以修改静态全局变量:block捕获到了变量的指针
     3. __block修饰的局部变量:被修饰的变量被转化为结构体__Block_byref_val_0,block捕获到结构体指针,通过结构体来访问变量
     
     //变量__block int val被转化后:
     struct __Block_byref_val_0 {
     void *__isa; //说明这是一个对象
     __Block_byref_val_0 *__forwarding; //指向当前结构体本身
     int __flags;
     int __size;
     int val;
     };
     */
}

#pragma mark - Block的实现

- (void)blockRealize{
    
    
    
}

#pragma mark - Block的存储区域

typedef int (^blk_t)(int);
blk_t blk = ^(int count){return count;};

- (void)blockStoreSegment{
    /*
     _NSGlobalBlock的情况:
         1.全局变量Block
         2.Block语法的表达式中不使用外部变量
     */
    
    //1. 全局变量
    NSLog(@"GlobalBlock:%@", blk); // GlobalBlock:<__NSGlobalBlock__: 0x1085c8980>
    blk_t bbb = blk;
    NSLog(@"%@", bbb);
    //2. 不使用外部变量
    blk_t blk_global = ^(int count){return count;};
    NSLog(@"GlobalBlock:%@", blk_global);// GlobalBlock:<__NSGlobalBlock__: 0x1085c89c0>
    NSLog(@"GlobalBlock:%@", ^(int count){return count;}); // GlobalBlock:<__NSGlobalBlock__: 0x1085c8a00>
    //3. 使用外部捕获的变量
    int a = 8;
    NSLog(@"StackBlock:%@", ^(int count){return count * a;});// StackBlock:<__NSStackBlock__: 0x7ffee765a0e0>
    //使用__weak修饰的变量单纯的指向Block,此变量为栈Block
    __weak blk_t blk_weak = ^(int count){// Assigning block literal to a weak variable; object will be released after assignment
        printf("%d\n", a);
        return a;
    };// <__NSStackBlock__: 0x7ffeeb28c0f8>
    NSLog(@"%@", blk);
    //4. 局部变量
    void (^blk_lg)(void) = ^{};
    void (^blk_lg_v)(void) = ^{int b = a+1;};
    NSLog(@"%@, %@", blk_lg, blk_lg_v); // <__NSGlobalBlock__: 0x100e22a60>, <__NSMallocBlock__: 0x60c000245a00>

    //5. 使用外部变量,并赋值; 在赋值的过程中(ARC变量默认是__strong修饰,在内部会进行objc_retainBlock操作,objc_retainBlock实际上就是_Block_copy)进行了copy,至堆上.
    blk_t blk_malloc = ^(int count){return count * a;};
    NSLog(@"MallocBlock:%@", blk_malloc);// MallocBlock:<__NSMallocBlock__: 0x600000058e40>
    
    NSArray * arr1 = [self getArrayWithoutLocalVariable];
    blk_t blk1 = arr1[0];
    NSLog(@"%@", blk1);// <__NSGlobalBlock__: 0x106590a80>
    blk1(10);

    //崩溃
    //NSArray * arr2 = [self getArrayWithLocalVariable];
    //blk_t blk2 = arr2[0];
    //NSLog(@"%@", blk2);// <__NSMallocBlock__: 0x604000253b60>
    //blk2(10);
    
    //因为返回数组的方法中的Block超出了作用域,栈上的Block被废弃
    //在大多数情况下编译器会自动将栈上的block复制到堆上,但是当block作为参数在函数或方法中传递时,block不会自动复制,需要手动copy
    //eg: 其实即便不取出block元素使用,依然会崩溃;(遇到一个奇怪的问题, 第0个元素不copy不会有问题)
    NSArray * arr3 = [self getArrayWithLocalVariableManCopy];
//    blk_t blk3 = arr3[0];
//    blk3(10);
    
//===================================================
    //总结:
    //注意区分Block, 与Block变量的区别:Block指的是表达式^{},Block变量指的是指向Block表达式的变量
    //1. 全局变量是Block类型或者Block表达式不使用外部变量时,则生成的Block为_NSConcreteGlobalBlock
    //2. 使用外部变量的Block为_NSConcreteStackBlock
    //3. 手动copy后,GlobalBlock仍为GlobalBlock,栈Block变为堆Block.
    //4. arc下,赋值过程因为默认是__strong修饰符,会发生拷贝(ARC变量默认是__strong修饰,在内部会进行objc_retainBlock操作,objc_retainBlock实际上就是_Block_copy);
    // 则如果Block表达式(^{})为Stack被赋值的变量为Malloc, 表达式为Global被赋值的变量仍然为Global
//===================================================
}

//构建block数组,不使用外部变量
- (NSMutableArray *)getArrayWithoutLocalVariable{
    NSLog(@"%@", ^(int count){return count;});// 全局block, __NSGlobalBlock__
    NSLog(@"%@", [^(int count){return count;} copy]);// __NSGlobalBlock__
    return [[NSMutableArray alloc] initWithObjects:
            ^(int count){return count;},
            ^(int count){return count;},
            ^(int count){return count;},
            nil];
}
//构建block数组,使用外部变量
- (NSMutableArray *)getArrayWithLocalVariable{
    NSInteger num = 10;
    NSLog(@"%@", ^(int count){return count*num;});// 栈block
    return [[NSMutableArray alloc] initWithObjects:
            ^(int count){return count*num;},
            ^(int count){return count*num;},
            ^(int count){return count*num;},
            nil];
}
//构建block数组,使用外部变量,手动copy
- (NSArray *)getArrayWithLocalVariableManCopy{
    NSInteger num = 10;
    NSLog(@"%@", [^(int count){return count*num;} copy]); //堆block
    return [[NSArray alloc] initWithObjects:
            ^(int count){return count*num;} ,// 第一个元素不copy也不会崩溃.why?????
            [^(int count){return count*num;} copy],
            [^(int count){return count*num;} copy],
            nil];

}
#pragma mark - Block变量的存储区域
- (void)blockVariableStoreSegment{
    
    // 栈上的Block和__block变量,blk是MallocBlock
    __block int a = 10;
    void  (^blk)(void) = /*[*/^{
        a++;
    } /*copy]*/;//Block和__block变量val都从栈复制到堆
    NSLog(@"%@ %@", blk, ^{ a++;});
    a++;
    blk();
    NSLog(@"%d", a++);
    //描述:
    /*
     Block从栈copy到堆之后,能够访问__block变量的原因:
     * __block变量也一并被copy到堆
     * 被__block修饰的变量会转化为结构体:
         struct __Block_byref_a_0 {
         void *__isa;
         __Block_byref_a_0 *__forwarding; // 此成员变量决定了无论在栈上或堆上,都可以访问同一个__block变量
         int __flags;
         int __size;
         int a;
         };

     * 在堆中的Block通过获取__block变量的结构体指针来访问变量:
         static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
         __Block_byref_a_0 *a = __cself->a; // bound by ref
     
         (a->__forwarding->a) = 20;
         }
     
         struct __main_block_impl_0 {
         struct __block_impl impl;
         struct __main_block_desc_0* Desc;
         __Block_byref_a_0 *a; // by ref
         __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_a_0 *_a, int flags=0) : a(_a->__forwarding) {
         impl.isa = &_NSConcreteStackBlock;
         impl.Flags = flags;
         impl.FuncPtr = fp;
         Desc = desc;
         }
         };
     * 在copy之前,__block变量在栈上,其结构体指针的成员变量__forwarding指向结构体本身;当被拷贝到栈上之后,
       新的结构体的__forwarding指向新的结构体本身,此时修改栈上的旧的结构体成员变量__forwarding指向新的结构体,
     * 所以,无论是在Block语法中\在Block语法之外,还是__block分配在栈上或者堆上都可以访问使用同一个__block变量.
     
     */
    
}
#pragma mark - Block截获对象

uintptr_t _objc_rootRetainCount(id obj);
blk_obj blk_o;
- (void)blockCaptureObject{

    {// __strong
        {
            id array = [[NSMutableArray alloc]init];
            blk_o = ^(id obj){
                [array addObject:obj];
                NSLog(@"Count:%ld", [array count]);
            };
        }
        blk_o([NSObject new]);//1
        blk_o([NSObject new]);//2
        blk_o([NSObject new]);//3
    }
    {// _weak
        {
            id array0 = [[NSMutableArray alloc]init];
            id __weak array = array0;
            blk_o = ^(id obj){
                [array addObject:obj];
                NSLog(@"Count:%ld %@", [array count], array);
            };
        }
        blk_o([NSObject new]);//0 (null)
        blk_o([NSObject new]);//0 (null)
        blk_o([NSObject new]);//0 (null)
        //因为array0在作用域结束时被废弃,__weak修饰的array变量指向nil,向nil发送消息什么也不会发生.
    }
}

#pragma mark - Block 循环引用

- (void)blockRetainCycle{
    
    /*1. 最简单的引用循环
     //使用__weal typeof(self) weakself = self;即可解决
    _blk = ^(id o){
        NSLog(@"%@", self->_obj);
    };
    self.block_obj = ^(id o) {
        NSLog(@"%@", _obj);
    };
    */
    
    //2 .__block也可以避免循环引用, 但是必须执行Block,并且在Block内部将指针指向别处或者置nil
    __block id bself = self;
    _blk = ^(id o){
        NSLog(@"%@", bself);
        bself = nil;//置空,可以释放bself指向的对象
        //bself = [NSObject new]; 将指针指向其他对象,也会释放bself指向的原来的对象,此时为self,当前控制器
    };
    _blk(@"12345");
    
    //3.同上, 此处blkself也对self有引用,也需要调用Block,并且重置变量指针.
    __block PNBlockViewController * blkself = self;
    _blk = ^(id o){
        NSLog(@"%@", blkself.arr);
        blkself = (PNBlockViewController *)[NSObject new];
    };
    _blk(@"123456");
    
    //4. 不必担心野指针.在不能使用__weak的场合可以使用.因为Block存在时,self一定存在,不可能是也指针.
    __unsafe_unretained typeof(self) un_self = self;
    _blk = ^(id o){
        NSLog(@"%@", blkself.arr);
        un_self.arr = @{}.mutableCopy;
    };
    
    //总结:====================================
    //在MRC时, 使用__block防止循环引用; 当Block从栈复制到堆上时,Block捕获的变量被__block修饰,则此变量不会retain, 没有__block修饰则会retain,造成强引用,导致循环.
    //__weak, __block, __unsafe_unretained 都可以解决引用循环的问题
    //__block的优点:
    //* 可以控制对象的持有期间,对,就是期间,一个时间段.
    //* 在不能使用的__weak的情况下使用
    //* 可以动态的控制决定是否将nil或其他对象赋值给__block变量
    //缺点:
    // * 必选调用block,并且重置__block变量指针的指向.
    
    
    
    //另一个示例eg:
    OkBlock * okblk = [[OkBlock alloc] init];
    [okblk exeBlock];
}

- (void)dealloc{
    
}

#pragma clang diagnostic pop

@end

#pragma mark - 添加的辅助测试新类

@implementation OkBlock

- (instancetype)init
{
    self = [super init];
    if (self) {
        __block typeof(self) blkself = self;
        self.block = ^{
            blkself.array = [NSArray new];
            
            //.....
            blkself = nil;//重置指针
        };
    }
    return self;
}
- (void)exeBlock{
    self.block();//调用block
}
- (void)dealloc{
    
}
@end
