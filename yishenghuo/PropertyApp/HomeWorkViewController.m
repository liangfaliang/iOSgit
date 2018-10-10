//
//  HomeWorkViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/8/11.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "HomeWorkViewController.h"
#import "JPUSHService.h"
#import "JWCycleScrollView.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "UIButton+WebCache.h"
#import "PayViewController.h"
#import "RepairsViewController.h"
#import "AttestViewController.h"
#import "InformationViewController.h"
#import "InforViewController.h"
#import "ActivityViewController.h"
#import "HouseRentingViewController.h"
#import "SatisfactionListViewController.h"
#import "HotlineViewController.h"
#import "DetailsActivityController.h"
#import "APPheadlinesViewController.h"
#import "STConfig.h"
#import "MeetingReservationViewController.h"
#import "CateringViewController.h"
#import "CommitteeViewController.h"
#import "InformationTableViewCell.h"
#import "CollectioncellTableViewCell.h"
#import "VolunteerServiceViewController.h"
#import "IndustrySuperviseViewController.h"
#import "PeripheralBusinessViewController.h"//周边商业
#import "CityNewsViewController.h"//城市新闻
#import "CastVoteListViewController.h"//投票表决
#import "ExpressViewController.h"// 快递通知
#import "HouserDetailViewController.h"
#import "PhoneOpenDoorViewController.h"//手机开门
#import <CoreLocation/CoreLocation.h>//定位
#import "LookAPILogViewController.h"//日志
#import "LoginViewController.h"
#import "AlertsButton.h"
#import "PushMessageViewController.h"
#import "FSTableViewCell.h"
#import "ActivityItemCollectionViewCell.h"
#import "YYText.h"
#import "HouserTableViewCell.h"
#import "SDCycleScrollView.h"
#import "InformationCycleCollectionViewCell.h"
#import "PaymentNewViewController.h"
#import "PreschoolHomeViewController.h"//幼教
#import "SanjinListViewController.h"//金钥匙
#import "HotlineViewController.h"
#import "ImLbModel.h"
#define headerHt SCREEN.size.width * 12/25
@interface HomeWorkViewController ()<UITableViewDelegate,UITableViewDataSource,JWCycleScrollImageDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,CLLocationManagerDelegate,UITabBarControllerDelegate,FSGridLayoutViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic,strong)NSMutableArray * images;
@property (nonatomic,strong)NSMutableArray * menuArr;
@property (nonatomic,strong)NSMutableArray * housesArr;
@property (nonatomic,strong)NSMutableArray * serviceArr;
@property (nonatomic,strong)NSMutableArray * weatherArr;
@property (nonatomic,strong)NSMutableArray * activityArr;
@property (nonatomic,strong)NSMutableArray * goldenArr;//金钥匙
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UICollectionView * collectionview;
@property (nonatomic,strong)UICollectionView * AcCollectionview;
@property (nonatomic,strong)NSMutableArray *noteArr;//存储的信息数组
@property (nonatomic,strong)NSMutableArray * InformationArr;
@property (nonatomic, assign) CGFloat InforHeight;
@property (nonatomic,strong)NSMutableArray *pictureArr;//存储的信息数组
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic, strong) JWCycleScrollView * jwView;
@property (nonatomic, strong) JWCycleScrollView * jwViewlabel;
@property (nonatomic, strong) NSArray *iconArray;
@property(nonatomic,strong)AlertsButton *alertbtn;//推送提醒
@property(nonatomic,assign)BOOL isInfo;
@property (nonatomic, strong) NSDictionary *jsonDt;//栅格cell
@property (nonatomic, strong) UIButton *titleView;
@property (nonatomic, assign) CGFloat headerHeight;
@property(nonatomic,assign)BOOL isAppear;
@property (nonatomic, retain)SDCycleScrollView *sdCySV;
@end

@implementation HomeWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate = self;
    self.navigationItem.titleView = self.titleView;
    //    self.navigationHidden = YES;
    self.InforHeight = 145;
//    self.navigationAlpha = 0;
    [self createTabbarItem];
    [self createUI];
    [self updata];
    [self setUPrefresh];
    [self createTabbarItem];

#ifdef DEBUG
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    UISwitch *swi = [[UISwitch alloc]init];
    [swi addTarget:self action:@selector(closeApiLog:) forControlEvents:UIControlEventTouchUpInside];
    [keywindow addSubview:swi];
    [swi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.equalTo(keywindow.mas_centerY);
    }];
    swi.alpha = 0.5;
    NSString *iSLog = [userDefaults objectForKey:IsDisplayApiLog];
    if (iSLog) {
        swi.on = YES;
    }else{
        swi.on = NO;
    }
    UIButton *logBtn = [[UIButton alloc]init];
    logBtn.alpha =0.5;
    logBtn.backgroundColor = [UIColor blackColor];
    [logBtn addTarget:self action:@selector(logbtnclick) forControlEvents:UIControlEventTouchUpInside];
    [keywindow addSubview:logBtn];
    [logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.equalTo(keywindow.mas_centerY);
        make.width.offset(30);
        make.height.offset(20);
    }];
#else
    //do sth.
#endif
    

}

-(void)logbtnclick{
    LookAPILogViewController *apilog = [[LookAPILogViewController alloc]init];
    UIViewController *topmostVC = [self topViewController];
    LFLog(@"topmostVC:%@",[topmostVC class]);
    [topmostVC.navigationController pushViewController:apilog animated:YES];
}
-(void)closeApiLog:(UISwitch *)sth{
    if (sth.on) {
        [userDefaults setObject:IsDisplayApiLog forKey:IsDisplayApiLog];
    }else{
        [userDefaults removeObjectForKey:IsDisplayApiLog];
    }
    
}

-(void)updata{

//    [self requestInforData];
    [self rotatePicture];
    [self MenuData];
    //    [self serviceData];
    [self UploadDataisEmploy];
    [self complainUploaddata];
    [self startLocation];
    [self UploadDataisInformation];
    [self activityUpdata];
    [self housesArrUpdata];
    [self UploadDataGold];
}
- (NSMutableArray *)goldenArr
{
    if (!_goldenArr) {
        _goldenArr = [[NSMutableArray alloc]init];
    }
    return _goldenArr;
}
- (NSMutableArray *)activityArr
{
    if (!_activityArr) {
        _activityArr = [[NSMutableArray alloc]init];
    }
    return _activityArr;
}
- (NSMutableArray *)weatherArr
{
    if (!_weatherArr) {
        _weatherArr = [[NSMutableArray alloc]init];
    }
    return _weatherArr;
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

- (NSMutableArray *)menuArr
{
    if (!_menuArr) {
        _menuArr = [[NSMutableArray alloc]init];
        NSArray *arr = @[@{@"name":@"一键开门",@"image":@"yijainkaimen",@"key":@"yjkm"},
                         @{@"name":@"在线缴费",@"image":@"zaixianjiaofei",@"key":@"zxjf"},
                         @{@"name":@"业主报修",@"image":@"yezhubaoxiu",@"key":@"yzbx"},
                         @{@"name":@"服务热线",@"image":@"fuwurexian",@"key":@"fwrx"},
                         @{@"name":@"小区圈电",@"image":@"xiaoququandian",@"key":@"xqqd"},
                         @{@"name":@"公区报修",@"image":@"gongqubaoxiu",@"key":@"gqbx"},
                         @{@"name":@"投诉表扬",@"image":@"tousubiaoyang",@"key":@"tsby"},
                         @{@"name":@"物业公示",@"image":@"wuyegongshi",@"key":@"wygs"}];
        [_menuArr addObjectsFromArray:arr];
    }
    return _menuArr;
}
- (NSMutableArray *)housesArr
{
    if (!_housesArr) {
        _housesArr = [[NSMutableArray alloc]init];
    }
    return _housesArr;
}
- (NSMutableArray *)serviceArr
{
    if (!_serviceArr) {
        _serviceArr = [[NSMutableArray alloc]init];
    }
    return _serviceArr;
}
- (NSMutableArray *)InformationArr
{
    if (!_InformationArr) {
        _InformationArr = [[NSMutableArray alloc]init];
    }
    return _InformationArr;
}
- (SDCycleScrollView *)sdCySV {
    if(!_sdCySV){
        _sdCySV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenW, 50) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        //        _sdCySV.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        //        _sdCySV.currentPageDotColor = JHColor(138, 181, 255);
        _sdCySV.showPageControl = NO;
        _sdCySV.backgroundColor = [UIColor whiteColor];
        _sdCySV.scrollDirection = UICollectionViewScrollDirectionVertical;
        _sdCySV.imageURLStringsGroup = @[];
    }
    
    return _sdCySV;
}
#pragma mark CycleScrollViewdelegate
-(UINib *)customCollectionViewCellNibForCycleScrollView:(SDCycleScrollView *)view{
    UINib *nib = [UINib nibWithNibName:@"InformationCycleCollectionViewCell" bundle:nil];
    return nib;
}
-(void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view{
    InformationCycleCollectionViewCell *mcell = (InformationCycleCollectionViewCell *)cell;
    mcell.iconIm.image = [UIImage imageNamed:@"wuyetoutiao"];
    for (int i = 0; i < 2; i ++) {
        if (self.InformationArr.count > index* 2 + i) {
            NSDictionary *dt = self.InformationArr[index* 2 + i];
            [mcell labelSetText:dt[@"title"] tag:dt[@"tag"] index:i+ 1];
        }
    }
    
}
//开始定位
- (void)startLocation {
//    if ([CLLocationManager locationServicesEnabled]) {
//        //        CLog(@"--------开始定位");
//        self.locationManager = [[CLLocationManager alloc]init];
//        self.locationManager.delegate = self;
//        //控制定位精度,越高耗电量越
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
//        // 总是授权
//        [self.locationManager requestWhenInUseAuthorization];
//        self.locationManager.distanceFilter = 10.0f;
//        [self.locationManager requestWhenInUseAuthorization];
//        [self.locationManager startUpdatingLocation];
//    }
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
        CLLocation *newLocation = locations[0];
        NSLog(@"latitude:%f longitude:%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
        //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
        [manager stopUpdatingLocation];
        [self UploadDataYYWeather:newLocation];
    }

    
}

-(void)createUI{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerHt)];

    CGFloat tableW = ScreenWidth;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, tableW, ScreenHeight) style:UITableViewStyleGrouped];
    if (iOS11) {
        self.tableView.height = SCREEN.size.height - TabH;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.tableHeaderView  = self.headerView;
    self.tableView.separatorColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CollectioncellTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollectioncellTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HouserTableViewCell" bundle:nil] forCellReuseIdentifier:@"HouserCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"InformationTableViewCell" bundle:nil] forCellReuseIdentifier:@"InformationTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"D0informationTableViewCell" bundle:nil] forCellReuseIdentifier:@"cuscell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self ceratCycleScrollView];
}
#pragma mark - --- delegate 视图委托 ---
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentInset.top + scrollView.contentOffset.y ;
//    CGFloat progress = offsetY / (self.headerHeight - 20);
//    CGFloat progressChange = offsetY / (self.headerHeight - (kDevice_Is_iPhoneX ? 84 :64) - 44);
    //     NSLog(@"%s, %f, %f, %f", __FUNCTION__ ,progressChange, progress, offsetY);
//    LFLog(@"progressChange:%f",progressChange);
//    if (self.isAppear) {
//        if (progressChange >= 1) {
//            _titleView.textColor = JHdeepColor;
//             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//            [self.navigationController setNavigationAlpha:(progressChange - 1) animated:YES];
//            //            self.titleView.alpha = (progressChange - 1);
//        }else {
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//            //            self.titleView.alpha = 0;
//            [self.navigationController setNavigationAlpha:0 animated:YES];
//            _titleView.textColor = [UIColor whiteColor];
//        }
//    }
    
}
#pragma mark - --- getters and setters 属性 ---


- (UIView *)headerView
{
    if (!_headerView) {
        CGFloat viewX = 0;
        CGFloat viewY = 0;
        CGFloat viewW = SCREEN.size.width;
        CGFloat viewH = self.headerHeight;
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        
        [_headerView.layer setMasksToBounds:YES];
    }
    return _headerView;
}


- (UIButton *)titleView
{
    if (!_titleView) {
        CGFloat viewX = 0;
        CGFloat viewY = 0;
        CGFloat viewW = 0;
        CGFloat viewH = 60;
        _titleView = [[UIButton alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        [_titleView setTitle:@"物业服务" forState:UIControlStateNormal];
        [_titleView setTitleColor:JHdeepColor forState:UIControlStateNormal];
        _titleView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _titleView;
}

- (CGFloat)headerHeight
{
    return SCREEN.size.width / 2;
}
-(UICollectionView *)AcCollectionview{
    if (!_AcCollectionview) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.itemSize = CGSizeMake(SCREEN.size.width *8 /15.0, SCREEN.size.width *2 /3.0);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _AcCollectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width,SCREEN.size.width *2 /3.0) collectionViewLayout:flowLayout];
        _AcCollectionview.dataSource=self;
        _AcCollectionview.delegate=self;
        [_AcCollectionview setBackgroundColor:[UIColor clearColor]];
        //注册Cell，必须要有
        [_AcCollectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"acHomeHeaderReuse"];//头视图
        [_AcCollectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"acHomeHeaderReuse"];//底视图
        [_AcCollectionview registerNib:[UINib nibWithNibName:@"ActivityItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ActivityHomeCollectionViewCell"];
//        [_AcCollectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ActivityHomeCollectionViewCell"];
    }
    return _AcCollectionview;
}

-(void)setUPrefresh{
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{        
        [self updata];
    }];
}
-(void)createTabbarItem{
    
    self.alertbtn = [[AlertsButton alloc]init];//tuisongxiaoxi
    self.alertbtn.alertLabel.textnum = @"0";
    UIImage *im =[UIImage imageNamed:@"tuisongxiaoxi"];
    self.alertbtn.frame =CGRectMake(0, 0, im.size.width, im.size.height);
    [self.alertbtn setImage:im forState:UIControlStateNormal];
    [self.alertbtn setImage:im forState:UIControlStateSelected];
    [self.alertbtn addTarget:self action:@selector(rightPushClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.alertbtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIButton *leftImview = [[UIButton alloc]init];//tuisongxiaoxi
    UIImage *leftim =[UIImage imageNamed:@"yishenghuo_logo"];
    leftImview.frame =CGRectMake(0, 0, leftim.size.width, leftim.size.height);
    [leftImview setImage:leftim forState:UIControlStateNormal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:leftImview];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
}
-(void)rightPushClick:(AlertsButton *)btn{
    PushMessageViewController *push = [[PushMessageViewController alloc]init];
    [self.navigationController pushViewController:push animated:YES];
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
    [_jwView removeFromSuperview];
    _jwView = nil;
    if (_jwView == nil) {
        _jwView=[[JWCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerHt)];
//        _jwView.contentType = contentNewTypeImage;
    }
    LFLog(@"_jwView.contentType:%u",_jwView.contentType);
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    if (self.pictureArr.count == 0) {
        imagesURLStrings = [NSMutableArray arrayWithObjects:@"placeholderImage",nil];
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
    
//    UIImageView *GradientImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"daohangtiaoyinying"]];
//    [_jwView addSubview:GradientImage];
//    [GradientImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(0);
//        make.left.offset(0);
//        make.right.offset(0);
//    }];
    
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
            
            //                        WebViewController *webVC = [[WebViewController alloc]init];
            //                        webVC.url= [NSURL URLWithString:[self.pictureArr[index] objectForKey:@"url"]];
            //
            //                        [self.navigationController pushViewController:webVC animated:YES];
            
            if (self.pictureArr.count) {
                NSDictionary *dt = self.pictureArr[index];
                if ([dt[@"ios"] isKindOfClass:[NSDictionary class]]) {
                    UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:dt[@"ios"] controller:self];
                    if (board == nil) {
                        [self presentLoadingTips:@"信息读取失败！"];
                    }
                    return;
                }
                DetailsActivityController *detial = [[DetailsActivityController alloc]init];
                detial.detailid = [self.pictureArr[index] objectForKey:@"id"];
                [self.navigationController pushViewController:detial animated:YES];
            }
        }
        
    }else if (cycleScrollView == _jwViewlabel){        
        //        APPheadlinesViewController *app = [[APPheadlinesViewController alloc]init];
        //        app.dataArray = self.housesArr;
        //        [self.navigationController pushViewController:app animated:YES];
        
//        InformationViewController *app = [[InformationViewController alloc]init];
//        [self.navigationController pushViewController:app animated:YES];
        
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) return self.InformationArr.count;
    if (section == 2) return self.goldenArr.count ? 1 : 0;
    if (section == 3) return self.activityArr.count ? 1: 0;
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        if (!self.goldenArr.count) {
            return 0.001;
        }
    }
    if (section == 3) {
        if (!self.activityArr.count) {
            return 0.001;
        }
    }
    return 10;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIImageView *view = [[UIImageView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.image = [UIImage imageNamed:@"fengexiantongyong"];
    if (section == 0 && !self.menuArr.count) {
        view.image = nil;
    }else if (section == 1 && !self.serviceArr.count) {
        view.image = nil;
    }else if (section == 2 && !self.InformationArr.count) {
        view.image = nil;
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) if (!self.goldenArr.count) return 0.001;
    if (section == 3) if (!self.activityArr.count) return 0.001;
    if (section > 0) {
        return 50;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        if (section == 2) if (!self.goldenArr.count) return nil;
        if (section == 3) if (!self.activityArr.count) return nil;
        UIView *header = [[UIView alloc]init];
//        YYLabel *nameLb = [[YYLabel alloc]init];
//        nameLb.textColor = JHdeepColor;
//        nameLb.font = [UIFont systemFontOfSize:20];
//        nameLb.numberOfLines = 0;
//        NSMutableAttributedString *text = nil;
//        NSString *attstring = @"\n丰富社区活动";
//        if (section ==2) {
//            text = [[NSMutableAttributedString alloc] initWithString:@"社区活动 \n丰富社区活动"];
//        }else{
//            attstring = @"\n租房交易真实可靠";
//            text = [[NSMutableAttributedString alloc] initWithString:@"房屋租售 \n租房交易真实可靠"];
//        }
//
//        text.yy_font = [UIFont boldSystemFontOfSize:20];
//        NSRange range =[[text string]rangeOfString:attstring];
//        text.yy_color = JHdeepColor;
//        text.yy_lineSpacing = 10;
//        [text yy_setFont:[UIFont systemFontOfSize:12] range:range];
//        [text yy_setColor:JHmiddleColor range:range];
//        nameLb.attributedText = text;
//        [header addSubview:nameLb];
//        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.offset(10);
//            make.right.offset(-10);
//            make.top.offset(0);
//            make.bottom.offset(0);
//        }];
        NSArray *nameArr = @[@"   物业通知",@"   金钥匙服务",@"   社区活动",@"   满意度测评"];
        NSArray *imageArr = @[@"tongzhi",@"jinyaoshi",@"shequ",@"manyiduceping"];
        NSArray *colorArr = @[@"ff4545",@"edb13f",@"3daef4",@"1ed892"];
        UIButton *namebtn = [[UIButton alloc]init];
        [namebtn setImage:[UIImage imageNamed:imageArr[section - 1]] forState:UIControlStateNormal];
        [namebtn setTitle:nameArr[section - 1] forState:UIControlStateNormal];
        [namebtn setTitleColor:[UIColor colorFromHexCode:colorArr[section - 1]] forState:UIControlStateNormal];
        namebtn.titleLabel.font = [UIFont systemFontOfSize:15];
         [header addSubview:namebtn];
        [namebtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(0);
            make.bottom.offset(0);
        }];
        
        ImRightBtn *btn = [[ImRightBtn alloc]init];
        btn.section = section;
        [btn setImage:[UIImage imageNamed:@"gerenzhongxinjiantou"] forState:UIControlStateNormal];
        [btn setTitle:@"查看更多 " forState:UIControlStateNormal];
        [btn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(header.mas_centerY);
            make.right.offset(-10);
        }];
        
        return header;
    }
    return nil;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //        NSString *CellIdentifier = @"iscell";
    //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        NSString *CellIdentifier = @"onecell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat num = 4;
        if (self.menuArr.count > 0) {
            num = self.menuArr.count;
            LFLog(@"num:%f",num);
        }
        if (self.collectionview == nil) {
            UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
            
            flowLayout.itemSize = CGSizeMake((SCREEN.size.width-5)/num, 90);
            flowLayout.minimumInteritemSpacing = 10;
            flowLayout.minimumLineSpacing = 1;
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, SCREEN.size.width,90) collectionViewLayout:flowLayout];
            self.collectionview.dataSource=self;
            self.collectionview.delegate=self;
            [self.collectionview setBackgroundColor:[UIColor clearColor]];
            self.collectionview.scrollEnabled = NO;
            //注册Cell，必须要有
            [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeaderReuse"];//头视图
            [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeFootReuse"];//底视图
            [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        }
        [cell.contentView addSubview:_collectionview];
        [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.left.offset(0);
            make.bottom.offset(0);
            make.right.offset(0);
        }];
        return cell;
        
    }else if (indexPath.section == 1) {
//        FSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeFScell"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (self.jsonDt) {
//            cell.json = self.jsonDt;
//        }
//        cell.layoutView.delegate = self;
//        return cell;
        InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationTableViewCell"];
        [cell setCellWithDict:self.InformationArr[indexPath.row] indexPath:indexPath];
        return cell;
        
    }else  if ( indexPath.section == 2) {
        CollectioncellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CollectioncellTableViewCell class]) forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.collectionView.backgroundColor = [UIColor whiteColor];
        cell.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        cell.layout.itemSize = CGSizeMake((screenW - 100)/3 - 1, 120);
        cell.layout.minimumLineSpacing = 35;
        cell.layout.minimumInteritemSpacing = 0.001;
        CGFloat oneX = 15;
        cell.layout.sectionInset = UIEdgeInsetsMake(5, oneX, 15, oneX);
        cell.itemSize = cell.layout.itemSize;
        cell.Identifier = @"ImageLabelCollectionViewCell";
        cell.titleArr = self.goldenArr;
        WEAKSELF;
        cell.ClickBlock = ^(NSIndexPath *indexpath) {
        };
        return cell;
    }else if (indexPath.section == 3){
        NSString *CellIdentifier2 = @"Activitycell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.AcCollectionview];
        [self.AcCollectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.bottom.offset(0);
            make.right.offset(0);
        }];
        return cell;
    } else if (indexPath.section ==30) {
        HouserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouserCell"];
        NSDictionary *dt = self.housesArr[indexPath.row];
        if (dt[@"index_img"]) {
            [cell.iconimage sd_setImageWithURL:[NSURL URLWithString:dt[@"index_img"]]placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
        }else{
            cell.iconimage.image = [UIImage imageNamed:@"placeholderImage"];
            
        }
        cell.titlelable.text = dt[@"title"];
        
        cell.locationlabel.text = [NSString stringWithFormat:@"%@-%@",dt[@"housetype"],dt[@"address"]];
        NSMutableString *mstr = [NSMutableString string];
        for (NSString *str in dt[@"tag"]) {
            [mstr appendFormat:@"    %@    ",str];
        }
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:mstr];
        text.yy_font = [UIFont boldSystemFontOfSize:12];
        text.yy_color = JHColor(255, 69, 69);
        for (NSString *str in dt[@"tag"]) {
            NSRange range =[[text string]rangeOfString:[NSString stringWithFormat:@" %@ ",str]];
            [text yy_setColor:JHmiddleColor range:range];
            YYTextBorder *boder = [[YYTextBorder alloc]init];
            boder.strokeWidth = 1;
            boder.cornerRadius = 3;
            boder.strokeColor = JHColor(255, 69, 69);;
            [text yy_setTextBorder:boder  range:range];
            [text yy_setColor:JHColor(255, 69, 69) range:range];
        }

        cell.signYYlb.attributedText = text;
        return cell;
        
    }else {
        NSString *CellIdentifier2 = @"Informationcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView removeAllSubviews];
        UIImageView *voteImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fuwuzhiliang"]];
        [cell.contentView addSubview:voteImage];
        [voteImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
        voteImage.contentMode = UIViewContentModeScaleAspectFill;
        voteImage.layer.masksToBounds = YES;

        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.InformationArr.count) {
            InforViewController *infor = [[InforViewController alloc]init];
            infor.detailid = self.InformationArr[indexPath.row][@"id"];
            [self.navigationController pushViewController:infor animated:YES];
        }
        
    }else if (indexPath.section == 4){
        SatisfactionListViewController *hot = [[SatisfactionListViewController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGFloat HH = 20;
        if (self.menuArr.count) {
            if (self.menuArr.count < 6) {
                HH += 90;
            }else{
                HH += (self.menuArr.count/4) * 90;
                if (self.menuArr.count%4 > 0) {
                    HH += 90;
                }
                
            }
        }
        if (![UserModel Certification]) {
            return HH += [UIImage imageNamed:@"qurenzheng"].size.height + 20;
        }
        return HH + 5;
    }else if(indexPath.section == 1){
        return 100;
    }else if(indexPath.section == 2){
        return 120;
    }else if(indexPath.section == 3){
        return SCREEN.size.width *2 /3.0;
    }else{
        
        return 120;
    }
    
}

#pragma mark - --- FSGridLayoutViewDelegate ---
-(void)FSGridLayouClickCell:(FSGridLayoutView *)flview itemDt:(NSDictionary *)itemDt{
    LFLog(@"itemDt:%@",itemDt);
    PreschoolHomeViewController *vc = [[PreschoolHomeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    return;
    if ([itemDt[@"ios"] isKindOfClass:[NSDictionary class]]) {
        UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:itemDt[@"ios"] controller:self];
        if (board == nil) {
            [self presentLoadingTips:@"信息读取失败！"];
        }
        return;
    }
}
//热门服务点击事件
-(void)imageviewClick:(IndexBtn *)btn{
    
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
    if ([self.serviceArr[btn.index - 33][@"ios"] isKindOfClass:[NSDictionary class]]) {
        UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:self.serviceArr[btn.index - 33][@"ios"] controller:self];
        if (board == nil) {
            [self presentLoadingTips:@"信息读取失败！"];
        }
        return;
    }
    NSString *name = [NSString stringWithFormat:@"%@",[self.serviceArr[btn.index - 33] objectForKey:@"navkey"]];
    
    if ([name isEqualToString:@"sqhd"]) {
        ActivityViewController *active = [[ActivityViewController alloc]init];
        [self.navigationController pushViewController:active animated:YES];
        return;
    }else if ([name isEqualToString:@"fwzs"]){
        LFLog(@"房屋租售");
        HouseRentingViewController *houser = [[HouseRentingViewController alloc]init];
        [self.navigationController pushViewController:houser animated:YES];
        
    }else if ([name isEqualToString:@"myddc"]){
        LFLog(@"满意度");
        
        SatisfactionListViewController *hot = [[SatisfactionListViewController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
        //        VolunteerServiceViewController *Volunteer = [[VolunteerServiceViewController alloc]init];//社区志愿者
        //        [self.navigationController pushViewController:Volunteer animated:YES];
        
        
    }else if ([name isEqualToString:@"sqst"]){
        LFLog(@"社区食堂");
        
        CateringViewController *hot = [[CateringViewController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
        
        
    }else if ([name isEqualToString:@"hyjg"]){
        LFLog(@"行业监管");
        IndustrySuperviseViewController *hot = [[IndustrySuperviseViewController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
        
        
    }else if ([name isEqualToString:@"zbsy"]){
        LFLog(@"周边商业");
        PeripheralBusinessViewController *hot = [[PeripheralBusinessViewController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
        
        
    }else if ([name isEqualToString:@"csxw"]){
        LFLog(@"城市新闻");
        CityNewsViewController *city = [[CityNewsViewController alloc]init];
        [self.navigationController pushViewController:city animated:YES];
        
        
    }else if ([name isEqualToString:@"yzwyh"]){
        LFLog(@"业主委员会");
        NSString *uid = [UserDefault objectForKey:@"useruid"];
        if (uid == nil) {
            [self presentLoadingTips:@"请您先进行业主认证"];
            return;
        }
        CommitteeViewController *com = [[CommitteeViewController alloc]init];
        com.urlstr = NSStringWithFormat(CommitteeUrl,uid);
        
        [self.navigationController pushViewController:com animated:YES];
        
    }else if ([name isEqualToString:@"runtime"]){
        //        NSDictionary *userinDt = @{@"type":@"runtime",@"ios_class":@"PayViewController"};
        UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:self.serviceArr[btn.index - 33] controller:self];
        if (board == nil) {
            [self presentLoadingTips:@"信息读取失败！"];
        }
        
    }else if ([name isEqualToString:@"runtime"]){
        LFLog(@"runtime");
        UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:self.serviceArr[btn.index - 33]  controller:self];
        if (board == nil) {
            [self presentLoadingTips:@"信息读取失败！"];
        }
    }
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        LFLog(@"拨打电话");
        
        NSURL *url = [NSURL URLWithString:@"tel:10086"];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

//更多点击事件
-(void)moreBtnClick:(IndexBtn *)btn{
    
    LFLog(@"点击更多");
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    if (btn.section == 1) {
        [self.navigationController pushViewController:[[InformationViewController alloc]init] animated:YES];
    }else if (btn.section == 2){
        SanjinListViewController *vc = [[SanjinListViewController alloc]init];
        vc.category_id =@"111";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.section == 3){
        [self.navigationController pushViewController:[[ActivityViewController alloc]init] animated:YES];
    }else if (btn.section == 4){
        [self.navigationController pushViewController:[[SatisfactionListViewController alloc]init] animated:YES];
    }
    
}


#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionview) {
        return self.menuArr.count;
    }else{
        return self.activityArr.count;
    }
    
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionview) {
        static NSString * CellIdentifier = @"UICollectionViewCell";
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        //
        UIImageView *imageveiw  = [[UIImageView alloc]init];
        imageveiw.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imageveiw];
//        NSString *url = [NSString string];
//        if (IS_IPHONE_6_PLUS) {
//            url = self.menuArr[indexPath.row][@"imgurl3"];
//        }else{
//            url = self.menuArr[indexPath.row][@"imgurl2"];
//        }
//
//        [imageveiw sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [imageveiw mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.offset(image.size.height);
//            }];
//        }];
        imageveiw.image = [UIImage imageNamed:self.menuArr[indexPath.row][@"image"]];
        [imageveiw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.centerX.equalTo(cell.contentView.mas_centerX);
            
            
        }];
        UILabel *lab  = [[UILabel alloc]init];
        lab.text = self.menuArr[indexPath.row][@"name"];
        lab.font = [UIFont systemFontOfSize:13];
        lab.textAlignment = NSTextAlignmentCenter;
        [lab setTextColor:[UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1]];
        lab.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(0);
            make.right.offset(0);
            make.top.equalTo(imageveiw.mas_bottom);
            make.bottom.offset(0);
            
        }];
        return cell;
    }else{
        
        ActivityItemCollectionViewCell * cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityHomeCollectionViewCell" forIndexPath:indexPath];
        NSString *url = [NSString string];
        if (IS_IPHONE_6_PLUS) {
            url = self.activityArr[indexPath.row][@"index_img"];
        }else{
            
            url = self.activityArr[indexPath.row][@"index_img"];
            
        }
        [cell.picture sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        cell.nameLb.text = self.activityArr[indexPath.row][@"content"];
        return cell;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionview) {
        CGFloat wid = 4;
        if (self.menuArr.count) {
            if (self.menuArr.count < 6) {
                wid = self.menuArr.count;
                
            }
        }
        
        return CGSizeMake((SCREEN.size.width-5)/wid, 90);

    }else{
        return CGSizeMake(SCREEN.size.width *8 /15.0, SCREEN.size.width *2 /3.0);
    }
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.collectionview) {
        return 0.001;
    }else{
        return 10;
    }
    
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.collectionview) {
        return 0.001;
    }else{
        return 10;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    //判断是否登录
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        return;
    }
//    PaymentNewViewController *hot = [[PaymentNewViewController alloc]init];
//    [self.navigationController pushViewController:hot animated:YES];
//    return;
    if (collectionView == self.collectionview) {
        NSString *name = [NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"name"]];
        NSLog(@"6554:%@",name);
        if ([name isEqualToString: @"(null)"]) {
            
            AttestViewController *att = [[AttestViewController alloc]init];
            
            [self.navigationController pushViewController:att animated:YES];
            return;
        }
//        if ([self.menuArr[indexPath.row][@"ios"] isKindOfClass:[NSDictionary class]]) {
//            UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:self.menuArr[indexPath.row][@"ios"] controller:self];
//            if (board == nil) {
//                [self presentLoadingTips:@"信息读取失败！"];
//            }
//            return;
//        }
        NSString *str = self.menuArr[indexPath.row][@"key"];
        if ([str isEqualToString:@"yzbx"]) {
            RepairsViewController * repair = [[RepairsViewController alloc]init];
            repair.tag = 101;
            repair.titlename = @"业主报修";
            [self.navigationController pushViewController:repair animated:YES];
            
        }else if ([str isEqualToString:@"yjkm"]){
            LFLog(@"手机开门");
            PhoneOpenDoorViewController *hot = [[PhoneOpenDoorViewController alloc]init];
            [self.navigationController pushViewController:hot animated:YES];
            
        }else if ([str isEqualToString:@"zxjf"]){
            LFLog(@"在线缴费");
            PayViewController *hot = [[PayViewController alloc]init];
            [self.navigationController pushViewController:hot animated:YES];
            
        }else if ([str isEqualToString:@"fwrx"]){
            LFLog(@"服务热线");
            HotlineViewController *hot = [[HotlineViewController alloc]init];
            [self.navigationController pushViewController:hot animated:YES];
            
        }else if ([str isEqualToString:@"xqqd"]){
            LFLog(@"小区圈电");
//            PhoneOpenDoorViewController *hot = [[PhoneOpenDoorViewController alloc]init];
//            [self.navigationController pushViewController:hot animated:YES];
            
        }else if ([str isEqualToString:@"gqbx"]){
            LFLog(@"公区报修");
            RepairsViewController * repair = [[RepairsViewController alloc]init];
            repair.tag = 101;
            repair.titlename = @"公区报修";
            repair.publicRepair =@"publicRepair";
            [self.navigationController pushViewController:repair animated:YES];
            
        }else if ([str isEqualToString:@"tsby"]){
            LFLog(@"表扬投诉");
            RepairsViewController *repair = [[RepairsViewController alloc]init];
            repair.tag = 102;
            repair.titlename = @"投诉表扬";
            [self.navigationController pushViewController:repair animated:YES];
            
        }else if ([str isEqualToString:@"wygs"]){
            LFLog(@"物业公示");
            APPheadlinesViewController *repair = [[APPheadlinesViewController alloc]init];
            [self.navigationController pushViewController:repair animated:YES];
            
        }else if ([str isEqualToString:@"runtime"]){
            //        NSDictionary *userinDt = @{@"type":@"runtime",@"ios_class":@"PayViewController"};
            UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:self.menuArr[indexPath.row] controller:self];
            if (board == nil) {
                [self presentLoadingTips:@"信息读取失败！"];
            }
            
        }
    }else{
        if (self.activityArr.count) {
            DetailsActivityController *infor = [[DetailsActivityController alloc]init];
            infor.detailid = self.activityArr[indexPath.row][@"id"];
            [self.navigationController pushViewController:infor animated:YES];
        }
    }
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
//头视图尺寸
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
//    if (collectionView == self.collectionview) {
//        if (self.InformationArr.count ) {
//            return CGSizeMake(SCREEN.size.width, 50);
//        }
//    }
    return CGSizeZero;
    
}
//底视图尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (collectionView == self.collectionview) {
        if (![UserModel Certification]) {
            return CGSizeMake(SCREEN.size.width, [UIImage imageNamed:@"qurenzheng"].size.height + 20);
        }
    }
     return CGSizeZero;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (collectionView == self.collectionview) {
        if (kind == UICollectionElementKindSectionHeader){
            UIView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeaderReuse" forIndexPath:indexPath];

            reusableview = (UICollectionReusableView *)headerV;
//            if (self.InformationArr.count) {
//                [reusableview removeAllSubviews];
//                [reusableview addSubview:self.sdCySV];
//                NSMutableArray *marr = [NSMutableArray array];
//                for (int i = 0; i < self.InformationArr.count ; i ++) {
//                    if (i%2 == 0) {
//                        [marr addObject:@""];
//                    }
//                }
//                self.sdCySV.imageURLStringsGroup = marr;
//            }

        }
        if (kind == UICollectionElementKindSectionFooter){
            UIView *footV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeFootReuse" forIndexPath:indexPath];
            reusableview = (UICollectionReusableView *)footV;
            [reusableview removeAllSubviews];
            if (![UserModel Certification]) {
                UIButton *cerBtn = [[UIButton alloc]init];
                [cerBtn addTarget:self action:@selector(cerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cerBtn setImage:[UIImage imageNamed:@"qurenzheng"] forState:UIControlStateNormal];
                [reusableview addSubview:cerBtn];
                [cerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(reusableview.mas_centerX);
                    make.centerY.equalTo(reusableview.mas_centerY);
                }];
            }
        }
        return reusableview;
    }else{
        reusableview =  [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"acHomeHeaderReuse" forIndexPath:indexPath];
    }
    return reusableview;
}

-(void)cerBtnClick:(UIButton *)btn{
    AttestViewController *att = [[AttestViewController alloc]init];
    
    [self.navigationController pushViewController:att animated:YES];

}

#pragma mark 轮播图数据
-(void)rotatePicture{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,HomeWheelUrl) params:dt success:^(id response) {
        LFLog(@"轮播图数据:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.pictureArr removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                [self.pictureArr addObject:dt];
            }
            [self.jwView removeFromSuperview];
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self ceratCycleScrollView];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}


#pragma mark 菜单数据
-(void)MenuData{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,HomeMenuUrl) params:dt success:^(id response) {
        LFLog(@"菜单数据:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
//            [self.menuArr removeAllObjects];
//            NSArray *arr = response[@"data"];
//
//            for (int i = 0; i < arr.count; i ++) {
//                [self.menuArr addObject:arr[i]];
//            }
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.tableView reloadData];
        [self.collectionview reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark 社区资讯
-(void)UploadDataisInformation{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session,@"pagination":@{@"count":@"2",@"page":@"1"}};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,HomeInformationListUrl) params:dt success:^(id response) {
        LFLog(@"社区资讯:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.InformationArr removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                [self.InformationArr addObject:dt];
            }
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark 金钥匙服务
-(void)UploadDataGold{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session,@"pagination":@{@"count":@"3",@"page":@"1"},@"category_id":@"111"};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,GoldenGoodsListUrl) params:dt success:^(id response) {
        LFLog(@"金钥匙服务:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.goldenArr removeAllObjects];
            [ImLbModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"imgurl":@"img"};
            }];
            for (NSDictionary *temDt in response[@"data"]) {
                ImLbModel *mo = [ImLbModel mj_objectWithKeyValues:temDt];
                mo.backcolor = @"F0F0F0";
                mo.data = temDt;
                mo.cornerRadius = @"3";
                [self.goldenArr addObject:mo];
            }
            [ImLbModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark 社区活动

-(void)activityUpdata{

    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSDictionary *pagination = @{@"count":@"8",@"page":@"1"};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"社区活动dt:%@",dt);

    //self.isJion
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ActivityListUrl) params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        LFLog(@"社区活动:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.activityArr removeAllObjects];
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dt in response[@"data"]) {
                    [self.activityArr addObject:dt];
                }
            }
            [self.tableView reloadData];
            [self.AcCollectionview reloadData];
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"社区活动error:%@",error);

        [_tableView.mj_header endRefreshing];
    }];

}
#pragma mark 房屋租售
-(void)housesArrUpdata{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSDictionary *pagination = @{@"count":@"8",@"page":@"1"};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"房屋租售dt:%@",dt);
    
    //self.isJion
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,HouseRentingListUrl) params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        LFLog(@"房屋租售:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.housesArr removeAllObjects];
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dt in response[@"data"]) {
                    [self.housesArr addObject:dt];
                }
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"房屋租售error:%@",error);
        
        [_tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark 服务
-(void)UploadDataisEmploy{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"json":session};
    [LFLHttpTool get:NSStringWithFormat(ZJShopBaseUrl,HomeServiceUrl) params:dt success:^(id response) {
        LFLog(@"服务数据:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.serviceArr removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                [self.serviceArr addObject:dt];
            }
            if (self.serviceArr.count == 4) {
                NSString *keystr = @"imgurl2";
                if (IS_IPHONE_6_PLUS) {
                    keystr = @"imgurl3";
                }
                self.jsonDt = @{@"images":@[@{@"children":@[@{@"image":self.serviceArr[0][keystr],@"data":self.serviceArr[0],@"weight":@1},
                                                            @{@"image":self.serviceArr[1][keystr],@"data":self.serviceArr[1],@"weight":@1},
                                                            @{@"image":self.serviceArr[2][keystr],@"data":self.serviceArr[2],@"weight":@1}],
                                              @"height":@130,@"orientation":@"h",@"Margins":@10,@"space":@10},
                                            @{@"children":@[@{@"image":self.serviceArr[3][keystr],@"data":self.serviceArr[3],@"weight":@1}],
                                              @"height":@120,@"orientation":@"h",@"Margins":@10,@"space":@10}]};
            }
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - *************YY天气查询*************
-(void)UploadDataYYWeather:(CLLocation *)location{
//    [self getDeviceIPIpAddresses:^(id IP) {
    NSMutableDictionary *dt = [NSMutableDictionary dictionary];
    if (location.coordinate.longitude > 0) {
        [dt setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"lon"];
        [dt setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"lat"];
    }else{
    
        LFLog(@"定位失败");
    }
    [LFLHttpTool get:ZJJHWeatherUrl params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        if (response[@"error_code"]) {
            NSString *str = [NSString stringWithFormat:@"%@",response[@"error_code"]];
            LFLog(@"YY天气查询：%@",response);
            if ([str isEqualToString:@"0"]) {
                [self.weatherArr addObject:response[@"result"]];
                [self.tableView reloadData];
                [self.collectionview reloadData];
            }
        }

    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];

//    }];

    
    
}

#pragma mark - *************版本更新*************
-(void)complainUploaddata{
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"98") params:nil success:^(id response) {
        [_tableView.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        LFLog(@"版本更：%@",response);
        if (![str isEqualToString:@"0"]) {
            [self AppStoreOfinfo:response[@"err_msg"]];
        }
        if (response[@"SelectIndex"]) {
            [UserDefault setInteger:[response[@"SelectIndex"] integerValue] forKey:@"tabarSelectIndex"];
        }
        
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - *************获取AppStore版本信息*************
- (void)AppStoreOfinfo:(NSString *)info
{
    [LFLHttpTool post:NSStringWithFormat(AppStoreUrl,@"1357016976") params:nil success:^(id response) {
        [_tableView.mj_header endRefreshing];
        NSArray *arr = response[@"results"];
        if (arr.count) {
            LFLog(@"AppStore：%@",response[@"results"][0][@"version"]);
            NSDictionary *dict = [[NSBundle mainBundle]infoDictionary];
            NSString *currentVersion = [NSString stringWithFormat:@"%@",[dict objectForKey:@"CFBundleShortVersionString"]];
            LFLog(@"版本信息：%@",currentVersion);
            if (![currentVersion isEqualToString:[NSString stringWithFormat:@"%@",response[@"results"][0][@"version"]]] ) {
                NSInteger interval = [[NSDate date] timeIntervalSince1970];
                NSInteger  loginTime = [[userDefaults objectForKey:@"AppStore"] integerValue];
                if (interval - loginTime > 86400) {
                    //                [UserDefault setObject:@"updateAppStore" forKey:@"AppStore"];
                    [UserDefault setInteger:interval forKey:@"AppStore"];
                    [self alertController:@"怡生活有新的版本可以更新了" prompt:info sure:@"确定" cancel:@"取消" success:^{
                        NSURL *url = [NSURL URLWithString:response[@"results"][0][@"trackViewUrl"]];
                        [[UIApplication  sharedApplication]openURL:url];
                    } failure:^{
                        
                    }];
                    
                }
                
            }else{
                
                [UserDefault removeObjectForKey:@"AppStore"];
                
            }

        }
        
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
}
#pragma mark - *************用户信息*************
-(void)refushUserInfo{
    [UserModel UploadDataUserInfo:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (response[@"data"][@"not_read"]) {
                if (self.alertbtn) {
                    self.alertbtn.alertLabel.textnum = [NSString stringWithFormat:@"%@",response[@"data"][@"not_read"]];
                }
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self refushUserInfo];;
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
            
        }
    } error:^(NSError *error) {
        
    }];
    
}
#pragma mark tabbar点击
-(void)tabbarDoubleClick:(BOOL)isDouble{
    if (isDouble) {//双击
    }
    [_tableView.mj_header beginRefreshing];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showTabbar];
    NSString *company = [UserDefault objectForKey:@"company"];
    if (company) {
//        [_titleView setImage:[UIImage imageNamed:@"xiaoqudingwei"] forState:UIControlStateNormal];
        [_titleView setTitle:[NSString stringWithFormat:@"  %@",company] forState:UIControlStateNormal];
    }else{
        [_titleView setImage:nil forState:UIControlStateNormal];
        [_titleView setTitle:@"物业服务" forState:UIControlStateNormal];
    }
    _titleView.width = [_titleView.titleLabel.text selfadap:17 weith:20].width + _titleView.imageView.image.size.width + 10;
    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
            if ([response isEqualToString:@"1"]) {
                
                if (![UserModel Certification]) {
                }else{
                    [self updata];
                }
                
            }
        }];
        
    }else{
            if (!self.pictureArr.count) {
                [self rotatePicture];
            }
            if (!self.menuArr.count) {
                [self MenuData];
            }
            if (!self.InformationArr.count) {
                [self UploadDataisInformation];
            }
            if (!self.serviceArr.count) {
                [self UploadDataisEmploy];
            }
            [self.collectionview reloadData];
        [self refushUserInfo];
    }
    if (@available(iOS 11.0, *)) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(0.2, dispatch_get_main_queue(), ^{
            [weakSelf scrollViewDidScroll:weakSelf.tableView];
        });
    } else {
        [self scrollViewDidScroll:self.tableView];
    }
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self hideTabbar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationColor:JHMaincolor animated:YES];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //    self.titleView.alpha = self.titleviewalph;
    self.isAppear = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isAppear = NO;
//    [self.navigationController setNavigationColor:self.navigationColor animated:NO];
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UINavigationController *na = (UINavigationController *)viewController;
    LFLog(@"viewController:%@",[na.topViewController class]);
    UIViewController *vc =((UINavigationController *)tabBarController.selectedViewController).topViewController;
    LFLog(@"selectedViewController:%@",[vc class]);
    if ([na.topViewController isKindOfClass:[HomeWorkViewController class]]) {
        if ( NO == [UserModel online] )
        {
            LoginViewController *login = [[LoginViewController alloc]init];
            [vc.navigationController pushViewController:login animated:YES];
            return NO;
        }
        if (![UserModel Certification]) {
            AttestViewController *att = [[AttestViewController alloc]init];
            [vc.navigationController pushViewController:att animated:YES];
            return NO;
        }
    }
    return YES;
}
@end

/*
 
 */
