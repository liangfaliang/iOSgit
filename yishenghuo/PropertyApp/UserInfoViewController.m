//
//  UserInfoViewController.m
//  shop
//
//  Created by 梁法亮 on 16/5/10.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "UserInfoViewController.h"
#import "PostViewController.h"
#import "Masonry.h"
#import "userInfoTableViewCell.h"
#import "DetailsViewController.h"
#import "GovernmentModel.h"
#import "STPhotoBroswer.h"
#import "GovernmentPostTableViewCell.h"

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,GovernmentPostDelegate>
@property(nonatomic,strong)UIView *vw;
@property(nonatomic,strong)UIButton *namelabel;
@property(nonatomic,strong)UILabel *addresslabel;
@property(nonatomic,strong)baseTableview *tableView;
@property (nonatomic,strong)UIButton *sendBtn;
//放大展示图片数组
@property (nonatomic,strong)NSMutableArray *imgListArray;
@property (nonatomic,strong)NSMutableArray *appArray;
//小图展示数组
@property (nonatomic,strong)NSMutableArray *imageArray;

@property(nonatomic,strong)NSString *more;
@property(nonatomic,assign)NSInteger page;

//@property(nonatomic,strong)NSMutableArray *infoArr;
//@property(nonatomic,strong)NSMutableArray *listArr;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitle = @"我的发帖";
    self.page = 1;
    self.more = @"1";
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    
//    self.navigationBarRight = [UIImage imageNamed:@"fatie"];;
//    UIBarButtonItem *infoBtn =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tianjiafatie"] style:UIBarButtonItemStylePlain target:self action:@selector(fatieBtnClick:)];;
//    infoBtn.tintColor = [UIColor whiteColor];
//
//    self.navigationItem.rightBarButtonItem = infoBtn;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTableview];
//    [self requestuserInfoData];
    [self requestuserListData:self.page];
    
}

-(NSMutableArray *)appArray{
    
    if (_appArray == nil) {
        _appArray = [[NSMutableArray alloc]init];
    }
    
    return _appArray;
}
//-(NSMutableArray *)listArr{
//    
//    if (_listArr == nil) {
//        _listArr = [[NSMutableArray alloc]init];
//    }
//    
//    return _listArr;
//}
//发帖
-(void)fatieBtnClick:(UIButton *)btn{
    PostViewController *post = [[PostViewController alloc]init];
    [self.navigationController pushViewController:post animated:YES];


}

//-(void)createUI{
//    
//    
//    self.vw = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, 120)];
//    self.vw.backgroundImage = [UIImage imageNamed:@"linlihudongdibeijing"];
//    [self.view addSubview:self.vw];
//    
//    UIImageView *iconview = [[UIImageView alloc]init];
//    iconview.image = [UIImage imageNamed:@"touxiang_nanhseng"];
//    //    iconview.center = CGPointMake(self.vw.frame.size.width/2, 40);
//    [self.vw addSubview:iconview];
//    [iconview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(50, 50));
//        make.centerX.equalTo(self.vw.mas_centerX);
//        make.top.equalTo(self.vw.mas_top).with.offset(30);
//    }];
//    iconview.layer.cornerRadius = 25;
//    iconview.layer.masksToBounds = YES;
//    
//    
//    self.namelabel = [[UIButton alloc]init];
//    //    self.namelabel.layer.borderColor = [JHColor(0, 123, 215) CGColor];
//    //    self.namelabel.layer.borderWidth = 1;
//    [self.namelabel addTarget:self action:@selector(namelabelClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.vw addSubview:self.namelabel];
//    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(iconview.mas_bottom).with.offset(3);
//        make.centerX.equalTo(iconview.mas_centerX);
//        make.height.offset(30);
//        
//    }];
//    [self.namelabel setTitle:self.infoArr[0][@"username"] forState:UIControlStateNormal];
//    [self.namelabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    //    self.namelabel.textColor = [UIColor whiteColor];
//    //    self.namelabel.text = self.infoArr[0][@"username"];
//    self.namelabel.titleLabel.font = [UIFont systemFontOfSize:14];
//    
//    
//    
//    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, self.vw.frame.size.height + 64, SCREEN.size.width, SCREEN.size.height - self.vw.frame.size.height) style:UITableViewStyleGrouped];
//    self.tableview.delegate = self;
//    self.tableview.dataSource = self;
//    [self.tableview registerNib:[UINib nibWithNibName:@"userInfoTableViewCell" bundle:nil ] forCellReuseIdentifier:@"usercell"];
//    //    [self.tableview registerClass:[userInfoTableViewCell class] forCellReuseIdentifier:@"cell"];
//    [self.view addSubview:self.tableview];
//    
//    [self setupRefresh];
//    
//}

//修改姓名
//-(void)namelabelClick:(UIButton *)btn{
//    
//    LFLog(@"点击姓名");
//    
//}
-(void)createSendBtn{
    
    if (self.sendBtn == nil) {
        self.sendBtn = [[UIButton alloc]init];
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        [self.sendBtn setImage:[UIImage imageNamed:@"fabiaohuati"] forState:UIControlStateNormal];
        [self.sendBtn addTarget:self action:@selector(fatieBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [win addSubview:self.sendBtn];
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.bottom.offset(-50);
            //        make.centerY.offset(300);
        }];
    }
    
}
- (void)creatTableview
{
    self.tableView = [[baseTableview alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    //    self.tableView.tableHeaderView  = self.image;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    //    [self.tableView setTableFooterView:view];
    [self.tableView registerNib:[UINib nibWithNibName:@"GovernmentPostTableViewCell" bundle:nil] forCellReuseIdentifier:@"GovernmentPostTableViewCell"];
    [self.view addSubview:self.tableView];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.appArray.count ;
    }
    return 3 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
#pragma mark从第二个cell开始加载帖子数据
    
    static NSString *CellIdentifier = @"GovernmentPostTableViewCell";
    GovernmentPostTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.categoryBtn.hidden = YES;
    cell.hotIm.hidden = YES;
    cell.delegate = self;
    cell.GovernmentModel = self.appArray[indexPath.row];
    cell.contentLbLeft.constant = 50;
    CGSize h = [cell.GovernmentModel.content selfadap:14 weith:60];
    CGFloat HH = h.height + 10;
    if (HH > 105) {
        HH = 105;
    }
    cell.contentLbHeight.constant = HH;
    __weak typeof(cell) weakcell = cell;
    [cell setLikeblock:^(UIButton *sender) {
        [self upDataforpraise:weakcell.GovernmentModel.id index:indexPath.row cell:weakcell];
    }];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    return cell;
    
    
    
}
#pragma mark  点击cell,进入帖子详情页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    
    DetailsViewController *detail = [[DetailsViewController alloc]init];
    GovernmentModel *mo = self.appArray[indexPath.row];
    detail.detailID = mo.id;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark  帖子详情代理
- (void)GovernmentDeletePost:(GovernmentModel *)model isDelete:(BOOL)isDelete{
    
    NSArray *tempArr = [self.appArray mutableCopy];
    int i = 0;
    for (GovernmentModel *gomodel in tempArr) {
        if ([gomodel.id isEqualToString:model.id]) {
            if (isDelete) {
                [self.appArray removeObject:gomodel];
            }else{
                [self.appArray replaceObjectAtIndex:i withObject:model];
            }
        }
        i ++;
    }
    
    [self.tableView reloadData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        GovernmentModel *mo = self.appArray[indexPath.row];
        CGSize h = [mo.content selfadap:14 weith:20];
        CGFloat HH = h.height + 10;
        if (HH > 105) {
            HH = 105;
        }
        if (mo.imgurl.count) {
            CGFloat imgWidth = (SCREEN.size.width - 90)/3 + 10;
            if (mo.imgurl.count == 1) {
                imgWidth = (SCREEN.size.width - 90)/3 * 2;
            }else if (mo.imgurl.count == 4){
                imgWidth += imgWidth;
            }else{
                imgWidth = imgWidth * (((mo.imgurl.count - 1)/3 +1) < 4? (mo.imgurl.count - 1)/3 +1:3);
            }
            
            return HH + 110 + imgWidth;
        }else{
            return HH + 110;
            
        }
    }else{
        return 50;
    }
    
    
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIButton *btn = [[UIButton alloc]init];
//
//    [btn setImage:[UIImage imageNamed:@"remenhuatiwenzi"] forState:UIControlStateNormal];
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    return btn;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}

- (void)imageViewClick:(NSInteger)index row:(NSInteger)row
{
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    GovernmentModel *model = [[GovernmentModel alloc]init];
    
    model = self.appArray[row];
    NSMutableArray *muarr = [[NSMutableArray alloc]init];
    for (NSDictionary *imurl in model.imgurl) {
        [muarr addObject:imurl[@"imgurl"]];
    }
    self.imgListArray = muarr;
    
    NSArray *arr =self.imgListArray;
    LFLog(@"%@",arr);
    if (muarr.count > 0) {
        STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:muarr currentIndex:index];
        [broser show];
    }
    
}

#pragma mark 点赞数据请求
-(void)upDataforpraise:(NSString *)articleid index:(NSInteger)index cell:(GovernmentPostTableViewCell *)cell{
    
    if ( NO == [UserModel online] )
    {
        
        [self showLogin:^(id response) {
            
        }];
        return;
    }
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session",articleid,@"id", nil];
    LFLog(@"点赞dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSLikeUrl) params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            LFLog(@"点赞：%@",response);
            GovernmentModel *model = self.appArray[index];
            NSInteger praise = [model.agree_count integerValue];
            if ([model.is_agree isEqualToString:@"0"]) {
                [self presentLoadingTips:@"点赞成功~~"];
                model.is_agree = @"1";
                praise ++;
            }else{
                [self presentLoadingTips:@"取消点赞~~"];
                model.is_agree = @"0";
                praise --;
                
            }
            model.agree_count = [NSString stringWithFormat:@"%d",(int)praise];
            [self.appArray replaceObjectAtIndex:index withObject:model];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            [self presentLoadingTips:response[@"err_msg"]];
            
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
    
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    DetailsViewController *detail = [[DetailsViewController alloc]init];
//    LFLog(@"%@",self.listArr[indexPath.row][@"id"]);
//    detail.detailID = self.listArr[indexPath.row][@"id"];
//    [self.navigationController pushViewController:detail animated:YES];
//    
//    
//}

#pragma mark 个人信息
//-(void)requestuserInfoData{
//    NSString *uid = [UserDefault objectForKey:@"useruid"];
//    if (uid == nil) {
//        uid = @"";
//    }
//    NSDictionary *dt = @{@"userid":uid};
//    [LFLHttpTool get:NSStringWithFormat(ZJBBsBaseUrl,@"12") params:dt success:^(id response) {
//        //        [UITableView.mj_header endRefreshing];
//        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
//        if ([str isEqualToString:@"0"]) {
//            if ([str isEqualToString:@"0"]) {
//                [self.infoArr removeAllObjects];
//                
//                [self.infoArr addObject:response[@"note"]];
//                [UserDefault setObject:response[@"note"][@"username"] forKey:@"username"];
//                [self createUI];
//            }else{
//                
//                
//            }
//            
//        }
//    } failure:^(NSError *error) {
//        
//    }];
//    
//}

#pragma mark 用户发帖
-(void)requestuserListData:(NSInteger )pagenum{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSMyPostUrl) params:dt success:^(id response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"用户发帖dt:%@",response);
        if ([str isEqualToString:@"1"]) {
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            if (pagenum == 1) {
                [self.appArray removeAllObjects];
            }
            for (NSDictionary *dt in response[@"data"]) {
                GovernmentModel *model=[[GovernmentModel alloc]initWithDictionary:dt error:nil];
                [self.appArray addObject:model];
            }
            if (!self.appArray.count) {
                [self presentLoadingTips:@"您暂无发帖纪录！"];
            }
            [self.tableView reloadData];
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self requestuserListData:self.page];
        
        //        [self wheelrequestData];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多数据了"];
            [self.tableView.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self requestuserListData:self.page];
        }
        
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestuserListData:self.page];
    [self createSendBtn];
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.sendBtn removeFromSuperview];
    self.sendBtn = nil;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
    [[SDWebImageManager sharedManager] cancelAll];
    
    [[SDImageCache sharedImageCache] clearDisk];
    
}


@end
