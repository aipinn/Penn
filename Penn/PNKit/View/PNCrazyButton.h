//
//  PNCrazyButton.h
//  Penn
//
//  Created by SanRong on 2017/11/24.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNCrazyButton : UIControl

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (PNCrazyButton *)crazyButton;
- (void)crazyButtonImage:(NSString *)imageStr title:(NSString *)title;


@end
