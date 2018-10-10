
//
//  WKViewViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/5/11.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "WKViewViewController.h"
#import <WebKit/WebKit.h>
@interface WKViewViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)WKWebView *wkview;
@end

@implementation WKViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = self.titleStr;
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    // 自适应屏幕宽度js
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 添加自适应屏幕宽度js调用的方法
    WKUserContentController *wkUController = [[WKUserContentController alloc]init];
    [wkUController addUserScript:wkUserScript];
    self.wkview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width,SCREEN.size.height) configuration:wkWebConfig];
    self.wkview.scrollView.delegate = self;
    self.wkview.UIDelegate = self;
    self.wkview.navigationDelegate = self;
    [self.wkview setAutoresizesSubviews:YES];
    if (self.urlStr) {
        if ([self.urlStr isEqualToString:FinancialUrl]) {
            self.wkview.height = screenH - NaviH -TabH - 40;
        }
        if ([self.urlStr isValidUrl]) {
            [self.wkview loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlStr]]];
        }else{
            [self.wkview loadHTMLString:self.urlStr baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        }
    }else{
        [self getData];
    }

    
    [self.view addSubview:self.wkview];
    
}
#pragma mark - 数据
- (void)getData{
    [self presentLoadingTips];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    NSString *uid = [UserDefault objectForKey:@"uid"];
    if (uid == nil) uid = @"";
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) coid = @"";
    coid = @"53";
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:uid forKey:@"uid"];
    [dt setObject:@"1" forKey:@"iszb"];
    if (self.hn_type) {
        [dt setObject:self.hn_type forKey:@"hn_type"];
    }
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"105") params:dt success:^(id response) {
        [self dismissTips];
        LFLog(@" 数据提交:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                NSString *content = response[@"data"][@"hn_content"];
                self.navigationBarTitle = response[@"data"][@"hn_type"];
                 [self.wkview loadHTMLString:content baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
            }
        }else{
            [self presentLoadingTips:response[@"error_desc"]];
        }

    } failure:^(NSError *error) {
        [self dismissTips];
    }];
    
}

#pragma mark UIWebViewDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [self presentLoadingTips];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self dismissTips];
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.height = %f/myimg.width *myimg.height;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);%@";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15,[UIScreen mainScreen].bounds.size.width-15,@"ResizeImages();"];
    //    LFLog(@"js:%@",js);
    [_wkview evaluateJavaScript:js  completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];

    
}

// 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    
    decisionHandler(WKNavigationActionPolicyAllow);
}


@end
