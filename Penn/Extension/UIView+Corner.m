//
//  UIView+Corner.m
//  HomeEconomics
//
//  Created by emoji on 2018/11/26.
//  Copyright © 2018 guanjia. All rights reserved.
//

#import "UIView+Corner.h"

@implementation UIView (Corner)

- (void)addSingleCornerRadius:(CGFloat)radius roundingCorners:(UIRectCorner)cornerRadii{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:cornerRadii cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addTopCornerRadius:(CGFloat)radius{
    [self addSingleCornerRadius:radius roundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
}
- (void)addBottomCornerRadius:(CGFloat)radius{
     [self addSingleCornerRadius:radius roundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
}
- (void)addLeftCornerRadius:(CGFloat)radius{
     [self addSingleCornerRadius:radius roundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft];
}
- (void)addRightCornerRadius:(CGFloat)radius{
     [self addSingleCornerRadius:radius roundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight];
}
- (void)addAllCornerRadius:(CGFloat)radius{
    [self addSingleCornerRadius:radius roundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight |UIRectCornerBottomLeft| UIRectCornerBottomRight];
}

@end
