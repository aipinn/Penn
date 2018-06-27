//
//  PNFillTextView.h
//  Penn
//
//  Created by emoji on 2018/6/26.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PNFillViewDelegate<NSObject>

- (void)fillViewAccViewDidComplete:(NSString *)content tapText:(NSString *)tapText range:(NSRange)range Info:(NSDictionary *)info;

@end

@interface PNFillTextView : UIView


@property (nonatomic, copy) NSString * ansText;
/**
 试题源字符串
 */
@property (nonatomic, copy) NSString * text;


/**
 分割后的控件数组
 */
@property (nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) NSMutableArray * ansItems;

@property (nonatomic, strong) UITextView * virtualTextVTiew;
@property (nonatomic, strong) UIView * inputAccView;
@property (nonatomic, strong) UITextView * realTextVTiew;
/**当前点击的文本相关信息*/
@property (nonatomic, strong) NSMutableDictionary * currentInfo;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, copy) NSString * tapText;



@property (nonatomic, weak) id<PNFillViewDelegate>delefate;


- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text ansText:(NSString *)ansText;




@end
