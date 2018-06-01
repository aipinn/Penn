//
//  PNGrandparent.h
//  Penn
//
//  Created by pinn on 2018/5/10.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNGrandparent : NSObject

{
    /*
    //@case1
     手动添加"_实例变量" autosynthesize将不再自动合成 _firstname
     _firstname 将会暴露在子类中, 在子类中可以直接访问
     NSString * _firstname;
    */
    
    /*
    //@case2
     Autosynthesized property 'firstname' will use synthesized instance variable '_firstname', not existing instance variable 'firstname'
     自动合成的_firstname将作为属性firstname的实例变量, 此处的firstname和它们没有关系,相当于另外的一个变量了.
     NSString * firstname;
     */
}

@property (nonatomic, copy) NSString * firstname;
@property (nonatomic, copy) NSString * lastname;

- (void)work;
- (void)play;

@end
