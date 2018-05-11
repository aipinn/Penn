//
//  PNButton.m
//  Penn
//
//  Created by PENN on 2017/11/4.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import "PNButton.h"

@implementation PNButton


// 每次点击会触发此方法, 将按钮添加到视图上时会调用
-(void)layoutSubviews{
    [super layoutSubviews];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addAction];
        [self setupUI];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addAction];
        [self setupUI];
    }
    return self;
}

/**block 按钮回调事件*/
- (void)doAction:(UIButton *)sender{
    if (self.callBack) {
        self.callBack(sender);
    }
}

- (void)setupUI{
    
    
}

- (void)addAction{
    
    [self addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)buttonImage:(NSString *)string title:(NSString *)title{
    [self setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)buttonImage:(NSString *)string highlightedImage:(NSString *)highStr title:(NSString *)title{
    [self buttonImage:string title:title];
    [self setImage:[UIImage imageNamed:string] forState:UIControlStateHighlighted];
}

- (void)buttonImage:(NSString *)string selectedImage:(NSString *)highStr title:(NSString *)title selectedTitle:(NSString *)selectedTitle{
    [self buttonImage:string title:title];
    [self setImage:[UIImage imageNamed:highStr] forState:UIControlStateSelected];
    [self setTitle:selectedTitle forState:UIControlStateSelected];
}





#pragma mark - Origin Methods
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    switch (self.pn_contentMode) {
        case PNButtonContentModeDefault:
            
            break;
        case PNButtonContentModeTopImage:
        {
            contentRect = CGRectMake((self.bounds.size.width - self.imageSize.width)/2,
                                     self.contentEdgeInsets.top,
                                     self.imageSize.width,
                                     self.imageSize.height);
        }
            break;
        case PNButtonContentModeBottomImage:
        {
            contentRect = CGRectMake((self.bounds.size.width - self.imageSize.width)/2,
                                     self.bounds.size.height - self.imageSize.height - self.contentEdgeInsets.bottom,
                                     self.imageSize.width,
                                     self.imageSize.height);
        }
            break;
        case PNButtonContentModeRightImage:
        {
            contentRect = CGRectMake(self.bounds.size.width - self.contentEdgeInsets.right - self.imageSize.width,
                                     (self.bounds.size.height - self.imageSize.height)/2,
                                     self.imageSize.width,
                                     self.imageSize.height);
        }
            break;
            
        default:
            break;
    }
    return contentRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{

    switch (self.contentMode) {
        case PNButtonContentModeDefault:
            
            break;
        case PNButtonContentModeTopImage:
        {
            contentRect = CGRectMake((self.bounds.size.width - self.titleSize.width)/2,
                                     self.bounds.size.height - self.titleSize.height - self.contentEdgeInsets.bottom,
                                     self.titleSize.width,
                                     self.titleSize.height);
            
        }
            break;
        case PNButtonContentModeBottomImage:
        {
            contentRect = CGRectMake((self.bounds.size.width - self.titleSize.width)/2,
                                     self.contentEdgeInsets.top,
                                     self.titleSize.width,
                                     self.titleSize.height);
            
        }
            break;
        case PNButtonContentModeRightImage:
        {
            contentRect = CGRectMake(self.contentEdgeInsets.left,
                                     (self.bounds.size.height - self.imageSize.height)/2,
                                     self.imageSize.width,
                                     self.imageSize.height);
        }
            break;
            
        default:
            break;
    }
    return contentRect;
}


-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    //注意: 在此获取title的frame为CGZero.使用intrinsicContentSize
    self.titleSize = self.titleLabel.intrinsicContentSize;
    
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    //注意: 在此获取imageView的frame为CGZero.使用intrinsicContentSize
    self.imageSize = self.imageView.intrinsicContentSize;
}

//直接子类化UIView不用调用super, 其他的都需要调用;
//不能直接调用此方法,call the setNeedsDisplay or setNeedsDisplayInRect: method instead.
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
}

//供子类调用, 不会改变自身size的大小, 子类重写此方法可以限制返回的view的大小
//默认返回自身大小
//- (CGSize)sizeThatFits:(CGSize)size{
//    return self.frame.size;
//}


@end
