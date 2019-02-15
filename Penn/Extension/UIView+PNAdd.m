//
//  UIView+PNAdd.m
//  HomeEconomics
//
//  Created by emoji on 2019/1/17.
//  Copyright © 2019 guanjia. All rights reserved.
//

#import "UIView+PNAdd.h"

@implementation UIView (PNAdd)

- (UIView *)gradientLayerColors:(NSArray <UIColor *>*)colors {

    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 0);
    
    NSMutableArray *cgColors = [[NSMutableArray alloc] init];
    for (UIColor *color in colors) {
        [cgColors addObject:(id)color.CGColor];
    }
    layer.colors = cgColors;
    layer.locations = @[@0.0, @1.0];
    [self.layer insertSublayer:layer atIndex:0];
    return self;
}

- (UIView *)gradientLayer:(CGRect)frame
               startPoint:(CGPoint)startPoint
                 endPoint:(CGPoint)endPoint
                   colors:(NSArray *)colors
                locations:(NSArray *)locations {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = frame;
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    
    NSMutableArray *cgColors = [[NSMutableArray alloc] init];
    for (UIColor *color in colors) {
        [cgColors addObject:(id)color.CGColor];
    }
    layer.colors = cgColors;
    layer.locations = locations;
    [self.layer insertSublayer:layer atIndex:0];
    return self;
}


@end
