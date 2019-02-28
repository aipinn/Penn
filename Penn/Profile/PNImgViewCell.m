//
//  PNImgViewCell.m
//  Penn
//
//  Created by emoji on 2019/2/25.
//  Copyright © 2019 PENN. All rights reserved.
//

#import "PNImgViewCell.h"

@implementation PNImgViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//For performance reasons, you should only reset attributes of the cell that are not related to content, for example, alpha, editing, and selection state.
- (void)prepareForReuse {
    [super prepareForReuse];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        for (NSInteger i = 0; i < 60; i++) {
            UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * (50+10), 10, 50, 50)];
            [self.contentView addSubview:imgV];
            [self clipCornersWithCR:imgV];
//            [self clipCornersWithPath:imgV];
//            [self clipCornerWithCG:imgV];
        }

        for (NSInteger i = 0; i < 6; i++) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(i * (50+10), 70, 50, 30)];
            [self.contentView addSubview:view];

            view.backgroundColor = [UIColor brownColor];
            view.layer.cornerRadius = 10;
            //view.layer.masksToBounds = YES;
            
            UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
            subView.backgroundColor = [UIColor greenColor];
            [view addSubview:subView];
        }
        
        for (NSInteger i = 0; i < 6; i++) {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(i * (50+10), 120, 50, 30)];
            [self.contentView addSubview:label];
            
            label.backgroundColor = [UIColor brownColor];
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            
        }
    }
    
    return self;
}

- (void)setNum:(NSInteger)num {
    _num = num;
}

- (void)clipCornersWithCR:(UIImageView *)imgV {
    imgV.image = [UIImage imageNamed:@"tmp"];
    imgV.layer.cornerRadius = 10;
    imgV.layer.masksToBounds = YES;
}
- (void)clipCornersWithPath:(UIImageView *)imgV {
    imgV.image = [UIImage imageNamed:@"tmp"];
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *aPath = [UIBezierPath bezierPathWithOvalInRect:imgV.bounds];
    layer.path = aPath.CGPath;
    imgV.layer.mask = layer;
    
//    self.layer.shouldRasterize = YES;
//    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)clipCornerWithCG:(UIImageView *)imgV {
    UIImage *img = [UIImage imageNamed:@"tmp"];
    imgV.image = [img imageByRoundCornerRadius:25];
}

@end
