//
//  UIView+Corner.h
//  HomeEconomics
//
//  Created by emoji on 2018/11/26.
//  Copyright © 2018 guanjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Corner)

- (void)addSingleCornerRadius:(CGFloat)radius roundingCorners:(UIRectCorner)cornerRadii;
- (void)addTopCornerRadius:(CGFloat)radius;
- (void)addBottomCornerRadius:(CGFloat)radius;
- (void)addLeftCornerRadius:(CGFloat)radius;
- (void)addRightCornerRadius:(CGFloat)radius;
- (void)addAllCornerRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
