//
//  PNCTDisplayView.h
//  Penn
//
//  Created by emoji on 2018/7/27.
//  Copyright © 2018年 PENN. All rights reserved.
//
/**
 显示绘制内容的view
 */

#import <UIKit/UIKit.h>
#import "PNCoreTextData.h"

@interface PNCTDisplayView : UIView

/**
 绘制文本数据模型
 */
@property (nonatomic, strong) PNCoreTextData * data;


@end
