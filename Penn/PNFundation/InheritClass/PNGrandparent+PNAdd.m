//
//  PNGrandparent+PNAdd.m
//  Penn
//
//  Created by pinn on 2018/5/11.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNGrandparent+PNAdd.h"

@implementation PNGrandparent (PNAdd)
//+ (void)load{
//    NSLog(@"category+%s", __FUNCTION__);
//}

+ (void)initialize
{
    if (self == [self class]) {
        NSLog(@"category-initialize: %s", __FUNCTION__);
    }
}

//Any methods that you declare in a category will be available to all instances of the original class, as well as any subclasses of the original class.
- (void)play{
    NSLog(@"%s", __FUNCTION__);
}


@end
