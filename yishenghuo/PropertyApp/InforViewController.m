//
//  InforViewController.m
//  shop
//
//  Created by wwzs on 16/4/20.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "InforViewController.h"
#import <WebKit/WebKit.h>
#import "UIButton+WebCache.h"
#import "STPhotoBroswer.h"
@interface InforViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *todayArray;
@property(nonatomic,strong)WKWebView *wkview;
@property(nonatomic,strong)UIView *footview;

@end

@implementation InforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"详情";
    self.navigationBarRightItem = [UIImage imageNamed:@"buttun_fenxiang"];
    __weak typeof(self) weakSelf = self;
    [self setRightBarBlock:^(UIBarButtonItem *sender) {
        if (weakSelf.dataArray.count) {
            [[ShareSingledelegate sharedShareSingledelegate] ShareContent:weakSelf.view content:weakSelf.dataArray[0][@"share"][@"title"] title:weakSelf.dataArray[0][@"share"][@"title"] url:weakSelf.dataArray[0][@"share"][@"url"] image:weakSelf.dataArray[0][@"share"][@"imgurl"]];
        }
    }];
    [self createUI];
}
-(void)createUI{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height )style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    //    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PeripheralBusinessDetailViewController"];
    
    
    self.footview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - ((SCREEN.size.width - 20) * 12/23 + 160))];
    //    self.tableview.tableFooterView = self.footview;
    self.footview.backgroundColor =[UIColor whiteColor];
    [self requestData];
    [self setupRefresh];
}
-(NSMutableArray *)todayArray{
    
    if (_todayArray == nil) {
        _todayArray = [[NSMutableArray alloc]init];
    }
    
    return _todayArray;
    
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeripheralBusinessDetailViewController"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PeripheralBusinessDetailViewController"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
        return cell;
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}

#pragma mark - *************请求数据*************
-(void)requestData{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.detailid,@"id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *url = HomeInformationDetailUrl;
    if (self.type == InfoStyleWenZhang) url = MedicalLectureDetailUrl;
    if (self.type == InfoStyleYiLiao) url = MedicalInfoDetailUrl;
    if (self.type == InfoStyleShangYe) url = BusinessInfoDetailUrl;
    if (self.type == InfoStyleSanJin) url = GoldenInfoDetailUrl;
    if (self.type == InfoStyleYouJiao) url = PreschoolInfoDetailUrl;
    LFLog(@"资讯详情dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        LFLog(@"资讯详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (![response[@"note"] isKindOfClass:[NSString class]]) {
                [self.dataArray removeAllObjects];
                if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                    [self.dataArray addObject:response[@"data"]];
                }
                if (self.wkview == nil) {
                    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
                    // 自适应屏幕宽度js
                    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
                    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
                    // 添加自适应屏幕宽度js调用的方法
                    WKUserContentController *wkUController = [[WKUserContentController alloc]init];
                    [wkUController addUserScript:wkUserScript];
                    self.wkview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, self.footview.height) configuration:wkWebConfig];
                    self.wkview.scrollView.delegate = self;
                    self.wkview.UIDelegate = self;
                    self.wkview.navigationDelegate = self;
                    [self.wkview setAutoresizesSubviews:YES];
                    [self.footview addSubview:self.wkview];
                }
                NSArray *hotArr = response[@"data"][@"today_hot"];
                if (lArrayIsEmpty(hotArr)) {
                    for (NSDictionary *dt in response[@"data"][@"today_hot"]) {
                        [self.todayArray addObject:dt];
                    }
                }
                

                [self.wkview loadHTMLString:self.dataArray[0][@"content"] baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
                
                if (self.dataArray.count) {
                    [self createheaerview];
                    [self.tableview reloadData];
                    
                }else{
                    [self createFootview];
                    [self presentLoadingTips:@"暂无数据~~~"];
                }
                
            }else{
                
                
                
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self requestData];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self presentLoadingTips:@"暂无数据"];
        [self createFootview];
        [_tableview.mj_header endRefreshing];
    }];
    
}

-(void)createheaerview{
    
    if (self.dataArray.count) {
        NSDictionary *dt = self.dataArray[0];
        CGSize size = [dt[@"title"] selfadap:15 weith:20];
        UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, size.height + 60)];
        backview.backgroundColor =JHbgColor;
        UIView *header = [[UIView alloc]init];
        [backview addSubview:header];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(-1);
        }];
        header.backgroundColor =[UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = JHdeepColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = dt[@"title"];
        titleLabel.numberOfLines = 0;
        [header addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.left.offset(10);
            make.right.offset(-10);
            make.height.offset(size.height + 15);
        }];
        
        UILabel *countLabel = [[UILabel alloc]init];
        countLabel.font = [UIFont systemFontOfSize:13];
        countLabel.textColor = JHmiddleColor;
        countLabel.textAlignment = NSTextAlignmentRight;
        countLabel.text = [NSString stringWithFormat:@"阅读%@ 分享%@ %@ ",dt[@"read_count"],dt[@"share_count"],dt[@"add_time"]];
        [header addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
            make.right.offset(-10);
            make.width.offset([countLabel.text selfadap:14 weith:20].width + 10);
            make.height.offset(20);
        }];
        
        UILabel *authorLabel = [[UILabel alloc]init];
        authorLabel.font = [UIFont systemFontOfSize:13];
        authorLabel.textColor = JHmiddleColor;
        authorLabel.text = dt[@"author"];
        [header addSubview:authorLabel];
        [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(countLabel.mas_centerY);
            make.left.offset(10);
            make.height.equalTo(countLabel.mas_height);
            make.right.equalTo(countLabel.mas_left).offset(0);
        }];
        NSArray *imarr = dt[@"imgurl"];
        if (imarr.count) {
            UIButton *imageview = [[UIButton alloc]init];
            [imageview setImage:[UIImage imageNamed:@"placeholderImage"] forState:UIControlStateNormal];
            
            [header addSubview:imageview];
            [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(countLabel.mas_bottom).offset(10);
                make.left.offset(10);
                make.width.offset(SCREEN.size.width - 20);
                make.height.offset((SCREEN.size.width - 20) *12/23);
            }];
            imageview.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageview addTarget:self action:@selector(imageBtnclick:) forControlEvents:UIControlEventTouchUpInside];
            [imageview sd_setImageWithURL:[NSURL URLWithString:dt[@"imgurl"][0]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            UILabel *countLabel = [[UILabel alloc]init];
            countLabel.font = [UIFont systemFontOfSize:13];
            countLabel.textColor = JHdeepColor;
            [header addSubview:countLabel];
            [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageview.mas_bottom).offset(0);
                make.right.offset(-10);
                
            }];
            
            if (imarr.count) {
                countLabel.text = [NSString stringWithFormat:@"共%lu张",(unsigned long)imarr.count];
            }
            
            backview.frame = CGRectMake(0, 0, SCREEN.size.width, size.height + 90 + (SCREEN.size.width - 20) *12/23);
            
        }
        
        self.tableview.tableHeaderView = backview;
        self.footview.frame = CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - backview.height - 20);
        self.wkview.frame = self.footview.frame;
    }
    
    
}
-(void)imageBtnclick:(UIButton *)btn{
    
    STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:self.dataArray[0][@"imgurl"] currentIndex:0];
    [broser show];
    
}
#pragma mark UIWebViewDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [self presentLoadingTips];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self dismissTips];

   [webView ImageAdaptiveIphone:webView];
    [_wkview evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        LFLog(@"_wkview高度：%f",[result doubleValue]);
        double height = [result doubleValue] + 30;
        if (self.todayArray.count) {
            height += self.todayArray.count * 100  + 80;
        }
        CGRect frame = self.footview.frame;
        frame.size.height = height  ;
        self.footview.frame = frame;
        _wkview.frame = CGRectMake(0, 0, SCREEN.size.width, [result doubleValue] + 30);
        self.tableview.tableFooterView = self.footview;
    }];
    
    
    
}

// 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    
}

@end
