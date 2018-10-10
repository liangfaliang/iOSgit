//
//  HealthEducateDetailViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/10.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "HealthEducateDetailViewController.h"
#import "ZFPlayer.h"
#import "HealthEducateListTableViewCell.h"
#import <WebKit/WebKit.h>
#import "ShareSingledelegate.h"
#import "AFNetworkReachabilityManager.h"
@interface HealthEducateDetailViewController ()<ZFPlayerDelegate,UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate>
{
    UIButton *detailBtn;
}
@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (strong, nonatomic)   UIView *playerFatherView;
@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSDictionary *dataDt;
/** 视频URL */
@property (nonatomic, strong) NSURL *videoURL;
@property(nonatomic,strong)WKWebView *wkview;
@property (nonatomic, assign) CGFloat webHeight;//webview高度
@end

@implementation HealthEducateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationAlpha =0;
    ZFPlayerShared.isStatusBarHidden = YES;
    [self.navigationController setNavigationAlpha:0 animated:YES];
    _webHeight = 0.001;
    [self.view addSubview:self.tableview];
    [self presentLoadingTips];
    [self requestDetailData];
    [Notification addObserver:self selector:@selector(NetworkNoti:)
                         name:NetworkNotification object:nil];
    
}
-(void)NetworkNoti:(NSNotification*)notify{
    LFLog(@"notify:%@",notify);
    if ([[notify.userInfo objectForKey:NetworkReachability]isEqualToString:NetworkReachabilityWWAN]) {//手机网络
        if (_playerView) {
            if (_playerView.state == ZFPlayerStatePlaying) {
                [_playerView pause];
                [self alertController:@"" prompt:@"当前环境为非WiFi环境，是否继续播放" sure:@"继续播放" cancel:@"暂停播放" success:^{
                    [_playerView play];
                } failure:^{
                    
                }];
            }
            
        }
        
    }else if ([[notify.userInfo objectForKey:NetworkReachability]isEqualToString:NetworkReachabilityWIFI]){//WiFi
        
    }else if ([[notify.userInfo objectForKey:NetworkReachability]isEqualToString:NetworkReachabilityNotReachable]){//无网
        
    }
}
-(baseTableview *)tableview{
    if (!_tableview) {
        _tableview = [[baseTableview alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableview];
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"detailCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"HealthEducateListTableViewCell" bundle:nil] forCellReuseIdentifier:@"HealthEducatedetailCell"];
    }
    return _tableview;
}
// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    // if (ZFPlayerShared.isLandscape) {
    //    return UIStatusBarStyleDefault;
    // }
    return UIStatusBarStyleLightContent;
}
//隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}
//分享
-(void)zf_playerDownload:(NSString *)url{
    if (self.dataDt && self.dataDt[@"share"] && [self.dataDt[@"share"] isKindOfClass:[NSDictionary class]]) {
        [[ShareSingledelegate sharedShareSingledelegate] ShareContent:self.view content:self.dataDt[@"share"][@"title"] title:self.dataDt[@"share"][@"title"] url:self.dataDt[@"share"][@"url"] image:self.dataDt[@"share"][@"imgurl"]];
    }
}
-(UIView *)playerFatherView{
    if (!_playerFatherView) {
        _playerFatherView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenW*9/16.0)];
    }
    return _playerFatherView;
}
-(WKWebView *)wkview{
    if (!_wkview) {
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        // 自适应屏幕宽度js
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        // 添加自适应屏幕宽度js调用的方法
        WKUserContentController *wkUController = [[WKUserContentController alloc]init];
        [wkUController addUserScript:wkUserScript];
        _wkview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 0) configuration:wkWebConfig];
        _wkview.scrollView.delegate = self;
        _wkview.UIDelegate = self;
        _wkview.navigationDelegate = self;
        _wkview.scrollView.scrollEnabled = NO;
        [_wkview setAutoresizesSubviews:YES];
    }
    return _wkview;
}
#pragma mark - Getter

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = @"";//这里设置视频标题
//        _playerModel.videoURL         = self.videoURL;
//        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;
        //        _playerModel.resolutionDic = @{@"高清" : self.videoURL.absoluteString,
        //                                       @"标清" : self.videoURL.absoluteString};
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *    指定控制层(可自定义)
         *    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
        controlView.videoSlider.popUpViewColor = JHColor(94, 178, 48);
        [controlView.downLoadBtn setImage:[UIImage imageNamed:@"buttun_fenxiang"] forState:UIControlStateNormal];
        [controlView.backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        [_playerView playerControlView:controlView playerModel:self.playerModel];
        // 设置代理
        _playerView.delegate = self;
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = YES;
        // 打开预览图
        _playerView.hasPreviewView = YES;
        //        _playerView.forcePortrait = YES;
        /// 默认全屏播放
        //        _playerView.fullScreenPlay = YES;
        ZFPlayerShared.isStatusBarHidden = YES;
    }
    return _playerView;
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if (!detailBtn.selected) {
            return 0;
        }
    }else if (section ==1){
        return self.dataArray.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.dataDt) {
            NSString *  title = self.dataDt[@"title"];
            if ([title isKindOfClass:[NSString class]] && title.length) {
                LFLog(@"headerheight:%f",[title selfadapUifont:[UIFont fontWithName:@"Helvetica-Bold" size:15] weith:85].height);
                return [title selfadapUifont:[UIFont fontWithName:@"Helvetica-Bold" size:15] weith:85].height + 20;
            }
        }
    }
    if (section == 1 && !self.dataArray.count) {
        return 0.001;
    }
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        UILabel *titleLlb = [[UILabel alloc]init];
        titleLlb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        titleLlb.textColor = JHdeepColor;
        titleLlb.numberOfLines = 0;
        if (self.dataDt) {
            titleLlb.text = self.dataDt[@"title"];
        }
        [header addSubview:titleLlb];
        [titleLlb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(10);
            make.right.offset(-75);
        }];
        if (detailBtn == nil) {
            detailBtn = [[UIButton alloc]init];
            detailBtn.selected = YES;
            [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
            [detailBtn setTitle:@"详情" forState:UIControlStateSelected];
            [detailBtn setTitleColor:JHsimpleColor forState:UIControlStateNormal];
            [detailBtn setTitleColor:JHsimpleColor forState:UIControlStateSelected];
            detailBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [detailBtn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateSelected];
            [detailBtn setImage:[UIImage imageNamed:@"shangla"] forState:UIControlStateNormal];
            detailBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [detailBtn addSubview:detailBtn.titleLabel];
            [detailBtn.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.centerY.equalTo(detailBtn.mas_centerY);
            }];
            [detailBtn addSubview:detailBtn.imageView];
            [detailBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(0);
                make.centerY.equalTo(detailBtn.mas_centerY);
            }];
            [detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [header addSubview:detailBtn];
        [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.right.offset(-10);
            make.width.offset(60);
            make.height.offset(20);
        }];
    }else if (section ==1 && self.dataArray.count){
        UIImageView *headerIm = [[UIImageView alloc]init];
        headerIm.image = [UIImage imageNamed:@"jiangcaituijian"];
        [header addSubview:headerIm];
        [headerIm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(header.mas_centerX);
            make.centerY.equalTo(header.mas_centerY);
        }];
    }
    return header;
}
-(void)detailBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    [self.tableview reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 100;
    }
    return _webHeight;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        [cell.contentView addSubview:self.wkview];
        [self.wkview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.offset(0);
            make.left.bottom.offset(0);
        }];
        [self.wkview setNeedsLayout];
        return cell;
    }
    HealthEducateListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthEducatedetailCell"];
    NSDictionary *dt = self.dataArray[indexPath.row];
    [cell.picture sd_setImageWithURL:[NSURL URLWithString:dt[@"index_img"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cell.contentLb.text = dt[@"title"];
//    cell.sourceLb.text = [NSString stringWithFormat:@"%@        %@条评论",dt[@"author"],dt[@"comment_count"]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        HealthEducateDetailViewController *detail = [[HealthEducateDetailViewController alloc]init];
        detail.article_id = self.dataArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:detail animated:YES];
    }
}
#pragma mark UIWebViewDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [self presentLoadingTips];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self dismissTips];
    [webView ImageAdaptiveIphone:webView];
    [webView getImageUrlByJS:webView];
    
    [_wkview evaluateJavaScript:@"document.getElementById(\"testDiv\").offsetTop" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        LFLog(@"_wkview高度：%f",[result doubleValue]);
        _webHeight = [result doubleValue] + 30;
        [self.tableview reloadData];
//        CGRect frame = self.footview.frame;
//        frame.size.height = height  ;
//        self.footview.frame = frame;
//        _wkview.frame = CGRectMake(0, 0, SCREEN.size.width, [result doubleValue] + 30);
    }];
    
}
// 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    [webView showBigImage:navigationAction.request];
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - *************详情请求************
-(void)requestDetailData{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.article_id) {
        [dt setObject:self.article_id forKey:@"id"];
    }
    if (self.urlStr == nil) {
        self.urlStr = HealthEducateDetailUrl;
    }
    LFLog(@"详情请求dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,self.urlStr) params:dt success:^(id response) {
        LFLog(@"详情请求:%@",response);
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                self.dataDt = response[@"data"];
                if ([self.dataDt[@"video"] isKindOfClass:[NSDictionary class]] &&[self.dataDt[@"video"][@"video_url"] isKindOfClass:[NSString class]] && [self.dataDt[@"video"][@"video_url"] length]) {
//                    self.videoURL = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
                    self.playerModel.videoURL = [NSURL URLWithString:self.dataDt[@"video"][@"video_url"]];
                    _playerModel.placeholderImageURLString = self.dataDt[@"video"][@"video_img"];
                    [self.playerView autoPlayTheVideo];
//                     self.tableview.tableHeaderView = self.playerFatherView;
                    self.tableview.contentInset = UIEdgeInsetsMake(self.playerFatherView.height, 0, 0, 0);
                    [self.view addSubview:self.playerFatherView];
                    [self.navigationController setNavigationBarHidden:YES animated:YES];
                    [[UIApplication sharedApplication] setStatusBarHidden:YES];
                    self.navigationBarTitle = @"";
                }
                if ([self.dataDt[@"content"] isKindOfClass:[NSString class]] && [self.dataDt[@"content"] length]) {
                    [self.wkview loadHTMLString:[NSString stringWithFormat:@"<meta content=\"width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=0;\" name=\"viewport\" />%@<div id=\"testDiv\" style = \"height:100px; width:100px\"></div>",self.dataDt[@"content"]] baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
                }
                [self.dataArray removeAllObjects];
                if ([self.dataDt[@"today_hot"] isKindOfClass:[NSArray class]] ) {
                    for (NSDictionary *temDt in self.dataDt[@"today_hot"]) {
                        [self.dataArray addObject:temDt];
                    }
                }
            }
            [self.tableview reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    [self requestDetailData];
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"暂无数据"];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.dataDt && [self.dataDt[@"video_url"] isKindOfClass:[NSString class]] && [self.dataDt[@"video_url"] length]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationBarTitle = @"";
    }else{
        self.navigationBarTitle = @"详情";
    }
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && _playerView && self.isPlaying) {
        self.isPlaying = NO;
        _playerView.playerPushedOrPresented = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && _playerView && !_playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        //        [self.playerView pause];
        _playerView.playerPushedOrPresented = YES;
    }
}


@end
