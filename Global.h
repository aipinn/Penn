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
