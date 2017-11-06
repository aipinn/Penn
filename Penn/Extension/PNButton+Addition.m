//
//  PNButton+Addition.m
//  Penn
//
//  Created by SanRong on 2017/11/4.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "PNButton+Addition.h"

@implementation PNButton (Addition)

- (void)imageRight{
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageSize.width, 0, self.imageSize.width);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleSize.width, 0, -self.titleSize.width);
    
}

- (void)imageTop{
    
}

- (void)imageBottom{
    
    
}

@end
