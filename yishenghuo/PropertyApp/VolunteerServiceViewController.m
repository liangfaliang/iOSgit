//
//  VolunteerServiceViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/1.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "VolunteerServiceViewController.h"
#import "JWCycleScrollView.h"
#import "UIButton+WebCache.h"
#import "VolunteerActivityTableViewCell.h"
#import "VolunteerApplyViewController.h"
#import "VolunteerActivitylistViewController.h"
#import "VolunteerAlreadyJionViewController.h"
#import "VolunteerControlRegulationsViewController.h"
#import "VolunteerActivityDetailViewController.h"
#define headerHt SCREEN.size.width * 8/15
@interface VolunteerServiceViewController ()<UITableViewDelegate,UITableViewDataSource,JWCycleScrollImageDelegate>

@property (nonatomic,strong)NSMutableArray *userInfoArr;//志愿者个人信息
@property (nonatomic,strong)NSMutableArray * images;
@property (nonatomic,strong)NSMutableArray * activityArr;
@property (nonatomic,strong)NSMutableArray * titleArr;
@property (nonatomic,strong)NSMutableArray * serviceArr;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UICollectionView * collectionview;
@property (nonatomic,strong)NSMutableArray *noteArr;//存储的信息数组


@property (nonatomic,strong)NSMutableArray *pictureArr;//存储的信息数组
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic, strong) JWCycleScrollView * jwView;



@end

@implementation VolunteerServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationAlpha = 0;
    self.navigationBarTitle = @"";
    [self createUI];
    [self updata];
    [self setUPrefresh];

}

-(void)updata{
    [self rotatePicture];
    [self ActivityData];

    [self UploadDataisEmploy];
    
}

-(NSMutableArray *)userInfoArr{
    
    if (_userInfoArr == nil) {
        _userInfoArr = [[NSMutableArray alloc]init];
    }
    return _userInfoArr;
}
- (NSMutableArray *)pictureArr
{
    if (!_pictureArr) {
        _pictureArr = [[NSMutableArray alloc]init];
    }
    return _pictureArr;
}

- (NSMutableArray *)noteArr
{
    if (!_noteArr) {
        _noteArr = [[NSMutableArray alloc]init];
    }
    return _noteArr;
}

- (NSMutableArray *)activityArr
{
    if (!_activityArr) {
        _activityArr = [[NSMutableArray alloc]init];
    }
    return _activityArr;
}
- (NSMutableArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]init];
    }
    return _titleArr;
}
- (NSMutableArray *)serviceArr
{
    if (!_serviceArr) {
        _serviceArr = [[NSMutableArray alloc]init];
    }
    return _serviceArr;
}

-(void)createUI{
    UIImage *im = [UIImage imageNamed:@"zhiyuanhuodong"];
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerHt + im.size.height + 20)];
    //    UIView *tableHeaderView = [[UIView alloc] initWithFrame:self.headerView.bounds];
    //    [tableHeaderView addSubview:self.headerView];
//       self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStylePlain];
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -64, SCREEN.size.width, SCREEN.size.height + 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableHeaderView  = self.headerView;
    self.tableView.separatorColor = JHColor(222, 222, 222);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VolunteerActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"VolunteerActivityTableViewCell"];
    _tableView.separatorStyle = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    
    [self ceratCycleScrollView];
    //zhiyuanhuodong
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.image = im;
    [_headerView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerView.mas_centerX);
        make.bottom.offset(-10);
        
    }];
    
    UIButton *moreBtn = [[UIButton alloc]init];
    [moreBtn setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(morebtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageview.mas_centerY);
        make.right.offset(-10);
        
    }];
}
-(void)morebtnClick:(UIButton *)btn{

    VolunteerActivitylistViewController *list = [[VolunteerActivitylistViewController alloc]init];
    for (NSDictionary *dt in self.activityArr) {
        [list.activityArr addObject:dt];
    }
    if (self.userInfoArr.count) {
        list.isVolunteer = YES;
    }else{
    list.isVolunteer = NO;
    }
    [self.navigationController pushViewController:list animated:YES];

}


-(void)leftItemClick:(UIBarButtonItem *)btn{
    LFLog(@"%@",[userDefaults objectForKey:NetworkReachability]);
    if ([userDefaults objectForKey:NetworkReachability]) {
        LFLog(@"leftItemClick");
    }
    
    //    [self presentLoadingTips:@"请稍后"];//菊花
    //    [self customViewExample];
}

-(void)rightItemClick:(UIBarButtonItem *)btn{
    
    //    [self dismissTips];
    LFLog(@"rightItem");
    
}
//图片轮播
- (void)ceratCycleScrollView
{
    //采用网络图片实现
    _jwView = nil;
    _jwView=[[JWCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerHt)];
    //    self.headerView.frame = CGRectMake(0, 0, SCREEN.size.width, _jwView.frame.size.height + 30);
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    
    if (self.pictureArr.count == 0) {
        imagesURLStrings = [NSMutableArray arrayWithObjects:@"banner",nil];
        _jwView.localImageArray = imagesURLStrings;
    }else{
        for (NSDictionary *dt in self.pictureArr) {
            [imagesURLStrings addObject:dt[@"imgurl"]];
        }
        
        _jwView.imageURLArray=imagesURLStrings;
    }    // 图片配文字
    
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
    
    
}

-(void)cycleScrollView:(JWCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index
{
    
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    if (cycleScrollView==_jwView)
    {
        if ( NO == [UserModel online] ){
            [self showLogin:^(id response) {
            }];
        }else{
            
            if (self.pictureArr.count) {
//                DetailsActivityController *detial = [[DetailsActivityController alloc]init];
//                detial.detailid = [self.pictureArr[index] objectForKey:@"id"];
//                [self.navigationController pushViewController:detial animated:YES];
            }
        }
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (section == 0) {
            if (self.activityArr.count > 2) {
                return 2;
            }
            return self.activityArr.count;
        }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIImageView *view = [[UIImageView alloc]init];
    view.image = [UIImage imageNamed:@"fengexiantongyong"];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //        NSString *CellIdentifier = @"iscell";
    //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        
        NSString *CellIdentifier = @"VolunteerActivityTableViewCell";
        VolunteerActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (self.activityArr.count) {

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dt = self.activityArr[indexPath.row];
        [cell.pictureIm sd_setImageWithURL:[NSURL URLWithString:dt[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        cell.titleLabel.text = dt[@"ac_name"];
        cell.timeLabel.text = dt[@"add_time"];
        NSString * countStr = [NSString stringWithFormat:@"已有%@人参加",dt[@"count"]];
        cell.countLB.attributedText = [countStr AttributedString:dt[@"count"] backColor:nil uicolor:JHAssistColor uifont:[UIFont systemFontOfSize:13]];
       
            
        }
         return cell;
    }else {
        NSString *CellIdentifier3 = @"threecell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = JHColor(229, 229, 229);
        for (int i = 0; i < self.serviceArr.count; i++) {
            
            UIButton *imageview1 = [self.view viewWithTag:33 + i ];
            if (imageview1 == nil) {
                imageview1 = [[UIButton alloc]init];
                imageview1.imageView.contentMode = UIViewContentModeScaleAspectFit;
            }

            imageview1.frame =CGRectMake(i * ((SCREEN.size.width -2)/3 + 1), 0, (SCREEN.size.width -2)/3, 165);
                
            
            //                imageview1.backgroundColor = [UIColor redColor];
            [imageview1 addTarget:self action:@selector(imageviewClick:) forControlEvents:UIControlEventTouchUpInside];
            imageview1.tag = 33 + i;
            if (self.serviceArr.count > 0) {
                CGRect rect_screen = [[UIScreen mainScreen]bounds];
                CGSize size_screen = rect_screen.size;
                
                CGFloat scale_screen = [UIScreen mainScreen].scale;
                
                CGFloat width = size_screen.width*scale_screen;
                
                NSString *url = [NSString string];
                if (width < 960) {
                    url = self.serviceArr[i][@"imgurl2"];
                }else{
                    url = self.serviceArr[i][@"imgurl3"];
                }
                [imageview1 sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
                //                [imageview1 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
                
            }
            
            [cell.contentView addSubview:imageview1];
            
            
            
        }
        
        return cell;
        
    }
    
    
}

//热门服务点击事件
-(void)imageviewClick:(UIButton *)btn{
    
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        
        return;
    }
    NSString *name = [NSString stringWithFormat:@"%@",[self.serviceArr[btn.tag - 33] objectForKey:@"keyword"]];
    
    
    
    if ([name isEqualToString:@"zyzsq"]) {
        LFLog(@"志愿者报名");
        VolunteerApplyViewController *active = [[VolunteerApplyViewController alloc]init];
        if (self.userInfoArr.count) {
            [active.userInfoArr addObject:self.userInfoArr[0]];
        }
        [self.navigationController pushViewController:active animated:YES];
        return;
    }else if ([name isEqualToString:@"zyzglzd"]){
        LFLog(@"志愿者管理制度");
        VolunteerControlRegulationsViewController *houser = [[VolunteerControlRegulationsViewController alloc]init];
        [self.navigationController pushViewController:houser animated:YES];
        
        
    }else if ([name isEqualToString:@"wdcy"]){
        LFLog(@"我的参与");
        if (self.userInfoArr.count) {
            VolunteerAlreadyJionViewController *hot = [[VolunteerAlreadyJionViewController alloc]init];
            [self.navigationController pushViewController:hot animated:YES];

        }else{
            VolunteerApplyViewController *active = [[VolunteerApplyViewController alloc]init];
            
            [self.navigationController pushViewController:active animated:YES];
        }
        
    }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.0001;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
        if (indexPath.section == 0) {
            if (self.userInfoArr.count) {
                if (self.activityArr.count) {
                    VolunteerActivityDetailViewController *datil = [[VolunteerActivityDetailViewController alloc]init];
                    datil.detailid = self.activityArr[indexPath.row][@"ac_id"];
                    [self.navigationController pushViewController:datil animated:YES];
                }
            }else{
                VolunteerApplyViewController *active = [[VolunteerApplyViewController alloc]init];
                
                [self.navigationController pushViewController:active animated:YES];
            }

        }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }else if(indexPath.section == 1){
        
        return 165;
        
    }else{
        
        return 60;
    }
    
}

#pragma mark 轮播图数据
-(void)rotatePicture{

    [LFLHttpTool get:NSStringWithFormat(ZJShopBaseUrl,volunteersBannerUrl) params:nil success:^(id response) {
        [_tableView.mj_header endRefreshing];

        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            
            [self.pictureArr removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                
                [self.pictureArr addObject:dt];
                
            }
            

            
        }else{
            
        }

        [self.jwView removeFromSuperview];
        [self ceratCycleScrollView];
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
    
}


#pragma mark 首页活动
-(void)ActivityData{
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,volunteersActivityUrl) params:nil success:^(id response) {
        [_tableView.mj_header endRefreshing];
        LFLog(@"活动：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            
            [self.activityArr removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                
                [self.activityArr addObject:dt];
                
            }
            [self.tableView reloadData];
            
            
        }else{
            
        }

    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark 服务列表
-(void)UploadDataisEmploy{

    [LFLHttpTool get:NSStringWithFormat(ZJShopBaseUrl,volunteersServiceUrl) params:nil success:^(id response) {
        [_tableView.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            
            [self.serviceArr removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                
                [self.serviceArr addObject:dt];
                
            }
            
             [self.tableView reloadData];
            
        }else{
            
        }

    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - *************志愿者个人信息
- (void)requestVolunteerInfo{
    
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]init];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }else{
        [self showLogin:^(id response) {
        }];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,volunteersInfoUrl) params:dt success:^(id response) {

        LFLog(@"志愿者信息：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"][@"vt_state"] isEqualToString:@"1"]) {

            }else{
               
                
            }
            [self.userInfoArr removeAllObjects];
            [self.userInfoArr addObject:response[@"data"]];
            
            LFLog(@"self.userInfoArr：%@",self.userInfoArr);
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {                    
                }];
            }
//            [self presentLoadingTips:response[@"status"][@"error_desc"]];
          
            //            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        LFLog(@"活动报名error：%@",error);

    }];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestVolunteerInfo];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
-(void)setUPrefresh{
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self rotatePicture];
        [self ActivityData];
        [self UploadDataisEmploy];
        [self requestVolunteerInfo];
    }];
    
    //    // 上拉刷新
    //    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //
    //    }];
    
}
@end
