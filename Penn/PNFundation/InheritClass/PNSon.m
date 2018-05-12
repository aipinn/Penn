//
//  PNSon.m
//  Penn
//
//  Created by pinn on 2018/5/10.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNSon.h"

@implementation PNSon

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"ap--%@", NSStringFromClass([super class]));
        NSLog(@"ap--%@", NSStringFromClass([self class]));
    }
    return self;
}
- (void)setLastname:(NSString *)lastname{
    NSLog(@"%s",__FUNCTION__);
}

- (void)setFirstname:(NSString *)firstname{
     NSLog(@"%s",__FUNCTION__);
}

- (void)work{
    NSLog(@"%@ is working...", self.firstname);
}

@end
