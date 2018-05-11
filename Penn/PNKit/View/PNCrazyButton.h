//
//  PNCrazyButton.h
//  Penn
//
//  Created by PENN on 2017/11/24.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNCrazyButton : UIControl

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (PNCrazyButton *)crazyButton;



@end
