//
//  PNCrazyButton.m
//  Penn
//
//  Created by SanRong on 2017/11/24.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "PNCrazyButton.h"

@implementation PNCrazyButton

+ (PNCrazyButton *)crazyButton{

    return [[NSBundle mainBundle] loadNibNamed:@"PNCrazyButton" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)crazyButtonImage:(NSString *)imageStr title:(NSString *)title{
    
    self.imageView.image = [UIImage imageNamed:imageStr];
    self.titleLabel.text = title;
}

@end
