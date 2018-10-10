//
//  CouponExchangeViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/1/4.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "CouponExchangeViewController.h"
#import "SelectorCustomView.h"
#import "GrabVolumeTableViewCell.h"
#import "ConfirmOrderViewController.h"
@interface CouponExchangeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,SelectorCustomViewDelegate>{
    SelectorCustomView *selectview;
}
@property(nonatomic,strong)UICollectionView *collectionview;
@property(nonatomic,strong)NSArray *menuArr;
@property(nonatomic,strong)NSMutableDictionary *dataDict;
@property(nonatomic,strong)NSMutableArray *tableArray;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
@end

@implementation CouponExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (!self.selectedIndex) {
        self.selectedIndex = 0;
    }

    if (!self.isSelect) {
        self.menuArr = @[@"未使用",@"已使用",@"已过期"];
        [self createtitleView];
    }else{
        self.menuArr = @[@"不使用优惠券"];
    }
    
    if (self.titleStr) {
        self.navigationBarTitle = self.titleStr;
    }else{
        self.navigationBarTitle = [NSString stringWithFormat:@"%@优惠券",self.menuArr[[self.selectedIndex integerValue]]];
    }
    
    self.tableArray = [NSMutableArray array];
    for (int i = 0; i < self.menuArr.count; i ++) {
        UITableView *tableveiw = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN.size.width, SCREEN.size.height - (self.isSelect ? 64:109) ) style:UITableViewStyleGrouped];
        tableveiw.delegate = self;
        tableveiw.dataSource  = self;
        tableveiw.emptyDataSetSource = self;
        tableveiw.emptyDataSetDelegate  = self;
        tableveiw.backgroundColor  = JHbgColor;
        tableveiw.separatorColor = [UIColor whiteColor];
        [tableveiw registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [tableveiw registerNib:[UINib nibWithNibName:@"GrabVolumeTableViewCell" bundle:nil] forCellReuseIdentifier:@"GrabVolumeTableViewCell"];
        
        [self.tableArray addObject:tableveiw];
        NSMutableArray *marr = [NSMutableArray array];
        [self.dataDict setObject:marr forKey:[NSString stringWithFormat:@"key%d",i]];
        [self.dataDict setObject:@"1" forKey:[NSString stringWithFormat:@"more%d",i]];
        [self.dataDict setObject:@"1" forKey:[NSString stringWithFormat:@"page%d",i]];
        if (!self.isSelect) {
            [self rotateData:i pagenum:1];
        }
        if (self.isSelect) {
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 50)];
            headerView.backgroundColor =JHbgColor;
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, SCREEN.size.width - 20, 30)];
            [headerView addSubview:button];
            button.backgroundColor = [UIColor whiteColor];
            button.layer.cornerRadius = 3;
            button.layer.masksToBounds =YES;
            [button setTitle:@"不使用优惠券" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:JHdeepColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(gobackBtnclick) forControlEvents:UIControlEventTouchUpInside];
            tableveiw.tableHeaderView = headerView;
            [marr addObjectsFromArray:self.boundArr];
            
        }else{
            [self setupRefresh:tableveiw];
        }
    }
    [self createtitleView];
    [self createCollectionview];
}
//不使用优惠券
-(void)gobackBtnclick{
    NSArray *vcArr = self.navigationController.viewControllers;
    for (UIViewController *vc in vcArr) {
        if ([vc isKindOfClass:[ConfirmOrderViewController class]]) {
            ConfirmOrderViewController *con = (ConfirmOrderViewController *)vc;
            con.couponDict = nil;
            [con updateTableview];
            [self.navigationController popToViewController:con animated:YES];
        }
    }
    
}
-(NSMutableDictionary *)dataDict{
    
    if (_dataDict == nil) {
        _dataDict = [[NSMutableDictionary alloc]init];
    }
    
    return _dataDict;
    
}

-(void)createtitleView{

    selectview = [[SelectorCustomView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, 45)];
    [selectview initWithsubArray:self.menuArr currentIndex:[self.selectedIndex integerValue] lineColor:JHMaincolor font:15 selectColor:JHMaincolor Color:JHdeepColor];
    selectview.delegate = self;
    [self.view addSubview:selectview];
}
-(void)SelectorCustomViewSelectBtnClick:(CGFloat )index titleName:(NSString *)titleName{
    LFLog(@"titleName:%@ index:%f",titleName,index);
    self.navigationBarTitle = [NSString stringWithFormat:@"%@优惠券",titleName];
    NSIndexPath * indexPth = [NSIndexPath indexPathForRow:index inSection:0];
    [self.collectionview scrollToItemAtIndexPath:indexPth atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}
-(void)createCollectionview{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.itemSize = CGSizeMake(SCREEN.size.width - 1, SCREEN.size.height - (self.isSelect ? 64:109));
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, (self.isSelect ? 64:109), SCREEN.size.width, SCREEN.size.height - (self.isSelect ? 64:109)) collectionViewLayout:flowLayout];
    //    self.collectionview.panEnabled = YES;
    self.collectionview.pagingEnabled = YES;
    self.collectionview.dataSource=self;
    //    self.collectionview.scrollEnabled = YES;
    self.collectionview.backgroundColor = [UIColor whiteColor];
    self.collectionview.delegate=self;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CouponCollectionViewCell"];
    [self.view addSubview:self.collectionview];
    
    [self tz_addPopGestureToView:self.collectionview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int index = 0;
    for (UITableView *tab in self.tableArray) {
        if (tab == tableView) {
            break;
        }
        index ++;
    }
    NSString *key = [NSString stringWithFormat:@"key%d",index];
    NSMutableArray *dataArray = self.dataDict[key];
    return dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int index = 0;
    for (UITableView *tab in self.tableArray) {
        if (tab == tableView) {
            break;
        }
        index ++;
    }
    
    GrabVolumeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GrabVolumeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.rightBackview removeAllSubviews];
    NSString *key = [NSString stringWithFormat:@"key%d",index];
    NSMutableArray *marr = self.dataDict[key];
    NSDictionary *dt = marr[indexPath.section];
    [cell.picture sd_setImageWithURL:[NSURL URLWithString:dt[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cell.progress.hidden = YES;
    cell.rightViewWidth.constant = 0;
    cell.rightBackview.hidden = YES;
    cell.leftBackview.backgroundImage = [UIImage imageNamed:@"youhuiquan_wsy"];
//    cell.progress.colorView.backgroundColor = JHColor(255, 205, 187);
//    cell.progress.scale = 0;
//    cell.progress.layer.borderColor = [[UIColor clearColor]CGColor];
//    cell.progress.leftLb.textColor = JHmiddleColor;
//    cell.progress.leftLb.font = [UIFont systemFontOfSize:10];
//    cell.progress.leftLb.text = @"";
    cell.contentLb.text = dt[@"type_name"];
    cell.amountLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    NSString *amount = [NSString stringWithFormat:@"%@ %@",dt[@"type_money"],dt[@"min_goods_amount"]];
    cell.amountLb.attributedText = [amount AttributedString:dt[@"type_money"] backColor:nil uicolor:nil uifont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
//    UILabel *rightlb = [[UILabel alloc]init];
//    rightlb.font = [UIFont systemFontOfSize:15];
//    rightlb.numberOfLines = 3;
//    rightlb.text = self.menuArr[index];
//    [cell.rightBackview addSubview:rightlb];
//    [rightlb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(cell.rightBackview.mas_centerX).offset(0);
//        make.width.offset(17);
//        make.top.offset(0);
//        make.bottom.offset(0);
//    }];
    if (index != 0) {
        cell.leftTopImage.hidden = NO;
        if (index == 1) {
            cell.leftTopImage.image = [UIImage imageNamed:@"yishiyong_yhq"];
        }else if(index == 2){
            cell.leftTopImage.image = [UIImage imageNamed:@"yiguoqi_yhq"];
        }
    }else{
        cell.leftTopImage.hidden = YES;
    }

    return cell;

}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    int index = 0;
    for (UITableView *tab in self.tableArray) {
        if (tab == tableView) {
            break;
        }
        index ++;
    }
    NSString *key = [NSString stringWithFormat:@"key%d",index];
    NSMutableArray *marr = self.dataDict[key];
    NSDictionary *dt = marr[section];
    UIView *bview = [[UIView alloc]init];
    bview.backgroundColor = [UIColor whiteColor];
    UILabel *lb = [[UILabel alloc]init];
    lb.font =  [UIFont systemFontOfSize:14];
    lb.textColor = JHmiddleColor;
    lb.text = [NSString stringWithFormat:@"使用有效期至: %@",dt[@"use_end_date"]];
    [bview addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(0);
        make.bottom.offset(0);
        make.right.offset(-10);
    }];
    return bview;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    int index = 0;
//    for (UITableView *tab in self.tableArray) {
//        if (tab == tableView) {
//            break;
//        }
//        index ++;
//    }
//    NSString *key = [NSString stringWithFormat:@"key%d",index];
//    NSMutableArray *marr = self.dataDict[key];
//    NSDictionary *dt = marr[section];
    UIView *bview = [[UIView alloc]init];
    bview.backgroundColor = JHBorderColor;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN.size.width, 10)];
    view.backgroundColor = [UIColor whiteColor];
    [bview addSubview:view];
//    UILabel *lb = [[UILabel alloc]init];
//    lb.font =  [UIFont systemFontOfSize:14];
//    lb.textColor = JHmiddleColor;
//    lb.text = [NSString stringWithFormat:@"兑换码: %@",dt[@"order_sn"]];
//    [view addSubview:lb];
//    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(10);
//        make.top.offset(0);
//        make.bottom.offset(0);
//        make.right.offset(-10);
//    }];
    return bview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isSelect) {
        NSArray *vcArr = self.navigationController.viewControllers;
        for (UIViewController *vc in vcArr) {
            if ([vc isKindOfClass:[ConfirmOrderViewController class]]) {
                ConfirmOrderViewController *con = (ConfirmOrderViewController *)vc;
                int index = 0;
                for (UITableView *tab in self.tableArray) {
                    if (tab == tableView) {
                        break;
                    }
                    index ++;
                }
                NSString *key = [NSString stringWithFormat:@"key%d",index];
                NSMutableArray *mArray = self.dataDict[key];
                con.couponDict = mArray[indexPath.row];
                [con updateTableview];
                [self.navigationController popToViewController:con animated:YES];
            }
        }
    }
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
    static NSString * CellIdentifier = @"CouponCollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UITableView *tableveiw = self.tableArray[indexPath.row];
    [cell.contentView addSubview:tableveiw];
    [self setupRefresh:tableveiw];
    [tableveiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
    }];
    return cell;
}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
    selectview.selectIndex = currentIndex;
    self.navigationBarTitle = [NSString stringWithFormat:@"%@优惠券",self.menuArr[currentIndex]];
}
#pragma mark 请求数据
-(void)rotateData:(NSInteger )selecIndex  pagenum:(NSInteger )pagenum{
    UITableView *tableveiw = self.tableArray[selecIndex];
    NSString *key = [NSString stringWithFormat:@"key%d",(int)selecIndex];
    NSMutableArray *dataArray = self.dataDict[key];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    NSDictionary *dt = @{@"session":session,@"pagination":pagination,@"status":[NSString stringWithFormat:@"%ld",(long)selecIndex]};
    LFLog(@"请求数据dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,CouponRushListUrl) params:dt success:^(id response) {
        LFLog(@"请求数据:%@",response);
        [tableveiw.mj_header endRefreshing];
        [tableveiw.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            
            NSString * more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            if (pagenum == 1) {
                [dataArray removeAllObjects];
            }
            for (NSDictionary *dt in response[@"data"]) {
                [dataArray addObject:dt];
            }
            [self.dataDict setObject:more forKey:[NSString stringWithFormat:@"more%d",(int)selecIndex]];
            [self.dataDict setObject:dataArray forKey:key];
            LFLog(@"self.dataDict:%@",self.dataDict);
            [tableveiw reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
        
    } failure:^(NSError *error) {
        [self presentLoadingTips:@"加载失败"];
        [tableveiw.mj_header endRefreshing];
        [tableveiw.mj_footer endRefreshing];
    }];
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh:(UITableView *)tabview
{
    
    // 下拉刷新
    tabview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
        NSString *more = self.dataDict[[NSString stringWithFormat:@"more%ld",(long)currentIndex]];
        [self.dataDict setObject:@"1" forKey:more];
        [self.dataDict setObject:@"1" forKey:[NSString stringWithFormat:@"page%ld",(long)currentIndex]];
        LFLog(@"currentIndex:%ld",(long)currentIndex);
        [self rotateData:currentIndex pagenum:1];
        
    }];
    tabview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
        NSString *more = self.dataDict[[NSString stringWithFormat:@"more%ld",(long)currentIndex]];
        NSInteger page = [self.dataDict[[NSString stringWithFormat:@"page%ld",(long)currentIndex]] integerValue];
        if ([more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多数据了"];
            [tabview.mj_footer endRefreshing];
        }else{
            page ++;
            [self.dataDict setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:[NSString stringWithFormat:@"page%ld",(long)currentIndex]];
            [self rotateData:currentIndex pagenum:page];
        }
        
    }];
    
}

@end

