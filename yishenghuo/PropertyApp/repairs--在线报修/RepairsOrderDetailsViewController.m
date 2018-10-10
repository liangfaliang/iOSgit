
//
//  RepairsOrderDetailsViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/1/11.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "RepairsOrderDetailsViewController.h"
#import "repairUserView.h"
#import "UploadImageView.h"
#import "RepairUserInfoViewController.h"
#import "CommentSubmitViewController.h"
#import "JXTAlertManagerHeader.h"
@interface RepairsOrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIView *dashedView;
}
@property(nonatomic,strong)UploadImageView *ImageListView1;
@property(nonatomic,strong)UploadImageView *ImageListView2;
@property(nonatomic,strong)repairUserView *UserView;
@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSArray *nameArr1;
@property(nonatomic,strong)NSArray *nameArr2;
@property(nonatomic,strong)NSArray *nameArr3;
@property(nonatomic,strong)NSArray *keyArr1;
@property(nonatomic,strong)NSArray *keyArr2;
@property(nonatomic,strong)NSMutableArray *valueArr2;

@end

@implementation RepairsOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"任务详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.nameArr1 = @[@"报修位置：",@"报修内容：",@"预约日期："];
    self.nameArr2 = @[@"您创建了报修任务",@"报修已接单",@"报修开始处理",@"报修已处理",@"报修已评价"];
    self.nameArr3 = @[@"费用总计：",@"维修费用：",@"维修耗材："];
    self.keyArr2 = @[@"or_requestTime",@"se_recdate",@"ws_begintime",@"ws_completetime",@"sea_date"];
    self.keyArr1 = @[@"or_location",@"er_desc",@"or_servertime"];
    [self createTableview];
    [self requestData:1];
}
-(void)createTableview{
    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height ) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"orderdetailcell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CityNewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CityNewsCell"];
    [self setupRefresh];
}
-(void)UserViewClick{
    RepairUserInfoViewController *user = [[RepairUserInfoViewController alloc]init];
    if (self.dataArray.count) {
        if ([self.dataArray[0][@"se_send_name"] isKindOfClass:[NSString class]]) {
            user.ws_worker = self.dataArray[0][@"se_send_name"];
        }
        if ([self.dataArray[0][@"et_typesname"] isKindOfClass:[NSString class]]) {
            user.ws_type = self.dataArray[0][@"et_typesname"];
        }
    }
    user.UserView.xxIm.scale = self.UserView.xxIm.scale;
    [self.navigationController pushViewController:user animated:YES];
}
-(repairUserView *)UserView{
    if (_UserView == nil) {
        _UserView = [[NSBundle mainBundle]loadNibNamed:@"repairUserView" owner:nil options:nil][0];
        _UserView.frame = CGRectMake(0, 0, SCREEN.size.width, 80);
    }
    return _UserView;
}
-(UploadImageView *)ImageListView1{
    if (_ImageListView1 == nil) {
        _ImageListView1 = [[UploadImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 70)];
    }
    return _ImageListView1;
}
-(UploadImageView *)ImageListView2{
    if (_ImageListView2 == nil) {
        _ImageListView2 = [[UploadImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 70)];
    }
    return _ImageListView2;
}
-(NSMutableArray *)valueArr2{
    
    if (_valueArr2 == nil) {
        _valueArr2 = [[NSMutableArray alloc]init];
    }
    
    return _valueArr2;
    
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
#pragma mark 打电话
-(void)telPhone{
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
}
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return YES;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.nameArr1.count;
    }else if (section == 1){
        return self.valueArr2.count;
    }else if (section == 2){
        if (self.dataArray.count && _dataArray[0][@"note"] && [_dataArray[0][@"note"] count] && _dataArray[0][@"note"][0][@"fe_name"] && [_dataArray[0][@"note"][0][@"fe_name"] length]) {
            return self.nameArr3.count;
        }
    }
    return 0;
    //    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *nameArr = self.nameArr1;
    NSArray *keyArr = self.keyArr1;
    if (indexPath.section == 0) {
        if (self.dataArray.count) {
            CGSize lbsize = [nameArr[indexPath.row] selfadaption:15];
            NSDictionary *dt = self.dataArray[0];
            if ([dt[keyArr[indexPath.row]] isKindOfClass:[NSString class]]){
                CGSize size = [dt[keyArr[indexPath.row]] selfadap:15 weith:lbsize.width + 30];
                return (size.height + 10) < 30 ? 30:(size.height + 10);
            }
        }
    }else if (indexPath.section == 1) {
        return 50;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        if (self.dataArray.count) {
            nameArr = self.nameArr3;
            keyArr = @[@"ws_spend",@"fu_sum",@"note"];
            CGSize lbsize = [nameArr[indexPath.row] selfadaption:15];
            NSDictionary *dt = self.dataArray[0];
            if ([dt[keyArr[indexPath.row]] isKindOfClass:[NSArray class]]){
                NSArray *note = dt[keyArr[indexPath.row]];
                NSMutableString *mstr = [NSMutableString string];
                for (int i = 0; i < note.count; i ++) {
                    if ([note[i] isKindOfClass:[NSDictionary class]] && note[i][@"fe_name"]) {
                        [mstr appendString:note[i][@"fe_name"]];
                    }
                    if (i < note.count - 1) {
                        [mstr appendString:@"、"];
                    }
                }
                CGSize size = [mstr selfadap:15 weith:lbsize.width + 30];
                return (size.height + 10) < 30 ?30:size.height + 10;
            }
        }
    }
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderdetailcell"];
    if (self.dataArray.count) {
        NSDictionary *dt = self.dataArray[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView removeAllSubviews];
        NSArray *nameArr = self.nameArr1;
        NSArray *keyArr = self.keyArr1;
        if (indexPath.section == 1) {
            nameArr = self.nameArr2;
            keyArr = self.keyArr2;
        }else if (indexPath.section == 2){
            nameArr = self.nameArr3;
            keyArr = @[@"ws_spend",@"fu_sum",@"note"];
        }
        CGSize lbsize = [nameArr[indexPath.row] selfadaption:15];
        UILabel *label = [[UILabel alloc]init];
        label.textColor = JHmiddleColor;
        if (indexPath.section == 1 && indexPath.row == self.valueArr2.count - 1) {
             label.textColor = JHMaincolor;
        }
        label.font = [UIFont systemFontOfSize:15];
        label.text = nameArr[indexPath.row];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (indexPath.section == 1) {
                make.left.offset(25);
            }else{
                make.left.offset(10);
            }
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.offset(lbsize.width + 5);
            
        }];
        
        UILabel *objclabel = [[UILabel alloc]init];
        objclabel.numberOfLines = 0;
        if ([dt[keyArr[indexPath.row]] isKindOfClass:[NSString class]]) {
            objclabel.text = dt[keyArr[indexPath.row]];
        }else if ([dt[keyArr[indexPath.row]] isKindOfClass:[NSNumber class]]){
            NSNumber *num = dt[keyArr[indexPath.row]];
            objclabel.text = [NSString stringWithFormat:@"%@",num];
        }else if ([dt[keyArr[indexPath.row]] isKindOfClass:[NSArray class]]){
            NSArray *note = dt[keyArr[indexPath.row]];
            NSMutableString *mstr = [NSMutableString string];
            for (int i = 0; i < note.count; i ++) {
                if ([note[i] isKindOfClass:[NSDictionary class]] && [note[i][@"fe_name"] isKindOfClass:[NSString class]] && [note[i][@"fe_name"] length]) {
                    [mstr appendString:note[i][@"fe_name"]];
                    if (i < note.count - 1) {
                        [mstr appendString:@"、"];
                    }
                }

            }
            objclabel.text = [NSString stringWithFormat:@"%@",mstr];
        }
        if (indexPath.section == 2 ) {
            if (objclabel.text.length) {
                if (indexPath.row == 0) {
                    objclabel.text = [NSString stringWithFormat:@"%@元 (维修费用：%@元)",objclabel.text,dt[@"ff_fee"]];
                }else if (indexPath.row == 1){
                    objclabel.text = [NSString stringWithFormat:@"%@元",objclabel.text];
                }
                
            }
        }
        if (indexPath.section == 0 && indexPath.row == 2) {
            if (!objclabel.text.length) {
                objclabel.text = @"无";
            }
        }
        objclabel.textColor = JHColor(102, 102, 102);
        objclabel.font = [UIFont systemFontOfSize:15];
        
        if (indexPath.section == 1) {
            objclabel.textAlignment = NSTextAlignmentRight;
        }else{
            objclabel.textAlignment = NSTextAlignmentLeft;
        }
        [cell.contentView addSubview:objclabel];
        [objclabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(label.mas_right).offset(5);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.offset(-10);
            
        }];

    }
    [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if ((self.dataArray.count && _dataArray[0][@"or_path"] && [_dataArray[0][@"or_path"] length])) {
            return 80;
        }
    }
    if (section == 2) {
        if ((self.dataArray.count && _dataArray[0][@"ws_image"] && [_dataArray[0][@"ws_image"] length])) {
            return 80;
        }
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if ((self.dataArray.count && _dataArray[0][@"or_path"] && [_dataArray[0][@"or_path"] length])) {
            NSString *or_path = _dataArray[0][@"or_path"];
            UIView *fview = [[UIView alloc]init];
            fview.backgroundColor = [UIColor whiteColor];
            [fview addSubview:self.ImageListView1];
            self.ImageListView1.isDisplay = NO;
            self.ImageListView1.isClick = NO;
            NSArray *imArr = [or_path componentsSeparatedByString:@","];
            [self.ImageListView1 setImageArray:[NSMutableArray arrayWithArray:imArr]];
            return fview;
        }

    }
    if (section == 2) {
        if ((self.dataArray.count && _dataArray[0][@"ws_image"] && [_dataArray[0][@"ws_image"] length])) {
            NSString *or_path = _dataArray[0][@"ws_image"];
            UIView *fview = [[UIView alloc]init];
            fview.backgroundColor = [UIColor whiteColor];
            [fview addSubview:self.ImageListView2];
            self.ImageListView2.isDisplay = NO;
            self.ImageListView2.isClick = NO;
            NSArray *imArr = [or_path componentsSeparatedByString:@","];
            [self.ImageListView2 setImageArray:[NSMutableArray arrayWithArray:imArr]];
            return fview;
        }
        
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 && !self.valueArr2.count){
        return 0.001;
    }else if (section == 2){
        if (!(self.dataArray.count && _dataArray[0][@"note"] && [_dataArray[0][@"note"] count] && _dataArray[0][@"note"][0][@"fe_name"] && [_dataArray[0][@"note"][0][@"fe_name"] length])) {
            return 0.001;
        }
    }
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1 && !self.valueArr2.count){
        return nil;
    }else if (section == 2){
        if (!(self.dataArray.count && _dataArray[0][@"note"] && [_dataArray[0][@"note"] count] && _dataArray[0][@"note"][0][@"fe_name"] && [_dataArray[0][@"note"][0][@"fe_name"] length])) {
            return nil;
        }
    }
    UIView *hview = [[UIView alloc]init];
    hview.layer.masksToBounds = NO;
    hview.backgroundColor = [UIColor whiteColor];
    UIView *vline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 10)];
    vline.backgroundColor = JHBorderColor;
    [hview addSubview:vline];
    UIButton *titleLb = [[UIButton alloc]init];
    titleLb.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleLb setTitleColor:JHdeepColor forState:UIControlStateNormal];
    if (section == 0) {
        NSString *temp = self.nameArr2[0];
        if (self.valueArr2.count) {
            temp = self.nameArr2[self.valueArr2.count-1];
        }
        [titleLb setTitle:[NSString stringWithFormat:@"%@   ",temp] forState:UIControlStateNormal];
        [titleLb setTitleColor:JHMaincolor forState:UIControlStateNormal];
        if ([temp isEqualToString:@"报修已处理"]) {
            [titleLb setImage:[UIImage imageNamed:@"qupingjia_qd"] forState:UIControlStateNormal];
            [titleLb addTarget:self action:@selector(evaluateClick) forControlEvents:UIControlEventTouchUpInside];
            titleLb.width = [titleLb.titleLabel.text selfadap:15 weith:20].width + 10 + titleLb.imageView.image.size.width;
            [titleLb setTitleEdgeInsets:UIEdgeInsetsMake(0, -titleLb.imageView.image.size.width, 0, titleLb.imageView.image.size.width )];
            [titleLb setImageEdgeInsets:UIEdgeInsetsMake(0, titleLb.titleLabel.bounds.size.width, 0, -titleLb.titleLabel.bounds.size.width)];
        }
        UILabel *timeLb = [[UILabel alloc]init];
        timeLb.font = [UIFont systemFontOfSize:13];
        timeLb.textColor = JHmiddleColor;
        timeLb.text = self.valueArr2.lastObject;
        [hview addSubview:timeLb];
        [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.top.offset(10);
            make.bottom.offset(0);
        }];
    }else if (section == 1){
        [titleLb setTitle:@"维修进度" forState:UIControlStateNormal];
        [self addDashedView:hview];
    }else if (section == 2){
        [titleLb setTitle:@"收费耗材明细" forState:UIControlStateNormal];
    }
    [hview addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(10);
        make.bottom.offset(0);
        make.width.offset([titleLb.titleLabel.text selfadap:15 weith:20].width + 10 + titleLb.imageView.image.size.width);
    }];
    return hview;

}
//去评价
-(void)evaluateClick{
    CommentSubmitViewController *main = [[CommentSubmitViewController alloc]init];
    main.isPerpher = NO;
    main.orid = self.orid;
    [self.navigationController pushViewController:main animated:YES];
}
-(void)addDashedView:(UIView *)hview{
    if (dashedView == nil) {
        dashedView = [[UIView alloc]init];
        [hview addSubview:dashedView];
        dashedView.userInteractionEnabled = NO;
    }
    [dashedView removeAllSubviews];
    CGFloat yy = 75;
    for (int i = 0 ; i < self.valueArr2.count; i ++) {
        UIImageView *dateImageview = [[UIImageView alloc]init];
        if (i == self.valueArr2.count - 1) {
            dateImageview.image = [UIImage imageNamed:@"dangqianjindu"];
        }else{
            dateImageview.image = [UIImage imageNamed:@"yiwanchengjindu_qd"];
        }
        dateImageview.contentMode = UIViewContentModeCenter;
        dateImageview.backgroundColor = [UIColor whiteColor];
//        dateImageview.frame =CGRectMake(18 - dateImageview.image.size.width/2, yy + dateImageview.image.size.height/2, dateImageview.image.size.width, dateImageview.image.size.height);
        dateImageview.center = CGPointMake(10, yy);
        [hview addSubview:dateImageview];
        if (i < self.valueArr2.count - 1) {
            yy += 50 ;
        }
    }
    dashedView.frame = CGRectMake(10, 75, 1, yy - 75);
    dashedView.backgroundColor = JHBorderColor;
}


#pragma mark - *************请求数据*************
-(void)requestData:(NSInteger )pagenum{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.orid) {
        [dt setObject:self.orid forKey:@"orid"];
    }
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) {
        coid = @"";
    }
    [dt setObject:coid forKey:@"coid"];
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"135") params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"工单详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        if ([str isEqualToString:@"0"]) {
            if ([response[@"date"] isKindOfClass:[NSArray class]] && [response[@"date"] count]) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObject:response[@"date"][0]];
                NSString * se_send_name = response[@"date"][0][@"se_send_name"];
                NSString * sea_Average = response[@"date"][0][@"sea_Average"];
                if (se_send_name && se_send_name.length) {
                    [self telPhone];
                    self.UserView.nameLb.text = se_send_name;
                    if (sea_Average && sea_Average.length) {
                        self.UserView.xxIm.scale = [sea_Average floatValue]/5.0;
                    }else{
                        self.UserView.xxIm.scale = 0;
                    }
                    
                    self.UserView.xxIm.image = [UIImage imageNamed:@"xingxing_huise"];
                    self.UserView.xxIm.selImage = [UIImage imageNamed:@"xingxing_chense"];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UserViewClick)];
                    [self.UserView addGestureRecognizer:tap];
                    self.tableview.tableHeaderView = self.UserView;
                }else{
//                    self.tableview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 0)];
                }
                int lastInter = -1;
                [self.valueArr2 removeAllObjects];
                for (int i = 0 ; i < self.keyArr2.count; i ++) {
                    NSString *time = @"";
                    if (response[@"date"][0][self.keyArr2[i]] && [response[@"date"][0][self.keyArr2[i]] length]) {
                        time = response[@"date"][0][self.keyArr2[i]];
                        lastInter = i;
                    }
                    [self.valueArr2 addObject:time];
                }
                if (lastInter == -1) {
                    [self.valueArr2 removeAllObjects];
                }else{
                    NSArray *vaArrCopy = [self.valueArr2 copy];
                    for (int i = lastInter + 1 ; i < self.keyArr2.count; i ++) {
                        [self.valueArr2 removeObject:vaArrCopy[i]];
                    }
                }
                [self.tableview reloadData];
            }else{
                [self presentLoadingTips:@"暂无数据！"];
            }
        }else{
            [self presentLoadingTips:response[@"date"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"暂无数据"];
        [self createFootview];
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
