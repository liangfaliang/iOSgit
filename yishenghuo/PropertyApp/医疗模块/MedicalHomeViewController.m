//
//  MedicalHomeViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/9.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MedicalHomeViewController.h"
#import "JWCycleScrollView.h"
#import "HomeWorkViewController.h"
#import "LoginViewController.h"
#import "AttestViewController.h"
#import "HealthEducateViewController.h"//健康教育
#import "MedicalPlanTableViewCell.h"
#import "HealthEducateListTableViewCell.h"
#import "FSTableViewCell.h"
#import "SPPageMenu.h"
#import "MJExtension.h"
#import "HealthEducateDetailViewController.h"//健康教育详情
#import "MedicalExaminationListViewController.h"//预约体检
#import "HealthRecordsFirstViewController.h"//健康档案
#import "HealthMyRecordsViewController.h"//健康档案记录
#import "ChildCareHomeViewController.h"//儿童保健
#import "FileQueryHomeViewController.h"//档案查询
#import "MedicalViewController.h"
#define headerHt SCREEN.size.width * 12/25
@interface MedicalHomeViewController ()<UITableViewDelegate,UITableViewDataSource,JWCycleScrollImageDelegate,UIScrollViewDelegate,UITabBarControllerDelegate,SPPageMenuDelegate,FSGridLayoutViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
{
    UIView *MenuFatherview;
}
@property (nonatomic,strong)UICollectionView * collectionview;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) JWCycleScrollView * jwView;
@property (nonatomic,strong)NSMutableArray *pictureArr;
@property (nonatomic,strong)NSMutableDictionary *dataDict;
@property (nonatomic, strong) NSDictionary *jsonDt;//栅格cell
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong) NSMutableArray *categoryListArr;
@property (nonatomic, strong) NSArray *menuArr;
@property(nonatomic,strong)UISearchBar *searchbar;
@end

@implementation MedicalHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"医疗首页";
//    NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%d",3] ofType:@"txt"];
//    NSDictionary *temdt = @{@"images":@[@{@"children":@[@{@"image":@"https://i.huim.com/miaoquan/14966511524892.SS2!/both/300x300/unsharp/true",@"weight":@1},@{@"children":@[@{@"image":@"https://i.huim.com/miaoquan/14963170206106.jpg!/both/300x300/unsharp/true",@"weight":@1},@{@"image":@"https://i.huim.com/miaoquan/14968041079523.jpg!/compress/true/both/300x300",@"weight":@1}],@"weight":@2,@"orientation":@"v"}],@"height":@212,@"orientation":@"h"}]};
//    self.jsonStr=[self dictionaryToJson:temdt];
//    self.jsonStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self createSearch];
    [self createUI];
    [self requestDetailData];
    [self requestCategoryData];
    
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (NSMutableDictionary *)dataDict
{
    if (!_dataDict) {
        _dataDict = [[NSMutableDictionary alloc]init];
    }
    return _dataDict;
}
-(NSArray *)menuArr{
    if (!_menuArr) {
        _menuArr = [NSArray array];
    }
    return _menuArr;
}
- (NSMutableArray *)pictureArr
{
    if (!_pictureArr) {
        _pictureArr = [[NSMutableArray alloc]init];
    }
    return _pictureArr;
}
- (NSMutableArray *)categoryArr
{
    if (!_categoryArr) {
        _categoryArr = [[NSMutableArray alloc]init];
    }
    return _categoryArr;
}
- (NSMutableArray *)categoryListArr
{
    if (!_categoryListArr) {
        _categoryListArr = [[NSMutableArray alloc]init];
    }
    return _categoryListArr;
}
-(void)createSearch{
    self.searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width - 120, 40)];
    self.searchbar.layer.cornerRadius = 5;
    self.searchbar.layer.masksToBounds = YES;
    self.searchbar.placeholder = @"  输入疾病|药品|症状|医生|检查";
    UITextField *searchField = [self.searchbar valueForKey:@"_searchField"];
    if (searchField) {
        [searchField setValue:JHmiddleColor forKeyPath:@"_placeholderLabel.textColor"];
        [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    }
    [self.searchbar setImage:[UIImage imageNamed:@"sousuoshangcheng"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.searchbar.delegate = self;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    [_searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"sousuokuangshangcheng"] forState:UIControlStateNormal];
    UIView *seachview = [[UIView alloc]initWithFrame:CGRectMake(60, 20, SCREEN.size.width - 120, 40)];
    [seachview addSubview:_searchbar];
    if (iOS11) {
        self.navigationItem.titleView = seachview;
    }else{
        self.navigationItem.titleView = _searchbar;
    }
    //    UIBarButtonItem *bt = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick:)];
    //    bt.tintColor = JHshopMainColor;
    //    self.navigationItem.rightBarButtonItem = bt;
    
}
-(void)createUI{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerHt)];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
    if (iOS11) {
        self.tableView.height = SCREEN.size.height - 50;
    }
    //    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -64, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableHeaderView  = self.headerView;
    self.tableView.separatorColor = JHColor(222, 222, 222);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MedicalPlanTableViewCell" bundle:nil] forCellReuseIdentifier:@"MedicalPlanTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HealthEducateListTableViewCell" bundle:nil] forCellReuseIdentifier:@"HealthEducateHomecell"];
    [self.tableView registerClass:[FSTableViewCell class] forCellReuseIdentifier:@"HomeFSCell"];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
    [self ceratCycleScrollView];
    
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
#pragma mark - --- delegate 视图委托 ---
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentInset.top + scrollView.contentOffset.y ;
    //    CGFloat progress = offsetY / (self.headerHeight - 20);
    CGFloat progressChange = offsetY / (SCREEN.size.width / 2 - (kDevice_Is_iPhoneX ? 84 :64) - 44);
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
               
            }
        }
        
    }
}

-(SPPageMenu *)pageMenu{
    if (_pageMenu == nil) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, screenW - [UIImage imageNamed:@"gengduo_jt"].size.width - 20, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLineLongerThanItem];
        _pageMenu.tracker.backgroundColor = JHMedicalColor;
        // 传递数组，默认选中第1个
        // 可滑动的自适应内容排列
        _pageMenu.permutationWay = SPPageMenuPermutationWayScrollAdaptContent;
        // 设置代理
        _pageMenu.selectedItemTitleColor = JHMedicalColor;
        _pageMenu.unSelectedItemTitleColor = JHmiddleColor;
        _pageMenu.delegate = self;
      
    }
    return _pageMenu;
}
#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
    
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    if (toIndex < self.categoryArr.count) {
        [self requestcategoryListData:self.categoryArr[toIndex][@"id"]];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        if (!(self.dataDict && [self.dataDict[@"gh"] isKindOfClass:[NSDictionary class]])) {
            return 0;
        }
    }
    if (section == 2) {
        if (!self.menuArr.count) {
            return 0;
        }
    }
    if (section == 3) {
        if (!self.jsonDt) {
            return 0;
        }
    }
    if (section == 4) {
        return self.categoryListArr.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIImageView *view = [[UIImageView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.image = [UIImage imageNamed:@"fengexiantongyong"];
//    if (section == 0 && !self.categoryArr.count) {
//        view.image = nil;
//    }else if (section == 1 && !self.InformationArr.count) {
//        view.image = nil;
//    }else if (section == 2 && !self.serviceArr.count) {
//        view.image = nil;
//    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return 40;
    }
    return 0.00l;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==4) {
//
        if (MenuFatherview == nil) {
            MenuFatherview = [[UIView alloc]init];
            MenuFatherview.backgroundColor = [UIColor whiteColor];
            [MenuFatherview addSubview:self.pageMenu];
            UIButton *moreBtn = [[UIButton alloc]init];
            [moreBtn setImage:[UIImage imageNamed:@"gengduo_jt"] forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [MenuFatherview addSubview:moreBtn];
            [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-10);
                make.centerY.equalTo(MenuFatherview.mas_centerY);
            }];
        }
        
        return MenuFatherview;
    }
    return [[UIView alloc]init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MedicalPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MedicalPlanTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.weekLb.text = @" 周一 ";
        return cell;
    }else if (indexPath.section == 1) {
        NSString *CellIdentifier3 = @"threecell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell.contentView removeAllSubviews];
        UIImageView *imview = [[UIImageView alloc]init];
        imview.contentMode = UIViewContentModeScaleAspectFill;
        if ((self.dataDict && [self.dataDict[@"gh"] isKindOfClass:[NSDictionary class]])) {
            NSString *url = self.dataDict[@"gh"][@"imgurl2"];
            if (IS_IPHONE_6_PLUS) {
                url = self.dataDict[@"gh"][@"imgurl3"];
            }
            if ([url isKindOfClass:[NSString class]] && url.length) {
                [imview sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            }
        }
        imview.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:imview];
        [imview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.top.offset(0);
        }];
        return cell;
        
    }else if (indexPath.section == 2) {
        NSString *CellIdentifier3 = @"threecell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.collectionview == nil) {
            UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
            
            flowLayout.itemSize = CGSizeMake((SCREEN.size.width-5)/self.menuArr.count, 90);
            flowLayout.minimumInteritemSpacing = 10;
            flowLayout.minimumLineSpacing = 1;
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width,90) collectionViewLayout:flowLayout];
            self.collectionview.dataSource=self;
            self.collectionview.delegate=self;
            [self.collectionview setBackgroundColor:[UIColor clearColor]];
            self.collectionview.scrollEnabled = NO;
            [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        }
        [cell.contentView addSubview:_collectionview];
        [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.bottom.offset(0);
            make.right.offset(0);
        }];
        return cell;
        
    }else if (indexPath.section == 3) {
        FSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFSCell"];
        cell.json = self.jsonDt;
        cell.layoutView.delegate = self;//必须放在json赋值之后
        return cell;
        
    }else {
        HealthEducateListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthEducateHomecell"];
        NSDictionary *dt = self.categoryListArr[indexPath.row];
        [cell.picture sd_setImageWithURL:[NSURL URLWithString:dt[@"index_img"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        cell.contentLb.text = dt[@"title"];
//        cell.sourceLb.text = [NSString stringWithFormat:@"%@        %@条评论",dt[@"author"],dt[@"comment_count"]];
        return cell;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 80;
    }else if (indexPath.section == 1){
        return 80;
    }else if (indexPath.section == 2){
        CGFloat HH = 0;
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
        return HH;
    }else if (indexPath.section == 3){
        return self.jsonDt ? [FSGridLayoutView GridViewHeightWithJsonStr:self.jsonDt]:0;
    }
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    HealthEducateDetailViewController *detail = [[HealthEducateDetailViewController alloc]init];
//    detail.titieStr = @"详情";
//    detail.article_id = self.categoryListArr[indexPath.row][@"id"];
//    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.menuArr.count;
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    //
    UIImageView *imageveiw  = [[UIImageView alloc]init];
    imageveiw.contentMode = UIViewContentModeScaleAspectFit;
    NSString *url = [NSString string];
    if (IS_IPHONE_6_PLUS) {
        url = self.menuArr[indexPath.row][@"imgurl3"];
    }else{
        
        url = self.menuArr[indexPath.row][@"imgurl2"];
        
    }
    [cell.contentView addSubview:imageveiw];
    [imageveiw sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [imageveiw mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(image.size.height);
        }];
    }];
    [imageveiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
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
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat wid = 4;
    if (self.menuArr.count) {
        if (self.menuArr.count < 6) {
            wid = self.menuArr.count;
            
        }
    }
    
    return CGSizeMake((SCREEN.size.width-5)/wid, 90);
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
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
    [self.navigationController pushViewController:[[MedicalViewController alloc]init] animated:YES];
    return;
    NSString *name = [NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"name"]];
    NSLog(@"6554:%@",name);
    if ([name isEqualToString: @"(null)"]) {
        
        AttestViewController *att = [[AttestViewController alloc]init];
        
        [self.navigationController pushViewController:att animated:YES];
        return;
    }
    if ([self.menuArr[indexPath.row][@"ios"] isKindOfClass:[NSDictionary class]]) {
        UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:self.menuArr[indexPath.row][@"ios"] controller:self];
        if (board == nil) {
            [self presentLoadingTips:@"信息读取失败！"];
        }
        return;
    }

    
    
    
}
#pragma mark - --- FSGridLayoutViewDelegate ---
-(void)FSGridLayouClickCell:(FSGridLayoutView *)flview itemDt:(NSDictionary *)itemDt{
    LFLog(@"itemDt:%@",itemDt);
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
//    if ([self.serviceArr[btn.index - 33][@"ios"] isKindOfClass:[NSDictionary class]]) {
//        UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:self.serviceArr[btn.index - 33][@"ios"] controller:self];
//        if (board == nil) {
//            [self presentLoadingTips:@"信息读取失败！"];
//        }
//        return;
//    }

    
}


//更多点击事件
-(void)moreBtnClick:(UIButton *)btn{
    
    LFLog(@"点击更多");
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    [self.navigationController pushViewController:[[HealthEducateViewController alloc]init] animated:YES];
}

#pragma mark - *************详情请求************
-(void)requestDetailData{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"详情请求dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,MedicalHomeUrl) params:dt success:^(id response) {
        LFLog(@"详情请求:%@",response);
        [_tableView.mj_header endRefreshing];
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                [self.dataDict removeAllObjects];
                [self.dataDict setDictionary:response[@"data"]];
                [self.pictureArr removeAllObjects];
                if (self.dataDict[@"banner"] && [self.dataDict[@"banner"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *picDt in self.dataDict[@"banner"]) {
                        [self.pictureArr addObject:picDt];
                    }
                }
                if (self.dataDict[@"middle_menu"] && [self.dataDict[@"middle_menu"] isKindOfClass:[NSArray class]]) {
                    self.menuArr = self.dataDict[@"middle_menu"];
                }
                if (self.dataDict[@"bottom_menu"] && [self.dataDict[@"bottom_menu"] isKindOfClass:[NSArray class]]) {
                    NSArray *temArr = self.dataDict[@"bottom_menu"];
                    if (temArr.count == 3) {
                        NSString *keystr = @"imgurl2";
                        if (IS_IPHONE_6_PLUS) {
                            keystr = @"imgurl3";
                        }
                        self.jsonDt = @{@"images":@[@{@"children":@[@{@"image":temArr[0][keystr],@"data":temArr[0],@"weight":@1},
                                                                    @{@"children":@[@{@"image":temArr[1][keystr],@"data":temArr[1],@"weight":@1},
                                                                                    @{@"image":temArr[2][keystr],@"data":temArr[2],@"weight":@1}],
                                                                      @"weight":@2,@"orientation":@"v"}],
                                                      @"height":@180,@"orientation":@"h"}]};
                    }
                    
                }
                
                [self ceratCycleScrollView];
            }
            [self.collectionview reloadData];
            [self.tableView reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    [self requestDetailData];
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [self dismissTips];
        [self presentLoadingTips:@"暂无数据"];
    }];
}
#pragma mark - *************分类请求************
-(void)requestCategoryData{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"分类请求dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,HealthEducateCategoryUrl) params:dt success:^(id response) {
        LFLog(@"分类请求:%@",response);
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                [self.categoryArr removeAllObjects];
                NSMutableArray *nameArr = [NSMutableArray array];
                for (NSDictionary *temdt in response[@"data"]) {
                    [self.categoryArr addObject:temdt];
                    [nameArr addObject:temdt[@"name"]];
                }
                [self.pageMenu removeAllItems];
                if (self.categoryArr.count) {
                    [self.pageMenu setItems:nameArr selectedItemIndex:0];
                    [self requestcategoryListData:self.categoryArr[0][@"id"]];
                }
                
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    [self requestCategoryData];
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
    }];
    
}
#pragma mark - *************健康教育列表*************
-(void)requestcategoryListData:(NSString* )cat_id{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSDictionary *pagination = @{@"count":@"5",@"page":@"1"};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"健康教育列表dt:%@",dt);
    if (cat_id) {
        [dt setObject:cat_id forKey:@"cat_id"];
    }
    [self.categoryListArr removeAllObjects];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,HealthEducateListUrl) params:dt success:^(id response) {
        LFLog(@"健康教育列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                [self.categoryListArr removeAllObjects];
                int i = 0;
                for (NSDictionary *dt in response[@"data"]) {
                    if (i > 4) {
                        break;
                    }
                    [self.categoryListArr addObject:dt];
                    i ++;
                }
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
                
            }else{
                [self presentLoadingTips:@"数据格式错误！"];
            }
        }else{

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
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDetailData];
        [self requestCategoryData];
    }];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showTabbar];
//    if (@available(iOS 11.0, *)) {
//        __weak typeof(self) weakSelf = self;
//        dispatch_after(0.2, dispatch_get_main_queue(), ^{
//            [weakSelf scrollViewDidScroll:weakSelf.tableView];
//        });
//    } else {
//        [self scrollViewDidScroll:self.tableView];
//    }
    
    
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

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationColor:self.navigationColor animated:NO];
}

@end
