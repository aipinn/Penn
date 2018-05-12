//
//  PNGrandparent+PNAdd.m
//  Penn
//
//  Created by pinn on 2018/5/11.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNGrandparent+PNAdd.h"

@implementation PNGrandparent (PNAdd)
+ (void)load{
    NSLog(@"load+%s", __FUNCTION__);
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)work{
    NSLog(@"category+%s", __FUNCTION__);
}

#pragma clang diagnostic pop

@end
