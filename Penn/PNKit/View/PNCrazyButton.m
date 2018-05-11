//
//  PNCrazyButton.m
//  Penn
//
//  Created by PENN on 2017/11/24.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import "PNCrazyButton.h"

@implementation PNCrazyButton

+ (PNCrazyButton *)crazyButton{

    return [[NSBundle mainBundle] loadNibNamed:@"PNCrazyButton" owner:nil options:nil].lastObject;
}

@end
