//
//  PNViewButton.m
//  Penn
//
//  Created by gjb on 2018/5/7.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNViewButton.h"

@implementation PNViewButton

+ (PNViewButton *)viewButton{
    
    return [[NSBundle mainBundle] loadNibNamed:@"PNViewButton" owner:nil options:nil].lastObject;
}


@end
