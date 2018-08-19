//
//  PNAutoDictionary.m
//  Penn
//
//  Created by emoji on 2018/7/23.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNAutoDictionary.h"
#import <objc/runtime.h>

@interface PNAutoDictionary ()

@property (nonatomic, strong) NSMutableDictionary * backingStore;

@end

@implementation PNAutoDictionary

@dynamic string, number, date, opaqueObject;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _backingStore = [NSMutableDictionary new];
    }
    return self;
}


void autoDictionarySetter(id self, SEL _cmd, id value){
    PNAutoDictionary * typeSelf = (PNAutoDictionary *)self;
    NSMutableDictionary * backingStore = typeSelf.backingStore;
    NSString * selString = NSStringFromSelector(_cmd);
    NSMutableString *key = [selString mutableCopy];
    [key deleteCharactersInRange:NSMakeRange(key.length-1, 1)];//删除末尾的":"
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    NSString * lowercaseFirstChar = [[key substringToIndex:1] lowercaseString];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:lowercaseFirstChar];
    if (value) {
        [backingStore setObject:value forKey:key];
    }else{
        [backingStore removeObjectForKey:key];
    }
}

id autoDictionaryGetter(id self, SEL _cmd){
    PNAutoDictionary * typeSelf = (PNAutoDictionary *)self;
    NSMutableDictionary * backingStore = typeSelf.backingStore;
    NSString * key = NSStringFromSelector(_cmd);
    return [backingStore objectForKey:key];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSString * selString = NSStringFromSelector(sel);
    if ([selString hasPrefix:@"set"]) {
        class_addMethod(self, sel, (IMP)autoDictionarySetter, "v@:@");
    }else{
        class_addMethod(self, sel, (IMP)autoDictionaryGetter, "@@:");
    }
    return YES;
}

@end
