//
//  PNDataStructureController.m
//  Penn
//
//  Created by emoji on 2018/8/22.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNDataStructureController.h"

@interface PNDataStructureController ()

@end

@implementation PNDataStructureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //数组中可以存储多种类型
//    [self testTypeInArray];
//    table t = initTable(5);
    llink * l =  initLink(5);
    for (int i = 1; i < 5; i++) {
        int n = selectElem(l, i);
        printf("%d", n);
    }

    
}


//数组存储的数据类型
- (void)testTypeInArray{
    
    NSArray *arr = @[@1, @"2", @[@1], [NSObject new], @4];
    //0011001000
    //1010101000
    NSMutableArray *arr1 = @[@"1", @"2", @"3", @"4", @"5"].mutableCopy;
    [arr1 addObject:@"7"];
    [arr1 addObject:@"8"];
    [arr1 addObject:@"9"];
    for (NSNumber *num in arr1) {
        NSLog(@"%p", num);
    }
    
    NSSet *set = [[NSSet alloc] initWithObjects:@1,@2,@3,@4,@5, nil];
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"set:%p", obj);
    }];

    NSSet *set1 = [[NSSet alloc] initWithArray:arr1];
    [set1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"set-1:%@,%p", obj, obj);
    }];
    
}

//============顺序表=============

//#define Size 4
//顺序表的存储结构
typedef struct Table{
    int *head;
    int length;
    int size;
}table;

//初始化顺序表
table initTable(int Size){
    table t;
    t.head = (int*)malloc(Size *sizeof(int));
    if (!t.head) {
        printf("init table failed");
        exit(0);
    }
    t.length = 0;
    t.size = Size;
    return t;
}
//添加元素
table addTable(table t, int elem, int add){
    if (add>t.length+1 || add<1) {
        printf("insert position error");
        return t;
    }
    if (t.length>=t.size){
        t.head = (int*)realloc(t.head, (t.size+1)*sizeof(int));
        if (!t.head) {
            printf("realloc failed");
        }
        t.size+=1;
    }
    for (int i = t.length-1; i>add-1; i--) {
        t.head[1+i] = t.head[i];
        printf("%d",i);
    }
    t.head[add-1] = elem;
    t.length++;
    return t;
}

//=============链表=============
typedef struct Link{
    int elem;
    struct Link *next;
}llink;

llink *initLink(int count){
    llink *p = (llink *)malloc(sizeof(llink));//创建一个头结点
    llink *temp = p;//声明一个指针指向头节点,用于遍历链表
    
    //生成链表
    for (int i = 1; i < count; i++) {
        llink *a = (llink *)malloc(sizeof(llink));
        a->elem = i;
        a->next = NULL;
        temp->next = a;
        temp = temp->next;
    }
    return p;
}

int selectElem(llink * p,int elem){
    llink * t=p;
    int i=1;
    while (t->next) {
        t=t->next;
        if (t->elem==elem) {
            return i;
        }
        i++;
    }
    return -1;
}












@end
