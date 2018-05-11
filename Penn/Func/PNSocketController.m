//
//  PNSocketController.m
//  Penn
//
//  Created by PENN on 2017/9/9.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import "PNSocketController.h"

#import <sys/socket.h>
#import <arpa/inet.h>
#import <netinet/in.h>

@interface PNSocketController ()

@property (nonatomic, strong) UITextField * field;
@property (nonatomic, assign) int clientSocket;

@end

@implementation PNSocketController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton * btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(100, 100, 100, 50);
    [btn  setTitle:@"发送消息" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(100, 200, 200, 50)];
    [self.view addSubview:field];
    field.borderStyle = UITextBorderStyleRoundedRect;
    self.field = field;
    
}
- (void)btnClicked{
    
    [self sendMsg:@"hello world"];
}



- (void)sendMsg:(NSString *)msg{
    
    /*
     socket~~ip+port
     $ nc -lk 12345,监听12345端口(Netcat-->nc)
     */
    
    //1. 创建socket
    
    /**
     domain, 协议域 AF_INET-->IPV4
     type socket类型, SOCK_STREAM/SCOK_DGRAM
     protocol, 默认写0, 会根据第二个参数自动选择合适的协议
     */
    int clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    //2. 连接
    
    struct sockaddr_in serverAddr;
    //协议域
    serverAddr.sin_family = AF_INET;
    //端口
    serverAddr.sin_port = htons(80);
    //地址
    serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    
    int connectResult = connect(clientSocket, (const struct sockaddr *)&serverAddr, sizeof(serverAddr));
    
    if (connectResult == 0) {
        NSLog(@"连接成功了......");
    }else{
        NSLog(@"连接失败%d",connectResult);
        return;
    }
    
    //3. 发送
    ssize_t sendLen = send(clientSocket, msg.UTF8String, strlen(msg.UTF8String), 0);
    NSLog(@"发送了%ld字节的数据",sendLen);
    
    //4. 读取
    uint8_t buffer[128];
    ssize_t recvLen = recv(clientSocket, buffer, sizeof(buffer), 0);
    NSLog(@"接收了%ld字节的数据",recvLen);
    
    //5. 关闭
    close(clientSocket);
    
    
    //6. 转换接收数据
    NSData * data = [NSData dataWithBytes:buffer length:recvLen];
    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    self.field.text = str;
    NSLog(@"收到的数据:%@", str);
    
}


@end
