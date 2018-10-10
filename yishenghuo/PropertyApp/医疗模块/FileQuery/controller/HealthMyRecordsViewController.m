//
//  HealthMyRecordsViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "HealthMyRecordsViewController.h"
#import "MKJCollectionViewFlowLayout.h"
#import "MKJCollectionViewCell.h"
#import "FileIListTableViewCell.h"
#import "MyFileModel.h"
#import "FilePersonalFormListViewController.h"//个人基本表 列表
#import "HealthFileCoverViewController.h"//健康档案封面
#import "HealthFileInfoViewController.h"//健康档案信息卡
#import "HealthCheckupFormListViewController.h"//健康体检表
#import "HealthReceiveRecordListViewController.h"//接诊记录表 列表
#import "HealthConsultationListViewController.h"//会诊记录 列表
#import "HealthNewbornVisitViewController.h"//新生儿访视
#import "HealthPostpartum42ListController.h"//产后42
#import "ChildHealthCheckListViewController.h"//儿童健康检查列表
#import "BabyVaccinationViewController.h"//接种证
#import "ChanQianRecordViewController.h"//产前检查服务记录表
#import "ChanQianFollowListViewController.h" //产前随访服务记录表 列表
#import "ChanHouVisitListViewController.h"//  产后访视记录 列表
#import "Diabetes2ListViewController.h"//2型糖尿病随访服务记录表 列表
#import "TwoWayINListViewController.h" //双向转诊 转出 列表
#import "HypertensionListViewController.h"//高血压
#import "OldManSelfCareViewController.h"//老年人自理评估表
#import "TriangleView.h"
#define headerH screenW * (46/ 75.0)
@interface HealthMyRecordsViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MKJCollectionViewFlowLayoutDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UICollectionView * collectionview;
@property(nonatomic, strong)UIView *headerView;
@end

@implementation HealthMyRecordsViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = true;
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = false;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 0;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back-white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
    [self UpData];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)UpData{
    [self getData:self.index];
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(NSMutableArray *)itemArray{
    if (_itemArray == nil) {
        _itemArray = [[NSMutableArray alloc]init];
    }
    return _itemArray;
    
}
-(UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, headerH)];
        _headerView.backgroundImage = [UIImage imageNamed:@"dangangrbg"];
        [_headerView addSubview:self.collectionview];
        TriangleView *triangle = [[TriangleView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        triangle.backgroundColor = [UIColor clearColor];
        [_headerView addSubview:triangle];
        [triangle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerView.mas_centerX);
            make.bottom.offset(2);
            make.height.offset(10);
            make.width.offset(10);
        }];
    }
    return _headerView;
}

-(UICollectionView *)collectionview{
    if (_collectionview == nil) {
        MKJCollectionViewFlowLayout *flow = [[MKJCollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.itemSize = CGSizeMake(50, 80);
        flow.minimumLineSpacing = 30;
        flow.needAlpha = YES;
        flow.delegate = self;
        CGFloat oneX = (screenW-50)/2;
//        if (self.itemArray.count) {
//            CGFloat width = self.itemArray.count * 50 + (self.itemArray.count - 1) * 30 + 20;
//            oneX = width > screenW ? 10 :(screenW-50)/2;
//        }
        CGFloat oneY = (headerH - 80)/2;
        flow.sectionInset = UIEdgeInsetsMake(oneY, oneX, oneY, oneX);
        _collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenW ,headerH) collectionViewLayout:flow];
        _collectionview.dataSource=self;
        _collectionview.delegate=self;

        _collectionview.showsHorizontalScrollIndicator = NO;
        _collectionview.layer.masksToBounds = NO;
        [_collectionview setBackgroundColor:[UIColor clearColor]];
        [_collectionview registerNib:[UINib nibWithNibName:@"MKJCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MKJCollectionViewCell"];
    }
    return _collectionview;
}
#pragma mark - tableView
- (void)initTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -NaviH, screenW, screenH + NaviH) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = 75;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FileIListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FileIListTableViewCell class])];
    _tableView.tableHeaderView = self.headerView;
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FileIListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FileIListTableViewCell class]) forIndexPath:indexPath];
    MyFileReModel *model = self.dataArray[indexPath.row];
    [cell.iconIm sd_setImageWithURL:[NSURL URLWithString:model.tr_imgurl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cell.nameLb.text = model.tr_name;
    cell.timeLb.text = model.time;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = JHbgColor;
    UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 30, 50) font:[UIFont systemFontOfSize:15] textcolor:JHmiddleColor numberOfLines:0 textAlignment:0];
    MyFileModel *model = self.itemArray[self.index];
    NSString *text = [NSString stringWithFormat:@"%@的档案   %lu份",model.hp_name, (unsigned long)self.dataArray.count];
    lb.attributedText = [text AttributedString:[NSString stringWithFormat:@"%lu份",(unsigned long)self.dataArray.count] backColor:nil uicolor:JHMedicalColor uifont:nil];
    [header addSubview:lb];
    return header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyFileModel *model = self.itemArray[self.index];
    MyFileReModel *remodel = self.dataArray[indexPath.row];
    if ([remodel.tr_InterfaceID isEqualToString:@"85"]) {//个人基本信息表
        FilePersonalFormListViewController *VC = [[FilePersonalFormListViewController alloc]init];
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        VC.archive_no = model.hp_no;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    if ([remodel.tr_InterfaceID isEqualToString:@"103"]) {//健康档案封面
        HealthFileCoverViewController *VC = [[HealthFileCoverViewController alloc]init];
        VC.archive_no = model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    if ([remodel.tr_InterfaceID isEqualToString:@"107"]) {//健康档案信息
        HealthFileInfoViewController *VC = [[HealthFileInfoViewController alloc]init];
        VC.archive_no = model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    if ([remodel.tr_InterfaceID isEqualToString:@"86"]) {//健康体检表
        HealthCheckupFormListViewController *VC = [[HealthCheckupFormListViewController alloc]init];
        VC.archive_no = model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    if ([remodel.tr_InterfaceID isEqualToString:@"95"]) {//接诊记录表
        HealthReceiveRecordListViewController *VC = [[HealthReceiveRecordListViewController alloc]init];
        VC.archive_no = model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    if ([remodel.tr_InterfaceID isEqualToString:@"96"]) {//会诊信息
        HealthConsultationListViewController *VC = [[HealthConsultationListViewController alloc]init];
        VC.archive_no = model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    
    if ([remodel.tr_InterfaceID isEqualToString:@"87"]) {//新生儿访视
        HealthNewbornVisitViewController *VC = [[HealthNewbornVisitViewController alloc]init];
        VC.archive_no = model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    if ([remodel.tr_InterfaceID isEqualToString:@"102"]) {//产后42
        HealthPostpartum42ListController *VC = [[HealthPostpartum42ListController alloc]init];
        VC.archive_no = model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    if ([remodel.tr_InterfaceID isEqualToString:@"106"]) {//孕妇第一次产检记录
        ChanQianRecordViewController *VC = [[ChanQianRecordViewController alloc]init];
        VC.archive_no = model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    if ([remodel.tr_InterfaceID isEqualToString:@"99"]) {//产前随访服务记录表 列表
        ChanQianFollowListViewController *VC = [[ChanQianFollowListViewController alloc]init];
        VC.archive_no = model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    if ([remodel.tr_InterfaceID isEqualToString:@"101"]) {//产后访视记录表 列表
        ChanHouVisitListViewController *VC = [[ChanHouVisitListViewController alloc]init];
        VC.archive_no = model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    
    if ([remodel.tr_InterfaceID isEqualToString:@"88"]) {//儿童健康检查列表
        ChildHealthCheckListViewController *VC = [[ChildHealthCheckListViewController alloc]init];
        VC.archive_no =  model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    if ([remodel.tr_InterfaceID isEqualToString:@"94"]) {//2型糖尿病随访服务记录表 列表
        Diabetes2ListViewController *VC = [[Diabetes2ListViewController alloc]init];
        VC.archive_no =  model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    if ([remodel.tr_InterfaceID isEqualToString:@"97"] || [remodel.tr_InterfaceID isEqualToString:@"98"]) {//双向转诊 转出 (转回) 列表 
        TwoWayINListViewController *VC = [[TwoWayINListViewController alloc]init];
        VC.archive_no =  model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    if ([remodel.tr_InterfaceID isEqualToString:@"93"] ) {//高血压列表 列表
        HypertensionListViewController *VC = [[HypertensionListViewController alloc]init];
        VC.archive_no =  model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    if ([remodel.tr_InterfaceID isEqualToString:@"92"] ) {//老年人自理评估表
        OldManSelfCareViewController *VC = [[OldManSelfCareViewController alloc]init];
        VC.archive_no =  model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    
    
    if ([remodel.tr_InterfaceID isEqualToString:@"90"]) {//接种证
        BabyVaccinationViewController *VC = [[BabyVaccinationViewController alloc]init];
        VC.archive_no = model.hp_no;
        VC.tr_InterfaceID = remodel.tr_InterfaceID;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }

    
}


#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return self.itemArray.count;
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"MKJCollectionViewCell";
    MKJCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    MyFileModel *model = self.itemArray[indexPath.row];
    [cell.heroImageVIew sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@""]];
    cell.nameLb.text = model.hp_name;
    return cell;
}

- (void)collectioViewScrollToIndex:(NSInteger)index {
    self.index = index;
    [self getData:index];
}

#pragma mark - 数据
- (void)getData:(NSInteger )index{
    if (!self.itemArray.count) {
        self.isLoadEnd = @1;
        return;
    }
    NSString *uid = [UserDefault objectForKey:@"uid"];
    if (uid == nil) uid = @"";
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) coid = @"";
    coid = @"53";
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:uid forKey:@"uid"];
    [dt setObject:@"1" forKey:@"iszb"];
    if (self.itemArray.count) {
        MyFileModel *model = self.itemArray[0];
        [dt setObject:model.hp_no forKey:@"hp_no"];
    }
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,ERPMyFileQueryRecordListUrl) params:dt success:^(id response) {
        LFLog(@" 数据提交:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *temdt in response[@"data"]) {
                MyFileReModel *model = [MyFileReModel mj_objectWithKeyValues:temdt];
                [self.dataArray addObject:model];
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




@end
