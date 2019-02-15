//
//  Global.h
//  HuEiicn
//
//  Created by Hucom on 2016/11/3.
//  Copyright © 2016年 Hucom. All rights reserved.
//

#ifndef Global_h
#define Global_h

#import "API.h"

//--------------自定义宏---------------------------------------

#define DBFileName [NSString stringWithFormat:@"%@_gdt_rep.sqlite",[MYUserDefaults objectForKey:@"FUSER_ID"]]

#define kNetworkErrorHint @"网络错误请稍后再试!"

//中文字体
#define CHINESE_FONT_NAME  @"Heiti SC"
#define CHINESE_SYSTEM(x) [UIFont fontWithName:CHINESE_FONT_NAME size:x]

//常用单例
#define MYNotification [NSNotificationCenter defaultCenter]
#define MYUserDefaults  [NSUserDefaults standardUserDefaults]
#define MYColor(R, G, B) [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:1]
#define APPDELEGATE  ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define APPKeyWindow ([UIApplication sharedApplication].keyWindow)
//--常用方法--

//弱引用
#ifndef PNWeakObj
#define PNWeakObj(obj) autoreleasepool{} __weak typeof(obj) weak##obj = obj
#endif
//距当前时间seconds秒的时间戳, seconds为负数返回当前时间之前
#define KTimestamp(seconds) \
({\
NSDate *date = [NSDate dateWithTimeIntervalSinceNow:seconds];\
NSTimeInterval interval = [date timeIntervalSince1970];\
NSString *timeString = [NSString stringWithFormat:@"%0.f", interval];\
(timeString);\
})
//常用字体
#define kFontSemiboldSize(fontSize) [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize]
#define kFontMediumSize(fontSize) [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize]
#define kFontRegularSize(fontSize) [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize]
//获取图片资源
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//设备宽和高
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//应用实际宽和高,除去状态栏
#define APPFRAME_WIDTH ([UIScreen mainScreen].applicationFrame.size.width)
#define APPFRAME_HEIGHT ([UIScreen mainScreen].applicationFrame.size.height)
//判断设备是否是iPhone/iPad
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//-----------Xcode8 iOS10-------
//版本判断(9与10的问题)
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size)  : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size)  : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断是否是iPhone X 系列
#define iPhoneX ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? YES : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)
//tool bar
#define TOOL_BAR_HEIGHT (iPhoneX ? 83.f : 44.f)



//其他
#define CLEARCOLOR  [UIColor clearColor]


//自定义打印Log
//A better version of NSLog
//#define NSLog(format, ...) do { \
//fprintf(stderr, "<%s : %d> %s\n", \
//[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
//__LINE__, __func__); \
//(NSLog)((format), ##__VA_ARGS__); \
//fprintf(stderr, "-------\n"); \
//} while (0)

//#ifdef DEBUG
//
//#define MyLog(fmt, ...) NSLog((@"MyLog:\n FUNC: %s  |**| [Line %d] \n" fmt),__func__, __LINE__, ##__VA_ARGS__)
//
//#define MBLog(fmt, ...) NSLog((@"[Line %d] --> " fmt), __LINE__, ##__VA_ARGS__)
//
//#else
//
//#define MyLog(fmt, ...)
//
//#define MBLog(fmt, ...)
//
//#endif

//单例化一个类
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = ［self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}




#endif /* Global_h */
