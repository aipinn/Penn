//
//  UIViewController+PNAdd.m
//  Penn
//
//  Created by pinn on 2018/5/23.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "UIViewController+PNAdd.h"

@implementation UIViewController (PNAdd)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalM = class_getInstanceMethod(self, @selector(viewDidLoad));
        Method swizzledM = class_getInstanceMethod(self, @selector(pn_viewDidLoad));
        
        method_exchangeImplementations(originalM, swizzledM);
        /* method_exchangeImplementations
         Exchanges the implementations of two methods.
         This is an atomic version of the following:
         */
        
        /*
         IMP imp1 = method_getImplementation(originalM);
         IMP imp2 = method_getImplementation(swizzledM);
         method_setImplementation(originalM, imp2);
         method_setImplementation(swizzledM, imp1);
        */
        
        
    });
}

- (void)pn_viewDidLoad{
    [self pn_viewDidLoad];
    [self.view makeToast:@"Method_Swizzling😜" duration:1.0 position:CSToastPositionCenter];
}


@end
