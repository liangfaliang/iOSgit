//
//  GovernmentSuggestListViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/12.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "GovernmentSuggestListViewController.h"
#import "GovernmentSendPostViewController.h"
#import "GovernmentModel.h"
#import "AppFMDBManager.h"
#import "MenuModel.h"
#import "CustomButton.h"
#import "CustomLabel.h"
#import "OneCellView.h"
#import "STPhotoBroswer.h"
#import "GovernmentPostTableViewCell.h"
#import "GovernmentPostDetailViewController.h"
@interface GovernmentSuggestListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UISearchBarDelegate,GovernmentPostDelegate,GovernmentPostDetailDelegate>
{
    //    long a ;
    float cellHight ;

}
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)UIButton *sendBtn;
//放大展示图片数组
@property (nonatomic,strong)NSMutableArray *imgListArray;
@property (nonatomic,strong)NSMutableArray *appArray;
//小图展示数组
@property (nonatomic,strong)NSMutableArray *imageArray;

@property(nonatomic,strong)NSString *more;
@property(nonatomic,assign)NSInteger page;
@end

@implementation GovernmentSuggestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.navigationItem.titleView = self.titleView;
    self.navigationBarTitle = self.model.name;
    self.page = 1;
    self.more = @"1";
   
    [self createUI];
    
    //    [self upDataforMenu];
    //    [self wheelrequestData];
}


- (NSMutableArray *)appArray
{
    if (!_appArray) {
        _appArray = [[NSMutableArray alloc]init];
    }
    return _appArray;
}
- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}
- (NSMutableArray *)imgListArray
{
    if (!_imgListArray) {
        _imgListArray = [[NSMutableArray alloc]init];
    }
    return _imgListArray;
}


-(void)createUI{
    [self creatTableview];
    [self setupRefresh];
//    [self requestData:self.page];
    
}


-(void)createSendBtn{

    if (self.sendBtn == nil) {
        self.sendBtn = [[UIButton alloc]init];
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        [self.sendBtn setImage:[UIImage imageNamed:@"fabiaohuati"] forState:UIControlStateNormal];
        [self.sendBtn addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
        [win addSubview:self.sendBtn];
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.bottom.offset(-50);
            //        make.centerY.offset(300);
        }];
    }

}
#pragma mark  点击发帖
-(void)sendClick:(UIButton *)btn{
    GovernmentSendPostViewController *send = [[GovernmentSendPostViewController alloc]init];
    send.cat_id = self.model.id;
    [send setBlock:^{
        self.page = 1;
        self.more = @"1";
        [self requestData:self.page];
    }];
    [self.navigationController pushViewController:send animated:YES];
    
}

- (void)creatTableview
{
    

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
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
    
    if (tableView == self.tableView) {
        GovernmentPostDetailViewController *de = [[GovernmentPostDetailViewController alloc]init];
        de.delegate = self;
        de.model = self.appArray[indexPath.row];
        [self.navigationController pushViewController:de animated:YES];
    }else{
    
    
    }
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
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,GovernmentLikeUrl) params:dt success:^(id response) {
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

#pragma mark 请求数据
- (void)requestData:(NSInteger )pagenum{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid) {
        [dt setObject:uid forKey:@"user_id"];
    }
    NSString *url = [NSString string];
    if ([self.model.keyword isEqualToString:@"tsjy"]) {
        url = GovernmentSuggestListUrl;
    }else if ([self.model.keyword isEqualToString:@"zxzx"]){
        url = GovernmentAdvisoryListUrl;
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"获取成功dt:%@",response);
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
                [self presentLoadingTips:@"暂无数据！"];
            }
            [self.tableView reloadData];
        }else{
        
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self requestData:self.page];
                    }
                }];
            }
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
    
}


#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self requestData:self.page];

        //        [self wheelrequestData];
    }];
    
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    
            if ([self.more isEqualToString:@"0"]) {
                [self presentLoadingTips:@"没有更多数据了"];
                [self.tableView.mj_footer endRefreshing];
            }else{
                self.page ++;
                [self requestData:self.page];
            }
    
        }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self requestData:self.page];
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
