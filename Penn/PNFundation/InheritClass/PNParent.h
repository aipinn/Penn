//
//  PNParent.h
//  Penn
//
//  Created by pinn on 2018/5/10.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNGrandparent.h"

@interface PNParent : PNGrandparent

//@property (nonatomic, copy) NSString * firstname;
@property (nonatomic, strong) NSString * proParent;

@property (nonatomic, strong) NSArray * sons;

- (void)fly;

@end


//----------------

@interface PNParent (PNAdd)

@property (nonatomic, strong) NSArray * images;

@end
