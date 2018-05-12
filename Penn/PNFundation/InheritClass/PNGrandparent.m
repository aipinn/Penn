//
//  PNGrandparent.m
//  Penn
//
//  Created by pinn on 2018/5/10.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNGrandparent.h"

@implementation PNGrandparent
+ (void)load{
    NSLog(@"load+%s", __FUNCTION__);
}
- (void)setLastname:(NSString *)lastname{
    _lastname = lastname;
    NSLog(@"%s",__FUNCTION__);
}

- (void)setFirstname:(NSString *)firstname{
    _firstname = firstname;
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"In Grandparent:%@", self);
    
}

- (void)work{
    NSLog(@"%@ is working...", self.firstname);
}

//获取属性列表,不包含指定类(class_copyPropertyList(self.class,xxx)的父类的属性
- (void)getAllPropertys{
 
    unsigned int outCount = 0;
    objc_property_t *propertys = class_copyPropertyList(self.class, &outCount);
    for(unsigned int i =0; i < outCount; ++i) {
        objc_property_t property = propertys[i];
        //属性名
        const char * propertyName =property_getName(property);
        //属性类型@encode编码
        const char *propertyAttName =property_getAttributes(property);
        NSLog(@"====:%s %s", propertyName,propertyAttName);
    }
    free(propertys);
}
@end
