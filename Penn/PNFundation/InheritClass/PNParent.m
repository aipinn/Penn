//
//  PNParent.m
//  Penn
//
//  Created by pinn on 2018/5/10.
//  Copyright © 2018年 PENN. All rights reserved.
//
/*
 PNGrandparent的子类
 */
#import "PNParent.h"

@interface PNParent()
//@case1 定义变量(全局)临时存储
{
    // 需要在setter方法中赋值_firstname = firstname; 本质相当于另外定义的成员变量来存储而已;
    // 定义为_myName也一样
//     NSString * _firstname;
}

@property (nonatomic, strong) NSArray * parentArr;

@end

@implementation PNParent

//@case2 手动合成成员变量
//@synthesize firstname = _firstname;


/*
** 重写父类的setter方法
*  敲黑板了😝😝😆😆....子类内部不能直接通过下划线的方式访问父类属性对应的成员变量, 只能通过access方法访问. 因为父类没有开放"_属性",是父类私有的,保证了属性对数据的封装性.
*/

// 😜@case1: 需要手动给自定义的成员变量赋值, 在其他方法中直接使用自定义的变量
//         在其他方法中self.firstname为nil
//- (void)setFirstname:(NSString *)firstname{
//    _firstname = firstname;
//}

// 😋@case2: 可以使用"_属性", 在其他方法中self.firstname和_firstname都可以使用;
//           推荐使用
//- (void)setFirstname:(NSString *)firstname{
//    _firstname = firstname;
//}

// 😜@case3: 调用父类的setter方法
//           和不重写setter方法相同
// ??????? 但是在LLDB调试窗口中可以po 出来_firstname为正确值.....^_^.....💫不会补全自己需要拼写出来.....好奇怪😯
//- (void)setFirstname:(NSString *)firstname{
//    [super setFirstname:firstname];
//
//}
//========================================//
+ (void)load{
    NSLog(@"load+%s", __FUNCTION__);
}
+ (void)initialize
{
    if (self == [self class]) {
        NSLog(@"initialize: %s", __FUNCTION__);
    }
}

- (void)getAllIvars{
    
    //指定类的属性
    Ivar var = class_getInstanceVariable(self.class, "_firstname");
    NSLog(@"%s", ivar_getName(var)); //_firstname
    
    // 不包含指定类的父类的实例变量
    unsigned int varCount = 0;
    Ivar * ivars = class_copyIvarList([PNGrandparent class], &varCount);
    for (int i = 0; i < varCount; i++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
        const char * type = ivar_getTypeEncoding(ivar);
        NSLog(@"In Parent, self:%@--拥有的成员变量的类型为%s，名字为 %s ",self, type, name);
    }
    free(ivars);
}

#pragma mark - self methods
- (void)fly{
    NSLog(@"%s", __FUNCTION__);
    self.horses = @[];
}

#pragma mark - super methods

- (void)work{
    NSLog(@"%@ is working...", self.firstname);
}

//- (void)setSons:(NSArray *)sons{
//    
//}

@end



//---------------
//---------------
@implementation PNParent (PNAdd)

+ (void)load{
    NSLog(@"load+%s", __FUNCTION__);
}
+ (void)initialize
{
    if (self == [self class]) {

        NSLog(@"initialize: %s", __FUNCTION__);
    }
}


// 分类重写本类的父类的方法: 本类和父类的实现都不再调用, 没有警告.
- (void)work{
    NSLog(@"category+%s", __FUNCTION__);
}

/*
 分类复写本类的方法,本类对应的方法不在调用, 此处会警告. +laod方法除外.
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

//- (void)fly{
//    NSLog(@"%s", __FUNCTION__);
//}
#pragma clang diagnostic pop

- (void)setImages:(NSArray *)images{
    
}
- (NSArray *)images{
    return @[];
}
@end









