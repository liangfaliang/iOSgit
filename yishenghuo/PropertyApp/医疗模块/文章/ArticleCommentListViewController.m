//
//  ArticleCommentListViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/5/3.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ArticleCommentListViewController.h"
#import "ArticleDetailTableViewCell.h"
#import "FooterInputView.h"
#import "AritcleModel.h"
@interface ArticleCommentListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)FooterInputView *footerTf;
@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;

@end

@implementation ArticleCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"详情";
    self.page = 1;
    self.more = @"1";
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
    [self requestData:1];
    [self setupRefresh];
    
    self.footerTf = [[FooterInputView alloc]initWithFrame:CGRectMake(0, screenH - 50, screenW, 50)];
    self.footerTf.tf.backgroundColor = JHbgColor;
    self.footerTf.tf.layer.cornerRadius = 15;
    self.footerTf.tf.layer.masksToBounds = YES;
    self.footerTf.tf.placeholder = @"   写评论";
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 40, btn.imageView.image.size.height);
    [btn addTarget:self action:@selector(sendBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerTf.btnSelectArr addObject:btn];
    [self.view addSubview:self.footerTf];
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}

#pragma mark 分享
-(void)shareBtnclick:(IndexBtn *)btn{
    LFLog(@"分享");
}
#pragma mark 发送
-(void)sendBtnclick:(UIButton *)btn{
    LFLog(@"发送");
    if (self.dataArray.count) {
        if (self.footerTf.tf.text.length) {
            [self addComment:self.footerTf.tf.text];
        }else{
            [self presentLoadingTips:@"请输入评论内容！"];
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AritcleModel *model =self.dataArray[indexPath.section];
    NSString * contentLb = model.content;
    return 125  + [contentLb selfadap:15 weith:70].height;//
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleDetailTableViewCell"];
    AritcleModel *model =self.dataArray[indexPath.section];
    cell.armodel = model;
    cell.conviewbottom.constant = 0;
    cell.reView.hidden = YES;
    if (indexPath.section == 0) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }else{
        cell.contentView.backgroundColor = JHbgColor;
    }
    __weak typeof(self) weakSelf = self;
    [cell setLikeblock:^{
        [weakSelf addlike:model.id index:indexPath.section];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    AritcleModel *model =self.dataArray[indexPath.section];
//    [self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    self.footerTf.tf.placeholder = [NSString stringWithFormat:@"@%@",model.user_name];
//    [self.footerTf.tf becomeFirstResponder];
}


#pragma mark - *************列表*************
-(void)requestData:(NSInteger )pagenum{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"健康教育列表dt:%@",dt);
    if (pagenum == 1) {
        [self.dataArray removeAllObjects];
    }
    if (self.comment_id) {
        [dt setObject:self.comment_id forKey:@"comment_id"];
    }
    [dt setObject:@"1" forKey:@"comment_type"];//1：孕妇建档文章评论
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ArticleCommentDetailUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"健康教育列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *temdt in response[@"data"]) {
                    AritcleModel *model = [[AritcleModel alloc]initWithDictionary:temdt error:nil];
                    if (!self.dataArray.count) {
                        self.footerTf.tf.placeholder = [NSString stringWithFormat:@"@%@",model.user_name];
                    }
                    [self.dataArray addObject:model];
                }
                [self.tableview reloadData];
                self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            }else{
                [self presentLoadingTips:@"数据格式错误！"];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        self.page = 1;
                        self.more = @"1";
                        [self requestData:self.page];
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
    if (self.dataArray.count) {
        AritcleModel *model = self.dataArray[0];
        [dt setObject:model.id forKey:@"parent_id"];
    }
    if (content) {
        [dt setObject:content forKey:@"content"];
    }

    if (self.article_id) {
        [dt setObject:self.article_id forKey:@"article_id"];
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
    if (self.article_id) {
        [dt setObject:self.article_id forKey:@"article_id"];
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
                [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
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

