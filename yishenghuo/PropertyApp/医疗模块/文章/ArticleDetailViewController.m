//
//  ArticleDetailViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/5/2.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ArticleDetailTableViewCell.h"
#import "FooterInputView.h"
#import <WebKit/WebKit.h>
#import "ArticleCommentListViewController.h"
#import "AritcleModel.h"
@interface ArticleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong)FooterInputView *footerTf;
@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)UIView *header;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSDictionary *dataDt;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
@property(nonatomic,strong)WKWebView *wkview;
@property (nonatomic, assign) CGFloat webHeight;//webview高度
@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"详情";
    self.page = 1;
    self.more = @"1";
    _webHeight = 0.001;
    [self createUI];
}
-(void)createUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - 50)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerNib:[UINib nibWithNibName:@"ArticleDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"ArticleDetailTableViewCell"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"wkwebCell"];
    [self.view addSubview:self.footerTf];
    [self requestDataDeatil];
//    [self requestData:1];
    [self setupRefresh];
    
}
-(FooterInputView *)footerTf{
    if (_footerTf == nil) {
        _footerTf = [[FooterInputView alloc]initWithFrame:CGRectMake(0, screenH - 50, screenW, 50)];
        _footerTf.tf.backgroundColor = JHbgColor;
        _footerTf.tf.layer.cornerRadius = 15;
        _footerTf.tf.layer.masksToBounds = YES;
        _footerTf.tf.placeholder = @"   写评论";
        NSArray *imnameArr =  @[@"buttun_fenxiang",@"shoucang_yiliao",@"dianzan_yiliao"];
        NSArray *imnameSelectArr =  @[@"buttun_fenxiang",@"shoucangxuanzhong_yiliao",@"dianzanxuanzhong_yiliao"];
        for (int i = 0; i < 3; i ++) {
            IndexBtn *btn = [[IndexBtn alloc]init];
            btn.index = i;
            [btn setImage:[UIImage imageNamed:imnameArr[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:imnameSelectArr[i]] forState:UIControlStateSelected];
            btn.frame = CGRectMake(0, 0, btn.imageView.image.size.width, btn.imageView.image.size.height);
            btn.section = btn.width;
            [btn addTarget:self action:@selector(shareBtnclick:) forControlEvents:UIControlEventTouchUpInside];
            [_footerTf.btnArr addObject:btn];
        }
        IndexBtn *btn = [[IndexBtn alloc]init];
        [btn setTitle:@"发送" forState:UIControlStateNormal];
        [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 40, btn.imageView.image.size.height);
        btn.section = btn.width;
        [btn addTarget:self action:@selector(sendBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        [_footerTf.btnSelectArr addObject:btn];
    }
    return _footerTf;
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(UIView *)header{
    if (_header == nil) {
        _header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 0)];
    }
    return _header;
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
#pragma mark 分享
-(void)shareBtnclick:(IndexBtn *)btn{
    LFLog(@"分享");
    if (btn.index == 2) {
        [self addlike:nil index:0];
    }else if (btn.index == 1 ){
        [self addCollection];
    }else{
        
    }
}
#pragma mark 发送
-(void)sendBtnclick:(UIButton *)btn{
    LFLog(@"发送");
    if (self.dataDt) {
        if (self.footerTf.tf.text.length) {
            [self addComment:self.footerTf.tf.text];
        }else{
            [self presentLoadingTips:@"请输入评论内容！"];
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
       AritcleModel *model =self.dataArray[indexPath.row];
        NSString * contentLb = model.content;
        NSArray *sublevelArr = model.sublevel;
        if (sublevelArr && sublevelArr.count) {
            NSMutableArray *conArr = [[NSMutableArray alloc]init];
            int i =0 ;
            for (NSDictionary *subDt in sublevelArr) {
                NSString *user_name = subDt[@"user_name"];
                NSString *user_name2 = subDt[@"user_name2"];
                NSString *temstr = nil;
                if (user_name2 && user_name2.length) {
                    temstr = [NSString stringWithFormat:@"%@ 回复 %@%@",user_name,user_name2,subDt[@"content"]];
                }else{
                    temstr = [NSString stringWithFormat:@"%@：%@",user_name,subDt[@"content"]];
                }
                [conArr addObject:temstr];
                if (i > 3) {
                    break;
                }
                i ++;
            }
            NSMutableString *mstr = [NSMutableString string];
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray *textArr = [NSMutableArray array];
            for (int i = 0; i < conArr.count; i ++) {
                [arr addObject:[NSNumber numberWithInteger:mstr.length]];
                NSString *str = conArr[i];
                NSRange ran = [str getTwoTextRangeWith:[UIFont systemFontOfSize:15] width:80 height:40];
                NSString *text = nil;
                if (ran.length < str.length) {
                    ran.length = ran.length - 3;
                    text = [NSString stringWithFormat:@"%@...",[str substringWithRange:ran]];
                }else{
                    text = str;
                }
                [mstr appendString:text];
                if (i < conArr.count) {
                    [mstr appendString:@"\n"];
                }
                [textArr addObject:text];
            }
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:mstr];
            text.yy_lineSpacing = 5;
            return 135 + ((sublevelArr.count > 4) ? 30 :0) + [contentLb selfadap:15 weith:70].height + [text selfadaption:80].height;//
        }
        return 125  + [contentLb selfadap:15 weith:70].height;//
    }
    return _webHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wkwebCell"];
        [cell.contentView addSubview:self.wkview];
        [self.wkview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.offset(0);
            make.left.bottom.offset(0);
        }];
        [self.wkview setNeedsLayout];
        return cell;
    }
    ArticleDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleDetailTableViewCell"];
    AritcleModel *model =self.dataArray[indexPath.row];
    cell.armodel = model;
    __weak typeof(self) weakSelf = self;
    [cell setLikeblock:^{
        [weakSelf addlike:model.id index:indexPath.row];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleCommentListViewController *detail = [[ArticleCommentListViewController alloc]init];
    AritcleModel *model = self.dataArray[indexPath.row];
    detail.comment_id = model.id;
    if (self.dataDt && self.dataDt[@"id"]) {
        detail.article_id = self.dataDt[@"id"];
    }
    [self.navigationController pushViewController:detail animated:YES];
    
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

//#pragma mark textfileddelegate
//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self.footerTf removeAllview];
//    UIButton *btn = [[UIButton alloc]init];
//    [btn setTitle:@"发送" forState:UIControlStateNormal];
//    [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
//    btn.frame = CGRectMake(0, 0, 40, btn.imageView.image.size.height);
//    [self.footerTf.btnArr addObject:btn];
//    [self.footerTf layoutSubviews];
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    [self.footerTf removeAllview];
//    for (int i = 0; i < 2; i ++) {
//        UIButton *btn = [[UIButton alloc]init];
//        [btn setImage:[UIImage imageNamed:@"buttun_fenxiang"] forState:UIControlStateNormal];
//        btn.frame = CGRectMake(0, 0, btn.imageView.image.size.width, btn.imageView.image.size.height);
//        [self.footerTf.btnArr addObject:btn];
//    }
//    [self.footerTf layoutSubviews];
//}

#pragma mark - *************详情接口*************
-(void)requestDataDeatil{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }

    if (self.articleId) {
        [dt setObject:self.articleId forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PregnantRecommendArticleDetailUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                self.dataDt = response[@"data"];
                if ([response[@"data"][@"content"] isKindOfClass:[NSString class]] && [response[@"data"][@"content"] length]) {
                    [self.wkview loadHTMLString:[NSString stringWithFormat:@"<meta content=\"width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=0;\" name=\"viewport\" />%@<div id=\"testDiv\" style = \"height:100px; width:100px\"></div>",response[@"data"][@"content"]] baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
                }
                NSString *title = self.dataDt[@"title"];
                if (title && title.length) {
                    [self.header removeAllSubviews];
                    CGSize titlesize = [title selfadap:15 weith:20 Linespace:10];
                    UILabel *namelb = [UILabel initialization:CGRectMake(10, 10, screenW - 20, titlesize.height + 10) font:[UIFont systemFontOfSize:15] textcolor:JHdeepColor numberOfLines:0 textAlignment:0];
                    namelb.text = title;
                    [namelb NSParagraphStyleAttributeName:10];
                    [self.header addSubview:namelb];
                    UILabel *timeLb = [UILabel initialization:CGRectMake(10, namelb.height + 10, screenW - 20, 20) font:[UIFont systemFontOfSize:13] textcolor:JHsimpleColor numberOfLines:0 textAlignment:0];
                    timeLb.text = self.dataDt[@"add_time"];
                    [self.header addSubview:timeLb];
                    self.header.height = timeLb.y + timeLb.height;
                    self.tableview.tableHeaderView = self.header;
                }
                self.page = 1;
                self.more = @"1";
                [self requestData:1];
                [self.tableview reloadData];
                for (IndexBtn *btn in self.footerTf.btnArr) {
                    if (btn.index == 2) {
                        if ([[NSString stringWithFormat:@"%@",self.dataDt[@"is_agree"]] isEqualToString:@"1" ]) {
                            btn.selected = YES;
                        }else{
                            btn.selected = NO;
                        }
                    }else if (btn.index == 1) {
                        if ([[NSString stringWithFormat:@"%@",self.dataDt[@"is_collection"]] isEqualToString:@"1" ]) {
                            btn.selected = YES;
                        }else{
                            btn.selected = NO;
                        }
                    }
                }
            }else{
                [self presentLoadingTips:@"暂无数据！"];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self requestDataDeatil];
                    }

                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"请求失败！"];
        [_tableview.mj_footer endRefreshing];
        [_tableview.mj_header endRefreshing];
    }];
}
#pragma mark - *************添加评论*************
-(void)addComment:(NSString *)content{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
//    if (self.articleId) {
//        [dt setObject:self.articleId forKey:@"parent_id"];
//    }
    if (content) {
        [dt setObject:content forKey:@"content"];
    }
    if (self.dataDt && self.dataDt[@"id"]) {
        [dt setObject:self.dataDt[@"id"] forKey:@"article_id"];
    }
    [dt setObject:@"1" forKey:@"comment_type"];//1：孕妇建档文章评论
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ArticleAddCommentUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"健康教育列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"评论成功！"];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                    }

                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"请求失败！"];
    }];
}
#pragma mark - *************评论接口*************
-(void)requestData:(NSInteger )pagenum{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"评论列表dt:%@",dt);
    if (pagenum == 1) {
        [self.dataArray removeAllObjects];
    }
    if (self.dataDt && self.dataDt[@"id"]) {
        [dt setObject:self.dataDt[@"id"] forKey:@"article_id"];
    }
    [dt setObject:@"1" forKey:@"comment_type"];//1：孕妇建档文章评论
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ArticleCommentListUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"评论列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *temdt in response[@"data"]) {
                    AritcleModel *model = [[AritcleModel alloc]initWithDictionary:temdt error:nil];
                    [self.dataArray addObject:model];
                }
                [self.tableview reloadData];
                self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            }else{
                [self presentLoadingTips:@"数据格式错误！"];
            }
        }else{
            //            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            //            if ([error_code isEqualToString:@"100"]) {
            //                [self showLogin:^(id response) {
            //                    if ([response isEqualToString:@"1"]) {
            //                        self.page = 1;
            //                        self.more = @"1";
            //                        [self requestData:self.page];
            //                    }
            //
            //                }];
            //            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"请求失败！"];
        [_tableview.mj_footer endRefreshing];
        [_tableview.mj_header endRefreshing];
    }];
    
}

#pragma mark - *************点赞*************
-(void)addlike:(NSString *)comment_id index:(NSInteger )index{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (comment_id) {
        [dt setObject:session forKey:@"comment_id"];
    }
    if (self.dataDt && self.dataDt[@"id"]) {
        [dt setObject:self.dataDt[@"id"] forKey:@"article_id"];
    }
    [dt setObject:@"1" forKey:@"comment_type"];//1：孕妇建档文章评论
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ArticleAddLikeUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"健康教育列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            BOOL isLike = YES;
            if (comment_id) {
                AritcleModel *model = self.dataArray[index];
                if ([model.is_agree isEqualToString:@"1"]) {
                    model.is_agree = @"0";
                    isLike = NO;
                }else{
                    model.is_agree = @"1";
                }
                [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                if (self.footerTf.btnArr.count > 2) {
                    IndexBtn *btn = self.footerTf.btnArr[2];
                    
                    btn.selected = !btn.selected;
                    isLike = btn.selected;
                }
            }
            if (isLike) {
                [self presentLoadingTips:@"点赞成功！"];
            }else{
                [self presentLoadingTips:@"取消点赞！"];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self addlike:nil index:0];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"请求失败！"];
    }];
}
#pragma mark - *************收藏*************
-(void)addCollection
{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.dataDt && self.dataDt[@"id"]) {
        [dt setObject:self.dataDt[@"id"] forKey:@"col_id"];
    }
    [dt setObject:@"1" forKey:@"comment_type"];//1：孕妇建档文章评论
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ArticleAddCollectionUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"收藏:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"收藏成功！"];
            if (self.footerTf.btnArr.count > 1) {
                IndexBtn *btn = self.footerTf.btnArr[1];
                btn.selected = YES;
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self addCollection];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"请求失败！"];
    }];
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self requestData:1];
    }];
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多数据了"];
            [self.tableview.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self requestData:self.page];
        }
        
    }];
}


@end
