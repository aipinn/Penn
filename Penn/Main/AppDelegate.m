//
//  AppDelegate.m
//  Penn
//
//  Created by PENN on 2017/9/7.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import <sys/utsname.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow * window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    BaseTabBarController * tabBar = [[BaseTabBarController alloc] init];
    window.rootViewController = tabBar;
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    self.window = window;
    

    return YES;
}


#pragma mark - app 日志上传

- (void)pnCatchCarshLog{
    [self pnUploadExceptionLog];
    NSSetUncaughtExceptionHandler(&catchExceptionLog);
    
}
- (void)pnUploadExceptionLog{
    if (&log != nil) {
        // 在这里上传 Crash 信息，上传完毕后要记得清空
    }
    
}
void catchExceptionLog(NSException *exception) {
    // 获取 Crash 信息
    NSArray *symbols = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSDictionary *userInfo = [exception userInfo];
    
    /*另外，我们可能需要一些别的信息，比如说发生 Crash 的设备的系统版本，设备型号，App的版本号.....*/
    struct utsname systemInfo; // 需要导入`sys/utsname.h`头文件。
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [appInfo objectForKey:@"CFBundleShortVersionString"];
    // 格式化字符串
    NSString *result = [NSString stringWithFormat:@"CarshReason = %@ \n name = %@ \n userInfo = %@ \n log = %@ \n systemVersion = %f \n deviceInfo = %@ \n appVersion = %@",reason,name,userInfo,symbols,[UIDevice currentDevice].systemVersion.floatValue,deviceString,appVersion];
    NSLog(@"----(꒦_꒦) -----:%@", result);
    // 把 result 写入本地
    
}

@end
