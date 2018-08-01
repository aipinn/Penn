//
//  PNCTImageData.h
//  Penn
//
//  Created by emoji on 2018/7/31.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNCTImageData : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) int position;

/**
 CoreText坐标,不是UIKit坐标
 */
@property (nonatomic, assign) CGRect imagePosition;


@end
