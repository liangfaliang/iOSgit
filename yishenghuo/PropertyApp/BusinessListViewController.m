//
//  BusinessListViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/30.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BusinessListViewController.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "PeripheralBusinessTableViewCell.h"
#import "BusinessStoreDetailsViewController.h"
#import "sortLabelview.h"
#import "UIButton+WebCache.h"
#import "IndexBtn.h"
#import <CoreLocation/CoreLocation.h>//定位
#import "PickerChoiceView.h"
#define cateHeight 90
@interface BusinessListViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,sortLabelviewDelegate,TFPickerDelegate>{
    sortLabelview *soreview;//分类标签
    UIView *headerview;
    CLLocation *newLocation;
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
@property(nonatomic,strong)NSMutableArray * categoryArr;//类别
@property(nonatomic,strong)NSString *sort;//标签
@property(nonatomic,strong)NSMutableArray * sortArr;//分类标签
@property(nonatomic,strong)NSMutableArray * businessArr;//商业街
@property(nonatomic,strong)NSString * businessID;//商业街
@property(nonatomic,strong)IndexBtn * selectBtn;
@property(nonatomic,strong)UIButton * titleBtn;
@end

@implementation BusinessListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.more = @"1";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height )];
    self.navigationItem.titleView = self.titleBtn;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"PeripheralBusinessTableViewCell" bundle:nil] forCellReuseIdentifier:@"PeripheralBusinessTableViewCell"];
    [self setupRefresh];
    [self startLocation];
    [self UploadDataBusinessl];
    
}
-(void)UpData{
    [self requestData:1];
    [self UploadDataShopListSortUrl];
}
-(UIButton *)titleBtn{
    if (_titleBtn == nil) {
        _titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenW-120, 44)];
        [_titleBtn setTitle:@"商业街" forState:UIControlStateNormal];
        [_titleBtn setTitleColor:JHdeepColor forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_titleBtn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleBtn;
}
#pragma mark title点击
-(void)titleBtnClick{
    if (self.businessArr.count) {
        PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
        picker.titlestr = @"请选择商业街";
        picker.inter =2;
        picker.delegate = self;
        picker.arrayType = HeightArray;
        for (NSDictionary *caDt in self.businessArr) {
            [picker.typearr addObject:caDt[@"name"]];
        }
        [self.view addSubview:picker];
    }
}
#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    LFLog(@"%@",str);
    for (NSDictionary *caDt in self.businessArr) {
        if ([caDt[@"name"] isEqualToString:str]) {
            [self.titleBtn setTitle:caDt[@"name"] forState:UIControlStateNormal];
            self.businessID = caDt[@"id"];
            [self UpData];
            return;
        }
    }
}
//开始定位
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        //        CLog(@"--------开始定位");
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        // 总是授权
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}
#pragma mark 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
        NSInteger interval = [[NSDate date] timeIntervalSince1970];
        NSInteger  loginTime = [[userDefaults objectForKey:@"locationPrompt"] integerValue];
        if (interval - loginTime > 86400) {
            [UserDefault setInteger:interval forKey:@"locationPrompt"];
            [self alertController:@"允许\"定位\"提示" prompt:@"请在设置中打开定位" sure:@"打开定位" cancel:@"取消" success:^{
                NSURL *setUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:setUrl];
            } failure:^{
                
            }];
        }
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}
#pragma mark  定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count) {
        [manager stopUpdatingLocation];
        if (!newLocation) {
            newLocation = locations[0];
            NSLog(@"latitude:%f longitude:%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
            //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
            self.page = 1;
            [self requestData:1];
        }
        
    }
    
    
}
-(void)createHeaderview{
    if (headerview == nil) {
        headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, self.categoryArr.count ? cateHeight:0)];
        headerview.backgroundColor = [UIColor whiteColor];
    }
    
    for (int i = 0; i < self.categoryArr.count; i ++) {
        IndexBtn *btn = [[IndexBtn alloc]initWithFrame:CGRectMake(i * SCREEN.size.width/4, 0, SCREEN.size.width/4, cateHeight)];
        btn.index = i;
        [btn addTarget:self action:@selector(listClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        UIButton *iconview = [[UIButton alloc]init];
        iconview.userInteractionEnabled = NO;
        iconview.imageView.contentMode =UIViewContentModeScaleAspectFit;
        [iconview sd_setImageWithURL:[NSURL URLWithString:self.categoryArr[i][@"imgurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [iconview sd_setImageWithURL:[NSURL URLWithString:self.categoryArr[i][@"click_imgurl"]] forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        //    iconview.center = CGPointMake(self.vw.frame.size.width/2, 40);
        [btn addSubview:iconview];
        [iconview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn.mas_centerX);
            make.top.offset(15);
            make.height.offset(40);
        }];
        UILabel *label = [[UILabel alloc]init];
        [btn addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconview.mas_bottom).offset(0);
            make.centerX.equalTo(btn.mas_centerX);
            make.height.offset(35);
            
        }];
        
        label.text = self.categoryArr[i][@"name"];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = JHmiddleColor;
        [headerview addSubview:btn];
        if (i == 0) {
            label.textColor = JHMaincolor;
            iconview.selected = YES;
            btn.selected = YES;
            self.selectBtn = btn;
            //            NSArray *dataArr = @[@"测试",@"测试标签",@"润体乳",@"测试",@"测试标签",@"润体乳",@"测试",@"测试标签",@"润体乳"];
            [self.sortArr removeAllObjects];
            for (NSString *str in self.categoryArr[0][@"keywords"]) {
                [self.sortArr addObject:str];
            }
            if (soreview == nil) {
                soreview = [[sortLabelview alloc]initWithFrame:CGRectMake(0, cateHeight, SCREEN.size.width, 100)];
                soreview.isMoreBtn = NO;
                soreview.delegate = self;
                soreview.titleSelctColor = JHMaincolor;
                soreview.btnBoderColor = JHMaincolor;
                [headerview addSubview:soreview];
            }
            [soreview initWithsortArray:self.sortArr currentIndex:0 sortH:40 font:14];
            [self viewDidLayoutSubviews];
        }
    }
    if (soreview) {
        headerview.frame = CGRectMake(0, 0, SCREEN.size.width, soreview.height + (self.categoryArr.count ? cateHeight:0));
    }
    self.tableview.tableHeaderView = headerview;
}
-(void)listClick:(IndexBtn *)btn{
    self.selectBtn.selected = NO;
    for (UIView *subview in self.selectBtn.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            ((UIButton *)subview).selected = NO;
        }else if ([subview isKindOfClass:[UILabel class]]){
            ((UILabel *)subview).textColor = JHmiddleColor;
        }
    }
    btn.selected = YES;
    self.selectBtn = btn;
    for (UIView *subview in btn.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            ((UIButton *)subview).selected = YES;
        }else if ([subview isKindOfClass:[UILabel class]]){
            ((UILabel *)subview).textColor = JHMaincolor;
        }
    }
    [self.sortArr removeAllObjects];
    for (NSString *str in self.categoryArr[btn.index][@"keywords"]) {
        [self.sortArr addObject:str];
    }
    [soreview initWithsortArray:self.sortArr currentIndex:0 sortH:40 font:14];
    
    self.page = 1;
    self.sort = @"";
    [self requestData:1];
    headerview.frame = CGRectMake(0, 0, SCREEN.size.width, soreview.height + (self.categoryArr.count ? cateHeight:0));
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (soreview) {
        soreview.frame = CGRectMake(0, cateHeight, soreview.frame.size.width, soreview.frame.size.height);
        headerview.frame =  CGRectMake(0, 0, SCREEN.size.width, soreview.height + (self.categoryArr.count ? cateHeight:0));
    }else{
        headerview.frame =  CGRectMake(0, 0, SCREEN.size.width, (self.categoryArr.count ? cateHeight:0));
    }
    [self.tableview reloadData];
}
#pragma mark 分类标签点击
-(void)sortLabelviewSelectSort:(NSString *)sort isSelect:(BOOL)isSelect{
    LFLog(@"标签：%@",sort);
    self.sort = sort;
    self.page = 1;
    [self requestData:1];
}
-(void)sortLabelviewMoreBtnClick:(UIButton *)btn{//点击更多或收起
    LFLog(@"soreview.height:%f",soreview.height);
    
}
#pragma mark - Table view data source
-(NSMutableArray *)sortArr{
    if (_sortArr == nil) {
        _sortArr = [[NSMutableArray alloc]init];
    }
    return _sortArr;
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(NSMutableArray *)categoryArr{
    if (_categoryArr == nil) {
        _categoryArr = [[NSMutableArray alloc]init];
    }
    return _categoryArr;
}
-(NSMutableArray *)businessArr{
    if (_businessArr == nil) {
        _businessArr = [NSMutableArray array];
    }
    return _businessArr;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    //    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PeripheralBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeripheralBusinessTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dt = self.dataArray[indexPath.row];
    [cell.iconimage sd_setImageWithURL:[NSURL URLWithString:[dt[@"imgurl"] count] ? dt[@"imgurl"][0] : @""] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    NSString *location = [NSString stringWithFormat:@" %@",dt[@"distance"]];
    [cell.locationBtn setTitle:location forState:UIControlStateNormal];
    cell.locaBtnWidth.constant = [location selfadap:12 weith:20].width + 5 + cell.locationBtn.imageView.image.size.width;
    cell.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    cell.titleLabel.text = dt[@"shop_name"];
    cell.contentLabel.text = dt[@"shop_address"];
    NSString *shop_price = [NSString stringWithFormat:@"人均:%@",dt[@"shop_price"]];
    cell.priceLabel.attributedText = [shop_price AttributedString:@"人均:" backColor:nil uicolor:JHmiddleColor uifont:nil];
    double rank = [dt[@"rank"] doubleValue];
    if ( rank >= 0 && rank <= 5) {
        UIImage *im = [UIImage imageNamed:@"xingxing_chense"];
        cell.xx_imWidth.constant = im.size.width * (rank/5.0);
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BusinessStoreDetailsViewController *detial = [[BusinessStoreDetailsViewController alloc]init];
    detial.dict = self.dataArray[indexPath.row];
    detial.shop_id  = detial.dict[@"shop_id"];
//    detial.detailid = self.dataArray[indexPath.row][@"shop_id"];
//    if (newLocation) {
//        if (newLocation.coordinate.longitude > 0) {
//            detial.LocationArr = @[newLocation];
//        }
//    }
    [self.navigationController pushViewController:detial animated:YES];
    
}
- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView{
    return CGPointMake(0, 50);
}
#pragma mark - *************商业街*************
-(void)UploadDataBusinessl{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BusinessUrl) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        LFLog(@"商业街:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.businessArr removeAllObjects];
            for (NSDictionary *caDt in response[@"data"]) {
                if (!self.businessArr.count) {
                    [self.titleBtn setTitle:caDt[@"name"] forState:UIControlStateNormal];
                    self.businessID = caDt[@"id"];
                }
                [self.businessArr addObject:caDt];
            }
            [self UpData];
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
    
    
}
#pragma mark - *************分类标签请求*************
-(void)UploadDataShopListSortUrl{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *url = BusinessCategoryUrl;
    LFLog(@"分类标签dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        LFLog(@"分类标签:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.categoryArr removeAllObjects];
            for (NSDictionary *caDt in response[@"data"]) {
                
                [self.categoryArr addObject:caDt];
            }
            [self createHeaderview];
            //            [self.sortArr addObject:@"全部"];
            
        }
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - *************请求数据*************
-(void)requestData:(NSInteger )pagenum{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    if (self.categoryArr.count) {
        if (self.categoryArr[self.selectBtn.index][@"id"]) {
            [dt setObject:self.categoryArr[self.selectBtn.index][@"id"] forKey:@"category_id"];
        }
    }
    if (newLocation) {
        if (newLocation.coordinate.longitude > 0) {
            [dt setObject:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude] forKey:@"coordinate_x"];
            [dt setObject:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude] forKey:@"coordinate_y"];
        }
    }
    if (self.sort) {
        [dt setObject:self.sort forKey:@"tag"];
    }
    if (self.businessID) {
        [dt setObject:self.businessID forKey:@"bustreet_id"];
    }
    
    LFLog(@"周边商业dt:%@",dt);
    NSString *url = BusinesslistUrl;

    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"周边商业:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (pagenum == 1) {
                [self.dataArray removeAllObjects];
            }
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dt in response[@"data"]) {
                    [self.dataArray addObject:dt];
                }
                if (!self.dataArray.count) {
                    [self presentLoadingTips:@"暂无数据~~~"];
                }
                self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            }else{
                [self presentLoadingTips:@"暂无数据~~~"];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        self.page = 1;
                        self.more = @"1";
                        [self requestData:1];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        [self.tableview reloadData];
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
