//
//  PNFillModel.h
//  Penn
//
//  Created by emoji on 2018/6/28.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "BaseModel.h"

@interface PNFillModel : BaseModel
@property (nonatomic, copy) NSString * text;

@property (nonatomic, strong) NSValue * rangeValue;

@property (nonatomic, assign, getter=isLink) BOOL link;

@property (nonatomic, assign) NSNumber * idx;

@end
