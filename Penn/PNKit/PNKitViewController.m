//
//  PNKitViewController.m
//  Penn
//
//  Created by PENN on 2017/11/4.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import "PNKitViewController.h"
#import "PNButton.h"
#import "PNCrazyButton.h"
#import "Penn-Swift.h"
#import "PNViewButton.h"
#import "PNEmptyButton.h"
#import "UIButton+Addition.h"
#import "PNTask.h"
#import "PNTextViewController.h"

@interface PNKitViewController ()


@end

@implementation PNKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];

    
//    [self customCrazyBtn];
//    [self customButton];
//    [self newButton];
    [self runtimeAssociated];
//    [self kvcUse];
    

}


#pragma mark - KVC + runtime使用
/**
 KVC 使用 + runtime
 */
- (void)kvcUse{
    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 100, 300, 100)];
    [self.view addSubview:searchBar];
    // 公开的属性
    searchBar.placeholder = @"默认文字";
    searchBar.prompt = @"prompt...";
    searchBar.tintColor = [UIColor yellowColor];// 光标的颜色
    
    //1. 运行时获取所有成员变量以及对应的类型
    //存在一个UISearchBarTextField类的变量_searchField,猜测应该是显示文字的
    [self getIvarsClassString:NSStringFromClass(UISearchBar.class)];
    // UISearchBarTextField本身没有找到相关的属性
    [self getIvarsClassString:@"UISearchBarTextField"];
    
    //2. 运行时获取指定字符串对应的类的父类:UITextField
    Class cls = class_getSuperclass(NSClassFromString(@"UISearchBarTextField"));
    NSLog(@"%@", cls);
    //3. 通过上一步可知UISearchBarTextField的父类为UITextField
    UITextField * field = [searchBar valueForKey:@"_searchField"];
    field.font = [UIFont systemFontOfSize:14.0];
    field.textColor = [UIColor orangeColor];
    //4. 同理可以获取UTextField的站位label:_placeholderLabel.textColor
    [field setValue:[UIColor greenColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    //5. 3,4可以合并,释放注释查看
    //[searchBar setValue:[UIColor purpleColor] forKeyPath:@"_searchField.placeholderLabel.textColor"];
}

- (void)getIvarsClassString:(NSString *)clsName{
    if (!clsName) {
        return;
    }
    unsigned int ivarCount = 0;
    /*
     An array of pointers of type Ivar describing the instance variables declared by the class. Any instance variables declared by superclasses are not included.
     */
    Ivar * ivars =  class_copyIvarList(NSClassFromString(clsName), &ivarCount);
    for (unsigned int i = 0; i < ivarCount; i++) {
        Ivar ivar = ivars[i];
        NSString * name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString * type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        NSLog(@"ap--name:%@ type:%@",name, type);
    }
}

#pragma mark - runtime+associated

- (void)runtimeAssociated{
    
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(10, 400, 100, 50);
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    // 这个没意思
    btn.title = @"title";
    // 使用associated添加数组属性
    btn.taps = [[NSMutableArray alloc] initWithObjects:@"asd", nil];
    // 使用associated添加回调方法
    __weak typeof(btn) weakBtn = btn;
    btn.callBack = ^{
        NSLog(@"哈哈哈, 添加回调成功. %@", weakBtn.taps);
        PNTextViewController * vc = [[PNTextViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    // btn-->block-->btn
    FBRetainCycleDetector *detector = [FBRetainCycleDetector new];
    [detector addCandidate:btn];
    NSSet *retainCycles = [detector findRetainCycles];
    NSLog(@"fb---:%@", retainCycles);
    

}

#pragma mark - Action

- (void)clickRedBtn:(PNCrazyButton *)sender{
    NSLog(@"红色按钮被点击了");
    //UIView 动画就近原则, 无法旋转2π
    //1. CGAffineTransformRotate代表每次旋转是以上次旋转之后的中心进行旋转
    //2. CGAffineTransformMakeRotation只能旋转一次, 与当t=CGAffineTransformIdentity效果相同
    [UIView animateWithDuration:0.5 animations:^{
        
        CGAffineTransform t = sender.imageView.transform;
        //1. sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        //2.
        sender.imageView.transform = CGAffineTransformRotate(t, M_PI);

        sender.imageView.alpha = 0;
        sender.titleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        sender.imageView.alpha = 1;
        sender.titleLabel.alpha = 1;
    }];
    
}

- (void)clickviewbtn:(UIControl *)sender{
    NSLog(@"viewBtn clicked");
}
- (void)clickemptyBtn:(UIControl *)sender{
    NSLog(@"emptyBtn clicked");
}
#pragma mark - CustomView

- (void)customCrazyBtn{

    //1. Empty xib中手动添加view 可以使用frame控制控件位置大小
    PNEmptyButton * emptyBtn = [PNEmptyButton emptyButton];
    emptyBtn.frame = CGRectMake(SCREEN_WIDTH-150, 88, 150, 50);
    //    [emptyBtn addTarget:self action:@selector(clickemptyBtn:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer * etap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickemptyBtn:)];
    [emptyBtn addGestureRecognizer:etap];
    [self.view addSubview:emptyBtn];
    // 或者使用约束
    //        [emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.center.equalTo(self.view);
    //            make.size.mas_equalTo(CGSizeMake(200, 50));
    //        }];
    
    //2. View xib默认的xib不能使用frame控制控件的位置大小
    PNViewButton * viewbtn = [PNViewButton viewButton];
    //    viewbtn.frame = CGRectMake(0, 200, 100, 50);
    UITapGestureRecognizer * vtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickviewbtn:)];
    [viewbtn addGestureRecognizer:vtap];
    //    [viewbtn addTarget:self action:@selector(clickviewbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewbtn];
    
    [viewbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    
    //3. Empty 使用示例
    PNCrazyButton * btn = [PNCrazyButton crazyButton];
    btn.frame = CGRectMake(0, 100, 60, 80);
    btn.backgroundColor = [UIColor grayColor];
    btn.imageView.image = [UIImage imageNamed:@"backRed"];
    btn.titleLabel.text = @"返回";
    [btn addTarget:self action:@selector(clickRedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

- (void)customButton{
    
//    PNButton * button = [[PNButton alloc] initWithFrame:CGRectMake(0, 100, 100, 80)];
//    button.pn_contentMode = PNButtonContentModeTopImage;
//    button.backgroundColor = [UIColor orangeColor];
//    [button setTitle:@"按下" forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"action-remove"] forState:UIControlStateNormal];
//    [self.view addSubview:button];
    
//    PNButton * button2 = [[PNButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 +2, 100, SCREEN_WIDTH/4, 100)];
//    button2.pn_contentMode = PNButtonContentModeBottomImage;
//    button2.backgroundColor = [UIColor orangeColor];
//    [button2 setTitle:@"按下" forState:UIControlStateNormal];
//    [button2 setImage:[UIImage imageNamed:@"action-remove"] forState:UIControlStateNormal];
//    [self.view addSubview:button2];
//
//    PNButton * button3 = [[PNButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 4, 100, SCREEN_WIDTH/4, 100)];
//    button3.pn_contentMode = PNButtonContentModeRightImage;
//    button3.backgroundColor = [UIColor orangeColor];
//    [button3 setTitle:@"按下" forState:UIControlStateNormal];
//    [button3 setImage:[UIImage imageNamed:@"action-remove"] forState:UIControlStateNormal];
//    [self.view addSubview:button3];
}

- (void)newButton{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 88, 100, 80);
    [self.view addSubview:btn];
    
    [btn setTitle:@"按钮哈额" forState:UIControlStateNormal];//(34, 29.33, 55.33, 21.67)
    [btn setImage:[UIImage imageNamed:@"action-remove"] forState:UIControlStateNormal];//(10.33, 28, 24, 24)
    NSLog(@"%@", btn.imageView);
    btn.titleLabel.backgroundColor = [UIColor cyanColor];
    btn.imageView.backgroundColor = [UIColor orangeColor];
    btn.backgroundColor = [UIColor lightGrayColor];
    
    CGSize size = btn.size;
    //    CGSize titleSize = [btn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    CGSize titleSize = btn.titleLabel.size;
    CGSize imgSize = btn.imageView.size;
    
    // 调整到左上角
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    CGFloat padding = 2;
    CGFloat topPad = (size.height - imgSize.height - titleSize.height - padding)/2;
    // 重新设置(图片在左边,文字在右边)
    btn.imageEdgeInsets = UIEdgeInsetsMake(topPad, (size.width-imgSize.width)/2, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(imgSize.height+padding+topPad, (size.width-titleSize.width)/2 -imgSize.width, 0, 0);
    //
    // 默认图片在左边,文字在右边, imgLeftInset与imgX比相同,并且不存在明显的关系, 所以无法通过Inset去准确设置,
    // 所以, 先将图片和文字调整到左上方再进行设置. 注意文字在图片的基础上进行的需要加上imgWidth.
    
    // 目标:
    /*
     文字: CGRect (22.3, 0, 55.33, 21.67)
     图片: CGRect (38, 0, 24, 24)
     */
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
