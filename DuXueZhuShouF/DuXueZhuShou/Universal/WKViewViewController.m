
//
//  WKViewViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/5/11.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "WKViewViewController.h"
#import <WebKit/WebKit.h>
#import "NSString+Hash.h"
@interface WKViewViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)WKWebView *wkview;
@property(nonatomic,strong)UIImageView *coverView;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property (nonatomic, retain) CALayer *progresslayer;
@end

@implementation WKViewViewController
-(instancetype)init{
    if (self = [super init]) {
        self.isShowLoginview = NO;
        self.isShare = NO;
        self.isCollection = NO;
    }
    return self;
}
- (void)dealloc {
    [self.wkview removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = self.titleStr;
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    // 自适应屏幕宽度js


    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//     添加自适应屏幕宽度js调用的方法
    WKUserContentController *wkUController = [[WKUserContentController alloc]init];
    [wkUController addUserScript:wkUserScript];
    wkWebConfig.userContentController = wkUController;
    self.wkview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width,SCREEN.size.height) configuration:wkWebConfig];
    self.wkview.scrollView.delegate = self;
    self.wkview.UIDelegate = self;
    self.wkview.navigationDelegate = self;
    [self.wkview sizeToFit];
//    [self.wkview setAutoresizesSubviews:YES];
//    self.wkview.allowsBackForwardNavigationGestures = YES;
    
    [self.wkview loadRequest:[self getRequest]];
//    [self.wkview loadHTMLString:@"" baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    [self.view addSubview:self.wkview];
    [_wkview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
//    [self creteBaritem];
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT, CGRectGetWidth(self.view.frame), 2)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 2);
    layer.backgroundColor = JHMaincolor.CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
}
-(NSMutableURLRequest *)getRequest{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr ? self.urlStr:@""]];
    [request setValue:@"iphone" forHTTPHeaderField:@"XX-Device-Type"];
    [request setValue:AppBuildVersion forHTTPHeaderField:@"XX-APP-VERSION"];
    UserModel *model = [UserUtils getUserInfo];
    if (model && model.token) {
        [request setValue:model.token forHTTPHeaderField:@"XX-Token"];
    }
    //加密
    NSInteger timeStamp = [[NSDate date]timeIntervalSince1970];
    [request setValue:[NSString stringWithFormat:@"%ld",(long)timeStamp] forHTTPHeaderField:@"XX-CHECK-TIME"];
    NSString *mdstr = [NSString stringWithFormat:@"%@%@",[lStringFormart(@"%ld", (long)timeStamp) MD5ForLower32Bate].lowercaseString,MD5String];
    NSString *checkToken = [NSString stringWithFormat:@"%@%@",MD5Header,[mdstr MD5ForLower32Bate].lowercaseString];
    [request setValue:checkToken forHTTPHeaderField:@"XX-CHECK-TOKEN"];
    return request;
}
-(NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
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

//-(void)creteBaritem{
//    if (self.isShare) [self.imageArr addObject:@"fenxiang"];
//    if (self.isCollection) [self.imageArr addObject:@"xingxing"];
//    NSMutableArray *barArr = [NSMutableArray array];
//    for (int i = 0; i < self.imageArr.count; i ++) {
//        UIImage *im = [UIImage imageNamed:self.imageArr[i]];
//        IndexBtn *btn = [[IndexBtn alloc]initWithFrame:CGRectMake(0, 0, im.size.width + 30, im.size.height)];
//        btn.index = i;
//        [btn setImage:im forState:UIControlStateNormal];
//        if ([@"xingxing" isEqualToString:self.imageArr[i]]) {
//            [btn setImage:[UIImage imageNamed:@"shoucanghuang"] forState:UIControlStateSelected];
//            [self iscollection:btn];
//        }
//        [btn addTarget:self action:@selector(baritemClick:) forControlEvents:UIControlEventTouchUpInside];
//        [barArr addObject:[[UIBarButtonItem alloc]initWithCustomView:btn]];
//    }
//    self.navigationItem.rightBarButtonItems = barArr;
//
//}
//-(void)baritemClick:(IndexBtn *)btn{
//    if (![UserUtils getUserInfo]) {
//        [self showLoginAlert];
//    }
//    btn.userInteractionEnabled = NO;
//    if ([@"xingxing" isEqualToString:self.imageArr[btn.index]]) {
//
//        NSDictionary *para = @{@"type":self.type,@"fav_id":self.urlId,@"token":[UserUtils getUserInfo].token ?[UserUtils getUserInfo].token :@""};
//        [LFLHttpTool post:[NSString stringWithFormat:@"%@%@",EnergyBaseUrl,CollectionUrl] params:para success:^(id response) {
//            NSNumber *code = [response objectForKey:@"code"];
//            [Showprompt Mbprogress:[response objectForKey:@"msg"]];
//            if (code.integerValue == 1) {
//                btn.selected = !btn.selected;
//                btn.userInteractionEnabled = YES;
//            }
//        } failure:^(NSError *error) {
//            btn.userInteractionEnabled = YES;
//            [Showprompt Mbprogress:@"收藏失败！"];
//        }];
//    }else{
//        if (self.isCollection && self.urlId && self.type) {
//            [self presentLoadingTips];
//            __weak typeof(self) weakSelf = self;
//            [self getShareDataWithPara:@{@"type":self.type,@"id":self.urlId} success:^(ShareModel * shareModel) {
//                btn.userInteractionEnabled = YES;
//                [weakSelf dismissTips];
//                [[ShareUtils sharedShareUtils] ShareContent:weakSelf title:shareModel.intro content:shareModel.intro url:shareModel.url image:shareModel.logo];
//            } failure:^(NSError *error) {
//                btn.userInteractionEnabled = YES;
//                [weakSelf dismissTips];
//                [weakSelf presentLoadingTips:@"分享失败！"];
//            }];
//        }
//    }
//}
//
//- (void)iscollection:(IndexBtn *)btn{
//    btn.userInteractionEnabled = NO;
//    UserModel *model = [UserUtils getUserInfo];
//    NSDictionary *para = @{@"type":self.type,@"id":self.urlId,@"token":model?model.token:@""};
//    [LFLHttpTool post:[NSString stringWithFormat:@"%@%@",EnergyBaseUrl,IsCollectionUrl] params:para success:^(id response) {
//        NSNumber *code = [response objectForKey:@"code"];
//        if (code.integerValue == 1) {
//            btn.selected = [[response objectForKey:@"data"] boolValue];
//        }
//        btn.userInteractionEnabled = YES;
//    } failure:^(NSError *error) {
//        btn.userInteractionEnabled = YES;
//    }];
//}
-(UIImageView *)coverView{
    if ( !_coverView) {
        _coverView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.25 *screenH, screenW, 0.75*screenH)];
        _coverView.userInteractionEnabled = YES;
        _coverView.backgroundColor = [UIColor redColor];
        for (int i = 0; i < 2; i ++) {
            UIButton *btn = [[UIButton alloc]init];
            [btn setTitle:@"登录" forState:UIControlStateNormal];
            btn.backgroundColor = JHMaincolor;
            [btn addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.cornerRadius = 20;
            btn.layer.masksToBounds = YES;
            [_coverView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.centerY.equalTo(_coverView.mas_centerY).offset(50);
                }else{
                    make.centerY.equalTo(_coverView.mas_centerY);
                }
                
                make.left.offset(30);
                make.right.offset(-30);
                make.height.offset(40);
            }];
            
        }
        [self changeAlpha];
    }
    return _coverView;
}
-(void)changeAlpha{
    
    CAGradientLayer *_gradLayer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                       nil];
    [_gradLayer setColors:colors];
    //渐变起止点，point表示向量
    [_gradLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
    [_gradLayer setEndPoint:CGPointMake(0.0f, 1.0f)];
    
    [_gradLayer setFrame:_coverView.bounds];
    
    [_coverView.layer setMask:_gradLayer];
    
}
-(void)doLogin{
    [self showLoginAlert];
}

#pragma mark UIWebViewDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [self presentLoadingTips];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self dismissTips];
//    NSString *js=@"var script = document.createElement('script');"
//    "script.type = 'text/javascript';"
//    "script.text = \"function ResizeImages() { "
//    "var myimg,oldwidth;"
//    "var maxwidth = %f;"
//    "for(i=0;i <document.images.length;i++){"
//    "myimg = document.images[i];"
//    "if(myimg.width > maxwidth){"
//    "oldwidth = myimg.width;"
//    "myimg.height = %f/myimg.width *myimg.height;"
//    "myimg.width = %f;"
//    "}"
//    "}"
//    "}\";"
//    "document.getElementsByTagName('head')[0].appendChild(script);%@";
//    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15,[UIScreen mainScreen].bounds.size.width-15,@"ResizeImages();"];
//    //    LFLog(@"js:%@",js);
//    [_wkview evaluateJavaScript:js  completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//
//    }];

    
    
    
}

// 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
    
}


@end
