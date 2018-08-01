//
//  PNCoreTextData.h
//  Penn
//
//  Created by emoji on 2018/7/30.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNCTImageData.h"

@interface PNCoreTextData : NSObject

/**
 绘制区域
 */
@property (nonatomic, assign) CTFrameRef ctFrame;

/**
 文本高度
 */
@property (nonatomic, assign) CGFloat height;

/**
 属性文本内容
 */
@property (nonatomic, strong) NSAttributedString * context;

/**
 图文混排时所有图片数组
 */
@property (nonatomic, strong) NSArray * imageArray;

@end
