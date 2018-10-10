//
//  HouserDetailViewController.m
//  shop
//
//  Created by 梁法亮 on 16/7/19.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "HouserDetailViewController.h"
#import "NSString+selfSize.h"
#import "UIImage+GIF.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "STPhotoBroswer.h"
#import <WebKit/WebKit.h>
@interface HouserDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)WKWebView *wkview;
@property(nonatomic,strong)UIView *footview;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong) STPhotoBroswer * brose;
@property(nonatomic,strong)NSArray *nameArr;
@property(nonatomic,strong)NSArray *nameKey;

@end

@implementation HouserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarTitle = @"房屋详情";
    self.nameArr = @[@"联系人：",@"联系电话：",@"联系地址："];
    self.nameKey = @[@"username",@"mobile",@"address"];
    self.navigationBarRightItem = [UIImage imageNamed:@"buttun_fenxiang"];
    __weak typeof(self) weakSelf = self;
    [self setRightBarBlock:^(UIBarButtonItem *sender) {
        if (weakSelf.dataArray.count) {
            [[ShareSingledelegate sharedShareSingledelegate] ShareContent:weakSelf.view content:weakSelf.dataArray[0][@"share"][@"title"] title:weakSelf.dataArray[0][@"share"][@"title"] url:weakSelf.dataArray[0][@"share"][@"url"] image:weakSelf.dataArray[0][@"share"][@"imgurl"]];
        }
    }];
    [self createFootview];
    [self createTableview];
    [self setupRefresh];
    [self requestdetailhouser];
    
}


-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(void)createFootview{
    
    if (_footview == nil) {
        _footview = [[UIView alloc]init];
    }
    if (self.dataArray.count > 0) {
        NSArray *dt = self.dataArray[0][@"imgurl"];
        UIImageView *picture = [self.view viewWithTag:30];
        if (dt.count > 0) {
            
            if (picture == nil) {
                picture = [[UIImageView alloc]init];
                picture.tag = 30;
                [_footview addSubview:picture];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageviewtap:)];
                [picture addGestureRecognizer:tap];
                picture.userInteractionEnabled = YES;
                [picture setContentScaleFactor:[[UIScreen mainScreen] scale]];
                picture.contentMode =  UIViewContentModeScaleAspectFill;
                picture.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                picture.clipsToBounds  = YES;
            }
            [picture mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.offset(15);
                make.left.offset(10);
                make.right.offset(-10);
                make.height.mas_equalTo(picture.mas_width).multipliedBy(0.5);
                
            }];
            [picture sd_setImageWithURL:[NSURL URLWithString:self.dataArray[0][@"imgurl"][0]] placeholderImage:[UIImage imageNamed:@""]];
            self.brose = [[STPhotoBroswer alloc]initWithImageArray:self.dataArray[0][@"imgurl"] currentIndex:0];
            NSArray *count = self.dataArray[0][@"imgurl"];
            UILabel *countlabel = [[UILabel alloc]init];
            countlabel.font = [UIFont systemFontOfSize:12];
            countlabel.text = [NSString stringWithFormat:@"共%d张",(int)count.count];
            [_footview addSubview:countlabel];
            [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-15);
                make.top.equalTo(picture.mas_bottom).offset(5);
                make.height.offset(14);
            }];
            UILabel *clicklabel = [self.view viewWithTag:32];
            if (clicklabel == nil) {
                clicklabel = [[UILabel alloc]init];
                clicklabel.tag = 32;
                clicklabel.font = [UIFont systemFontOfSize:12];
                clicklabel.text = [NSString stringWithFormat:@"点击查看更多"];
                [_footview addSubview:clicklabel];
                [clicklabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(15);
                    make.top.equalTo(picture.mas_bottom).offset(-15);
                    make.height.offset(14);
                }];
            }
            
        }
        
        
        if (self.wkview == nil) {
            WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
            // 自适应屏幕宽度js
            NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
            WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
            // 添加自适应屏幕宽度js调用的方法
            WKUserContentController *wkUController = [[WKUserContentController alloc]init];
            [wkUController addUserScript:wkUserScript];
            self.wkview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) configuration:wkWebConfig];
            self.wkview.scrollView.delegate = self;
            self.wkview.UIDelegate = self;
            self.wkview.navigationDelegate = self;
            [self.wkview setAutoresizesSubviews:YES];
            
            
        }
        
        if (picture) {
            self.wkview.frame = CGRectMake(0, (SCREEN.size.width -20)/2  + 20, SCREEN.size.width,  SCREEN.size.height);
        }else{
            self.wkview.frame = CGRectMake(0, 20, SCREEN.size.width, SCREEN.size.height);
            
        }
        [_footview addSubview:self.wkview];
        if (![self.dataArray[0][@"content"] isKindOfClass:[NSNull class]]) {
            [self.wkview loadHTMLString:self.dataArray[0][@"content"] baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        }else{
            self.wkview.frame = CGRectMake(0, 20, 0, 0);
        }
        
        
        
        //        UILabel *_contentLabel = [self.view viewWithTag:33];
        //        if (_contentLabel == nil) {
        //            _contentLabel = [[UILabel alloc]init];
        //            _contentLabel.numberOfLines = 0;
        //            _contentLabel.tag = 33;
        //            _contentLabel.font = [UIFont systemFontOfSize:14];
        //            _contentLabel.textColor = JHColor(51, 51, 51);
        //
        //        }
        //
        //        _contentLabel.text = self.dataArray[0][@"content"];
        //
        //        [_contentLabel NSParagraphStyleAttributeName:20];
        //        CGSize contentsize = [_contentLabel.text selfadap:14 weith:30 Linespace:20];
        //        [_footview addSubview:_contentLabel];
        //
        //        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        //            if (picture) {
        //                make.top.equalTo(picture.mas_bottom).offset(20);
        //            }else{
        //                make.top.offset(20);
        //
        //            }
        //            make.left.offset(15);
        //            make.right.offset(-15 );
        //
        //            make.height.offset(contentsize.height + 35);
        //
        //        }];
        
    }
    
}

-(void)createTableview{
    
    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height + 50)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        if (self.dataArray.count > 0) {
            NSDictionary *dt = self.dataArray[0];
            CGSize size = [dt[@"title"] selfadap:15 weith:20];
            return size.height + 20 + 35;
        }
        return 65;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (self.dataArray.count > 0) {
        
        NSDictionary *dt = self.dataArray[0];
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titlelabel = [self.view viewWithTag:11];
            if (titlelabel == nil) {
                titlelabel = [[UILabel alloc]init];
                titlelabel.tag = 11;
                titlelabel.textColor = JHColor(51, 51, 51);
                titlelabel.font = [UIFont systemFontOfSize:15];
                
            }
            titlelabel.text = dt[@"title"];
            [cell.contentView addSubview:titlelabel];
            titlelabel.numberOfLines = 0;
            [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.right.offset(-10);
                make.top.offset(10);
                make.height.offset([titlelabel.text selfadap:15 weith:20].height + 15);
            }];
            
            UILabel *timelabel = [self.view viewWithTag:12];
            if (timelabel == nil) {
                timelabel = [[UILabel alloc]init];
                timelabel.tag = 12;
                timelabel.textColor = JHColor(151, 151, 151);
                timelabel.font = [UIFont systemFontOfSize:15];
                
            }
            timelabel.text = dt[@"add_time"];
            [cell.contentView addSubview:timelabel];
            [timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.top.equalTo(titlelabel.mas_bottom).offset(5);
                make.height.offset(21);
            }];
            
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellname"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellname"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView removeAllSubviews];
            CGSize lbsize = [self.nameArr[indexPath.row - 1] selfadaption:15];
            UILabel *label = [[UILabel alloc]init];
            label.textColor = JHColor(53, 53, 53);
            label.font = [UIFont systemFontOfSize:15];
            label.text = self.nameArr[indexPath.row - 1];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.offset(10);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.width.offset(lbsize.width + 5);
                
            }];
            UILabel *objclabel = [[UILabel alloc]init];
            objclabel.textColor = JHColor(102, 102, 102);
            objclabel.font = [UIFont systemFontOfSize:13];
            objclabel.numberOfLines = 0;
            if ([[dt objectForKey:self.nameKey[indexPath.row - 1]] isKindOfClass:[NSString class]]) {
                objclabel.text = [dt objectForKey:self.nameKey[indexPath.row - 1]];
            }else if ([[dt objectForKey:self.nameKey[indexPath.row - 1]] isKindOfClass:[NSNull class]]){
                objclabel.text = @"无";
            }
            
            [cell.contentView addSubview:objclabel];
            [objclabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(label.mas_right).offset(0);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.offset(-10);
                
            }];
            
            return cell;
            
        }
        
    }
    return cell;
}
-(NSMutableAttributedString *)AttributedString:(NSString *)allstr attstring:(NSString *)attstring{
    NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:allstr];
    NSString *str = attstring;
    NSRange range =[[htinstr string]rangeOfString:str];
    [htinstr addAttribute:NSForegroundColorAttributeName value:JHColor(102, 102, 102) range:range];
    [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    return htinstr;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        NSString *phone = self.dataArray[0][@"mobile"];
        NSLog(@"打电话");
        if (phone != nil)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phone]]];
        }
    }
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footview = [[UIView alloc]init];
    
    return footview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.001;
    
}
//图片点击事件
-(void)imageviewtap:(UITapGestureRecognizer *)tap{
    
    LFLog(@"点击图片");
    
    [_brose show];
    
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
        CGRect wkframe = _wkview.frame;
        wkframe.size.height = height;
        _wkview.frame = wkframe;

        NSArray *dt = self.dataArray[0][@"imgurl"];
        if (dt.count > 0) {
            _footview.frame = CGRectMake(0, 0, SCREEN.size.width, height +  (SCREEN.size.width -20)/2  + 20);
        }else{
            _footview.frame = CGRectMake(0, 0, SCREEN.size.width, height + 20);
        }
        
        self.tableview.tableFooterView = self.footview;
    }];
    
    
}
#pragma mark - *************详情请求*************
-(void)requestdetailhouser{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.detailid) {
        [dt setObject:self.detailid forKey:@"id"];
    }
    LFLog(@"社区活动dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,self.isBusiness ? BusinessRentDetailBUrl : HouseRentingDetailUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            LFLog(@"获取成功%@",response);
            [self.dataArray removeAllObjects];
            
            [self.dataArray addObject:response[@"data"]];
            [self createFootview];
            [self.tableview reloadData];
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self requestdetailhouser];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        [_tableview.mj_header endRefreshing]; 
    }];
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestdetailhouser];
    }];
}

@end
