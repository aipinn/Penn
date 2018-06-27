//
//  PNFillTextView.m
//  Penn
//
//  Created by emoji on 2018/6/26.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNFillTextView.h"

@implementation PNFillTextView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text ansText:(NSString *)ansText{
    if ([super initWithFrame:frame]) {
        _text = text;
        _ansText = ansText;
        [self configUI];
        [self initTextItems:text];

    }
    return self;
}
- (void)configUI{

    UIView * inputAccView = [[UIView alloc]init];
    inputAccView.backgroundColor = [UIColor greenColor];
    inputAccView.frame = CGRectMake(0, 200, SCREEN_WIDTH, 60);
    self.inputAccView = inputAccView;
    
    UITextView * textView = [[UITextView alloc]init];
    textView.frame = CGRectMake(0, 0, SCREEN_WIDTH-60, 60);
    [inputAccView addSubview:textView];
    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.realTextVTiew = textView;
    
    UIButton * btn = [UIButton new];
    btn.frame = CGRectMake(CGRectGetMaxX(textView.frame), 0, 60, 60);
    [inputAccView addSubview:btn];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissKeyboardText:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismissKeyboardText:(UIButton *)sender{
    [self.realTextVTiew resignFirstResponder];
    [self.virtualTextVTiew resignFirstResponder];
    if (self.delefate) {
        [self.delefate fillViewAccViewDidComplete:self.realTextVTiew.text tapText:self.tapText range:self.range Info:nil];
    }
}

- (void)initTextItems:(NSString *)textStr{

    NSMutableAttributedString *text = [NSMutableAttributedString new];
    text.lineSpacing = 4;

    //遍历字符串
    NSMutableArray * mArr = [NSMutableArray new];
    NSString * space = @"";
    NSMutableString * effective = [NSMutableString new];
    NSInteger count = 0;
    NSInteger total = 0;
    for(int i =0; i < [textStr length]; i++)
    {
        space = [textStr substringWithRange:NSMakeRange(i,1)];
        if ([space isEqualToString:@"_"]) {
            count++;
        }else{
            [effective appendString:space];
        }
        if (count==4) {
            if (effective.length>0) {
                [mArr addObject:effective];
            }
            [mArr addObject:@"____"];
            effective = @"".mutableCopy;
            count = 0;
        }

        total++;
        if (total == textStr.length) {
            [mArr addObject:effective];
        }
    }
    //初始化数组容器
    self.items = mArr;
    self.ansItems = mArr;
    //为"____"元素添加下划线
    for (NSString * str in mArr) {
        if ([str isEqualToString:@"____"]) {
            NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:str];
            one.font = [UIFont boldSystemFontOfSize:15];
            one.underlineStyle = NSUnderlineStyleSingle;
            
            [one setTextHighlightRange:one.rangeOfAll
                                 color:[UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000]
                       backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                             tapAction:^(UIView *containerView, NSAttributedString *aText, NSRange range, CGRect rect) {
                                 //弹出键盘
                                 NSString * tapStr = [aText.string substringWithRange:range];
                                 NSLog(@"%@", tapStr);
                                 
                                 self.tapText = tapStr;
                                 self.range = range;
                                 
                                 [self.virtualTextVTiew becomeFirstResponder];
                                 [self.realTextVTiew becomeFirstResponder];
                             }];
            
            [text appendAttributedString:one];
            
        }else{
            NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:str];
            one.font = [UIFont boldSystemFontOfSize:15];
            [text appendAttributedString:one];
        }
    }
    
    //显示
    CGSize size = [self calculateAttributeStringSize:text];
    YYLabel *label = [YYLabel new];
    label.attributedText = text;
    label.top = 10;
    label.width = self.width;
    label.height = size.height+20;
    
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
    [self addSubview:label];
    //创建可以弹出键盘的视图
    UITextView * tv = [[UITextView alloc]init];
    tv.frame = CGRectMake(-100, -100, 0, 0);
    tv.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:tv];
    tv.inputAccessoryView = self.inputAccView;
    self.virtualTextVTiew = tv;
    
}

- (void)setAnsText:(NSString *)ansText{
    _ansText = ansText;
    [self removeAllSubviews];
    [self configUI];
    [self resetAnsTextItems:ansText];
}
// 重新赋值
- (void)resetAnsTextItems:(NSString *)textStr{
    self.ansItems = [NSMutableArray new];
    [self.ansItems addObjectsFromArray:_items];
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    text.lineSpacing = 4;
    
    //遍历字符串
    NSMutableArray * mArr = [NSMutableArray new];
    NSString * rep = @"****晶体的对称性可由****点群表征，晶体的排列可分为****种布喇菲格子，其中六角密积结构****布喇菲格子****。";
    //提取填空处的文本
    NSArray * arr = [textStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:rep]];
    for (NSString * one in arr) {
        if (![one isEqualToString:@""]) {
            [mArr addObject:one];
        }
    }
    //替换

    if ([_text hasPrefix:@"___"]) {
        for (NSInteger i = 0; i< _ansItems.count; i++) {
            if (i%2==0) {
                [_ansItems replaceObjectAtIndex:i withObject:mArr[i/2]];
            }
        }
    }else{
        for (NSInteger i = 0; i< _ansItems.count; i++) {
            if (i%2==1) {
                [_ansItems replaceObjectAtIndex:i withObject:mArr[i/2]];
            }
        }
    }
    
    
    if(_ansItems.count != _items.count)return;//分割错误
    
    for (NSInteger i = 0; i<_items.count; i++) {
        
            if (![_items[i] isEqualToString:_ansItems[i]] || [_items[i] isEqualToString:@"____"]) {
                
                NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:_ansItems[i]];
                one.font = [UIFont boldSystemFontOfSize:15];
                one.underlineStyle = NSUnderlineStyleSingle;
                
                [one setTextHighlightRange:one.rangeOfAll
                                     color:[UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000]
                           backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                                 tapAction:^(UIView *containerView, NSAttributedString *aText, NSRange range, CGRect rect) {
                                     //弹出键盘
                                     NSString * tapStr = [aText.string substringWithRange:range];
                                     NSLog(@"%@", tapStr);
                                     self.tapText = tapStr;
                                     self.range = range;
                                     if ([tapStr isEqualToString:@"____"]) {
                                          self.realTextVTiew.text = @"";
                                     }else{
                                         self.realTextVTiew.text = tapStr;
                                     }
                                     [self.virtualTextVTiew becomeFirstResponder];
                                     [self.realTextVTiew becomeFirstResponder];

                                     
                                 }];
                
                [text appendAttributedString:one];
                
            }else{
                NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:_items[i]];
                one.font = [UIFont boldSystemFontOfSize:15];
                [text appendAttributedString:one];
                
            }
        
    }

    
    CGSize size = [self calculateAttributeStringSize:text];
    YYLabel *label = [YYLabel new];
    label.attributedText = text;
    label.top = 10;
    label.width = self.width;
    label.height = size.height+20;
    
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
    [self addSubview:label];

    //创建可以弹出键盘的视图
    UITextView * tv = [[UITextView alloc]init];
    tv.frame = CGRectMake(-100, -100, 0, 0);
    tv.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:tv];
    tv.inputAccessoryView = self.inputAccView;
    self.virtualTextVTiew = tv;

    
}

- (CGSize)calculateAttributeStringSize:(NSAttributedString *)string{
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return size;
}

- (NSAttributedString *)createAttributeString:(NSString *)string{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                      range:(NSRange){0,[attString length]}];
    return attString;
}
- (UITextField *)createTextFieldWithText:(NSAttributedString *)string{
    UITextField * tf = [[UITextField alloc] init];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.attributedText = string;
    return tf;
}

- (NSMutableDictionary *)currentInfo{
    if (!_currentInfo) {
        _currentInfo = [NSMutableDictionary new];
    }
    return _currentInfo;
}

@end
