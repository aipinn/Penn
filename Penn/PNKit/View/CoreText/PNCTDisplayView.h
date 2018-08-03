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

static NSString *const PNCTDisplayViewImageTapedNOtification = @"PNCTDisplayViewImageTapedNOtification";
static NSString *const PNCTDisplayViewLinkTapedNotification = @"PNCTDisplayViewLinkTapedNotification";

@interface PNCTDisplayView : UIView<UIKeyInput>

/**
 绘制文本数据模型
 */
@property (nonatomic, strong) PNCoreTextData * data;

/**
 只需要重新声明此属性,并设置值就会有辅助视图
 */
@property (nonatomic, strong) UIView * inputAccessoryView;

@property (nonatomic, strong) NSArray * images;

@property (nonatomic, copy) NSString * name;


@end
