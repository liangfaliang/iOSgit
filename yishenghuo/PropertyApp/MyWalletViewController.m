
//
//  MyWalletViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/7/20.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyWalletTableViewCell.h"
#import "RechargeViewController.h"
@interface MyWalletViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    UIView *headview ;
}
@property(nonatomic,strong)UICollectionView *collectionview;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)NSMutableArray *consumptionArr;
@property(nonatomic,strong)NSMutableArray *RechargeArr;
@property(nonatomic,strong)UIButton *selecbutton;
@property(nonatomic,strong)UIView *vline;
@property(strong,nonatomic)UIImageView *backImage;
@property(strong,nonatomic)UILabel *priceLb;

@property(nonatomic,strong)NSString *conmore;//消费
@property(nonatomic,assign)NSInteger conpage;
@property(nonatomic,strong)NSString *Recmore;//充值
@property(nonatomic,assign)NSInteger Recpage;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"我的钱包";
    self.conpage = 1;
    self.conmore = @"1";
    self.Recpage = 1;
    self.Recmore = @"1";
    [self createTable];
    [self rotateData:@"0" pagenum:1];
    [self rotateData:@"1" pagenum:1];
}

-(void)createTable{
    
    //    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height )];
    //    [self.view addSubview:_scrollview];
    //    _scrollview.contentSize = CGSizeMake(0, SCREEN.size.height *2);
    //    _scrollview.pagingEnabled = YES;
    //    _scrollview.delegate = self;
    //
    //    UIImageView *headerview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 300)];
    //    headerview.backgroundColor = [UIColor redColor];
    //    [_scrollview addSubview:headerview];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height ) style:UITableViewStylePlain] ;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"onecell"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"twocell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"MyWalletTableViewCell" bundle:nil] forCellReuseIdentifier:[NSString stringWithFormat:@"MyWalletTableViewCell"]];
    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width,SCREEN.size.height - 114)];
    [self setupRefresh:self.tableview];
    
    
}
-(void)createCollectionview{
    
    if (self.collectionview == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.itemSize = CGSizeMake(SCREEN.size.width - 1, SCREEN.size.height - 50);
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.minimumLineSpacing = 1;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        self.collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 50) collectionViewLayout:flowLayout];
        //    self.collectionview.panEnabled = YES;
        self.collectionview.pagingEnabled = YES;
        self.collectionview.dataSource=self;
        //    self.collectionview.scrollEnabled = YES;
        self.collectionview.backgroundColor = [UIColor whiteColor];
        self.collectionview.delegate=self;
        [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }else{
        [self.collectionview reloadData];
    }
    
    
}
-(NSMutableArray *)RechargeArr{
    
    if (_RechargeArr == nil) {
        _RechargeArr = [[NSMutableArray alloc]init];
    }
    
    return _RechargeArr;
    
}
-(NSMutableArray *)consumptionArr{
    
    if (_consumptionArr == nil) {
        _consumptionArr = [[NSMutableArray alloc]init];
    }
    
    return _consumptionArr;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.tableview) {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return self.dataArray.count;
    if (tableView == self.tableview) {
        if (section == 0) {
            return 1;
        }else if (self.selecbutton.tag == 100){
            return self.consumptionArr.count;
        }else{
            return self.RechargeArr.count;;
        }
    }else if (tableView.tag == 10000){
        
        return self.consumptionArr.count;
    }
    return self.RechargeArr.count;;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableview) {
        if (indexPath.section == 0) {
            UIImage *image = [UIImage imageNamed:@"beijing_chongzhi"];
            return image.size.height ;
        }
        return 60;
    }
    return 60;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableview) {
        if (section == 0) {
            return 0.0001;
        }
        return 50;
    }
    return 0.0001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableview) {
        if (section == 0) {
            return nil;
        }
        if (headview == nil) {
            headview = [[UIView alloc]init];
            NSArray *segementArray =@[@"消费明细",@"充值明细"];
            for (int i = 0; i < 2; i ++) {
                UIButton *segbtn = [self.view viewWithTag:i + 100];
                if (segbtn == nil) {
                    segbtn = [[UIButton alloc]initWithFrame:CGRectMake(i * SCREEN.size.width/2, 0, SCREEN.size.width/2, 48)];
                    segbtn.tag = i + 100;
                    segbtn.backgroundColor = [UIColor whiteColor];
                    [segbtn setTitle:segementArray[i] forState:UIControlStateNormal];
                    
                    if (i == 0) {
                        [segbtn setTitleColor:JHMaincolor forState:UIControlStateNormal];
                        self.selecbutton = segbtn;
                        
                        
                    }else{
                        [segbtn setTitleColor:JHColor(53, 53, 53) forState:UIControlStateNormal];
                        
                        
                    }
                    [segbtn addTarget:self action:@selector(segmentclick:) forControlEvents:UIControlEventTouchUpInside];
                }
                [headview addSubview:segbtn];
                
            }
            
            if (self.vline == nil) {
                self.vline =[[UIView alloc]initWithFrame:CGRectMake(10, 48, SCREEN.size.width/2 - 20, 2)];
                self.vline.backgroundColor = JHMaincolor ;
                
            }
            [headview addSubview:self.vline];
        }
        return headview;
    }
    return nil;
}
#pragma mark 选择按钮
-(void)segmentclick:(UIButton *)seg{
    
    LFLog(@"seg.tag:%ld",(long)seg.tag);
    LFLog(@"(self.selecbutton:%ld",(long)self.selecbutton.tag);
    if (self.selecbutton.tag !=seg.tag) {
        [self.selecbutton setTitleColor:JHColor(53, 53, 53) forState:UIControlStateNormal];
        [seg setTitleColor:JHMaincolor forState:UIControlStateNormal];
        
    }
    NSInteger Index = seg.tag - 100;
    self.selecbutton = seg;
    //    NSIndexPath * index = [NSIndexPath indexPathForRow:seg.tag - 100 inSection:0];
    //    [self.collectionview scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    if (Index == 0) {
        self.vline.center = CGPointMake(SCREEN.size.width/4, 49);
        
    }else{
        self.vline.center = CGPointMake(SCREEN.size.width/4 * 3, 49);
        
    }
    [self.tableview reloadData];
    //    [self.tableview reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableview) {
        
        //    NSDictionary *dt = self.dataArray[indexPath.row];
        if (indexPath.section == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecell"];
            cell.backgroundColor = JHbgColor;
            if (self.backImage == nil) {
                self.backImage = [[UIImageView alloc]init];
                self.backImage.userInteractionEnabled = YES;
                self.backImage.image = [UIImage imageNamed:@"beijing_chongzhi"];
                if (self.priceLb == nil) {
                    self.priceLb = [[UILabel alloc]init];
                    self.priceLb.textColor = [UIColor whiteColor];
                    self.priceLb.numberOfLines = 0;
                    self.priceLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:40];
                    NSString *meony  = [userDefaults objectForKey:@"user_money"];
                    if (meony == nil) {
                        meony = @"0.00";
                    }
                    self.priceLb.attributedText = [[NSString stringWithFormat:@"%@\n总金额",meony] AttributedString:@"总金额" backColor:nil uicolor:nil uifont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
                    self.priceLb.textAlignment = NSTextAlignmentCenter;
                    [self.backImage addSubview:self.priceLb ];
                    [self.priceLb  mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.backImage.mas_centerX);
                        make.top.offset(80);
                        
                    }];
                }
                
                UIButton *RechargeBtn = [[UIButton alloc]init];
                [self.backImage addSubview:RechargeBtn];
                [RechargeBtn addTarget:self action:@selector(RechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [RechargeBtn setImage:[UIImage imageNamed:@"quchongzhibuttun"] forState:UIControlStateNormal];
                [RechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.backImage.mas_centerX);
                    make.bottom.offset(-80);
                    make.height.offset(RechargeBtn.imageView.image.size.height);
                }];
                
            }
            [cell.contentView addSubview:self.backImage];
            [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.right.offset(0);
                make.top.offset(0);
                make.bottom.offset(0);
            }];
            return cell;
        }else{
            
            //            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twocell"];
            //            cell.backgroundColor = [UIColor whiteColor];
            //            [self createCollectionview];
            //            [cell.contentView addSubview:self.collectionview];
            //            [self tz_addPopGestureToView:self.collectionview];
            MyWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyWalletTableViewCell"]];
            NSDictionary *dt = @{};
            if (self.selecbutton.tag == 100) {
                dt = self.consumptionArr[indexPath.row];
            }else{
                dt = self.RechargeArr[indexPath.row];
            }
            cell.nameLb.text = [NSString stringWithFormat:@"%@",dt[@"change_desc"]];
            cell.timeLb.text = [NSString stringWithFormat:@"%@",dt[@"add_time"]];
            cell.priceLabel.text = [NSString stringWithFormat:@"%@",dt[@"user_money"]];
            cell.priceLbWidth.constant = [cell.priceLabel.text selfadap:15 weith:20].width + 5;
            return cell;
        }
        
        
    }
    LFLog(@"(long)indexPath.row:%ld",(long)(tableView.tag - 10000));
    MyWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyWalletTableViewCell_%ld",(long)(tableView.tag - 10000)]];
    NSDictionary *dt = @{};
    if (tableView.tag == 10000) {
        dt = self.consumptionArr[indexPath.row];
    }else{
        dt = self.RechargeArr[indexPath.row];
    }
    cell.nameLb.text = [NSString stringWithFormat:@"%@",dt[@"change_desc"]];
    cell.timeLb.text = [NSString stringWithFormat:@"%@",dt[@"add_time"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",dt[@"user_money"]];
    cell.priceLbWidth.constant = [cell.priceLabel.text selfadap:15 weith:20].width + 5;
    
    
    return cell;
}

#pragma mark 充值按钮
-(void)RechargeBtnClick{
    
    RechargeViewController *rech = [[RechargeViewController alloc]init];
    [self.navigationController pushViewController:rech animated:YES];
}

#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 2;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    //    for (id subView in cell.contentView.subviews) {
    //        [subView removeFromSuperview];
    //    }
    
    //    MenuModel *mo = [[MenuModel alloc]init];
    //    mo = self.menuArr[indexPath.row];
    //    UIImageView *banerimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.width *8 /25)];
    //
    //    [banerimage sd_setImageWithURL:[NSURL URLWithString:mo.imgurl] placeholderImage:[UIImage imageNamed:@""]];
    //    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 50, 20)];
    //    l.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    //    [banerimage addSubview:l];
    //    [cell.contentView addSubview:banerimage];
    UITableView *tableveiw = [self.view viewWithTag:indexPath.item + 10000];
    if (tableveiw == nil) {
        tableveiw = [[UITableView alloc]init];
        tableveiw.delegate = self;
        tableveiw.tag = 10000 + indexPath.row;
        tableveiw.dataSource  = self;
        //        tableveiw.scrollEnabled = NO;
        
        [tableveiw registerNib:[UINib nibWithNibName:@"MyWalletTableViewCell" bundle:nil] forCellReuseIdentifier:[NSString stringWithFormat:@"MyWalletTableViewCell_%ld",(long)indexPath.item]];
        //        [tableveiw registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listcell"];
        [cell.contentView addSubview:tableveiw];
        [tableveiw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.top.offset(0);
            make.bottom.offset(0);
        }];
        
    }else{
        [tableveiw reloadData];
    }
    
    
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
    
    //    CGPoint pInView = [self.view convertPoint:self.collectionview.center toView:self.collectionview];
    //    // 获取这一点的indexPath
    //    NSIndexPath *indexPathNow = [self.collectionview indexPathForItemAtPoint:pInView];
    //    // 赋值给记录当前坐标的变量
    //
    
    if (scrollView == self.collectionview) {
        NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
        LFLog(@"currentIndex:%ld",(long)currentIndex);
        //        UIButton *button = [self.view viewWithTag:currentIndex + 100];
        //        if (button == self.selecbutton) {
        //
        //        }else{
        //            [self segmentclick:button];
        //        }
        
    }
    
    
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    LFLog(@"scrollView.y:%f",scrollView.y);
    //    if (self.selectBtn.tag == 100) {
    //        if (scrollView.contentOffset.y < - 50) {
    //            //        if (scrollView == self.main.scrollview) {
    //            [self.main.scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    //            //            self.main.scrollview.contentOffset = CGPointMake(0, 0);
    //            //        }
    //        }
    //    }
    
}
-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    LFLog(@"scrollViewDidScrollToTop:%f",scrollView.y);
}
//scrollView滚动时，就调用该方法。任何offset值改变都调用该方法。即滚动过程中，调用多次
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UITableView *tableveiw = [self.view viewWithTag: self.selecbutton.tag + 900];
    if (scrollView == tableveiw) {
        CGPoint point = scrollView.contentOffset;
        if (point.y < 0) {
            tableveiw.scrollEnabled = NO;
            
        }
        
        NSLog(@"%f,%f",point.x,point.y);
        // 从中可以读取contentOffset属性以确定其滚动到的位置。
        // 注意：当ContentSize属性小于Frame时，将不会出发滚动
    }
    if (scrollView == self.tableview) {
        
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    UITableView *tableveiw = [self.view viewWithTag: self.selecbutton.tag + 900];
    if (scrollView == tableveiw) {
        CGFloat height = self.tableview.frame.size.height;
        CGFloat contentYoffset = self.tableview.contentOffset.y;
        CGFloat distanceFromBottom = self.tableview.contentSize.height - contentYoffset;
        if (distanceFromBottom < height) {
            
            NSLog(@"end of table");
            tableveiw.scrollEnabled = YES;
            
        }else{
            if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
                tableveiw.scrollEnabled = NO;
                
            }
            
        }
    }
    
}

// 滑动scrollView，并且手指将要离开时执行。一次有效滑动，只执行一次。
// 当pagingEnabled属性为YES时，不调用该方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSLog(@"scrollViewWillEndDragging");
    
    UITableView *tableveiw = [self.view viewWithTag: self.selecbutton.tag + 900];
    tableveiw.scrollEnabled = YES;
}

#pragma mark 请求数据
-(void)rotateData:(NSString *)type pagenum:(NSInteger )pagenum{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    NSDictionary *dt = @{@"session":session,@"type":type,@"pagination":pagination};
    LFLog(@"请求数据dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,RechargeRecordingUrl) params:dt success:^(id response) {
        LFLog(@"请求数据:%@",response);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            
            if ([type isEqualToString:@"0"]) {
                self.conmore = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
                if (pagenum == 1) {
                    [self.consumptionArr removeAllObjects];
                }
                for (NSDictionary *dt in response[@"data"]) {
                    [self.consumptionArr addObject:dt];
                }
            }else{
                self.Recmore = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
                if (pagenum == 1) {
                    [self.RechargeArr removeAllObjects];
                }
                for (NSDictionary *dt in response[@"data"]) {
                    [self.RechargeArr addObject:dt];
                    
                }
                
            }
            [self.tableview reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self RefreshData];
                    }
                    
                }];
            }
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
        
    } failure:^(NSError *error) {
        [self presentLoadingStr:@"加载失败！"];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
    
}

#pragma mark - *************用户信息*************
-(void)UploadDataUserInfo{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,UserInfoUrl) params:dt success:^(id response) {
        LFLog(@"用户信息：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [UserDefault setObject:response[@"data"][@"user_money"] forKey:@"user_money"];//用户余额
            [UserDefault setObject:response[@"data"][@"pay_points"] forKey:@"user_pay_points"];//用户积分
            [UserDefault setObject:response[@"data"][@"rank_name"] forKey:@"user_rank_name"];//用户等级名称
            [UserDefault setObject:response[@"data"][@"rank_level"] forKey:@"user_rank_level"];//用户等级
            NSString *meony  = response[@"data"][@"user_money"];
            if (meony == nil) {
                meony = @"0.00";
            }
            self.priceLb.attributedText = [[NSString stringWithFormat:@"%@\n总金额",meony] AttributedString:@"总金额" backColor:nil uicolor:nil uifont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self UploadDataUserInfo];
}
#pragma mark 集成刷新控件
- (void)setupRefresh:(UITableView *)tabview
{
    
    //    }
    // 下拉刷新
    tabview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self RefreshData];
        
    }];
    tabview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.selecbutton.tag == 100) {
            if ([self.conmore isEqualToString:@"0"]) {
                [self presentLoadingTips:@"没有更多数据了"];
                [tabview.mj_footer endRefreshing];
            }else{
                [self rotateData:@"0" pagenum:1];
            }
        }else{
            if ([self.Recmore isEqualToString:@"0"]) {
                [self presentLoadingTips:@"没有更多数据了"];
                [tabview.mj_footer endRefreshing];
            }else{
                [self rotateData:@"1" pagenum:1];
            }
            
        }
        
    }];
    
}
//刷新数据
-(void)RefreshData{

    if (self.selecbutton.tag == 100) {
        self.conmore = @"1";
        self.conpage = 1;
        [self rotateData:@"0" pagenum:1];
    }else{
        self.Recpage = 1;
        self.Recmore = @"1";
        [self rotateData:@"1" pagenum:1];
    }

}
@end
