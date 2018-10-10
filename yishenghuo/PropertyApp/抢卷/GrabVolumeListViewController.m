//
//  GrabVolumeListViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/1/4.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "GrabVolumeListViewController.h"
#import "GrabVolumeTableViewCell.h"
#import "IndexBtn.h"
#import "AlertsButton.h"
#import "ShoppingCartViewController.h"
@interface GrabVolumeListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate>{
    // 定时器
    NSTimer *timer;
    UIImageView *headerIm;
    UIView *vline;
}
@property(nonatomic,strong)UICollectionView *collectionview;
@property(nonatomic,strong)UITableView *tableveiw;
@property(nonatomic,strong)IndexBtn *selecbutton;
@property(nonatomic,strong)UIScrollView *scrollveiw;
@property(nonatomic,strong)NSMutableArray *tableArr;
@property(nonatomic,strong)NSMutableArray *menuArr;
@property(nonatomic,strong)NSMutableArray *btnArr;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
@property(nonatomic,strong)AlertsButton *alertbtn;//购物车按钮
@end

@implementation GrabVolumeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.more = @"1";
    self.navigationBarTitle  = @"嘉年华抢券";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    [self presentLoadingTips];
    [self requestparentidData];
    [self countDownWithPER_SEC];
    [self createBaritem];
}
-(void)createBaritem{
    self.alertbtn = [[AlertsButton alloc]init];
    UIImage *im =[UIImage imageNamed:@"gouwuchebaise"];
    self.alertbtn.alertLabel.textnum = @"0";
    self.alertbtn.frame =CGRectMake(0, 0, im.size.width, im.size.height);
    [self.alertbtn setImage:im forState:UIControlStateNormal];
    [self.alertbtn addTarget:self action:@selector(rightCartClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.alertbtn];
    self.navigationItem.rightBarButtonItem = rightBtn;

}
//购物车
-(void)rightCartClick:(UIButton *)btn{
    if ( NO == [UserModel online] )
    {
        [self showLogin:nil];
        return;
    }
    ShoppingCartViewController *cart =[[ShoppingCartViewController alloc]init];
    [self.navigationController pushViewController:cart animated:YES];
    
}
-(NSMutableArray *)tableArr{

    if (_tableArr == nil) {
        _tableArr = [[NSMutableArray alloc]init];
    }
    return _tableArr;

}
-(NSMutableArray *)btnArr{
    
    if (_btnArr == nil) {
        _btnArr = [[NSMutableArray alloc]init];
    }
    
    return _btnArr;
    
}

-(NSMutableArray *)menuArr{
    
    if (_menuArr == nil) {
        _menuArr = [[NSMutableArray alloc]init];
    }
    
    return _menuArr;
    
}


-(void)createScrollview{
    self.scrollveiw = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64 + (headerIm ? headerIm.height:0), SCREEN.size.width  + 5, 50)];
    //    self.scrollveiw.backgroundImage  = [UIImage imageNamed:@"yiqigoufenleikuang"];
    self.scrollveiw.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollveiw];
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN.size.width, 10)];
    grayView.backgroundColor = JHBorderColor;
    [self.scrollveiw addSubview:grayView];
    [self tz_addPopGestureToView:self.scrollveiw];
    CGFloat wide = 0.0;
    for (int i = 0; i < self.menuArr.count; i ++) {
        UITableView *tableveiw = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN.size.width, SCREEN.size.height - 94 ) style:UITableViewStylePlain];
        tableveiw.delegate = self;
        tableveiw.dataSource  = self;
        tableveiw.emptyDataSetSource = self;
        tableveiw.emptyDataSetDelegate  = self;
        [tableveiw registerNib:[UINib nibWithNibName:@"GrabVolumeTableViewCell" bundle:nil] forCellReuseIdentifier:[NSString stringWithFormat:@"D0BBsTableViewCell_%d",i]];
        [self.tableArr addObject:tableveiw];
        NSMutableDictionary *model = self.menuArr[i];
        CGSize size = [model[@"name"] selfadaption:14];
        IndexBtn * btn = [[IndexBtn alloc]initWithFrame:CGRectMake( wide, 0,SCREEN.size.width/4, 40)];
        btn.index = i;
        if (self.categoryId) {
            if ([self.categoryId isEqualToString:model[@"id"]]) {
                [btn setTitleColor:JHAssistColor forState:UIControlStateNormal];
                self.selecbutton = btn;
                self.tableveiw = tableveiw;
                if (vline == nil) {
                    vline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width + 10, 1)];
                    vline.center = CGPointMake(btn.center.x, 39);
                    vline.backgroundColor = JHAssistColor;
                    [self.scrollveiw addSubview:vline];
                }
            }else{
                [btn setTitleColor:JHColor(51, 51, 51) forState:UIControlStateNormal];
            }
        }else{
            if (i == 0) {
                
                [btn setBackgroundImage:[UIImage imageNamed:@"qiyigouyuanjiaojuxing"] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.selecbutton = btn;
            }else{
                [btn setTitleColor:JHColor(51, 51, 51) forState:UIControlStateNormal];
            }
        }
        
        wide += SCREEN.size.width/4;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btn setTitle: model[@"name"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollveiw addSubview:btn];
        [self.btnArr addObject:btn];
    }
    if (wide > SCREEN.size.width) {
        self.scrollveiw.contentSize = CGSizeMake((wide + 5 * self.menuArr.count + 50), 0);
    }else{
        self.scrollveiw.contentSize = CGSizeMake(0, 0);
    }
    
}

-(void)menuClick:(IndexBtn *)btn{
    
    self.page = 1;
    CGFloat wide = SCREEN.size.width/4 * (btn.index + 1);
    CGSize size = [self.menuArr[btn.index][@"name"] selfadaption:14];
    vline.width = size.width + 10;
    vline.center = CGPointMake(btn.index *SCREEN.size.width/4  + SCREEN.size.width/8, 39);
//    for (int i = 0; i < btn.index; i ++) {
//        NSDictionary *model = self.menuArr[i];
//        CGSize size = [model[@"name"] selfadaption:14];
//        wide += size.width +15;
//    }
    [self.selecbutton  setTitleColor:JHColor(51, 51, 51) forState:UIControlStateNormal];
    [btn setTitleColor:JHAssistColor forState:UIControlStateNormal];
    
//    if (wide > SCREEN.size.width/2) {
//        [self.scrollveiw setContentOffset:CGPointMake(wide - SCREEN.size.width/2, 0)animated:YES];
//    }
    
    NSIndexPath * index = [NSIndexPath indexPathForRow:btn.index inSection:0];
    [self.collectionview scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    NSMutableDictionary *model = self.menuArr[btn.index];
    [self requestlistData:btn.index category:model[@"id"] pagenum:self.page];
    self.selecbutton = btn;
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.collectionview) {
        NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
        LFLog(@"currentIndex:%ld",(long)currentIndex);
        if (self.btnArr.count > currentIndex) {
            IndexBtn *button = self.btnArr[currentIndex];
            if (button != self.selecbutton) {
                [self menuClick:button];
            }
        }
    }

}

-(void)createCollectionview{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.itemSize = CGSizeMake(SCREEN.size.width - 1, SCREEN.size.height - (114 + (headerIm ? headerIm.height:0)));
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 114 + (headerIm ? headerIm.height:0), SCREEN.size.width, SCREEN.size.height - (114 + (headerIm ? headerIm.height:0))) collectionViewLayout:flowLayout];
    //    self.collectionview.panEnabled = YES;
    self.collectionview.pagingEnabled = YES;
    self.collectionview.dataSource=self;
    //    self.collectionview.scrollEnabled = YES;
    self.collectionview.backgroundColor = [UIColor whiteColor];
    self.collectionview.delegate=self;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"grabHeaderReuse"];
    [self.view addSubview:self.collectionview];
//    self.collectionview.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    [self tz_addPopGestureToView:self.collectionview];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *marr = self.menuArr[self.selecbutton.index][@"data"];
    return marr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int index = 0;
    for (UITableView *tab in self.tableArr) {
        if (tab == tableView) {
            break;
        }
        index ++;
    }

    GrabVolumeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"D0BBsTableViewCell_%d",index]];
    cell.imAcpect.constant = 8/9.0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *marr = self.menuArr[self.selecbutton.index][@"data"];
    NSDictionary *dt = marr[indexPath.row];
//    [[SDWebImageManager sharedManager]loadImageWithURL:[NSURL URLWithString:dt[@"imgurl"]] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//        cell.picture.image = image;
//    }];
//    [cell.image sd_setImageWithURL:[NSURL URLWithString:dt[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//    }];
    [cell.picture sd_setImageWithURL:[NSURL URLWithString:dt[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cell.progress.colorView.backgroundColor = JHColor(255, 205, 187);
    CGFloat stock = [dt[@"stock"] floatValue];
    if (stock > 0) {
        cell.progress.scale = [dt[@"percen"] floatValue]/100.0;
    }else{
        cell.progress.scale = 0;
    }
//
    cell.progress.leftLb.textColor = JHAssistRedColor;
    cell.progress.leftLb.font = [UIFont systemFontOfSize:10];
    cell.progress.leftLb.text = [NSString stringWithFormat:@"已抢%@个",dt[@"now_count"]];
    cell.progress.rightLb.textColor = JHAssistRedColor;
    cell.progress.rightLb.font = [UIFont systemFontOfSize:10];
    cell.progress.rightLb.text = [NSString stringWithFormat:@"%@%%",dt[@"percen"]];
    cell.contentLb.text = dt[@"name"];
    cell.amountLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    NSString *amount = [NSString stringWithFormat:@"%@ %@",dt[@"money"],dt[@"min_amount"]];
    cell.amountLb.attributedText = [amount AttributedString:dt[@"money"] backColor:nil uicolor:nil uifont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
    __weak typeof(self) weakSelf = self;
    [cell setBlock:^{
        [weakSelf rushVolume:dt[@"id"] ac_id:nil];
    }];
    [cell.contentView layoutIfNeeded];
    [cell.leftBackview layoutIfNeeded];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bview = [[UIView alloc]init];
    bview.backgroundColor = [UIColor whiteColor];
    return bview;
    //    return bview;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bview = [[UIView alloc]init];
    bview.backgroundColor = [UIColor whiteColor];
    return bview;
    //    return bview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
    //    return SCREEN.size.width *8 /25;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }

    
}
//设置空白页图片的偏移量
-(CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView{
    return CGPointMake(0, SCREEN.size.width * 6/15.0);
}
#pragma mark - 启动定时器
- (void)countDownWithPER_SEC{

    if (timer == nil) {
        timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        // 加入RunLoop中
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
}
-(void)timerAction{
    NSArray  *cells = self.tableveiw.visibleCells; //取出屏幕可见ceLl
    if (self.menuArr.count) {
        NSMutableArray *marr = self.menuArr[self.selecbutton.index][@"data"];
        for (GrabVolumeTableViewCell * cell in cells) {
            NSIndexPath *indexpath = [self.tableveiw indexPathForCell:cell];
            NSInteger sjInteger = [[NSDate date] timeIntervalSince1970];  // 手机当前时间戳
            if (marr.count > indexpath.row) {
                NSInteger start_time = [marr[indexpath.row][@"send_start_time"] integerValue];
                NSInteger end_time = [marr[indexpath.row][@"send_end_time"] integerValue];
                NSInteger timeout = end_time - sjInteger;
                //                    LFLog(@"start_time:%ld",(long)start_time);
                //                    LFLog(@"sjInteger:%ld",(long)sjInteger);
                //                    LFLog(@"end_time:%ld",(long)end_time);
                if (sjInteger < start_time) {
                    sjInteger = 0;
                }
                if(timeout<=0){ //倒计时结束，关闭
                    //                        dispatch_source_cancel(_timer);
                    //                        _timer = nil;
                    cell.hourLb.text = @"00";
                    cell.minuteLb.text = @"00";
                    cell.secondLb.text = @"00";
                }else{
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)(timeout/3600);
                    int minute = (int)(timeout-days*24*3600-((timeout-days*24*3600)/3600)*3600)/60;
                    int second = (int)(timeout-days*24*3600-((timeout-days*24*3600)/3600)*3600-minute*60);
                    if (hours<10) {
                        cell.hourLb.text = [NSString stringWithFormat:@"0%d",hours];
                    }else{
                        cell.hourLb.text = [NSString stringWithFormat:@"%d",hours];
                    }
                    if (minute<10) {
                        cell.minuteLb.text = [NSString stringWithFormat:@"0%d",minute];
                    }else{
                        cell.minuteLb.text = [NSString stringWithFormat:@"%d",minute];
                    }
                    if (second<10) {
                        cell.secondLb.text = [NSString stringWithFormat:@"0%d",second];
                    }else{
                        cell.secondLb.text = [NSString stringWithFormat:@"%d",second];
                    }
                }
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
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    UITableView *tableveiw = self.tableArr[indexPath.row] ;
    [cell.contentView addSubview:tableveiw];
    [tableveiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    [self setupRefresh:tableveiw];
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

#pragma mark 菜单栏
-(void)requestparentidData{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,CouponCateUrl) params:dt success:^(id response) {
        LFLog(@"分类请求：%@",response);
        [self dismissTips];
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.menuArr removeAllObjects];
            int i = 0;
            NSInteger inx = 0;
            for (NSDictionary *dt in response[@"data"][@"nav"]) {
                NSMutableDictionary *mdt = [NSMutableDictionary dictionaryWithDictionary:dt];
                NSMutableArray *marr = [NSMutableArray array];
                [mdt setObject:marr forKey:@"data"];
                [self.menuArr addObject:mdt];
                if ([dt[@"id"] isEqualToString:self.categoryId]) {
                    inx = i;
                }
                i ++;
            }
            if ([response[@"data"][@"banner"] isKindOfClass:[NSDictionary class]]) {
                NSString *imageurl = response[@"data"][@"banner"][@"imgurl"];
                if (imageurl && imageurl.length) {
                    if (IS_IPHONE_6_PLUS) {
                        imageurl = response[@"data"][@"banner"][@"imgurl3"];
                    }else{
                        imageurl = response[@"data"][@"banner"][@"imgurl2"];
                    }
                    if (headerIm == nil) {
                        headerIm = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, SCREEN.size.width * 6/15.0)];
                        [self.view addSubview:headerIm];
                    }
                    [headerIm sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                }
            }
            if (self.menuArr.count > 0) {
                [self createScrollview];
                [self createCollectionview];
                NSIndexPath * index = [NSIndexPath indexPathForRow:inx inSection:0];
                [self.collectionview reloadItemsAtIndexPaths:@[index]];
                [self.collectionview scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                if (self.categoryId) {
                    [self requestlistData:inx category:self.categoryId pagenum:self.page];
                }else{
                    [self requestlistData:0 category:response[@"data"][@"nav"][0][@"id"] pagenum:self.page];
                }
            }else{
                
                if (self.tableveiw == nil) {
                    NSMutableDictionary *mdt = [NSMutableDictionary dictionaryWithDictionary:dt];
                    NSMutableArray *marr = [NSMutableArray array];
                    [mdt setObject:marr forKey:@"data"];
                    [self.menuArr addObject:mdt];
                    self.selecbutton = [[IndexBtn alloc]init];
                    self.selecbutton.index = 0;
                    
                    self.tableveiw= [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN.size.width, SCREEN.size.height ) style:UITableViewStylePlain];
                    self.tableveiw.delegate = self;
                    self.tableveiw.dataSource  = self;
                    self.tableveiw.emptyDataSetSource = self;
                    self.tableveiw.emptyDataSetDelegate  = self;
                    [self.tableveiw registerNib:[UINib nibWithNibName:@"GrabVolumeTableViewCell" bundle:nil] forCellReuseIdentifier:@"D0BBsTableViewCell_0"];
                    self.tableveiw.tableHeaderView = headerIm;
                    [self.view addSubview:self.tableveiw];
                    [self.tableArr addObject:self.tableveiw];
                    [self setupRefresh:self.tableveiw];
                }
                [self requestlistData:0 category:self.categoryId pagenum:self.page];
                
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    [self requestparentidData];
                }];
            }
            [self presentTextStr:[NSString stringWithFormat:@"\n%@\n",response[@"status"][@"error_desc"]]];
            
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"加载失败！"];
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
    
}

#pragma mark 抢卷
-(void)rushVolume:(NSString *)volumeid ac_id:(NSString *)ac_id{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary *dt = [NSMutableDictionary dictionaryWithObjectsAndKeys:session,@"session", nil];
    if (volumeid) {
        [dt setObject:volumeid forKey:@"id"];
    }
    if (ac_id) {
        [dt setObject:ac_id forKey:@"ac_id"];
    }
    LFLog(@"抢卷dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,CouponRushUrl) params:dt success:^(id response) {
        LFLog(@"抢卷：%@",response);
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self presentTextStr:@"\n抢券成功\n可在个人中心查看\n"];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentTextStr:[NSString stringWithFormat:@"\n%@\n",response[@"status"][@"error_desc"]]];
            
        }
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self dismissTips];
        });
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"加载失败！"];
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
    
}
#pragma mark 列表
- (void)requestlistData:(NSInteger )tag category:(NSString *)category  pagenum:(NSInteger )pagenum{
    UITableView *tableview = self.tableArr[tag];
    if (tableview) {
        self.tableveiw = tableview;
    }
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    if (category) {
        [dt setObject:category forKey:@"id"];
    }
    LFLog(@"列表:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,CouponListUrl) params:dt success:^(id response) {
        [tableview.mj_header endRefreshing];
        [tableview.mj_footer endRefreshing];
        [self dismissTips];
        LFLog(@"列表详情：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            NSMutableArray *marr = self.menuArr[tag][@"data"];
            if (pagenum == 1) {
                [marr removeAllObjects];
            }
            NSArray * arr = response[@"data"];
            if (arr.count == 0) {
                [self presentLoadingTips:@"暂无数据~~"];
            }
            int i = 0;
            for (NSDictionary *resdt in response[@"data"]) {
                if (i != 0) {
                    
                }
                [marr addObject:resdt];
                i ++;
            }
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        [tableview reloadData];
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"加载失败！"];
        [tableview.mj_header endRefreshing];
        [tableview.mj_footer endRefreshing];
    }];
    
}



#pragma mark 集成刷新控件
- (void)setupRefresh:(UITableView *)tabview
{
//
//    //    }
    // 下拉刷新
    tabview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
//        NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
        NSMutableDictionary * mo  = self.menuArr[self.selecbutton.index];
        [self requestlistData:self.selecbutton.index category:mo[@"id"] pagenum:self.page];
    }];
    //    [tabview.mj_header beginRefreshing];
    tabview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多数据了"];
            [tabview.mj_footer endRefreshing];
        }else{
//            NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
            NSMutableDictionary * mo  = self.menuArr[self.selecbutton.index];
            self.page ++;
            [self requestlistData:self.selecbutton.index category:mo[@"id"] pagenum:self.page];
        }

    }];
//
}
//更新购物车数量
-(void)updateCratCount{
    
    ShoppingCartViewController *cart =[ShoppingCartViewController sharedShoppingCartViewController];
    [cart UploadDataCartList];
    [cart setBlock:^(NSArray *cartArr ,NSInteger count) {
        self.alertbtn.alertLabel.textnum = [NSString stringWithFormat:@"%lu",count];
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateCratCount];
}
@end

