//
//  MedicalExaminationDetailViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/12.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MedicalExaminationDetailViewController.h"
#import "JWCycleScrollView.h"
#import "btnFootView.h"
#define headerHt SCREEN.size.width * 12/25
@interface MedicalExaminationDetailViewController ()<JWCycleScrollImageDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)btnFootView *footer;
@property(nonatomic,strong)JWCycleScrollView *jwView;
@property (nonatomic,strong)NSMutableArray *dataArray;//详情

@end

@implementation MedicalExaminationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"套餐详情";
    [self createTableview];
    self.footer = [[NSBundle mainBundle]loadNibNamed:@"btnFootView" owner:nil options:nil][0];
    self.footer.frame = CGRectMake(0, SCREEN.size.height - 50, SCREEN.size.width, 50);
    [self.footer.clickBtn setTitle:@"立即预约" forState:UIControlStateNormal];
    [self.footer setBlock:^{//立即预约
        
    }];
    [self.view addSubview:self.footer];
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


-(void)createTableview{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerHt )];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height -50) style:UITableViewStyleGrouped];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsReviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"shopGoodsReview"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentListTableViewCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
    [self setupRefresh];
    [self.view addSubview:self.tableView];
    
}
//图片轮播
- (void)ceratCycleScrollView
{
    //采用网络图片实现
    _jwView = nil;
    _jwView=[[JWCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerHt)];
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    if (self.dataArray.count == 0) {
        imagesURLStrings = [NSMutableArray arrayWithObjects:@"placeholderImage",nil];
        _jwView.localImageArray = imagesURLStrings;
    }else{
        for (NSString *imstr in self.dataArray[0][@"imgurl"]) {
            if (IS_IPHONE_6_PLUS) {
                [imagesURLStrings addObject:imstr];
            }else{
                [imagesURLStrings addObject:imstr];
            }
        }
        _jwView.imageURLArray=imagesURLStrings;
    }    // 图片配文字
    _jwView.imageMode = UIViewContentModeScaleAspectFill;
    _jwView.placeHolderColor=[UIColor grayColor];
    //轮播时间间隔
    _jwView.autoScrollTimeInterval=3.0f;
    //显示分页符
    _jwView.showPageControl=YES;
    //分页符位置
    _jwView.delegate=self;
    _jwView.pageControlAlignmentType=pageControlAlignmentTypeRight;
    _jwView.jwCycleScrollDirection=JWCycleScrollDirectionHorizontal; //横向
    [_jwView startAutoCarousel];
    
    [self.headerView addSubview:self.jwView];
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark JWCycleScrollImageDelegate
-(void)cycleScrollView:(JWCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dt in self.dataArray[0][@"pictures"]) {
        [arr addObject:dt[@"url"]];
    }
    if (arr.count > 0) {
        STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:arr currentIndex:index];
        [broser show];
    }
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 4) {
        return 1;
    }
    if (self.dataArray.count) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count) {
        if (indexPath.section == 0) {
            CGSize descsize = [self.dataArray[0][@"shop_name"] selfadapUifont:[UIFont fontWithName:@"Helvetica-Bold" size:16] weith:20];
            return ((descsize.height + 10) > 30 ? (descsize.height + 10):30) + 40 ;
        }else if (indexPath.section == 1 ){//评论
            CGSize addsize = [[NSString stringWithFormat:@"%@",self.dataArray[0][@"shop_address"]] selfadap:15 weith:80];
            return addsize.height + [UIImage imageNamed:@"dingwijuli_zbsy"].size.height + 30;
        }else if (indexPath.section == 2 ){//更多
            CGSize moresize = [[NSString stringWithFormat:@"%@",self.dataArray[0][@"shop_desc"]] selfadap:13 weith:20 Linespace:10];
            return moresize.height + 45;
        }else if (indexPath.section == 3){
            return 100;
        }
        
    }

    return 0.001;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *onecellid = [NSString stringWithFormat:@"pbussDtailcell_%ld",(long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:onecellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:onecellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.contentView removeAllSubviews];
    if (indexPath.section == 0) {
        
        if (self.dataArray.count) {
            //名字
            UILabel *descLabel = [[UILabel alloc]init];
            //                    descLabel.tag = 100;
            descLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
            descLabel.textColor  = JHdeepColor;
            [cell.contentView addSubview: descLabel];
            descLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"shop_name"]];
            descLabel.numberOfLines = 0;
            CGSize descsize = [descLabel.text selfadapUifont:descLabel.font weith:20];
            [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.right.offset(-10);
                make.top.offset(10);
                make.height.offset((descsize.height + 10) > 30 ? (descsize.height + 10):30);
            }];
          
            
        }
        return cell;
    }else if (indexPath.section == 1){
        //地址
        UILabel *AddLb = [[UILabel alloc]init];
        //                    descLabel.tag = 100;
        AddLb.font = [UIFont systemFontOfSize:15];
        AddLb.textColor  = JHdeepColor;
        [cell.contentView addSubview: AddLb];
        AddLb.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"shop_address"]];
        AddLb.numberOfLines = 0;
        CGSize descsize = [AddLb.text selfadap:15 weith:80];
        [AddLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-70);
            make.top.offset(10);
            make.height.offset(descsize.height + 5);
        }];
        //距离
        UIButton *alreadyLb = [[UIButton alloc]init];
        [alreadyLb setImage:[UIImage imageNamed:@"dingwijuli_zbsy"] forState:UIControlStateNormal];
        [alreadyLb setTitle:[NSString stringWithFormat:@"  %@",self.dataArray[0][@"distance"]] forState:UIControlStateNormal];
        alreadyLb.titleLabel.font = [UIFont systemFontOfSize:12];
        [alreadyLb setTitleColor:JHMaincolor forState:UIControlStateNormal];
        [cell.contentView addSubview: alreadyLb];
        [alreadyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(AddLb.mas_bottom).offset(0);
            make.left.offset(10);
            make.bottom.offset(0);
        }];
        //打电话
        UIButton *phoneBtn = [[UIButton alloc]init];
        [phoneBtn setImage:[UIImage imageNamed:@"icon_zhoubianshangye_dianhua"] forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(phoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview: phoneBtn];
        [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.offset(0);
            make.width.offset(60);
        }];
        return cell;
    }else if (indexPath.section == 2){
        //更多
        UILabel *moreLb = [[UILabel alloc]init];
        //                    descLabel.tag = 100;
        moreLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        moreLb.textColor  = JHdeepColor;
        [cell.contentView addSubview: moreLb];
        moreLb.text = @"更多信息";
        [moreLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.top.offset(10);
            make.height.offset(25);
        }];
        //信息
        UILabel *infoLb = [[UILabel alloc]init];
        //                    descLabel.tag = 100;
        infoLb.font = [UIFont systemFontOfSize:13];
        infoLb.textColor  = JHmiddleColor;
        [cell.contentView addSubview: infoLb];
        infoLb.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"shop_desc"]];
        if (infoLb.text) {
            [infoLb NSParagraphStyleAttributeName:10];
        }
        infoLb.numberOfLines = 0;
        [infoLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(moreLb.mas_bottom).offset(0);
            make.left.offset(10);
            make.right.offset(-10);
            make.bottom.offset(0);
        }];
        return cell;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section < 3) {
        return 10;
    }
    return 0.0001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = JHbgColor;
    return foot;
}


#pragma mark - *************详情请求*************
-(void)UploadDatagoods{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }

    NSString *url = PBusinessdetailUrl;
    LFLog(@"详情请求dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@"详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObject:response[@"data"]];
            NSArray *imageArr = response[@"data"][@"imgurl"];
            if (imageArr.count) {
                [self ceratCycleScrollView];
            }else{
                self.tableView.tableHeaderView = nil;
            }
            [self.tableView reloadData];
        }else{
            //            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            //            if ([error_code isEqualToString:@"100"]) {
            //                [self showLogin:^(id response) {
            //                    if ([response isEqualToString:@"1"]) {
            //                        [self UploadDatagoods];
            //                    }
            //
            //                }];
            //            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self UploadDatagoods];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}


@end
