//
//  NSObject+PNAdd.m
//  Penn
//
//  Created by pinn on 2018/5/23.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "NSObject+PNAdd.h"

@implementation NSObject (PNAdd)

+ (BOOL)pn_swizzleInstanceMethod:(SEL)originalSel newMethod:(SEL)newSel{
    Method originalM = class_getInstanceMethod(self, originalSel);
    Method newM = class_getInstanceMethod(self, newSel);
    if (!originalM || !newM) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalM));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newM));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}
// TODO:
+ (BOOL)pn_swizzleClassMethod:(SEL)originalSel newMethod:(SEL)newSel{
    
    Method originM = class_getClassMethod(self, originalSel);
    Method newM = class_getClassMethod(self, newSel);
    if (!originalSel || !newSel) return NO;
    
    method_exchangeImplementations(originM, newM);
    return YES;
}

@end

/**
 可变数组 NSMutableArray
 */
@implementation NSMutableArray (PNAdd)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSArrayM");
        [class pn_swizzleInstanceMethod:@selector(addObject:) newMethod:@selector(pn_addObject:)];
        [class pn_swizzleInstanceMethod:@selector(removeObjectAtIndex:) newMethod:@selector(pn_removeObjectAtIndex:)];
        [class pn_swizzleInstanceMethod:@selector(replaceObjectAtIndex:withObject:) newMethod:@selector(pn_replaceObjectAtIndex:withObject:)];
        // 直接崩溃, 找不到原因.😢
//        [class pn_swizzleInstanceMethod:@selector(insertObject:atIndex:) newMethod:@selector(pn_insertObject:atIndex:)];
        
    });
}

- (void)pn_addObject:(id)anObject{
    if(!anObject){
        return;
    }
    [self pn_addObject:anObject];
}

- (void)pn_removeObjectAtIndex:(NSUInteger)index{
    if (index+1 > self.count) {
        return;
    }
    [self pn_removeObjectAtIndex:index];
}

- (void)pn_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    if (index+1 > self.count || anObject == nil) {
        return;
    }
    [self pn_replaceObjectAtIndex:index withObject:anObject];
}

- (void)pn_insertObject:(id)anObject atIndex:(NSUInteger)index{
    
    if (index+1 > self.count || anObject == nil) {
        return;
    }
    [self pn_insertObject:anObject atIndex:index];
}




@end
