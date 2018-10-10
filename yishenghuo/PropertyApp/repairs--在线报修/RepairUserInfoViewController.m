//
//  RepairUserInfoViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/1/12.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "RepairUserInfoViewController.h"
#import "UploadImageView.h"
#import "CommentListTableViewCell.h"
#import "PBusyModel.h"
#import "JXTAlertManagerHeader.h"
#import "CommentListViewController.h"
@interface RepairUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIView *dashedView;
    UIView *hView;
    UIView *foot;
}
@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,strong)UploadImageView *ImageListView;
@property(nonatomic,assign)CGFloat sacleCount;//总评分
@end

@implementation RepairUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBarTitle = @"维修员信息";
    self.sacleCount  = 0;
    [self createTableview];
    [self requestData:1];
}

-(void)createTableview{
    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0, 144, SCREEN.size.width, SCREEN.size.height -144) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"orderdetailcell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CommentListTableViewCell" bundle:nil] forCellReuseIdentifier:@"repairUserInfolistCell"];
    [self.tableview registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"headrView"];
    [self setupRefresh];
    self.UserView.nameLb.text = self.ws_worker;
    self.UserView.xxIm.image = [UIImage imageNamed:@"xingxing_huise"];
    self.UserView.xxIm.selImage = [UIImage imageNamed:@"xingxing_chense"];
    self.UserView.backgroundImage = [UIImage imageNamed:@"beijing_wxyqd"];
    [self.UserView.callBtn setImage:[UIImage imageNamed:@"dianhua_lanse"] forState:UIControlStateNormal];
    self.UserView.rightImage.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.UserView.callBlock = ^{//打电话
        if (weakSelf.dataArray.count ) {
            NSString *shop_mobile = weakSelf.dataArray[0][@"us_tel"];
            if (shop_mobile.length) {
                [weakSelf jxt_showActionSheetWithTitle:@"拨打电话" message:@"" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                    alertMaker.
                    addActionCancelTitle(@"取消").
                    addActionDefaultTitle(shop_mobile);
                    
                } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                    if (![action.title isEqualToString:@"取消"]) {
                        NSString *tell = [NSString stringWithFormat:@"telprompt://%@",action.title];
                        NSURL *url = [NSURL URLWithString:tell];
                        NSComparisonResult compare = [[UIDevice currentDevice].systemName compare:@"10.0"];
                        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        }else{
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                    
                }];
                return ;
            }
            
        }
        [weakSelf presentLoadingTips:@"暂无电话信息！"];
    };
    
    foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 50)];
    foot.backgroundColor = [UIColor whiteColor];
    UIButton *allBtn = [[UIButton alloc]init];
    [allBtn setImage:[UIImage imageNamed:@"chakanquanbu_zbsy"] forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:allBtn];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(foot.mas_centerX);
        make.centerY.equalTo(foot.mas_centerY);
    }];
}
-(repairUserView *)UserView{
    if (_UserView == nil) {
        _UserView = [[NSBundle mainBundle]loadNibNamed:@"repairUserView" owner:nil options:nil][0];
        _UserView.frame = CGRectMake(0, 64, SCREEN.size.width, 80);
        _UserView.nameLb.textColor = [UIColor whiteColor];
        [self.view addSubview:_UserView];
    }
    return _UserView;
}
-(UploadImageView *)ImageListView{
    if (_ImageListView == nil) {
        _ImageListView = [[UploadImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 70)];
    }
    return _ImageListView;
}
-(NSMutableArray *)listArray{
    
    if (_listArray == nil) {
        _listArray = [[NSMutableArray alloc]init];
    }
    
    return _listArray;
    
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
#pragma mark 查看更多
-(void)moreBtnClick{
    CommentListViewController *more = [[CommentListViewController alloc]init];
    more.ws_worker = self.ws_worker;
    more.ws_type = self.ws_type;
    more.commentArr = [self.listArray mutableCopy];
    [self.navigationController pushViewController:more animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count < 2 ? self.listArray.count :2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listArray.count) {
        PBusyModel *mo = self.listArray[indexPath.row];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repairUserInfolistCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.likeBtn.hidden = YES;
    cell.pbmodel = self.listArray[indexPath.row];
    cell.contentLbLeft.constant = 60;
    CGSize h = [cell.pbmodel.content selfadap:14 weith:50];
    CGFloat HH = h.height + 10;
    if (HH > 105) {
        HH = 105;
    }
    cell.contentLbHeight.constant = HH;
//    __weak typeof(cell) weakcell = cell;
//    [cell setLikeblock:^(UIButton *sender) {
//
//    }];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.listArray.count) {
        return 100;
    }
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.listArray.count) {
        return nil;
    }
    UIView *hview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headrView"];
    [hview removeAllSubviews];
    //评论条数
    UIView *commentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 44)];
    commentView.backgroundColor = [UIColor whiteColor];
    [hview addSubview:commentView];
    //地址
    UILabel *commentLb = [[UILabel alloc]init];
    //                    descLabel.tag = 100;
    commentLb.font = [UIFont systemFontOfSize:12];
    commentLb.textColor  = JHsimpleColor;
    [commentView addSubview: commentLb];
    NSInteger count = 0;
    if (self.listArray.count) {
        count = self.listArray.count;
    }
    commentLb.attributedText = [[NSString stringWithFormat:@"评论 (%ld条评论)",(long)count] AttributedString:@"评论" backColor:nil uicolor:JHdeepColor uifont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    commentLb.numberOfLines = 0;
    [commentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(0);
        make.bottom.offset(0);
    }];

    //星星
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, SCREEN.size.width, 54)];
    backView.backgroundColor = [UIColor whiteColor];
    [hview addSubview:backView];
    XX_image *XX = [[XX_image alloc]init];
    XX.image = [UIImage imageNamed:@"dahuise_zbsy"];
    XX.scale = self.UserView.xxIm.scale;
//    XX.scale = self.sacleCount;
    XX.selImage = [UIImage imageNamed:@"dachengse_zbsy"];
    [backView addSubview:XX];
    [XX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.centerX.equalTo(backView.mas_centerX);
        make.width.offset(XX.image.size.width);
    }];
    UILabel *rankLb = [[UILabel alloc]init];
    rankLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    rankLb.textColor  = JHdeepColor;
    [backView addSubview: rankLb];
    rankLb.text = [NSString stringWithFormat:@"%.f",self.sacleCount];
    [rankLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(XX.mas_left).offset(-10);;
    }];
    return hview;
    
}



#pragma mark - *************请求数据*************
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
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"工单详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        if ([str isEqualToString:@"0"]) {
            if ([response[@"date"] isKindOfClass:[NSArray class]] && [response[@"date"] count]) {
                [self.dataArray removeAllObjects];
                [self.listArray removeAllObjects];
                [self.dataArray addObject:response[@"date"][0]];
                int num = 1;
                if (response[@"date"][0][@"sea_Average"]) {
                    self.sacleCount += [response[@"date"][0][@"sea_Average"] floatValue];
                }
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
                    LFLog(@"p:%@",p);
                    [self.listArray addObject:p];
                    num ++;
                }
//                self.sacleCount = self.sacleCount/num;
                if (self.listArray.count > 2) {
                    self.tableview.tableFooterView = foot;
                }else{
                    self.tableview.tableFooterView = nil;
                }
                [self.tableview reloadData];
            }
        }else{
            [self presentLoadingTips:response[@"date"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"暂无数据"];
        [_tableview.mj_footer endRefreshing];
        [_tableview.mj_header endRefreshing];
    }];
    
}


#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData:1];
    }];
//    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//        if ([self.more isEqualToString:@"0"]) {
//            [self presentLoadingTips:@"没有更多商品了"];
//            [self.tableview.mj_footer endRefreshing];
//        }else{
//            self.page ++;
//            [self requestData:self.page];
//        }
//
//    }];
}
@end
