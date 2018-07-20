//
//  PNFillTextView.h
//  Penn
//
//  Created by emoji on 2018/6/26.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNFillModel.h"

//文字模型
//@interface PNFillModel : NSObject
//
//@property (nonatomic, copy) NSString * text;
//
//@property (nonatomic, strong) NSValue * rangeValue;
//
//@property (nonatomic, assign, getter=isLink) BOOL link;
//
//@property (nonatomic, assign) NSNumber * idx;
//
//
//@end

@protocol PNFillViewDelegate<NSObject>

- (void)fillViewAccViewDidComplete:(NSString *)content tapText:(NSString *)tapText range:(NSRange)range model:(PNFillModel *)model Info:(NSDictionary *)info;

@end

@interface PNFillTextView : UIView

/**
 试题源字符串
 */
@property (nonatomic, copy) NSString * text;

@property (nonatomic, weak) id<PNFillViewDelegate>delefate;

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text;
- (void)resetDataSource:(PNFillModel *)model;

@end





