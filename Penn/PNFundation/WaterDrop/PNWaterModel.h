//
//  PNWaterModel.h
//  Penn
//
//  Created by emoji on 2018/8/9.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "BaseModel.h"

@class DropModel;
@interface PNWaterModel : BaseModel

@property (nonatomic, copy) NSString * name;

@property (nonatomic, strong) NSMutableArray <DropModel *> *list;

@end

@interface DropModel : BaseModel

@property (nonatomic, copy) NSString * MSG;

@property (nonatomic, copy) NSString * TRANSTYPE;

@property (nonatomic, copy) NSString * TIME;

@end
