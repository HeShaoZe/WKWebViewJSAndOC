//
//  ViewController.m
//  WKWebViewJSAndOC
//
//  Created by hesz on 2019/3/6.
//  Copyright © 2019年 HSZ. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *myWebView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadWKWebView];
    
    [self loadNavigationViewItem];
}

//加载以及设置WKWebview的配置
- (void)loadWKWebView
{
    NSInteger screenW = [UIScreen mainScreen].bounds.size.width;
    NSInteger screenH = [UIScreen mainScreen].bounds.size.height;
    
    //开始配置WKWebview的一些参数
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //注入一些方法到JS
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    //注册一个html的方法
    [userController addScriptMessageHandler:self name:@"jsSendOcWithPrams"];
    
    configuration.userContentController = userController;
    
    
    WKWebView *myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH) configuration:configuration];
    //html的路径
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"Index" ofType:@"html"];
    NSURL *htmlUrl = [NSURL fileURLWithPath:htmlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:htmlUrl];
    [myWebView loadRequest: request];
    myWebView.navigationDelegate = self;
    myWebView.UIDelegate = self;
    [self.view addSubview:myWebView];
    self.myWebView = myWebView;
}


//导航栏的按钮
- (void)loadNavigationViewItem
{
    UIBarButtonItem * ocToJsBtItem = [[UIBarButtonItem alloc] initWithTitle:@"OC调用JS" style:UIBarButtonItemStyleDone target:self action:@selector(ocTakeJsMethod)];
    self.navigationItem.rightBarButtonItems = @[ocToJsBtItem];
}

#pragma mark - TargetEvent
//OC-->JS
- (void)ocTakeJsMethod
{
    //OC调js的方法随机改变html页面的颜色
    NSString *ocToJs = @"ocToJs()";
    [self.myWebView evaluateJavaScript:ocToJs completionHandler:^(id _Nullable name, NSError * _Nullable error) {
        NSLog(@"方法调用完成回调");
    }];
}

#pragma mark - WKScriptMessageHandler
//JS-->OC
//这个协议类监听JavaScript方法从而调用原生OC方法.接收来自Html页面的方法
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"userContentControllerfdfjdik----%@---%@",message.body,message.name);
    
    if ([message.name isEqualToString:@"jsSendOcWithPrams"])
    {
        NSString *keyContent = message.body[@"oneParam"];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:keyContent preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:([UIAlertAction actionWithTitle:@"OC显示" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }])];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
    
}


@end
