//
//  MedicalServiceOtherViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/7/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MedicalServiceOtherViewController.h"
#import "CollectioncellTableViewCell.h"
#import "HealthEducateListTableViewCell.h"
#import "FSTableViewCell.h"
#import "SDCycleScrollView.h"
#import "InformationCycleCollectionViewCell.h"
#import "MKJCollectionViewFlowLayout.h"
#import "ImLbModel.h"
#import "ChildCareHomeview.h"
#import "MedicalPlanTableViewCell.h"
#import "WarmTipsTableViewCell.h"
#import "WKViewViewController.h"
#import "HealthRecordsFirstViewController.h"
#import "ChanQianRecordViewController.h"
#import "ChanQianFollowListViewController.h"
#import "HealthMyRecordsViewController.h"
#import "HealthNewbornVisitViewController.h"
#import "MyFileModel.h"
#import "ChildVaccinationMainViewController.h"
#import "OldManSelfCareViewController.h"
#import "HypertensionListViewController.h"
#import "HealthCheckupFormListViewController.h"
#import "HealthReceiveRecordListViewController.h"
#import "SanjinListViewController.h"
#import "MeGoodModel.h"
#import "ShopDoodsDetailsViewController.h"
#import "InformationViewController.h"
@interface MedicalServiceOtherViewController ()
<UITableViewDataSource, UITableViewDelegate,FSGridLayoutViewDelegate,SDCycleScrollViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableDictionary *dataDt;
@property(nonatomic,strong)ChildCareHomeview *headerview;
@property (nonatomic, retain)SDCycleScrollView *sdCySV;
@property(nonatomic,strong)NSMutableArray *childArray;
@property(nonatomic,strong)NSMutableArray *iconbtnArr;
@property(nonatomic,strong)NSMutableArray *aritcleArr;
@property(nonatomic,strong)NSDictionary *VaDict;
@property (nonatomic, strong) NSMutableArray *goodArr;//
@end

@implementation MedicalServiceOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self.view addSubview:self.tableView];
    [self UpateHeaderview];
    [self UpData];
}
-(void)initData{
    NSArray *arr1 = @[];
    NSArray *arr2 = @[];
    if (self.typeStyle == ServiceStyleYun) {
        arr1 = @[@{@"name":@"产检须知",@"imgurl":@"chanjianxuzhifw"},
                 @{@"name":@"孕妇建档",@"imgurl":@"yunfudanganfw"},
                 @{@"name":@"产检记录",@"imgurl":@"chanjianjlfw"},
                 @{@"name":@"随访记录",@"imgurl":@"suifangjilufw"}];
        arr2 = @[@{@"name":@"金豆子套餐",@"imgurl":@"jiancexuzhiyunyufw"},
                 @{@"name":@"金豆子套餐",@"imgurl":@"manbingjzfw"},
                 @{@"name":@"金豆子套餐",@"imgurl":@"manbingjzfw"}];
    }
    if (self.typeStyle == ServiceStyleYing) {
        arr1 = @[@{@"name":@"婴幼儿档案",@"imgurl":@"yingyouerdanafws"},
                 @{@"name":@"随访记录",@"imgurl":@"yingersuifjlfw"},
                 @{@"name":@"接种记录",@"imgurl":@"jizhongjlfws"},
                 @{@"name":@"接种须知",@"imgurl":@"jiezhongxuzfw"}];
        arr2 = @[@{@"name":@"金豆子套餐",@"imgurl":@"jiancexuzhiyunyufw"},
                 @{@"name":@"金豆子套餐",@"imgurl":@"manbingjzfw"},
                 @{@"name":@"金豆子套餐",@"imgurl":@"manbingjzfw"}];
    }
    if (self.typeStyle == ServiceStyleMan) {
        arr1 = @[@{@"name":@"生活能力评估",@"imgurl":@"shehuonenglipinggu"},
                 @{@"name":@"随访记录",@"imgurl":@"suifangjilu"},
                 @{@"name":@"体检记录",@"imgurl":@"tijianjilu"},
                 @{@"name":@"就诊记录",@"imgurl":@"jiuzhengjlu"}];
        arr2 = @[@{@"name":@"金夕阳套餐",@"imgurl":@"jiancexuzhiyunyufw"},
                 @{@"name":@"金夕阳套餐",@"imgurl":@"manbingjzfw"},
                 @{@"name":@"金夕阳套餐",@"imgurl":@"manbingjzfw"}];
    }

    NSMutableArray *marr1 = [NSMutableArray array];
    for (NSDictionary *temdt in arr1) {
        ImLbModel *mo = [ImLbModel mj_objectWithKeyValues:temdt];
        [marr1 addObject:mo];
    }
    [self.dataDt setObject:marr1 forKey:@"section1"];

//    NSMutableArray *marr2 = [NSMutableArray array];
//    for (NSDictionary *temdt in arr2) {
//        ImLbModel *mo = [ImLbModel mj_objectWithKeyValues:temdt];
//        if (self.typeStyle == ServiceStyleMan) {
//            mo.backcolor = @"83CAF8";
//        }else if (self.typeStyle == ServiceStyleYing) {
//            mo.backcolor = @"83CAF8";
//        }else if (self.typeStyle == ServiceStyleYun) {
//            mo.backcolor = @"83CAF8";
//        }
//        mo.cornerRadius = @"3";
//        [marr2 addObject:mo];
//    }
//    [self.dataDt setObject:marr2 forKey:@"section2"];
}
-(NSMutableDictionary *)dataDt{
    if (_dataDt == nil) {
        _dataDt = [NSMutableDictionary dictionary];
    }
    return _dataDt;
}
-(NSMutableArray *)childArray{
    if (_childArray == nil) {
        _childArray = [NSMutableArray array];
        NSDictionary *dt =@{@"name":@"老猴子",
                            @"age":@"80岁",
                            @"time":@"上次体检06-21",
                            };
        [_childArray addObject:dt];
    }
    return _childArray;
}
-(NSMutableArray *)goodArr{
    if (_goodArr == nil) {
        _goodArr = [NSMutableArray array];
    }
    return _goodArr;
}
-(NSMutableArray *)iconbtnArr{
    if (_iconbtnArr == nil) {
        _iconbtnArr = [NSMutableArray array];
    }
    return _iconbtnArr;
}
-(NSMutableArray *)aritcleArr{
    if (_aritcleArr == nil) {
        _aritcleArr = [NSMutableArray array];
    }
    return _aritcleArr;
}
-(void)UpData{
    [self getData];
    [self getDataVaccination];
    [self UploadDataGoods];
    [self UploadDataGold];
}
-(ChildCareHomeview *)headerview{
    if (_headerview == nil) {
        _headerview = [[NSBundle mainBundle]loadNibNamed:@"ChildCareHomeview" owner:nil options:nil][0];
        NSString *image = @"";
        if (self.typeStyle == ServiceStyleMan) image = @"laonianrenbeijing";
        if (self.typeStyle == ServiceStyleYing) image = @"yingweweijiandang";
        if (self.typeStyle == ServiceStyleYun) image = @"yunfubg";
        _headerview.backgroundImage = [UIImage imageNamed:image];
        _headerview.frame = CGRectMake(0, 0, SCREEN.size.width,  140);
        _headerview.iconTop.constant = 20;
        _headerview.backBtn.hidden = YES;
        __weak typeof(self) weakSelf = self;
        [_headerview setAddblock:^{

        }];
    }
    return _headerview;
}
-(void)UpateHeaderview{
    for (UIView *subview in self.headerview.subviews) {
        if (self.VaDict) {
            subview.hidden = NO;
        }else{
            subview.hidden = YES;
        }
    }
    CGFloat xx = 0;
    int i = 0;
    CGFloat ww = 50;
    CGFloat wid = 40;//小but的间隔
    if (self.childArray.count > 1) {
        CGFloat width = (screenW - 110)/(self.childArray.count -1);
        if (wid > width) {
            wid = width;
        }
    }
    NSString *image = @"";
    if (self.typeStyle == ServiceStyleMan) image = self.VaDict ? @"laonianrenbeijing-1" : @"laonianrenbeijing";
    if (self.typeStyle == ServiceStyleYing) image = self.VaDict ? @"yingerbg" : @"yingweweijiandang";
    if (self.typeStyle == ServiceStyleYun) image = self.VaDict ? @"yunfubg-1" : @"yunfubg";
    _headerview.backgroundImage = [UIImage imageNamed:image];
    if (!self.VaDict) {
        return;
    }
    NSDictionary *dt = self.VaDict;
    NSMutableAttributedString *text = nil;
    if (self.typeStyle == ServiceStyleMan) {
        text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | %@ ",dt[@"hp_name"],dt[@"hp_sex"]]];
        
        NSRange range0 =[[text string]rangeOfString:[NSString stringWithFormat:@"%@",dt[@"hp_sex"]]];
        [text yy_setFont:[UIFont boldSystemFontOfSize:13] range:range0];
    }else if (self.typeStyle == ServiceStyleYing) {
        text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | %@ | %@",dt[@"hp_name"],dt[@"hp_sex"],dt[@"hp_age"]]];
        
        NSRange range0 =[[text string]rangeOfString:[NSString stringWithFormat:@"%@",dt[@"hp_sex"]]];
        [text yy_setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13] range:range0];
    }else if (self.typeStyle == ServiceStyleYun) {
        text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | %@ | %@",dt[@"hp_name"],dt[@"hp_sex"],dt[@"hp_age"]]];
        
        NSRange range0 =[[text string]rangeOfString:[NSString stringWithFormat:@"%@",dt[@"hp_sex"]]];
        [text yy_setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13] range:range0];
    }
    text.yy_font = [UIFont boldSystemFontOfSize:15];
    text.yy_color = JHdeepColor;
    self.headerview.nameLb.attributedText = text;
    [self.headerview.locationBtn setTitle:[NSString stringWithFormat:@"   %@",dt[@"de_name"]] forState:UIControlStateNormal];
//    [self.iconbtnArr removeAllObjects];
//    for (NSDictionary *dt in self.childArray) {
//        IndexBtn *btn = [[IndexBtn alloc]initWithFrame:CGRectMake(xx, 0, i == 0 ? 50 :(wid > 30 ? 30 : wid) , i == 0 ? 50 :(wid > 30 ? 30 : wid))];
//        btn.index = i;
//        btn.center = CGPointMake(xx + ww/2, 25);
//        [btn setImage:[UIImage imageNamed:@"touxaing_chlid"] forState:UIControlStateNormal];
//        [self.headerview.iconView addSubview:btn];
//        if (i == 0) {
//            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | %@ | %@",dt[@"name"],dt[@"age"],dt[@"time"]]];
//            text.yy_font = [UIFont boldSystemFontOfSize:15];
//            text.yy_color = JHdeepColor;
//            NSRange range0 =[[text string]rangeOfString:[NSString stringWithFormat:@"%@",dt[@"age"]]];
//            [text yy_setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13] range:range0];
//            self.headerview.nameLb.attributedText = text;
////            [self.headerview.locationBtn setTitle:dt[@"address"] forState:UIControlStateNormal];
//        }else{
//            btn.alpha = 0.7;
//        }
//        i ++;
//        xx += ww;
//        ww = wid;
//        [btn addTarget:self action:@selector(childIconClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.iconbtnArr addObject:btn];
//    }
    self.headerview.iconWidth.constant = xx ;
}
- (SDCycleScrollView *)sdCySV {
    if(!_sdCySV){
        _sdCySV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenW, 50) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        //        _sdCySV.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        //        _sdCySV.currentPageDotColor = JHColor(138, 181, 255);
        _sdCySV.showPageControl = NO;
        _sdCySV.autoScroll = NO;
        _sdCySV.backgroundColor = JHbgColor;
        _sdCySV.scrollDirection = UICollectionViewScrollDirectionVertical;
        _sdCySV.imageURLStringsGroup = @[@"",@""];
    }
    
    return _sdCySV;
}
#pragma mark CycleScrollViewdelegate
//-(Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view{
//    return [UICollectionViewCell class];
//}

//-(void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view{
//    [cell.contentView removeAllSubviews];
//    UIButton *btn = [[UIButton alloc]init];
//    [btn setImage:[UIImage imageNamed:@"tixing"] forState:UIControlStateNormal];
//    [btn setTitle:@"  宝宝已经有豆粒大小了，宝妈们不要担心了" forState:UIControlStateNormal];
//    [btn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [cell.contentView addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.offset(0);
//        make.right.offset(-15);
//        make.left.offset(15);
//    }];
//}
#pragma mark - tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH -NaviH-TabH) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = JHbgColor;
        _tableView.estimatedRowHeight = 110;
        [_tableView registerNib:[UINib nibWithNibName:@"CollectioncellTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollectioncellTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MedicalPlanTableViewCell" bundle:nil] forCellReuseIdentifier:@"MedicalPlanTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HealthEducateListTableViewCell" bundle:nil] forCellReuseIdentifier:@"HealthEducateListTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"WarmTipsTableViewCell" bundle:nil] forCellReuseIdentifier:@"WarmTipsTableViewCell"];
        _tableView.tableHeaderView = self.headerview;
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf UpData];
        }];
    }
    return _tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) return self.dataDt[@"section2"] ? 1 : 0;
    if (section == 3) return self.aritcleArr.count;
    if (section == 4) return self.goodArr.count ? 1 : 0;
    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 4) {
        CollectioncellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CollectioncellTableViewCell class]) forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.collectionView.backgroundColor = [UIColor whiteColor];
        if (indexPath.section == 1) {
            cell.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            cell.layout.itemSize = CGSizeMake((screenW - 75)/4 - 1, 110);
            cell.layout.minimumLineSpacing = 15;
            cell.layout.minimumInteritemSpacing = 0.001;
            CGFloat oneX = 15;
            CGFloat oneY = 0;
            cell.layout.sectionInset = UIEdgeInsetsMake(oneY, oneX, oneY, oneX);
            cell.itemSize = cell.layout.itemSize;
            cell.Identifier = @"ImageLabelCollectionViewCell";
            cell.titleArr = self.dataDt[@"section1"];
        }else if (indexPath.section == 2) {
            cell.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            cell.layout.itemSize = CGSizeMake((screenW - 100)/3 - 1, 120);
            cell.layout.minimumLineSpacing = 35;
            cell.layout.minimumInteritemSpacing = 0.001;
            CGFloat oneX = 15;
            cell.layout.sectionInset = UIEdgeInsetsMake(5, oneX, 15, oneX);
            cell.itemSize = cell.layout.itemSize;
            cell.Identifier = @"ImageLabelCollectionViewCell";
            cell.titleArr = self.dataDt[@"section2"];
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            cell.layout.itemSize = CGSizeMake((screenW - 70)/3 , 190);
            cell.layout.minimumLineSpacing = 10;
            CGFloat oneX = 15;
            CGFloat oneY = 0;
            cell.layout.sectionInset = UIEdgeInsetsMake(oneY, oneX, 10, oneX);
            cell.itemSize = cell.layout.itemSize;
            cell.Identifier = @"HealthShopCollectionViewCell";
            cell.titleArr = self.goodArr;
        }
        WEAKSELF;
        cell.ClickBlock = ^(NSIndexPath *indexpath) {
            if (indexPath.section == 1) {
                if (self.typeStyle == ServiceStyleMan) {
                    if (weakSelf.VaDict) {
                        if (indexpath.row == 0) {//老年人自理评估表
                            OldManSelfCareViewController *VC = [[OldManSelfCareViewController alloc]init];
                            if (weakSelf.VaDict) {
                                VC.archive_no = weakSelf.VaDict[@"hp_no"];
                            }
                            VC.tr_InterfaceID = @"92";
                            [self.navigationController pushViewController:VC animated:YES];
                        }else if (indexpath.row == 1){//高血压列表 列表
                            HypertensionListViewController *VC = [[HypertensionListViewController alloc]init];
                            if (weakSelf.VaDict) {
                                VC.archive_no = weakSelf.VaDict[@"hp_no"];
                            }
                            VC.tr_InterfaceID = @"93";
                            [self.navigationController pushViewController:VC animated:YES];
                        }else if (indexpath.row == 2){//健康体检表
                            HealthCheckupFormListViewController *VC = [[HealthCheckupFormListViewController alloc]init];
                            if (weakSelf.VaDict) {
                                VC.archive_no = weakSelf.VaDict[@"hp_no"];
                            }
                            VC.tr_InterfaceID = @"86";
                            [weakSelf.navigationController pushViewController:VC animated:YES];
                        }else if (indexpath.row == 3){//接诊记录表
                            HealthReceiveRecordListViewController *VC = [[HealthReceiveRecordListViewController alloc]init];
                            if (weakSelf.VaDict) {
                                VC.archive_no = weakSelf.VaDict[@"hp_no"];
                            }
                            VC.tr_InterfaceID = @"95";
                            [weakSelf.navigationController pushViewController:VC animated:YES];
                        }
                    }
                    
                }else if (self.typeStyle == ServiceStyleYing) {
                    if (indexpath.row == 0) {
                        HealthMyRecordsViewController *VC = [[HealthMyRecordsViewController alloc]init];
                        MyFileModel *model = [MyFileModel mj_objectWithKeyValues:self.VaDict];
                        [VC.itemArray addObject:model];
                        [self.navigationController pushViewController:VC animated:YES];
                    }else if (indexpath.row == 1){//新生儿访视
                        HealthNewbornVisitViewController *vc = [[HealthNewbornVisitViewController alloc]init];
                        if (weakSelf.VaDict) {
                            vc.archive_no = weakSelf.VaDict[@"hp_no"];
                        }
                        vc.tr_InterfaceID = @"87";
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else if (indexpath.row == 2){//
                        
                        if (weakSelf.VaDict) {
                            ChildVaccinationMainViewController *vc = [[ChildVaccinationMainViewController alloc]init];
                            vc.child_id = weakSelf.VaDict[@"hp_no"];
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }
                        
                    }else if (indexpath.row == 3){////产前随访服务记录表 列表
                        WKViewViewController *vc = [[WKViewViewController alloc]init];
                        vc.hn_type = @"婴幼儿接种须知";
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                }else if (self.typeStyle == ServiceStyleYun) {
                    if (indexpath.row == 0) {
                        WKViewViewController *vc = [[WKViewViewController alloc]init];
                        vc.hn_type = @"孕妇建档须知";
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else if (indexpath.row == 1){
                        HealthRecordsFirstViewController *vc = [[HealthRecordsFirstViewController alloc]init];
                        vc.isYun = YES;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else if (indexpath.row == 2){//孕妇第一次产检记录
                        ChanQianRecordViewController *VC = [[ChanQianRecordViewController alloc]init];
                        if (weakSelf.VaDict) {
                            VC.archive_no = weakSelf.VaDict[@"hp_no"];
                        }
                        VC.tr_InterfaceID = @"106";
                        [weakSelf.navigationController pushViewController:VC animated:YES];
                    }else if (indexpath.row == 3){////产前随访服务记录表 列表
                        ChanQianFollowListViewController *VC = [[ChanQianFollowListViewController alloc]init];
                        [self.navigationController pushViewController:VC animated:YES];
                        if (weakSelf.VaDict) {
                            VC.archive_no = weakSelf.VaDict[@"hp_no"];
                        }
                        VC.tr_InterfaceID = @"99";
                        [weakSelf.navigationController pushViewController:VC animated:YES];
                    }
                }
                
            }else if (indexPath.section == 4){
                MeGoodModel *mo = self.goodArr[indexpath.row];
                ShopDoodsDetailsViewController * goods = [[ShopDoodsDetailsViewController alloc]init];
                goods.goods_id = mo.goods_id;
                [self.navigationController pushViewController:goods animated:YES];
            }else if (indexPath.section == 2){
                ShopDoodsDetailsViewController *vc = [[ShopDoodsDetailsViewController alloc]init];
                NSArray *marr = self.dataDt[@"section2"];
                ImLbModel *mo = marr[indexpath.row];
                vc.goods_id = mo.data[@"goods_id"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        
        return cell;
    }else if (indexPath.section == 0 ){
        if (self.VaDict) {
            MedicalPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MedicalPlanTableViewCell"];
            if (self.typeStyle == ServiceStyleMan) {
                cell.nameLb.text = @"下次体检时间";
                cell.dateLb.text = self.VaDict[@"nextdate"];
            }else if (self.typeStyle == ServiceStyleYing) {
                cell.nameLb.text = @"下次接种计划";
                cell.dateLb.text = self.VaDict[@"next_expect_time"];
            }else if (self.typeStyle == ServiceStyleYun) {
                cell.nameLb.text = @"下次产检时间";
                cell.dateLb.text = self.VaDict[@"hc_nextFollowUpdate"];
            }
            return cell;
        }
        WarmTipsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WarmTipsTableViewCell"];
        cell.contentLb.text = @"亲爱的准妈妈：\n1、请您在办理建册档案前到所辖的社区卫生服务站中心建立居民健康档案，并自行留存居民档案号以便孕期建册时使用\n2、请您仔细阅读《孕期建册预约须知》内容，以免影响您建册办理。\n(请客户确认您已阅读)";
        if (self.typeStyle == ServiceStyleMan) {
            cell.contentView.backgroundColor = [UIColor colorFromHexCode:@"83CAF8"];
        }else if (self.typeStyle == ServiceStyleYing) {
            cell.contentView.backgroundColor = [UIColor colorFromHexCode:@"83CAF8"];
        }else if (self.typeStyle == ServiceStyleYun) {
            cell.contentView.backgroundColor = [UIColor colorFromHexCode:@"83CAF8"];
        }
        return cell;

    }
    HealthEducateListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthEducateListTableViewCell"];
    cell.model = self.aritcleArr[indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) return self.VaDict ? 130 : -1;
    
    if (indexPath.section == 1) return 120;
    if (indexPath.section == 2) return 130;
    if (indexPath.section == 3) return -1;
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 1) {
        if (section == 4 && !self.goodArr.count) return 0.001;
            if (section == 2) return self.dataDt[@"section2"] ? 50 : 0.001;
        return 50;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 1) {
        if (section == 4 && !self.goodArr.count) return nil;
        if (section == 2 && !self.dataDt[@"section2"]) return  nil;
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 30, 50) font:[UIFont fontWithName:@"Helvetica-Bold" size:15] textcolor:JHMedicalColor numberOfLines:0 textAlignment:0];
        if (self.typeStyle == ServiceStyleYun) {
            NSArray *arr = @[@"金钥匙服务",@"孕育知识",@"孕育商城"];
            lb.text  = arr[section - 2];
        }
        if (self.typeStyle == ServiceStyleYing) {
            NSArray *arr = @[@"金豆子服务",@"婴幼知识",@"婴幼商城"];
            lb.text  = arr[section - 2];
        }
        if (self.typeStyle == ServiceStyleMan) {
            NSArray *arr = @[@"金夕阳服务",@"慢病知识",@"老高糖商城"];
            lb.text  = arr[section - 2];
        }
        [header addSubview:lb];
        ImRightBtn *btn = [[ImRightBtn alloc]init];
        btn.section = section;
        [btn setImage:[UIImage imageNamed:@"gerenzhongxinjiantou"] forState:UIControlStateNormal];
        [btn setTitle:@"更多 " forState:UIControlStateNormal];
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        return 50;
//    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        return self.sdCySV;
//    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        InforViewController *hot = [[InforViewController alloc]init];
        AritcleNewModel *mo = self.aritcleArr[indexPath.row];
        hot.detailid = mo.ID;
        hot.type = InfoStyleWenZhang;
        [self.navigationController pushViewController:hot animated:YES];
    }

}
#pragma mark - 查看全部
-(void)moreBtnClick:(ImRightBtn *)btn{

    if (btn.section == 2) {
        SanjinListViewController *vc = [[SanjinListViewController alloc]init];
        NSArray *cateArr = @[@"111",@"112",@"110"];
        vc.category_id = cateArr[self.typeStyle];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.section == 3){
        InformationViewController *hot = [[InformationViewController alloc]init];
        hot.type = InfoStyleWenZhang;
        if (self.typeStyle == ServiceStyleYun) {
            hot.url = MedicalYunListUrl;
            hot.titleStr = @"孕育知识";
        }
        if (self.typeStyle == ServiceStyleYing) {
            hot.url = MedicalYingListUrl;
            hot.titleStr = @"婴幼知识";
        }
        if (self.typeStyle == ServiceStyleMan) {
            hot.url = MedicalManListUrl;
            hot.titleStr = @"慢病知识";
        }
        
        [self.navigationController pushViewController:hot animated:YES];
    }
}
#pragma mark - 接种记录
- (void)getDataVaccination{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    NSString *uid = [UserDefault objectForKey:@"uid"];
    if (uid == nil) uid = @"";
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) coid = @"";
    coid = @"53";
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:uid forKey:@"uid"];
    [dt setObject:@"1" forKey:@"iszb"];
    NSString *url = @"";
    if (self.typeStyle == ServiceStyleMan) {
        url = @"115";
    }else if (self.typeStyle == ServiceStyleYing) {
        url = @"113";
    }else if (self.typeStyle == ServiceStyleYun) {
        url = @"116";
    }
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,url) params:dt success:^(id response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@" 数据提交:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSArray class]] && [response[@"data"] count]) {
                self.VaDict = response[@"data"][0];
            }
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self UpateHeaderview];
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
    NSMutableDictionary *dt = [NSMutableDictionary dictionaryWithDictionary:@{@"session":session,@"pagination":@{@"count":@"3",@"page":@"1"}}];
    NSString *category_id  =@"";
    if (self.typeStyle == ServiceStyleMan) {
        category_id = @"110";
    }else if (self.typeStyle == ServiceStyleYing) {
        category_id = @"112";
    }else if (self.typeStyle == ServiceStyleYun) {
        category_id = @"111";
    }
    [dt setObject:category_id forKey:@"category_id"];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,GoldenGoodsListUrl) params:dt success:^(id response) {
        LFLog(@"金钥匙服务:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            NSMutableArray *marr = [NSMutableArray array];
            [ImLbModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"imgurl":@"img"};
            }];
            for (NSDictionary *temDt in response[@"data"]) {
                ImLbModel *mo = [ImLbModel mj_objectWithKeyValues:temDt];
                mo.backcolor = @"F0F0F0";
                mo.data = temDt;
                mo.cornerRadius = @"3";
                [marr addObject:mo];
            }
            [self.dataDt setObject:marr forKey:@"section2"];
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
#pragma mark - 文章
- (void)getData{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    NSString *url = @"";
    NSDictionary *pagination = @{@"count":@"3",@"page":@"1"};
    [dt setObject:pagination forKey:@"pagination"];
    if (self.typeStyle == ServiceStyleMan) {
        url = MedicalManListUrl;
    }else if (self.typeStyle == ServiceStyleYing) {
        url = MedicalYingListUrl;
    }else if (self.typeStyle == ServiceStyleYun) {
        url = MedicalYunListUrl;
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        LFLog(@" 数据提交:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.aritcleArr removeAllObjects];
            for (NSDictionary *temdt in response[@"data"]) {
                AritcleNewModel *model = [AritcleNewModel mj_objectWithKeyValues:temdt];
                [self.aritcleArr addObject:model];
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
#pragma mark 商品
-(void)UploadDataGoods{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary *dt = [NSMutableDictionary dictionaryWithDictionary:@{@"session":session,@"pagination":@{@"count":@"2",@"page":@"1"}}];
    if (self.typeStyle == ServiceStyleMan) {
        [dt setObject:@"lgt" forKey:@"String"];
    }else if (self.typeStyle == ServiceStyleYing) {
        [dt setObject:@"yingyou" forKey:@"String"];
    }else if (self.typeStyle == ServiceStyleYun) {
        [dt setObject:@"yunyu" forKey:@"String"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,MedicalGoodsListUrl) params:dt success:^(id response) {
        LFLog(@"商品:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.goodArr removeAllObjects];
            for (NSDictionary *temdt in response[@"data"]) {
                MeGoodModel *mo = [MeGoodModel mj_objectWithKeyValues:temdt];
                [self.goodArr addObject:mo];
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
