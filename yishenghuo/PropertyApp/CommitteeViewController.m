//
//  CommitteeViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/25.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//
/// 控件高度
#define kSearchBarH  44
#define kBottomViewH 44

/// 屏幕大小尺寸
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "CommitteeViewController.h"
#import <WebKit/WebKit.h>
@interface CommitteeViewController ()<UISearchBarDelegate, WKNavigationDelegate>

@property(nonatomic,strong)WKWebView *wkview;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) NSUInteger loadCount;


@property (weak, nonatomic) UIButton *backBtn;
@property (weak, nonatomic) UIButton *forwardBtn;
@property (weak, nonatomic) UIButton *reloadBtn;
@property (weak, nonatomic) UIButton *browserBtn;
@property (nonatomic, strong) UISearchBar *searchBar;
/// 网页控制导航栏
@property (weak, nonatomic) UIView *bottomView;
@property (assign, nonatomic) BOOL istimeOut;
@end

@implementation CommitteeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"业主委员会";
    self.istimeOut = YES;
    LFLog(@"%@",self.urlstr);
//    self.webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height)];
//    self.webview.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
//    self.webview.userInteractionEnabled = YES;//自动检测网页上的电话号码，单击可以拨打
//    NSURL * url = [NSURL URLWithString:self.urlstr];
//    NSURLRequest * request = [NSURLRequest requestWithURL:url];
//    [_webview loadRequest:request];
//    //    [self.webview loadHTMLString:HtmlData baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
//    [self.view addSubview:self.webview];
    
//    self.wkview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height)];
//       self.wkview.userInteractionEnabled = YES;//自动检测网页上的电话号码，单击可以拨打
    
    [self addSubViews];
    [self refreshBottomButtonState];
    [self.wkview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSURL * url = [NSURL URLWithString:self.urlstr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.wkview loadRequest:request];
//    [self.view addSubview:self.wkview];
    
    self.progressView =  [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.center = self.view.center;
    [self.view addSubview:self.progressView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.wkview.title;
    } else if ([keyPath isEqualToString:@"URL"]) {
        
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        LFLog(@"estimatedProgress:%f",self.wkview.estimatedProgress);
        self.progressView.progress = self.wkview.estimatedProgress;
    }
    
    if (object == self.wkview && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}


- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
        
    }
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.loadCount ++;

    [self presentLoadingTips];


    double delayInSeconds = 10.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
        if (self.istimeOut) {
            [self dismissTips];
            [self presentLoadingTips:@"加载失败"];
            self.loadCount --;
            NSLog(@"超时2345t");
            [self.wkview stopLoading];
        }

    });
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.istimeOut = NO;
[self refreshBottomButtonState];
    [self dismissTips];
}
// 内容返回时
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.loadCount --;
}
//失败
- (void)webView:(WKWebView *)webView didFailNavigation: (null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.istimeOut = NO;
    [self dismissTips];
    [self presentLoadingTips:@"加载失败"];
    self.loadCount --;
    NSLog(@"%@",error);
}




- (void)addSubViews {
    [self addBottomViewButtons];
    
    [self.view addSubview:self.searchBar];
    
    [self.view addSubview:self.wkview];
}

- (void)addBottomViewButtons {
    // 记录按钮个数
    int count = 0;
    // 添加按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"后退" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:249 / 255.0 green:102 / 255.0 blue:129 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    button.tag = ++count;    // 标记按钮
    [button addTarget:self action:@selector(onBottomButtonsClicled:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:button];
    self.backBtn = button;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"前进" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:249 / 255.0 green:102 / 255.0 blue:129 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    button.tag = ++count;
    [button addTarget:self action:@selector(onBottomButtonsClicled:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:button];
    self.forwardBtn = button;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"重新加载" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:249 / 255.0 green:102 / 255.0 blue:129 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    button.tag = ++count;
    [button addTarget:self action:@selector(onBottomButtonsClicled:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:button];
    self.reloadBtn = button;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Safari" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:249 / 255.0 green:102 / 255.0 blue:129 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    button.tag = ++count;
    [button addTarget:self action:@selector(onBottomButtonsClicled:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:button];
    self.browserBtn = button;
    // 统一设置frame
    [self setupBottomViewLayout];
}
- (void)setupBottomViewLayout
{
    int count = 4;
    CGFloat btnW = 80;
    CGFloat btnH = 30;
    
    CGFloat btnY = (self.bottomView.bounds.size.height - btnH) / 2;
    // 按钮间间隙
    CGFloat margin = (self.bottomView.bounds.size.width - btnW * count) / count;
    
    CGFloat btnX = margin * 0.5;
    self.backBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    btnX = self.backBtn.frame.origin.x + btnW + margin;
    self.forwardBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    btnX = self.forwardBtn.frame.origin.x + btnW + margin;
    self.reloadBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    btnX = self.reloadBtn.frame.origin.x + btnW + margin;
    self.browserBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
}
/// 刷新按钮是否允许点击
- (void)refreshBottomButtonState {
    if ([self.wkview canGoBack]) {
        self.backBtn.enabled = YES;
    } else {
        self.backBtn.enabled = NO;
    }
    
    if ([self.wkview canGoForward]) {
        self.forwardBtn.enabled = YES;
    } else {
        self.forwardBtn.enabled = NO;
    }
}
/// 按钮点击事件
- (void)onBottomButtonsClicled:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            [self.wkview goBack];
            [self refreshBottomButtonState];
        }
            break;
        case 2:
        {
            [self.wkview goForward];
            [self refreshBottomButtonState];
        }
            break;
        case 3:
            [self.wkview reload];
            break;
        case 4:
            [[UIApplication sharedApplication] openURL:self.wkview.URL];
            break;
        default:
            break;
    }
}

#pragma mark - WKWebView WKNavigationDelegate 相关
/// 是否允许加载网页 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    
    urlString = [urlString stringByRemovingPercentEncoding];
    //    NSLog(@"urlString=%@",urlString);
    // 用://截取字符串
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    if ([urlComps count]) {
        // 获取协议头
        NSString *protocolHead = [urlComps objectAtIndex:0];
        NSLog(@"protocolHead=%@",protocolHead);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark - searchBar代理方法
/// 点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 创建url
    NSURL *url = nil;
    NSString *urlStr = searchBar.text;
    
    // 如果file://则为打开bundle本地文件，http则为网站，否则只是一般搜索关键字
    if([urlStr hasPrefix:@"file://"]){
        NSRange range = [urlStr rangeOfString:@"file://"];
        NSString *fileName = [urlStr substringFromIndex:range.length];
        url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        // 如果是模拟器加载电脑上的文件，则用下面的代码
        //        url = [NSURL fileURLWithPath:fileName];
    }else if(urlStr.length>0){
        if ([urlStr hasPrefix:@"http://"]) {
            url=[NSURL URLWithString:urlStr];
        } else {
            urlStr=[NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",urlStr];
        }
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        url=[NSURL URLWithString:urlStr];
        
    }
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    // 加载请求页面
    [self.wkview loadRequest:request];
}
#pragma mark - 懒加载
- (UIView *)bottomView {
    if (_bottomView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kBottomViewH, kScreenWidth, kBottomViewH)];
        view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [self.view addSubview:view];
        _bottomView = view;
    }
    return _bottomView;
}
- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kSearchBarH)];
        searchBar.delegate = self;
        searchBar.text = @"http://www.cnblogs.com/mddblog/";
        _searchBar = searchBar;
        
    }
    return _searchBar;
}

- (WKWebView *)wkview {
    if (_wkview == nil) {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20 + kSearchBarH, kScreenWidth, kScreenHeight - 20 - kSearchBarH - kBottomViewH)];
        webView.navigationDelegate = self;
        //                webView.scrollView.scrollEnabled = NO;
        
        //        webView.backgroundColor = [UIColor colorWithPatternImage:self.image];
        // 允许左右划手势导航，默认允许
        webView.allowsBackForwardNavigationGestures = YES;
        _wkview = webView;
    }
    
    return _wkview;
}





-(void)dealloc{
    [self.wkview removeObserver:self forKeyPath:@"estimatedProgress"];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
@end
