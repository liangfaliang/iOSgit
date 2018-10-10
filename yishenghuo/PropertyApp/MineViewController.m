//
//  MineViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/4.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "MineViewController.h"
#import "testViewController.h"
#import "HomeWorkViewController.h"
#import "AttestViewController.h"
#import "EmployeeCertificationViewController.h"
#import "ExpressViewController.h"
#import "SendExpressViewController.h"
#import "QueryNationalViolationViewController.h"
#import "YYText.h"
#import "SetupPageViewController.h"
#import "KYCuteView.h"
#import "ShopNoPaymentViewController.h"
#import "PersonalCenterViewController.h"
#import "UIButton+WebCache.h"
#import "AlertsButton.h"
#import "JWCycleScrollView.h"
#import "APPheadlinesViewController.h"
#import "PushMessageViewController.h"
#import "SatisfactionListViewController.h"
#import "HouseRentingViewController.h"
#import "CommitteeViewController.h"
#import "PhoneOpenDoorViewController.h"//手机开门
#import "UserInfoViewController.h"//发帖个人中心
#import "ReleasePropertyViewController.h"//发布租房
#import "ActivityViewController.h"
#import "VehicleServiceViewController.h"//车辆管理
#import "MyWalletViewController.h"//钱包
#import "MyIntegralViewController.h"//积分
#import "InviteFriendsViewController.h"//邀请好友
#import "MyCouponViewController.h"//优惠券
#import "CouponExchangeViewController.h"//优惠券兑换
#import "CityNewsViewController.h"//城市新闻
#import "LoginViewController.h"
#import "MineHeaderView.h"
#import "ImTopBtn.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,JWCycleScrollImageDelegate,UITabBarControllerDelegate>
@property(nonatomic,strong)MineHeaderView *headerview;
@property (nonatomic,strong)UITableView * tableView;
//@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)NSMutableArray * titleArr;//文字轮播
@property (nonatomic, strong) NSArray *headerArray;
@property (nonatomic, strong) NSArray *userInfoArr;
@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) NSMutableArray *menuTwoArray;
@property (nonatomic, strong) NSMutableArray *menuTopArray;
@property (nonatomic, strong) NSArray *imagearr1;
@property (nonatomic, strong) NSArray *imagearr2;
@property (nonatomic, strong) NSArray *imagearr3;

@property (nonatomic, strong) NSArray *namearr1;
@property (nonatomic, strong) NSArray *namearr2;
@property (nonatomic, strong) NSArray *namearr3;

@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *locationLb;
@property (nonatomic, strong) UIButton *iconbtn;

@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, assign) CGFloat headerHeight;
@property(nonatomic,assign)BOOL isAppear;


@property(nonatomic,strong)AlertsButton *alertbtn;//推送提醒
@property (nonatomic, strong) JWCycleScrollView * jwViewlabel;//文字轮播
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tabBarController.delegate = self;
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
//    self.navigationItem.titleView =self.titleView;
    self.navigationBarTitle  = @"";
    self.navigationAlpha = 0;
    self.imagearr1 = @[@"yezhurenzheng",@"kuaiditongzhi",@"weizhangchaxun",@"daishoukuaidi"];
    self.imagearr2 = @[@"wodeshangcheng",@"wodejifen",@"wodeqianbao",@"youhuiquan",@"wodefatie",@"canjiadehuodong",@"fangwuzushoufabu"];//,@"yaoqinglinli"
    self.imagearr3 = @[@"yuangongrenzheng",@"yingjiyuan",@"guizhangzhidu",@"kaoqinshenqing"];
    self.namearr1 = @[@"业主认证",@"快递通知",@"违章查询",@"快递代收"];
    self.namearr2 = @[@"我的商城",@"我的积分",@"我的钱包",@"优惠券",@"我的发帖",@"我的活动",@"租售信息发布"];//,@"邀请邻里"
    self.namearr3 = @[@"员工认证",@"考勤申请",@"规章制度",@"应急预案"];
    self.headerArray = @[@"yezhufuwulan",@"shangchengfuwulan",@"wuyerenyuanfuwulan"];
    [self createTableview];
    [self menuData:PersonalCenterFwUrl];
    [self menuData:PersonalCenterGrUrl];
    [self menuData:PersonalCenterBottomMenuUrl];
    [self createTabbarItem];
    [self setupRefresh];
    [self serviceData];
    [Notification addObserver:self selector:@selector(updateState:)
                         name:USERNotifiLogin object:nil];
    [Notification addObserver:self selector:@selector(updateState:)
                         name:USERInfoChange object:nil];
    [Notification addObserver:self selector:@selector(RefreshPage:)
                                                 name:USERNotifiCancel object:nil];
}
- (NSMutableArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]init];
    }
    return _titleArr;
}
-(NSMutableArray *)menuArray{
    
    if (_menuArray == nil) {
        _menuArray = [[NSMutableArray alloc]init];
    }
    
    return _menuArray;
}
-(NSMutableArray *)menuTwoArray{
    
    if (_menuTwoArray == nil) {
        _menuTwoArray = [[NSMutableArray alloc]init];
    }
    
    return _menuTwoArray;
}
-(NSMutableArray *)menuTopArray{
    
    if (_menuTopArray == nil) {
        _menuTopArray = [[NSMutableArray alloc]init];
    }
    
    return _menuTopArray;
}
-(void)createTabbarItem{
 
    UIImage *btnim = [UIImage imageNamed:@"shezhi_ysh"];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnim.size.width, btnim.size.height)];
    [btn setImage:btnim forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    
    self.alertbtn = [[AlertsButton alloc]init];
    self.alertbtn.alertLabel.textnum = @"0";
    UIImage *im =[UIImage imageNamed:@"tuisongxiaoxi-2"];
    self.alertbtn.frame =CGRectMake(0, 0, im.size.width, im.size.height);
    [self.alertbtn setImage:im forState:UIControlStateNormal];
    [self.alertbtn addTarget:self action:@selector(rightPushClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.alertbtn];
    NSArray *itemArr = @[rightBtn,rightItem];
    self.navigationItem.rightBarButtonItems = itemArr;
    
}

-(void)leftItemClick:(UIBarButtonItem *)btn{
    LFLog(@"%@",[userDefaults objectForKey:NetworkReachability]);
    if ([userDefaults objectForKey:NetworkReachability]) {
        LFLog(@"leftItemClick");
    }
    
    //    [self presentLoadingTips:@"请稍后"];//菊花
    //    [self customViewExample];
}

-(void)rightPushClick:(AlertsButton *)btn{

    
    PushMessageViewController *set = [[PushMessageViewController alloc]init];
    [self.navigationController pushViewController:set animated:YES];
}

-(void)rightItemClick:(UIBarButtonItem *)btn{
    
    SetupPageViewController *set = [[SetupPageViewController alloc]init];
    [self.navigationController pushViewController:set animated:YES];
//    [[ShareSingledelegate sharedShareSingledelegate] ShareContent:self.view content:@"分享内容" title:@"分享标题" url:@"" image:[UIImage imageNamed:@"MBlogo"]];
    
}
-(void)createTableview{
    
//    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.width * 12/25)];
//    self.headerView.backgroundImage = [UIImage imageNamed:@"beijing_gerenzhongxin"];
//    self.headerView.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -NaviH, SCREEN.size.width, SCREEN.size.height + NaviH) style:UITableViewStyleGrouped];
    if (iOS11) {
        self.tableView.height -= 50;
    }
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.tableView.tableHeaderView  = self.headerview;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"D0informationTableViewCell" bundle:nil] forCellReuseIdentifier:@"cuscell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - --- delegate 视图委托 ---
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentInset.top + scrollView.contentOffset.y;
    CGFloat progress = offsetY / (self.headerHeight - 20);
    CGFloat progressChange = offsetY / (self.headerHeight - 64 - 44);
//    NSLog(@"%s, %f, %f, %f", __FUNCTION__ ,progressChange, progress, offsetY);
    if (self.isAppear) {
        if (progressChange >= 1) {
            
            [self.navigationController setNavigationAlpha:(progressChange - 1) animated:YES];
//            self.titleView.alpha = (progressChange - 1);
        }else {
            
//            self.titleView.alpha = 0;
            [self.navigationController setNavigationAlpha:0 animated:YES];
            
        }
    }
    
}
#pragma mark - --- getters and setters 属性 ---


- (UILabel *)titleView
{
    if (!_titleView) {
        CGFloat viewX = 0;
        CGFloat viewY = 0;
        CGFloat viewW = 0;
        CGFloat viewH = 44;
        _titleView = [[UILabel alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        _titleView.text = @"个人中心";
        _titleView.textColor = [UIColor whiteColor];
        [_titleView sizeToFit];
    }
    return _titleView;
}

- (CGFloat)headerHeight
{
    return SCREEN.size.width / 2;
}
-(MineHeaderView *)headerview{
    if (_headerview == nil) {
        _headerview = [[NSBundle mainBundle]loadNibNamed:@"MineHeaderView" owner:nil options:nil][0];
        _headerview.backgroundImage = [UIImage imageNamed:@"child_bg"];
        _headerview.grayView.backgroundImage = [UIImage imageNamed:@"huisebeijing"];
        _headerview.whiteView.backgroundImage = [UIImage imageNamed:@"baisebeijing"];
        _headerview.frame = CGRectMake(0, 0, SCREEN.size.width, 250);
    }
    return _headerview;
}
-(void)refeshHeaderItem:(NSArray *)menuarr{
    [self.headerview.btnView removeAllSubviews];
    if (menuarr.count) {
        for (int i = 0; i < menuarr.count; i ++) {
            ImTopBtn *button = [[ImTopBtn alloc]init];
            button.edgeInsetsStyle = MKButtonEdgeInsetsStyleTop;
            button.space = 10;
            button.index = i;
            button.backgroundColor = [UIColor whiteColor];
            [button addTarget:self action:@selector(ItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.headerview.btnView addSubview:button];
            button.frame = CGRectMake(i * (self.headerview.btnView.width/menuarr.count ), 0, self.headerview.btnView.width/menuarr.count, 60);
            [button sd_setImageWithURL:[NSURL URLWithString:menuarr[i][@"imgurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            [button setTitle:menuarr[i][@"name"] forState:UIControlStateNormal];
            [button setTitleColor:JHmiddleColor forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addSubview:button.imageView];
        }
        
    }
}
-(void)ItemButtonClick:(ImTopBtn *)btn{
    if ([self.menuTopArray[btn.index][@"ios"] isKindOfClass:[NSDictionary class]]) {
        UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:self.menuTopArray[btn.index][@"ios"] controller:self];
        if (board == nil) {
            [self presentLoadingTips:@"信息读取失败！"];
        }
        return;
    }
}
-(void)setName{
    NSString *headimage = [UserDefault objectForKey:@"userheadimage"];
    
    
    NSString *name = [UserDefault objectForKey:@"nickname"];
    NSString *po_name = [UserDefault objectForKey:@"po_name"];
    NSString *usernamec = [UserDefault objectForKey:@"usernamec"];
    NSString *company = [UserDefault objectForKey:@"company"];
    LFLog(@"po_name:%@",po_name);
    LFLog(@"headimage:%@",headimage);
    if (headimage.length > 0) {
        [self.headerview.iconIm sd_setImageWithURL:[NSURL URLWithString:headimage] placeholderImage:[UIImage imageNamed:@"gerentouxiang"]];
    }
    
    _locationLb.text = nil;
    _nameLb.text = @"未登录";
    if (name) {
        self.headerview.nameLb.text = name;
        self.headerview.adressLb.text = po_name;
//        _nameLb.text =name;
//        _locationLb.text = po_name;
    }else{
        if ( usernamec )
        {
            self.headerview.nameLb.text = usernamec;
//            _nameLb.text = usernamec;
            if (po_name) {
                self.headerview.adressLb.text = po_name;
//                _locationLb.text = po_name;
            }else{
                self.headerview.adressLb.text = nil;
//                _locationLb.text = nil;
            }
        }else{
            self.headerview.nameLb.text = @"未登录";
            self.headerview.adressLb.text = nil;
//            _locationLb.text = nil;
//            _nameLb.text = @"未登录";
        }
    }
    if (company) {
        _titleView.text = [NSString stringWithFormat:@"%@",company];
    }else{
        _titleView.text = @"个人服务";
    }
}
#pragma mark 点击头像
-(void)iconBtnclick{
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
    
//    for(NSString *familyName in [UIFont familyNames])
//    {
//        NSLog(@"%@",familyName);
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
//        for(NSString *fontName in fontNames)
//        {
//            NSLog(@"\t|- %@",fontName);//打印系统所有已注册的字体名称
//        }
//    }
    PersonalCenterViewController *per = [[PersonalCenterViewController alloc]init];
    [self.navigationController pushViewController:per animated:YES];
    

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.menuTwoArray.count;
    }else if (section == 3){
        return 3;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 40;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = [UIColor whiteColor];
        YYLabel *nameLb = [[YYLabel alloc]init];
        nameLb.textColor = JHdeepColor;
        nameLb.font = [UIFont systemFontOfSize:20];
        nameLb.numberOfLines = 0;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"我的商城 |订单查询商品评价"];;
        NSString *attstring = @"|订单查询商品评价";
        text.yy_font = [UIFont boldSystemFontOfSize:15];
        NSRange range =[[text string]rangeOfString:attstring];
        text.yy_color = JHdeepColor;
        [text yy_setFont:[UIFont systemFontOfSize:13] range:range];
        [text yy_setColor:JHmiddleColor range:range];
        nameLb.attributedText = text;
        [header addSubview:nameLb];
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.top.offset(0);
            make.bottom.offset(0);
        }];
        
        return header;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( indexPath.section == 1|| indexPath.section == 3) {
        return 50;
    }
    if (self.menuArray.count) {
        return SCREEN.size.width/4;
    }
    return 0.001 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ldcell",(long)indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *rightimage = [cell viewWithTag:3333];
    if (rightimage == nil) {
        rightimage = [[UIImageView alloc]init];
        rightimage.tag = 3333;
        rightimage.image = [UIImage imageNamed:@"gerenzhongxinjiantou"];
        
    }
    if (indexPath.section == 0 || indexPath.section == 10) {
        cell.contentView.backgroundColor = JHColor(229, 229, 229);
        [cell.contentView removeAllSubviews];
        NSArray *menuarr = [NSArray array];
        if (indexPath.section == 0) {
            menuarr = self.menuArray;
        }else{
            menuarr = self.menuTwoArray;
        }
            for (int i = 0; i < menuarr.count; i ++) {
                IndexBtn *button = [[IndexBtn alloc]init];
                button.backgroundColor = [UIColor whiteColor];
                button.index = indexPath.section * 20 + i + 10;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
                UIImageView *imageview = [[UIImageView alloc]init];
                [imageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
                imageview.contentMode =  UIViewContentModeScaleAspectFit;
                [imageview sd_setImageWithURL:menuarr[i][@"imgurl"] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                [button addSubview:imageview];
                [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.offset(10);
                    make.centerX.equalTo(button.mas_centerX);
                    
                }];
                button.frame = CGRectMake(i * (SCREEN.size.width/menuarr.count ), 0, SCREEN.size.width/menuarr.count, SCREEN.size.width/4);
                UILabel *lb = [[UILabel alloc]init];
                lb.text = menuarr[i][@"name"];
                lb.tag = indexPath.section * 20 + i + 200;
                lb.textAlignment = NSTextAlignmentCenter;
                lb.font = [UIFont systemFontOfSize:12];
                lb.textColor = JHColor(51, 51, 51);
                [button addSubview:lb];
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(imageview.mas_bottom).offset(5);
                    make.centerX.equalTo(button.mas_centerX);
                    make.left.offset(0);
                    make.right.offset(0);
                    make.bottom.offset(-15);
                }];
                
                
            }
        
        
    }else if (indexPath.section == 10){//APP头条
//        NSString *CellIdentifier2 = @"twocell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UIView *bview = [self.view viewWithTag:889];
//        if (bview == nil) {
//            bview = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN.size.width, 59)];
//            bview.tag = 889;
//            bview.backgroundColor = [UIColor whiteColor];
//            [cell.contentView addSubview:bview];
//            
//        }
//        UIImageView *imageview = [self.view viewWithTag:890];
//        if (imageview == nil) {
//            imageview = [[UIImageView alloc]init];
//            imageview.tag = 890;
//            imageview.contentMode = UIViewContentModeScaleAspectFit;
//            imageview.image = [UIImage imageNamed:@"apptoutiao"];
//            [bview addSubview:imageview];
//            [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.offset(15);
//                make.centerY.equalTo(bview.mas_centerY);
//                
//            }];
//        }
//        
//        _jwViewlabel = nil;
//        if (_jwViewlabel == nil) {
//            _jwViewlabel=[[JWCycleScrollView alloc]initWithFrame:CGRectMake(75, 0, SCREEN.size.width-75, 59)];
//            _jwViewlabel.contentType=contentTypeText;
//            _jwViewlabel.jwtextFont=[UIFont systemFontOfSize:13];
//            _jwViewlabel.showPageControl = NO;
//            _jwViewlabel.jwtextcolor = JHColor(51, 51, 51);
//            _jwViewlabel.delegate=self;
//            _jwViewlabel.jwCycleScrollDirection = JWCycleScrollDirectionVertical; //纵向
//            [bview addSubview:_jwViewlabel];
//        }
//        
//        //    _jwViewlabel.textAlignment = NSTextAlignmentCenter;
//        NSMutableArray *marray = [[NSMutableArray alloc]init];
//        if (self.titleArr.count == 0) {
//            
//        }else{
//            
//            for (int i = 0; i < self.titleArr.count; i ++) {
//                NSDictionary *dt = self.titleArr[i];
//                if (i%2 == 0) {
//                    [_jwViewlabel.lablearr1 addObject:[dt objectForKey:@"title"]];
//                    [marray addObject:[dt objectForKey:@"title"]];
//                }else{
//                    [_jwViewlabel.lablearr2 addObject:[dt objectForKey:@"title"]];
//                    
//                }
//            }
//            
//            
//        }
//        LFLog(@"marray:%@",marray);
//        _jwViewlabel.textH = 10;//文字行间距
//        _jwViewlabel.jwTextArray = marray;
//        
//        
//        
//        
//        
//        // 开始轮播
//        [_jwViewlabel startAutoCarousel];
//        
//        
//        return cell;
//
        
    }else if (indexPath.section == 1){
        cell.textLabel.text = self.menuTwoArray[indexPath.row][@"name"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor =JHColor(51, 51, 51);
        NSString *url = [NSString string];
        if (IS_IPHONE_6_PLUS) {
            url = self.menuTwoArray[indexPath.row][@"imgurl3"];
        }else{
            url = self.menuTwoArray[indexPath.row][@"imgurl2"];
        }
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
        [cell.contentView addSubview:rightimage];
        [rightimage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.offset(-10);
            make.centerY.equalTo(cell.mas_centerY);
            
        }];
//        UILabel *lb = [self.view viewWithTag: indexPath.row + 400];
//        if (lb == nil) {
//            lb  = [[UILabel alloc]init];
//            lb.backgroundColor = [UIColor clearColor];
//            lb.userInteractionEnabled = YES;
//            lb.tag = indexPath.row + 400;
//            [cell.contentView addSubview:lb];
//            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(rightimage.mas_left).offset(-5);
//                make.centerY.equalTo(cell.contentView.mas_centerY);
//                make.width.offset(30);
//                make.height.offset(30);
//                
//            }];
//            
//        }
//        
//        KYCuteView *cutview0 = [self.view viewWithTag: 300 + indexPath.row];
//        if (cutview0 == nil) {
//            cutview0 = [[KYCuteView alloc]initWithPoint:CGPointMake(7.5, 5) superView:lb];
//            cutview0.tag = 300 + indexPath.row;
//            cutview0.viscosity  = 20;
//            cutview0.bubbleWidth = 20;
//            cutview0.bubbleColor = [UIColor redColor];
//            [cutview0 setUp];
//            cutview0.frontView.hidden = YES;
//            cutview0.bubbleLabel.font = [UIFont systemFontOfSize:12];
//    
//        }
        
    }else if (indexPath.section == 3){
        cell.textLabel.text = self.namearr3[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor =JHColor(51, 51, 51);
        cell.imageView.image = [UIImage imageNamed:self.imagearr3[indexPath.row]];
        [cell.contentView addSubview:rightimage];
        [rightimage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.offset(-10);
            make.centerY.equalTo(cell.mas_centerY);
            
        }];
    }
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    return cell;
}

-(void)buttonClick:(IndexBtn *)btn{
    
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
    NSDictionary *dt = [NSDictionary dictionary];
    if (btn.tag - 10 < 20) {
        dt = self.menuArray[btn.index - 10];dt = self.menuArray[btn.index - 10];
    }else{
        dt = self.menuTwoArray[btn.index - 10 - 20];
    }
    if ([dt[@"ios"] isKindOfClass:[NSDictionary class]]) {
        UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:dt[@"ios"] controller:self];
        if (board == nil) {
            [self presentLoadingTips:@"信息读取失败！"];
        }
        return;
    }
    NSString *name = [NSString stringWithFormat:@"%@",dt[@"keyword"]];
 
    if ([name isEqualToString:@"zwygrz"]) {
        LFLog(@"员工认证");
        EmployeeCertificationViewController *employ = [[EmployeeCertificationViewController alloc]init];
        [self.navigationController pushViewController:employ animated:YES];
        //        AttestViewController *att = [[AttestViewController alloc]init];
        //        [self.navigationController pushViewController:att animated:YES];
        return;
    }else if ([name isEqualToString:@"yzrz"]){
        LFLog(@"业主认证");
        AttestViewController *att = [[AttestViewController alloc]init];
        [self.navigationController pushViewController:att animated:YES];

    }else if ([name isEqualToString:@"kdtz"]){
        LFLog(@"快递通知");
        
        ExpressViewController *att = [[ExpressViewController alloc]init];
        [self.navigationController pushViewController:att animated:YES];
        
    }else if ([name isEqualToString:@"clfw"]){//clfw
        LFLog(@"车辆服务");
        VehicleServiceViewController *att = [[VehicleServiceViewController alloc]init];
        [self.navigationController pushViewController:att animated:YES];
        
    }else if ([name isEqualToString:@"kdds"]){
        LFLog(@"发送快递");
        [self presentLoadingTips:nil];
        [self expresssubtimeData];
        
    }else if ([name isEqualToString:@"shjf"]){
        
        LFLog(@"生活缴费");
        PhoneOpenDoorViewController *hot = [[PhoneOpenDoorViewController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
        
    }else if ([name isEqualToString:@"fwzs"]){
        LFLog(@"房屋租售");
        HouseRentingViewController *houser = [[HouseRentingViewController alloc]init];
        [self.navigationController pushViewController:houser animated:YES];

        
    }else if ([name isEqualToString:@"csxw"]){
        LFLog(@"城市新闻");
        
        CityNewsViewController *hot = [[CityNewsViewController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
        
    }else if ([name isEqualToString:@"myddc"]){
        LFLog(@"满意度");
        
        SatisfactionListViewController *hot = [[SatisfactionListViewController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
        
    }else if ([name isEqualToString:@"sjkm"]){
        LFLog(@"手机开门");
        
        PhoneOpenDoorViewController *hot = [[PhoneOpenDoorViewController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
        
    }else if ([name isEqualToString:@"jrfw"]){
        LFLog(@"金融服务");
        
        PhoneOpenDoorViewController *hot = [[PhoneOpenDoorViewController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
        
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
        LFLog(@"runtime");
        UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:self.menuArray[btn.index - 10] controller:self];
        if (board == nil) {
            [self presentLoadingTips:@"信息读取失败！"];
        }
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        return;
    }
    
    if (indexPath.section == 1) {
        if ([self.menuTwoArray[indexPath.row][@"ios"] isKindOfClass:[NSDictionary class]]) {
            UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:self.menuTwoArray[indexPath.row][@"ios"] controller:self];
            if (board == nil) {
                [self presentLoadingTips:@"信息读取失败！"];
            }
            return;
        }
        if (indexPath.row == 0) {
            ShopNoPaymentViewController *pay = [[ShopNoPaymentViewController alloc]init];//商城
            pay.selecIndex = 0;
            pay.titlename = @"我的订单";
            [self.navigationController pushViewController:pay animated:YES];
            
        }else if (indexPath.row == 1){
            
            MyIntegralViewController *room= [[MyIntegralViewController alloc]init];//积分
            [self.navigationController pushViewController:room animated:YES];
        }else  if (indexPath.row == 2) {
            MyWalletViewController *pay = [[MyWalletViewController alloc]init];//钱包
            [self.navigationController pushViewController:pay animated:YES];
        }else if (indexPath.row == 3){
            CouponExchangeViewController *room= [[CouponExchangeViewController alloc]init];//优惠券
            [self.navigationController pushViewController:room animated:YES];
        }else if (indexPath.row == 40){
            
            InviteFriendsViewController *room= [[InviteFriendsViewController alloc]init];//邀请好友
            [self.navigationController pushViewController:room animated:YES];
        }else if (indexPath.row == 4){
            UserInfoViewController *user= [[UserInfoViewController alloc]init];//发帖
            [self.navigationController pushViewController:user animated:YES];

        }else if (indexPath.row == 5){
            
            ActivityViewController *active = [[ActivityViewController alloc]init];//参加的活动
            active.isJion =ActivityJionListUrl;
            [self.navigationController pushViewController:active animated:YES];
        }else if (indexPath.row == 6){

            ReleasePropertyViewController *room= [[ReleasePropertyViewController alloc]init];//房屋租售
            [self.navigationController pushViewController:room animated:YES];
        }else{
            
            PhoneOpenDoorViewController *hot = [[PhoneOpenDoorViewController alloc]init];
            [self.navigationController pushViewController:hot animated:YES];
        }
        
        
    }
    
    
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    UIView *header = [[UIView alloc]init];
//    if (section == 2) {
//        
//        UIImageView *imageline = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_headerArray[section]]];
//        [header addSubview:imageline];
//        [imageline mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.offset(10);
//            make.centerY.equalTo(header.mas_centerY).offset(0);
//            
//            //      make.width.mas_equalTo(imageline.mas_height).multipliedBy(1);
//        }];
//        
//        header.backgroundColor = [UIColor whiteColor];
        
//    }
//    return header;
//    
//    
//}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIImageView *view = [[UIImageView alloc]init];
    view.image = [UIImage imageNamed:@"fengexiantongyong"];
    
    return view;
    
}
-(void)cycleScrollView:(JWCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index
{
    
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
  if (cycleScrollView == _jwViewlabel){
        
        APPheadlinesViewController *app = [[APPheadlinesViewController alloc]init];
        app.dataArray = self.titleArr;
        [self.navigationController pushViewController:app animated:YES];
        
        
    }
}

#pragma mark 数据提交
-(void)expresssubtimeData{
    NSString *usid = [UserDefault objectForKey:@"useruid"];
    if (usid == nil) {
        usid = @"";
    }
    LFLog(@"usid:%@",usid);
    NSDictionary *dt = @{@"userid":usid};
    
    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"61") params:dt success:^(id response) {

        LFLog(@"response:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            [self dismissTips];
            SendExpressViewController *send = [[SendExpressViewController alloc]init];
            [self.navigationController pushViewController:send animated:YES];
//            [self.stack pushBoard:[SendExpressViewController board] animated:YES];
            
        }else{
            [self dismissTips];
            [self presentLoadingTips:@"您尚不能代收快递"];
            
        }

        
    } failure:^(NSError *error) {
    [self presentLoadingTips:@"您尚不能代收快递"];
    }];
    
    
}
#pragma mark 菜单数据
-(void)menuData:(NSString *)urlstr{
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,urlstr) params:nil success:^(id response) {
        [self.tableView.mj_header endRefreshing];
        LFLog(@"菜单数据:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                if ([urlstr isEqualToString:PersonalCenterGrUrl]) {
                    [self.menuArray removeAllObjects];
                    for (NSDictionary *dt in response[@"data"]) {
                        [self.menuArray addObject:dt];
                    }
                    [self.tableView reloadData];
                }else if ([urlstr isEqualToString:PersonalCenterFwUrl]) {
                    [self.menuTopArray removeAllObjects];
                    for (NSDictionary *dt in response[@"data"]) {
                        [self.menuTopArray addObject:dt];
                    }
                    [self refeshHeaderItem:response[@"data"]];
                }else{
                    [self.menuTwoArray removeAllObjects];
                    for (NSDictionary *dt in response[@"data"]) {
                        [self.menuTwoArray addObject:dt];
                    }
                    [self.tableView reloadData];
                }

            }
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
    } failure:^(NSError *error) {
  [self.tableView.mj_header endRefreshing];
    }];
    
    
}
#pragma mark 文字轮播
-(void)serviceData{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid};
    
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"21") params:dt success:^(id response) {
        LFLog(@"文字轮播:%@",response);
        [_tableView.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            [self.titleArr removeAllObjects];
            for (NSDictionary *dt in response[@"note"]) {
                
                [self.titleArr addObject:dt];
                
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - *************用户信息*************
-(void)refushUserInfo{
    [UserModel UploadDataUserInfo:^(id response) {
        [self.tableView.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            self.userInfoArr = response[@"data"];
            if ([response[@"data"][@"activity_info"] isKindOfClass:[NSDictionary class]]) {
                self.headerview.activity_info = response[@"data"][@"activity_info"];
                [self.headerview.activiBtn setTitle:response[@"data"][@"activity_info"][@"title"] forState:UIControlStateNormal];
            }
            if ([response[@"data"][@"user_money"] isKindOfClass:[NSString class]]) {
                [UserDefault setObject:response[@"data"][@"user_money"]  forKey:@"user_money"];//用户余额
                [UserDefault setObject:response[@"data"][@"pay_points"] forKey:@"user_pay_points"];//用户积分
                [UserDefault setObject:response[@"data"][@"rank_name"] forKey:@"user_rank_name"];//用户等级名称
                [UserDefault setObject:response[@"data"][@"rank_level"] forKey:@"user_rank_level"];//用户等级
            }
            
            if (response[@"data"][@"not_read"]) {
                self.alertbtn.alertLabel.textnum = [NSString stringWithFormat:@"%@",response[@"data"][@"not_read"]];
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
        [self.tableView.mj_header endRefreshing];
    }];
    
}
#pragma mark 通知刷新
//注销
-(void)updateState:(NSNotification*)notify{
//    if ([[notify.userInfo objectForKey:@"login"]isEqualToString:@"succeed"]) {
        [self setName];
//    }
}
//登陆
-(void)RefreshPage:(NSNotification*)notify{
//    LFLog(@"notify:%@",notify.userInfo);
    NSArray *keyarr = @[@"await_pay",@"shipped",@"comment",@"finished"];
    NSDictionary *dt = notify.userInfo[@"order_num"];
    LFLog(@"notify:%@",dt);
    if (dt.count) {
        for (int i = 0 ; i < 4; i ++) {
            LFLog(@"notify:%@",[dt objectForKey:keyarr[i]]);
            KYCuteView *cutview0 = [self.view viewWithTag: 300 + i];
            cutview0.bubbleLabel.text = [NSString stringWithFormat:@"%@",[dt objectForKey:keyarr[i]]];
            if (![cutview0.bubbleLabel.text isEqualToString:@"0"]) {
                cutview0.frontView.hidden = NO;
            }else{
            cutview0.frontView.hidden = YES;
            }
            

        }
    }
    [self setName];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showTabbar];
    [self refushUserInfo];
    [self setName];
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
//    [self.navigationController setNavigationAlpha:1.0 animated:YES];
    //    [self.navigationController.navigationBar st_reset];
    //    self.titleviewalph = self.titleView.alpha;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //    self.titleView.alpha = self.titleviewalph;
    self.isAppear = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationAlpha:1.0 animated:YES];
    //    [self.navigationController.navigationBar st_reset];
    self.isAppear = NO;
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self menuData:PersonalCenterGrUrl];
        [self menuData:PersonalCenterFwUrl];
        [self menuData:PersonalCenterBottomMenuUrl];
        [self refushUserInfo];
    }];
    
    
}

@end
