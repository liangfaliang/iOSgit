//
//  CommentListViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/11/23.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CommentListViewController.h"
#import "PBusyModel.h"
#import "CommentListTableViewCell.h"
#import "IndexBtn.h"
@interface CommentListViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView *headerview;

@property(nonatomic,strong)IndexBtn * selectBtn;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
@end
@implementation CommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBarTitle = @"全部评论";
    self.page = 1;
    self.more = @"1";
    [self createTableview];
    if (!self.ws_worker) {
        [self commentUploadData:self.page];
        [self commentUploadStatistical];
    }

}
-(NSMutableArray *)commentArr{
    if (!_commentArr) {
        _commentArr = [NSMutableArray array];
    }
    return _commentArr;
}
-(void)createHeaderview{
    _headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, 50)];
    _headerview.backgroundColor = [UIColor whiteColor];
    NSArray *keyArr = @[@"all_count",@"good_count",@"bad_count",@"img_count"];
    NSArray *nameArr = @[@"全部",@"好评",@"差评",@"带图"];
    for (int i = 0; i < 4; i ++) {
        IndexBtn *button = [[IndexBtn alloc]initWithFrame:CGRectMake(0, 0, (SCREEN.size.width-20)/4 - 10, 25)];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        if (self.countDt[keyArr[i]]) {
            NSInteger count = [self.countDt[keyArr[i]] integerValue];
            NSString *countStr = @"";
            if (count > 0) {
                countStr = [NSString stringWithFormat:@"(%ld)",(long)count];
            }
            [button setTitle:[NSString stringWithFormat:@"%@%@",nameArr[i],countStr] forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:JHdeepColor forState:UIControlStateNormal];
        [button setTitleColor:JHAssistColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(btnListClick:) forControlEvents:UIControlEventTouchUpInside];
        button.index =  i;
        button.layer.borderColor = [JHdeepColor CGColor];
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 3;
        if (i == 0) {
            button.layer.borderColor = [JHAssistColor CGColor];
            button.selected = YES;
            self.selectBtn = button;
        }
        button.center = CGPointMake(10 +  (SCREEN.size.width-20)/8 + i * (SCREEN.size.width-20)/4 , 25);
        [_headerview addSubview:button];
        
    }
    [self.view addSubview: _headerview];
}
-(void)btnListClick:(IndexBtn *)btn{
    self.selectBtn.selected = NO;
    self.selectBtn.layer.borderColor = [JHdeepColor CGColor];
    btn.selected = YES;
    btn.layer.borderColor = [JHAssistColor CGColor];
    self.selectBtn = btn;
    self.page = 1;
    [self commentUploadData:self.page];
    
}
-(void)createTableview{
 
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.ws_worker ? 64 :114, SCREEN.size.width, SCREEN.size.height -(self.ws_worker ? 64 :114) ) style:UITableViewStylePlain];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentListTableViewCell" bundle:nil] forCellReuseIdentifier:@"commentlistCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"confirmCell"];
    [self setupRefresh];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.commentArr.count) {
        PBusyModel *mo = self.commentArr[indexPath.row];
        CGSize h = [mo.content selfadap:14 weith:70];
        CGFloat HH = h.height + 10;
        if (HH > 105) {
            HH = 105;
        }
        if (mo.imgurl.count) {
            CGFloat imgWidth = (SCREEN.size.width - 90)/3 + 10;
            return HH + 110 + imgWidth;
        }else{
            return HH + 110;
        }
    }
    return SCREEN.size.height - 114;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentlistCell"];
    if (self.ws_worker) {
        cell.likeBtn.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.pbmodel = self.commentArr[indexPath.row];
    cell.contentLbLeft.constant = 60;
    CGSize h = [cell.pbmodel.content selfadap:14 weith:50];
    CGFloat HH = h.height + 10;
    if (HH > 105) {
        HH = 105;
    }
    cell.contentLbHeight.constant = HH;
    __weak typeof(cell) weakcell = cell;
    [cell setLikeblock:^(UIButton *sender) {
        [self upDataforpraise:weakcell.pbmodel.comment_id index:indexPath.row cell:weakcell];
    }];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark - *************评论列表*************
-(void)commentUploadData:(NSInteger )pagenum{
    [self presentLoadingTips];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.detailid,@"id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    if (self.selectBtn.index == 1) {
        [dt setObject:@"1" forKey:@"rank"];
    }else if (self.selectBtn.index == 2) {
        [dt setObject:@"2" forKey:@"rank"];
    }else if (self.selectBtn.index == 3) {
        [dt setObject:@"1" forKey:@"is_img"];
    }
    LFLog(@"评论列表dt:%@",dt);
    if (pagenum == 1) {
        [self.commentArr removeAllObjects];
    }
    NSString *url = PBusyCommentListUrl;
    if (self.isCarnival) {
        url = CarnivalCommentListUrl;
    }

    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@"评论列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]]; 
            for (NSDictionary *comDt in response[@"data"]) {
                PBusyModel *model= [[PBusyModel alloc]initWithDictionary:comDt error:nil];
                [self.commentArr addObject:model];
            }
           
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
         [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark 点赞数据请求
-(void)upDataforpraise:(NSString *)articleid index:(NSInteger)index cell:(CommentListTableViewCell *)cell{
    
    if ( NO == [UserModel online] )
    {
        
        [self showLogin:nil];
        return;
    }
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session",articleid,@"id", nil];
    LFLog(@"点赞dt：%@",dt);
    NSString *url = PBusyCommentClickUrl;
    if (self.isCarnival) {
        url = CarnivalCommentClickUrl;
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            
            PBusyModel *model = self.commentArr[index];
            NSInteger praise = [model.agree_count integerValue];
            if ([model.is_agree isEqualToString:@"0"]) {
                [self presentLoadingTips:@"点赞成功~~"];
                model.is_agree = @"1";
                praise ++;
            }else{
                [self presentLoadingTips:@"取消点赞~~"];
                model.is_agree = @"0";
                praise --;
                
            }
            model.agree_count = [NSString stringWithFormat:@"%d",(int)praise];
            [self.commentArr replaceObjectAtIndex:index withObject:model];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
    
}
#pragma mark - *************评论列表统计*************
-(void)commentUploadStatistical
{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.detailid,@"id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"评论列表统计dt:%@",dt);
    NSString *url = PBusyCommentListCountUrl;
    if (self.isCarnival) {
        url = CarnivalCommentListCountUrl;
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@"评论列表统计:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                self.countDt = response[@"data"];
                [self createHeaderview];
            }
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - *************维修评论列表*************
-(void)requestData:(NSInteger )pagenum{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.ws_worker) {
        [dt setObject:self.ws_worker forKey:@"ws_worker"];
    }
    if (self.ws_type) {
        [dt setObject:self.ws_type forKey:@"ws_type"];
    }
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) {
        coid = @"";
    }
    [dt setObject:coid forKey:@"coid"];
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"136") params:dt success:^(id response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@"工单详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        if ([str isEqualToString:@"0"]) {
            if ([response[@"date"] isKindOfClass:[NSArray class]] && [response[@"date"] count]) {
                [self.commentArr removeAllObjects];
                for (NSDictionary* dataDt in response[@"date"][0][@"note"]) {
                    NSArray *imArr = [NSArray array];
                    //                    if ([dataDt[@"or_path"] isKindOfClass:[NSString class]]&&[dataDt[@"or_path"] length]) {
                    //                        imArr = [dataDt[@"or_path"] componentsSeparatedByString:@","];
                    //                    }
                    NSDictionary *temDt = @{@"user_name":dataDt[@"sea_user"],
                                            @"add_time":dataDt[@"sea_date"],
                                            @"content":dataDt[@"sea_IDea"],
                                            @"rank":dataDt[@"sea_Branch"],
                                            @"imgurl":imArr,
                                            @"agree_count":@"",
                                            @"headimage":@"0",
                                            };
                    PBusyModel *p = [[PBusyModel alloc]initWithDictionary:temDt error:nil];
                    [self.commentArr addObject:p];
                }
                [self.tableView reloadData];
            }
        }else{
            [self presentLoadingTips:response[@"date"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"暂无数据"];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
    }];
    
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.ws_worker) {
            [self requestData:1];
        }else{
            self.page = 1;
            self.more = @"1";
            [self commentUploadData:1];
        }

    }];
    if (!self.ws_worker) {
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            if ([self.more isEqualToString:@"0"]) {
                [self presentLoadingTips:@"没有更多数据了"];
                [_tableView.mj_footer endRefreshing];
            }else{
                self.page ++;
                [self commentUploadData:self.page];
            }
            
        }];
    }

}
@end
