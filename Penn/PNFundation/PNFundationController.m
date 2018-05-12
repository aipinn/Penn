//
//  PNFundationController.m
//  Penn
//
//  Created by PENN on 2017/11/11.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import "PNFundationController.h"
#import "PNGrandparent.h"
#import "PNParent.h"
#import "PNSon.h"
#import "NSMutableDictionary+PNSafe.h"
#import "PNGrandparent+PNAdd.h"

@interface PNFundationController ()

@end

@implementation PNFundationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    NSString * str = nil;
    [dict setObject:@"231" forKey:@"aKey"];
    
    
    PNGrandparent * grand = [[PNGrandparent alloc]init];
    [grand work];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 测试子类重写父类的setter方法遇到的问题:
 1. 子类不能使用"_属性"的原因
 2. synchronize autosynchronize dynamic的交替
 3. 继承
 4. 对象和类的数据结构 继承关系链
 5. runtime获取类的实例变量和属性
 */
- (void)testSubClassOverwriteSuperclassProperty{

    PNGrandparent * gp = [PNGrandparent new];
    gp.lastname = @"John";
    gp.firstname = @"Tom";
    
    PNParent * p = [PNParent new];
    p.firstname = @"Jean";
    NSLog(@"ap:%@", gp.firstname);
    
    PNSon * s = [PNSon new];
    s.firstname = @"Jack";
    
    [gp work];
    [p work];
}
#pragma mark - Fundation Tips
- (void)aboutSet{
    
    NSArray *array1 = @[@"1",@"2",@"3"];//before
    NSArray *array2 = @[@"1",@"2",@"3",@"4",@"5"];//after
    NSMutableSet *set1 = [NSMutableSet setWithArray:array1];
    NSMutableSet *set2 = [NSMutableSet setWithArray:array2];
    
//    [set1 unionSet:set2];       //取并集后 set1中为1，2，3，5，6
//    NSLog(@"%@", set1);
//    [set1 intersectSet:set2];  //取交集后 set1中为1
//    NSLog(@"%@", set1);
//    [set1 minusSet:set2];      //取差集后 set1中为2，3，5，6
//    NSLog(@"%@", set1);
    {//并集 差集之后为2,3
        NSMutableSet * temp = [NSMutableSet setWithArray:set1.allObjects];
        [set1 unionSet:set2];
        [set1 minusSet:temp];
        NSLog(@"%@", set1);//
    }
    {//并集交集之后为:1, 5, 6
//        [set1 unionSet:set2];
//        [set1 intersectSet:set2];
//        NSLog(@"%@", set1);
    }
    
    {
        NSArray * arr = set2.allObjects;
        NSLog(@"%@", arr);
    }
    
}

@end
