//
//  PNFillTextView.m
//  Penn
//
//  Created by emoji on 2018/6/26.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNFillTextView.h"

#define kQuestionSpace @"____"

@interface PNFillTextView()

@property (nonatomic, strong) NSMutableArray <PNFillModel *>* datasource;

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
@property (nonatomic, strong) PNFillModel * model;

@end

@implementation PNFillTextView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text{
    self = [super initWithFrame:frame];
    if (self) {
        self.text = text;
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


/**初始化题目显示*/
- (void)initTextItems:(NSString *)textStr{
   
    //初始化数组容器
    self.items = [self separateText:textStr];
    self.ansItems = self.items;
    
    [self initDataSource];
    
}

- (void)resetLabel{

    //拼接属性字符串
    NSMutableAttributedString * attriStr = [self appendBuildAttributedString];
    //赋值给YYlabel
    [self showLabel:attriStr];
    
}

- (NSMutableAttributedString *)appendBuildAttributedString{
    
    //遍历拼接更新过后的datasource的text文本,其中:isLink决定是否有下划线
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    text.lineSpacing = 4;
    [_datasource enumerateObjectsUsingBlock:^(PNFillModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isLink) {
            NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:obj.text];
            one.font = [UIFont boldSystemFontOfSize:15];
            one.underlineStyle = NSUnderlineStyleSingle;
            
            [one setTextHighlightRange:one.rangeOfAll
                                 color:[UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000]
                       backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                             tapAction:^(UIView *containerView, NSAttributedString *aText, NSRange range, CGRect rect) {
                                 //弹出键盘
                                 NSString * tapStr = [aText.string substringWithRange:range];
                                 NSLog(@"-----\n%@\n-----", tapStr);
                                 self.tapText = tapStr;
                                 self.range = range;
                                 self.model = obj;
                                 
                                 if ([tapStr isEqualToString:kQuestionSpace]) {
                                     self.realTextVTiew.text = @"";
                                 }else{
                                     self.realTextVTiew.text = tapStr;
                                 }
                                 if (!self.virtualTextVTiew.isFirstResponder) {
                                     [self.virtualTextVTiew becomeFirstResponder];
                                 }
                                 if (!self.realTextVTiew.isFirstResponder) {
                                     [self.realTextVTiew becomeFirstResponder];
                                 }
                                 
                                 
                             }];
            
            [text appendAttributedString:one];
        }else{
            NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:obj.text];
            one.font = [UIFont boldSystemFontOfSize:15];
            [text appendAttributedString:one];
        }
    }];
    text.lineSpacing = 5.0;
    return text;
}

/**初始化构建datasource*/
- (void)initDataSource{

    __block NSInteger location = 0;
    if (self.datasource.count==0) {
        
    [_items enumerateObjectsUsingBlock:^(NSString * str, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = NSMakeRange(location, str.length);
        location = location+str.length;
        NSInteger link = 0;
        //构建model数组
        NSDictionary * dict = @{
                                @"text":str,
                                @"rangeValue":[NSValue valueWithRange:range],
                                @"idx":@(idx),
                                @"link":@(link)
                                };
        PNFillModel * model = [PNFillModel modelWithDictionary:dict];
        [self.datasource addObject:model];
        
        if ([str isEqualToString:kQuestionSpace]) {
            model.link = 1;
        }else{
            model.link = 0;
        }
    }];
    }
}

/**重置datasource*/
- (void)resetDataSource:(PNFillModel *)model{
    
    NSInteger diff = 0;
    NSRange newRange, oldRange;
    [model.rangeValue getValue:&newRange];
    
    for (PNFillModel * mmm in self.datasource) {
        [model.rangeValue getValue:&oldRange];
        if (mmm.idx.integerValue == model.idx.integerValue) {

            diff = newRange.length-oldRange.length;
        }
        mmm.rangeValue = [NSValue valueWithRange:NSMakeRange(oldRange.location+diff, oldRange.length+diff)];
    }
    
}
/**添加显示label*/
- (void)showLabel:(NSAttributedString *)text{
    //显示label
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
#pragma mark - 辅助方法

- (void)dismissKeyboardText:(UIButton *)sender{
    [self.realTextVTiew resignFirstResponder];
    [self.virtualTextVTiew resignFirstResponder];
    if (self.delefate) {
        [self.delefate fillViewAccViewDidComplete:self.realTextVTiew.text tapText:self.tapText range:self.range model:self.model Info:nil];
    }
}

- (NSMutableArray *)separateText:(NSString *)text{
    //遍历分割字符串
    NSMutableArray * mArr = [NSMutableArray new];
    NSString * space = @"";
    NSMutableString * effective = [NSMutableString new];
    NSInteger count = 0;
    NSInteger total = 0;
    for(int i =0; i < [text length]; i++)
    {
        space = [text substringWithRange:NSMakeRange(i,1)];
        if ([space isEqualToString:@"_"]) {
            count++;
        }else{
            [effective appendString:space];
        }
        if (count==4) {
            if (effective.length>0) {
                [mArr addObject:effective];
            }
            [mArr addObject:kQuestionSpace];
            effective = @"".mutableCopy;
            count = 0;
        }
        
        total++;
        if (total == text.length) {
            [mArr addObject:effective];
        }
    }
    return mArr;
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
#pragma mark - access 方法

- (void)setText:(NSString *)text{
    _text = text;
    [self initTextItems:_text];
    [self removeAllSubviews];
    [self configUI];
    [self resetLabel];
}

- (NSMutableDictionary *)currentInfo{
    if (!_currentInfo) {
        _currentInfo = [NSMutableDictionary new];
    }
    return _currentInfo;
}
- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray new];
    }
    return _datasource;
}
@end
