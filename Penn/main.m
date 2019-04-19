//
//  main.m
//  Penn
//
//  Created by PENN on 2017/9/7.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSLog(@"%s", __FUNCTION__);
    @autoreleasepool {
//        [FBAssociationManager hook];
        
        NSInteger i = 100;
        NSInteger a = i++ > 100 ? 2 : 99;
        NSLog(@"a=%ld, i=%ld", a, i);//a=99, i=101
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));

    }
}
