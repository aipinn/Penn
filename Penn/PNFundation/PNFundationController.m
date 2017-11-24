//
//  PNFundationController.m
//  Penn
//
//  Created by SanRong on 2017/11/11.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "PNFundationController.h"

@interface PNFundationController ()

@end

@implementation PNFundationController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self aboutSet];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
