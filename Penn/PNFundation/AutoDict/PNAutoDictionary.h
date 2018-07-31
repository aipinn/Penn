//
//  PNAutoDictionary.h
//  Penn
//
//  Created by emoji on 2018/7/23.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNAutoDictionary : NSObject

@property (nonatomic, copy) NSString * string;
@property (nonatomic, strong) NSNumber * number;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) id opaqueObject;

@end
