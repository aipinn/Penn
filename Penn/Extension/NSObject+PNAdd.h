//
//  NSObject+PNAdd.h
//  Penn
//
//  Created by pinn on 2018/5/23.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PNAdd)

/**
  Exchange class method imp

 @param originalSel Original selector method
 @param newSel New selector method
 */
+ (BOOL)pn_swizzleClassMethod:(nonnull SEL)originalSel newMethod:(nonnull SEL)newSel;

/**
 Exchange instance method imp

 @param originalSel original selector method
 @param newSel selector method
 */
+ (BOOL)pn_swizzleInstanceMethod:(nonnull SEL)originalSel newMethod:(nonnull SEL)newSel;

@end


@interface NSMutableArray (PNAdd)

@end

@interface NSMutableDictionary (PNAdd)

@end
