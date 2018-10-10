//
//  VaccinationPlanViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/21.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "VaccinationPlanViewController.h"
#import "SPPageMenu.h"
#import "MKJCollectionViewFlowLayout.h"
#import "MKJCollectionViewCell.h"
#import "VaccinationPlanCollectionViewCell.h"
#import "VaccinationPlanTableViewCell.h"
#import "VaccinationSumbitViewController.h"
#import "HealthEducateDetailViewController.h"
#import "PregnantAddItemViewController.h"
@interface VaccinationPlanViewController ()<SPPageMenuDelegate, UIScrollViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MKJCollectionViewFlowLayoutDelegate>
@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong) NSMutableArray *tabviewArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic,strong)UICollectionView * collectionview;
@end

@implementation VaccinationPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.dataArr = [NSMutableArray arrayWithObjects:@"1月龄",@"2月龄",@"3月龄",@"4月龄",@"5月龄",@"6月龄", nil];
//    self.navigationBarTitle =@"接种证";
    self.view.backgroundColor = JHbgColor;
    [self.view addSubview:self.pageMenu];
    [self presentLoadingTips];
    [self requestDataChildRelation:YES];
    
}
-(NSMutableArray *)dataArr{
    if (_dataArr== nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)tabviewArr{
    if (_tabviewArr == nil) {
        _tabviewArr = [NSMutableArray array];
    }
    return _tabviewArr;
}
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, NaviH, screenW, 70) trackerStyle:SPPageMenuTrackerStyleLine];
        pageMenu.tracker.backgroundColor = JHMedicalColor;
        // 传递数组，默认选中第1个
        // 可滑动的自适应内容排列
        pageMenu.permutationWay = SPPageMenuPermutationWayScrollAdaptContent;
        // 设置代理
        pageMenu.selectedItemTitleColor = JHMedicalColor;
        pageMenu.unSelectedItemTitleColor = JHmiddleColor;
        pageMenu.delegate = self;
        pageMenu.VerticalLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 20)];
        pageMenu.VerticalLine.backgroundColor = JHBorderColor;
        _pageMenu = pageMenu;
        
        
    }
    return _pageMenu;
}

-(void)RefreshCategoryData{
    [self.tabviewArr removeAllObjects];
    for (int i = 0; i < self.dataArr.count; i ++) {
        baseTableview *tab = [[baseTableview alloc]init];
        tab.dataSource = self;
        tab.delegate = self;
        if (!self.child_id) {
            tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
//        tab.emptyDataSetSource = self;
//        tab.emptyDataSetDelegate = self;
        [tab registerClass:[UITableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"Pregnantcell_%d",i]];
        [tab registerNib:[UINib nibWithNibName:@"VaccinationPlanTableViewCell" bundle:nil] forCellReuseIdentifier:[NSString stringWithFormat:@"Vaccinationcell_%d",i]];
        [self.tabviewArr addObject:tab];
    }
    [self.pageMenu setItems:self.dataArr selectedItemIndex:(self.selectedIndex ? [self.selectedIndex integerValue] :0)];
    [self.view addSubview:self.collectionview];
    if (self.child_id) {
        UIButton *moreBtn = [[UIButton alloc]init];
        [moreBtn setTitle:@"   了解更多疫苗相关知识" forState:UIControlStateNormal];
        [moreBtn setTitleColor:JHdeepColor forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"liaojiegengduo"] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [moreBtn addTarget:self action:@selector(moreBtnclick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.offset(-10);
        }];
    }

}
-(void)moreBtnclick{
    HealthEducateDetailViewController *detail = [[HealthEducateDetailViewController alloc]init];
    detail.urlStr = UnderstandMoreUrl;
    [self.navigationController pushViewController:detail animated:YES];
}
-(UICollectionView *)collectionview{
    if (_collectionview == nil) {
        MKJCollectionViewFlowLayout *flow = [[MKJCollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.itemSize = CGSizeMake(screenW - 120, screenH - NaviH - 70 - 200);
        flow.minimumLineSpacing = 30;
        flow.minimumInteritemSpacing =30;
        flow.needAlpha = NO;
        flow.delegate = self;
        CGFloat oneX = 30;
        flow.sca = 4;
        flow.sectionInset = UIEdgeInsetsMake(0, oneX, 0, oneX);
        _collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, NaviH + 70 , screenW ,screenH - NaviH - 70 - 50) collectionViewLayout:flow];
        _collectionview.dataSource=self;
        _collectionview.delegate=self;
        _collectionview.showsHorizontalScrollIndicator = NO;
        _collectionview.layer.masksToBounds = NO;
        [_collectionview setBackgroundColor:JHbgColor];
        [_collectionview registerClass:[VaccinationPlanCollectionViewCell class] forCellWithReuseIdentifier:@"VaccinationCell"];
//        [_collectionview registerNib:[UINib nibWithNibName:@"MKJCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"VaccinationCell"];
    }
    return _collectionview;
}
#pragma mark - *************tableview*************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (self.child_id) {
//        return 1;
//    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int inx = 0;
    baseTableview *tab = nil;
    for (UITableView *tabtem in self.tabviewArr) {
        if (tableView == tabtem) {
            tab = (baseTableview *)tabtem;
            break;
        }
        inx ++;
    }
    if (self.child_id) {
        NSArray *vaccinateArr = self.dataArray[inx][@"Vaccine"];
        if (vaccinateArr && vaccinateArr.count) {
            return vaccinateArr.count;
        }
    }else{
        return 2;
    }

    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.child_id) {
        return 40;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int inx = 0;
    baseTableview *tab = nil;
    for (UITableView *tabtem in self.tabviewArr) {
        if (tableView == tabtem) {
            tab = (baseTableview *)tabtem;
            break;
        }
        inx ++;
    }
    VaccinationPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Vaccinationcell_%d",inx]];
    if (self.child_id) {
        NSArray *vaccinateArr = self.dataArray[inx][@"Vaccine"];
        NSDictionary *dt = vaccinateArr[indexPath.row];
        cell.nameLb.text  = dt[@"va_free"];
        cell.descLb.text  = dt[@"va_name"];
        cell.numLb.text  = [NSString stringWithFormat:@"%@ %@",dt[@"va_free"],dt[@"times"]];
    }else{
        cell.nameDescHeight.constant = -40;
        if (indexPath.row == 0) {
            cell.nameLb.text = @"产检\n项目";
            cell.descLb.text = self.dataArray[inx][@"vaccinate_isfree"];
        }else{
            cell.nameLb.text =  @"可选\n加项";
            cell.descLb.text = self.dataArray[inx][@"vaccinate_notfree"];
        }
    }

    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (self.child_id) {
//        return nil;
//    }
//    UIView *header = [[UIView alloc]init];
//    header.backgroundColor = [UIColor whiteColor];
//    UILabel * nameLb = [UILabel initialization:CGRectZero font:[UIFont systemFontOfSize:15] textcolor:JHmiddleColor numberOfLines:0 textAlignment:0];
//    [header addSubview:nameLb];
//    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(10);
//        make.top.offset(0);
//        make.bottom.offset(0);
//    }];
//    return header;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int inx = 0;
    for (UITableView *tab in self.tabviewArr) {
        if (tableView == tab) {
            break;
        }
        inx ++;
    }
    if (self.child_id) {
        NSArray *vaccinateArr = self.dataArray[inx][@"vaccinate_isfree"];
        NSDictionary *dt = vaccinateArr[indexPath.row];
        VaccinationSumbitViewController *sub = [[VaccinationSumbitViewController alloc]init];
        sub.tid = dt[@"tid"];
        sub.child_id = self.child_id;
        [self.navigationController pushViewController:sub animated:YES];
    }else{
        PregnantAddItemViewController *sub = [[PregnantAddItemViewController alloc]init];
        sub.planid = self.dataArray[inx][@"tid"];
        [self.navigationController pushViewController:sub animated:YES];
    }
}
#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
    //    return self.menuArr.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    MKJCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VaccinationCell" forIndexPath:indexPath];
//    cell.heroImageVIew.image = [UIImage imageNamed:@"touxiang_yiliao"];
    VaccinationPlanCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VaccinationCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];

    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.tabview = self.tabviewArr[indexPath.row];
    NSDictionary *dt = self.dataArray[indexPath.row];
    NSArray *vaccinateArr = dt[@"Vaccine"];
//    cell.headerLb.text = [NSString stringWithFormat:@"   预计：%@   ",dt[@"expect_time"]];
    if (vaccinateArr.count) {
        cell.headerLb.text = [NSString stringWithFormat:@"   预计：%@   ",vaccinateArr[0][@"next_expect_time"]];
        cell.footerLb.text = [NSString stringWithFormat:@"下次接种时间：%@",vaccinateArr[0][@"next_expect_time"]];
    }else{
        cell.footerLb.text = @"";
        cell.headerLb.text = @"";
    }
    
    __weak typeof(self) weakSelf = self;
    [cell setBlock:^{
        if (self.child_id) {
            VaccinationSumbitViewController *sub = [[VaccinationSumbitViewController alloc]init];
            sub.tid = dt[@"tid"];
            sub.child_id = weakSelf.child_id;
            [weakSelf.navigationController pushViewController:sub animated:YES];
        }else{
            PregnantAddItemViewController *sub = [[PregnantAddItemViewController alloc]init];
            sub.planid = dt[@"tid"];
            [weakSelf.navigationController pushViewController:sub animated:YES];
        }
        

    }];
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(screenW - 160, screenH - NaviH - 70 - 200);
//}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 80;
//}
//// 设置最小列间距，也就是左行与右一行的中间最小间隔
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 80;
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)collectioViewScrollToIndex:(NSInteger)index{
    LFLog(@"index:%ld",(long)index);
    self.selectedIndex = [NSNumber numberWithInteger:index];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.collectionview) {
        if (self.pageMenu.selectedItemIndex != [self.selectedIndex integerValue]) {
            self.pageMenu.selectedItemIndex = [self.selectedIndex integerValue];
        }
    }

}

#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    self.selectedIndex = [NSNumber numberWithInteger:toIndex];
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        if (self.dataArr.count > toIndex) {
            [self.collectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
//        [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:NO];
    } else {
        if (self.dataArr.count > toIndex) {
            [self.collectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
//        [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:YES];
    }
//    if (self.myChildViewControllers.count <= toIndex) {return;}
//
//    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
//    // 如果已经加载过，就不再加载
//    if ([targetViewController isViewLoaded]) return;
//
//    targetViewController.view.frame = CGRectMake(screenW * toIndex, 0, screenW, scrollViewHeight);
//    [_scrollView addSubview:targetViewController.view];
    
}

- (void)pageMenu:(SPPageMenu *)pageMenu functionButtonClicked:(UIButton *)functionButton {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"插入一个带标题的item" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self insertItemWithObject:@"十九大" toIndex:0];
//    }];
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"插入一个带图片的item" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self insertItemWithObject:[UIImage imageNamed:@"Expression_1"] toIndex:1];
//    }];
//    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"删除一个item" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [self removeItemAtIndex:1];
//    }];
//    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"删除所有item" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [self removeAllItems];
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alertController addAction:action1];
//    [alertController addAction:action2];
//    [alertController addAction:action3];
//    [alertController addAction:action4];
//    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - *************分类*************
-(void)requestDataChildRelation:(BOOL )isFirst{

    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    NSString *url = ERPVaccinationPlanUrl;
    if (self.child_id) {
        [dt setObject:self.child_id forKey:@"hp_no"];
    }else{
        url =  PregnantCheckPlanUrl;
    }
    NSString *uid = [UserDefault objectForKey:@"uid"];
    if (uid == nil) uid = @"";
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) coid = @"";
    coid = @"53";
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:uid forKey:@"uid"];
    [dt setObject:@"1" forKey:@"iszb"];
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,url) params:dt success:^(id response) {
        LFLog(@"接种计划分类:%@",response);
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *str in response[@"data"]) {
                [self.dataArray addObject:str];
                [self.dataArr addObject:str[@"va_monthold"]];
            }
            if (self.dataArr.count) {
                [self RefreshCategoryData];
            }
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self requestDataChildRelation:YES];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"%@",error);
        [self presentLoadingTips:@"请求失败！"];
    }];
    
}

@end
