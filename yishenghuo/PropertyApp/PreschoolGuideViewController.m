//
//  PreschoolGuideViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PreschoolGuideViewController.h"
#import <WebKit/WebKit.h>
#import "PreschoolSubmitViewController.h"
@interface PreschoolGuideViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)WKWebView *wkview;
@property (nonatomic, retain) CALayer *progresslayer;

@end

@implementation PreschoolGuideViewController

- (void)dealloc {
    [self.wkview removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"招生简章";
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    // 自适应屏幕宽度js
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    //     添加自适应屏幕宽度js调用的方法
    WKUserContentController *wkUController = [[WKUserContentController alloc]init];
    [wkUController addUserScript:wkUserScript];
    wkWebConfig.userContentController = wkUController;
    self.wkview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width,SCREEN.size.height - 50) configuration:wkWebConfig];
    self.wkview.scrollView.delegate = self;
    self.wkview.UIDelegate = self;
    self.wkview.navigationDelegate = self;
    [self.wkview sizeToFit];
//    [self.wkview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr ? self.urlStr:@""]]];
    [self.view addSubview:self.wkview];
    [_wkview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, NaviH, CGRectGetWidth(self.view.frame), 2)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 2);
    layer.backgroundColor = JHMaincolor.CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
    [self getData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 2);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



#pragma mark UIWebViewDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [self presentLoadingTips];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self dismissTips];
}

// 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (IBAction)btnclick:(id)sender {
    PreschoolSubmitViewController *vc = [[PreschoolSubmitViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 数据
-(void)getData{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};// PreschoolBannerUrl
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PreschoolGuideUrl) params:dt success:^(id response) {
        LFLog(@"轮播图数据:%@",response);

        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            NSString *content = response[@"data"][@"content"];
            if (content) {
                [self.wkview loadHTMLString:content baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
            }
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self presentLoadingTips:@"服务器繁忙！"];
    }];
    
}

@end
