//
//  PNEmptyButton.m
//  Penn
//
//  Created by gjb on 2018/5/7.
//  Copyright © 2018年 SanRong. All rights reserved.
//

#import "PNEmptyButton.h"

@implementation PNEmptyButton

+ (PNEmptyButton *)emptyButton{
    
    return [[NSBundle mainBundle] loadNibNamed:@"PNEmptyButton" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

@end
