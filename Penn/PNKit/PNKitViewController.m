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
#import "PNCoreTextViewController.h"
#import "PNCustomTransController.h"


@interface PNKitViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation PNKitViewController
{
    UIWindow * _window;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}
#pragma mark - CoreText-Test

- (void)yyImage_sdImage{
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 300, 100, 100)];
    imageV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageV];
    UIImage *ph = [UIImage imageNamed:@"coretext-image-1.jpg"];
    NSString * url = @"https://cdn2.jianshu.io/assets/web/misc-phone-69b812fa6eb049ce4a32ec03ab30416c.png";
//    url = @"http://erp.95081.com/img/brand_logo/2018/03/15/9d9a771d1cbb4fcbb55779c63dc508c9.jpg";
    __weak typeof(imageV) weakImageV = imageV;
//    imageV.layer.cornerRadius = 50;
//    imageV.layer.masksToBounds = YES;
    [imageV setImageWithURL:[NSURL URLWithString:url] placeholder:ph options:1 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        weakImageV.image = [image imageByRoundCornerRadius:MIN(image.size.width, image.size.height)/2];
    }];
    
//    [imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:ph completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        imageV.image = [image imageByRoundCornerRadius:50];//没有循环引用提示
//    }];
    
}
- (IBAction)testCoreText:(id)sender {
    PNCoreTextViewController * ctVC = [[PNCoreTextViewController alloc] init];
    [self.navigationController pushViewController:ctVC animated:YES];
}
- (IBAction)testCustomTransition:(id)sender {
    PNCustomTransController *vc = [[PNCustomTransController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)testInteractiveTransation:(id)sender {
}


#pragma mark - UIWindow

- (void)tapToShowWindow{
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.windowLevel = UIWindowLevelNormal;
    _window.backgroundColor = UIColorHex(666666);
    _window.hidden = NO;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(hideWindow)];
    [_window addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] init];
    [tap2 addTarget:self action:@selector(show)];
    tap2.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap2];
}


#pragma mark - KVC + runtime使用
/**
 KVC 使用 + runtime
 */
- (void)testKvcUse{
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

#pragma mark - runtime+associated

- (void)testRuntimeAssociated{
    
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(10, 100, 150, 30);
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    // 这个没意思
    btn.title = @"Fill-TextView";
    // 使用associated添加数组属性
    btn.taps = [[NSMutableArray alloc] initWithObjects:@"asd", nil];
    // 使用associated添加回调方法
    __weak typeof(btn) weakBtn = btn;
    btn.callBack = ^{
        NSLog(@"哈哈哈, 添加回调成功. %@", weakBtn.taps);
        PNTextViewController * vc = [[PNTextViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    //获取成员变量列表
    [self getIvarsClassString:NSStringFromClass(btn.titleLabel.class)];
    [YYClassInfo classInfoWithClass:UIButton.class];//返回字典
    
    

    
}

#pragma mark - FBRetainCycleDetector 测试循环引用

- (void)testFBRetainCycleDetectorCycle{
    UIButton * btn = [[UIButton alloc] init];
    [self.view addSubview:btn];

    __weak typeof(btn) weakBtn = btn;
    btn.callBack = ^{
        NSLog(@"%@", weakBtn.taps);
    };
    
    // btn-->block-->btn
    FBRetainCycleDetector *detector = [FBRetainCycleDetector new];
    [detector addCandidate:btn];
    NSSet *retainCycles = [detector findRetainCycles];
    NSLog(@"FBRetainCycleDetector:%@", retainCycles);
}




#pragma mark - CustomView
- (void)testCustomCrazyBtn{
    
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

- (void)testNewButton{
    
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
#pragma mark - Action

- (void)hideWindow{
    _window.hidden = YES;
}

- (void)show{
    _window.hidden = NO;
    /*
     Makes the receiver the key window.
     Use this method to make the window key without changing its visibility. The key window receives keyboard and other non-touch related events. This method causes the previous key window to resign the key status.
     
     - (void)becomeKeyWindow;                               // override point for subclass. Do not call directly
     - (void)resignKeyWindow;                               // override point for subclass. Do not call directly
     
     */
    [_window makeKeyWindow];
}

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
#pragma mark - assist methods

/**
 获取一个类所有的成员变量,只能获取当前类的不能获取子类的属性对应的成员变量
 */
- (void)getIvarsClassString:(NSString *)clsName{
    //可以使用YYKit获取
    //YYClassInfo * cls = [YYClassInfo classInfoWithClass:[UIButton class]];
    if (!clsName) {
        return;
    }
    unsigned int ivarCount = 0;
    /*
     An array of pointers of type Ivar describing the instance variables declared by the class.
     Any instance variables declared by superclasses are not included.
     */
    NSLog(@"%@",NSClassFromString(clsName));
    Ivar * ivars =  class_copyIvarList(NSClassFromString(clsName), &ivarCount);
    for (unsigned int i = 0; i < ivarCount; i++) {
        Ivar ivar = ivars[i];
        NSString * name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString * type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        NSLog(@"ap--name:%@ type:%@",name, type);
    }
}




@end
