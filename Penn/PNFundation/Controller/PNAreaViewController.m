//
//  PNAreaViewController.m
//  Penn
//
//  Created by emoji on 2019/3/1.
//  Copyright © 2019 PENN. All rights reserved.
//

#import "PNAreaViewController.h"

@interface PNAreaViewController ()

@end

@implementation PNAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)test0 {
    

}

- (void)test1 {
    NSMutableArray *arr = [NSMutableArray new];
    
    dispatch_semaphore_t sem = dispatch_semaphore_create(1);
    
    for (NSInteger i = 0; i < 100; i++) {
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [arr addObject:@(i)];
            NSLog(@"%@", [NSThread currentThread]);
            dispatch_semaphore_signal(sem);
            
        });
    }
    
    NSLog(@"arr: %ld", arr.count);
    
}

@end
