//
//  PNCTDisplayView.m
//  Penn
//
//  Created by emoji on 2018/7/27.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNCTDisplayView.h"
#import <CoreText/CoreText.h>
#import "PNCTImageData.h"
#import "PNCTUtils.h"

@interface PNCTDisplayView()

@property (nonatomic, strong) NSArray * links;


@end

@implementation PNCTDisplayView
@dynamic name;

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupEvents];
        [self setupInputView];
    
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupEvents];
        [self setupInputView];
    }
    return self;
}

- (void)setupInputView{
    
    //创建辅助视图
    UIView * inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    inputAccessoryView.backgroundColor = [UIColor orangeColor];
    self.inputAccessoryView = inputAccessoryView;
    
    // 键盘弹起通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
}

/**
 添加事件
 */
- (void)setupEvents{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(userTapGestureDetected:)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
}

- (void)userTapGestureDetected:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self];
    for (PNCTImageData * imgData in self.data.imageArray) {
        // 翻转坐标系.因为imageData中的坐标是CoreText中的坐标系
        CGRect imageRect = imgData.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        // 检测点击的位置是否在rect之内
        if(CGRectContainsPoint(rect, point)){
            NSDictionary *userInfo = @{@"imageData": imgData};
            //发送点击通知
            [[NSNotificationCenter defaultCenter] postNotificationName:PNCTDisplayViewImageTapedNOtification
                                                                object:self
                                                              userInfo:userInfo];
            break;
        }
    }
    
    PNCTLinkData * linkData = [PNCTUtils touchLinkInView:self atPoint:point data:self.data];
    if (linkData) {
        NSDictionary *userInfo = @{ @"linkData": linkData };
        //发送点击通知
        [[NSNotificationCenter defaultCenter] postNotificationName:PNCTDisplayViewLinkTapedNotification
                                                            object:self
                                                          userInfo:userInfo];
        return;
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (!self.data) {
        return;
    }
    //1. 获取绘制上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2. 坐标系上下翻转
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //3. 创建绘制区域
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, self.bounds);
    //设置不同的文字绘制区域
    //    CGPathAddEllipseInRect(path, NULL, self.bounds);
    
    //4.
//    NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:@"Hello TextCore"];
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, NULL);
    
    //5.
//    CTFrameDraw(frame, context);

    CTFrameDraw(self.data.ctFrame, context);
    
    for (PNCTImageData *imgData in self.data.imageArray) {
        UIImage *image = [UIImage imageNamed:imgData.name];
        if (image) {
            CGContextDrawImage(context, imgData.imagePosition, image.CGImage);
        }
    }
    //6.
//    CFRelease(frame);
//    CFRelease(path);
//    CFRelease(framesetter);
    
}

#pragma mark - 重写UIResponsder方法
/*
 This method returns NO by default. Subclasses must override this method and return YES to be able to become first responder.
 */
- (BOOL)canBecomeFirstResponder{
    return YES;
}
/*
 You can override this method in your custom responders to update your object's state or perform some action such as highlighting the selection. If you override this method, you must call super at some point in your implementation.
 */
- (BOOL)becomeFirstResponder{
    [super becomeFirstResponder];
    return YES;
}
#pragma mark - UIKeyInput 协议
- (void)insertText:(NSString *)text{
    NSLog(@"正在输入:%@", text);
}
- (void)deleteBackward{
    
}

@synthesize hasText;

#pragma mark - KeyboardNotification actions

- (void)keyboardWillChangeFrame:(NSNotification *)notify{
    CGRect keyboardFrame;
    [[notify.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
}

- (void)keyboardWillShow:(NSNotification *)notify{
    
}

@end
