//
//  NSMutableDictionary+PNSafe.m
//  Penn
//
//  Created by pinn on 2018/5/11.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "NSMutableDictionary+PNSafe.h"

@implementation NSMutableDictionary (PNSafe)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if (!anObject) {
        return;
    }
}

#pragma clang diagnostic pop


@end
