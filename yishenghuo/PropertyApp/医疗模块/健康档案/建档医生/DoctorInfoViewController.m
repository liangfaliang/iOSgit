//
//  DoctorInfoViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "DoctorInfoViewController.h"
#import "DoctorInfoHeaderView.h"
#import "DoctorScheduleCollectionViewCell.h"
#import "AlertSelectTimeView.h"
@interface DoctorInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AlertSelectTimeViewDelegate>
@property(nonatomic,strong)DoctorInfoHeaderView *headerview;
@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UICollectionView * collectionview;
@property (nonatomic, strong) NSMutableArray *menuArr;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic,strong)AlertSelectTimeView *alertView;
@end

@implementation DoctorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(NSMutableArray *)btnArr{
    if (_btnArr == nil) {
        _btnArr = [[NSMutableArray alloc]init];
    }
    return _btnArr;
}
-(NSMutableArray *)menuArr{
    if (!_menuArr) {
        _menuArr = [NSMutableArray array];
    }
    return _menuArr;
}
-(DoctorInfoHeaderView *)headerview{
    if (_headerview == nil) {
        _headerview = [[NSBundle mainBundle]loadNibNamed:@"DoctorInfoHeaderView" owner:nil options:nil][0];
        _headerview.frame = CGRectMake(0, 0, SCREEN.size.width, 210 + 60);
    }
    return _headerview;
}
-(AlertSelectTimeView *)alertView{
    if (_alertView == nil) {
        _alertView = [[AlertSelectTimeView alloc]initWithFrame:CGRectMake(0, - NaviH, SCREEN.size.width, SCREEN.size.height + NaviH)];
        _alertView.backgroundColor = [UIColor clearColor];
        _alertView.delegate = self;
    }
    return _alertView;
}
-(void)createUI{
    for (int i = 0 ; i < 2; i ++) {
        IndexBtn *btn = [[IndexBtn alloc]init];
        btn.index = i;
        [btn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"shangla"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(refreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected = YES;
        [self.btnArr addObject:btn];
    }
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0, -statusRect.size.height, screenW, screenH + statusRect.size.height)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerNib:[UINib nibWithNibName:@"ArchiveDoctorTableViewCell" bundle:nil] forCellReuseIdentifier:@"ArchiveDoctorTableViewCell"];
    self.tableview.tableHeaderView = self.headerview;
    __weak typeof(self) weakSelf = self;
    [self.headerview setBlock:^(UIButton *sender) {
        if (!sender.selected) {
            weakSelf.headerview.frame = CGRectMake(0, 0, SCREEN.size.width, 210 + 60);
        }else{
            weakSelf.headerview.frame = CGRectMake(0, 0, SCREEN.size.width, 210 + 100);
        }
        weakSelf.tableview.tableHeaderView = weakSelf.headerview;
    }];
    
}
-(void)refreBtnClick:(IndexBtn *)sender{
    sender.selected = !sender.selected;
    [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:sender.section] withRowAnimation:UITableViewRowAnimationNone];
}
-(UICollectionView *)collectionview{
    if (_collectionview == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN.size.width-5)/self.menuArr.count, 90);
        flowLayout.minimumInteritemSpacing = 0.001;
        flowLayout.minimumLineSpacing = 0.001;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width,180) collectionViewLayout:flowLayout];
        _collectionview.dataSource=self;
        _collectionview.delegate=self;
        [_collectionview setBackgroundColor:[UIColor clearColor]];
        [_collectionview registerNib:[UINib nibWithNibName:@"DoctorScheduleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DoctorInfoViewCell"];
    }
    return _collectionview;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    IndexBtn *sender = self.btnArr[section];
    if (sender.selected) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 190;
    }
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *onecellid = [NSString stringWithFormat:@"DoctorInfocell_%ld",(long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:onecellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:onecellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.collectionview];
        [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.bottom.offset(-10);
        }];
    }else{
        cell.textLabel.text = @"对于项目有的很多处都需要这个代码，可以给它写成宏定义";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = JHmiddleColor;
    }

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
    }
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor whiteColor];
    UIView *boderVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 10)];
    boderVeiw.backgroundColor = JHbgColor;
    [header addSubview:boderVeiw];
    
    UILabel *descLabel = [[UILabel alloc]init];
    //                    descLabel.tag = 100;
    descLabel.font = [UIFont systemFontOfSize:15];
    descLabel.textColor  = JHdeepColor;
    [header addSubview: descLabel];
    descLabel.text = @"门诊预约规则";
    descLabel.numberOfLines = 0;
    CGSize descsize = [descLabel.text selfadapUifont:descLabel.font weith:20];

    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-30);
        make.bottom.offset(0);
        make.height.offset((descsize.height + 10) > 40 ? (descsize.height + 10):40);
    }];
    if (section == 0) {
        UILabel *namelb = [[UILabel alloc]init];
        //                    descLabel.tag = 100;
        namelb.font = [UIFont systemFontOfSize:15];
        namelb.textColor  = JHdeepColor;
        [header addSubview: namelb];
        namelb.text = @"门诊预约规则";
        namelb.numberOfLines = 0;
        [namelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-40);
            make.top.equalTo(boderVeiw.mas_bottom).offset(0);
            make.bottom.equalTo(descLabel.mas_top).offset(0);
        }];
    }
    IndexBtn *sender = self.btnArr[section];
    sender.section = section;
    [header addSubview:sender];
    [sender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(30);
        make.right.offset(-10);
        make.bottom.offset(0);
        make.height.offset((descsize.height + 10) > 40 ? (descsize.height + 10):40);
    }];
    return header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    MedicalExaminationDetailViewController *detail = [[MedicalExaminationDetailViewController alloc]init];
    //    //    detail.titieStr = self.titieStr;
    //    detail.listId = self.dataArray[indexPath.row][@"id"];
    //    [self.navigationController pushViewController:detail animated:YES];
    
}
#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 14;
//    return self.menuArr.count;
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"DoctorInfoViewCell";
    DoctorScheduleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.backcolor = @"JHMedicalColor";
    }else if(indexPath.row == 7){
        cell.backcolor = @"JHBorderColor";
    }else{
        cell.backcolor = @"";
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((screenW -7)/7 , 90);
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self.alertView showAlertview:@[@"2019-222 萨克的喀什市",@"29019 -8838 交互打开大家深刻的"]];
}
#pragma mark AlertSelectTimeViewDelegate
-(void)AlertSelectTimeViewDidSelectCell:(AlertSelectTimeView *)alertview phy_timeArr:(NSArray *)phyArr Indexpath:(NSIndexPath *)indexpath{
    LFLog(@"phyArr:%@",phyArr[indexpath.row]);
}
#pragma mark - *************预约体检列表*************
-(void)requestData:(NSInteger )pagenum{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"预约体检列表dt:%@",dt);
    if (pagenum == 1) {
        [self.dataArray removeAllObjects];
    }
    //    if (self.cat_id) {
    //        [dt setObject:self.cat_id forKey:@"cat_id"];
    //    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,MedicalExaminationListUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"预约体检列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (![response[@"note"] isKindOfClass:[NSString class]]) {
                for (NSDictionary *dt in response[@"data"]) {
                    [self.dataArray addObject:dt];
                }
                if (self.dataArray.count) {
                    [self.tableview reloadData];
                }else{
                    [self presentLoadingTips:@"暂无数据~~~"];
                }
               
            }else{
                [self presentLoadingTips:@"数据格式错误！"];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self requestData:1];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"请求失败！"];
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
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

@end
