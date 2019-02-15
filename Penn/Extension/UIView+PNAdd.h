//
//  UIView+PNAdd.h
//  HomeEconomics
//
//  Created by emoji on 2019/1/17.
//  Copyright © 2019 guanjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PNAdd)

/**
 添加和自身同等大小的渐变(自左到右)layer

 @param colors 渐变颜色数组
 @return self
 */
- (UIView *)gradientLayerColors:(nonnull NSArray <UIColor *>*)colors;
/**
 添加渐变色
 */
- (UIView *)gradientLayer:(CGRect)frame
               startPoint:(CGPoint)startPoint
                 endPoint:(CGPoint)endPoint
                   colors:(NSArray *)colors
                locations:(NSArray *)locations;
@end

NS_ASSUME_NONNULL_END
