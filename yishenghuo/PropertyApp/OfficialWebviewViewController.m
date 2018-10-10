//
//  OfficialWebviewViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/10.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "OfficialWebviewViewController.h"

@interface OfficialWebviewViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UIWebView *webview;

@end

@implementation OfficialWebviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height)];
    self.webview.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    self.webview.userInteractionEnabled = YES;//自动检测网页上的电话号码，单击可以拨打
    NSURL * url = [NSURL URLWithString:self.urlstr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webview loadRequest:request];
//    [self.webview loadHTMLString:HtmlData baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    [self.view addSubview:self.webview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
