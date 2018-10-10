//
//  ListBBsViewController.m
//  shop
//
//  Created by 梁法亮 on 16/7/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "ListBBsViewController.h"
#import "D0BBsTableViewCell.h"
#import "D0BBBSmodel.h"
#import "MenuModel.h"
#import "NSString+selfSize.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "SDImageCache.h"
#import "DetailsViewController.h"
#import "GovernmentPostTableViewCell.h"
#import "STPhotoBroswer.h"
#import "PostViewController.h"
@interface ListBBsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,BBSPostDetailDelegate,GovernmentPostDelegate>
@property(nonatomic,strong)UICollectionView *collectionview;
@property(nonatomic,strong)baseTableview *tableveiw;
@property(nonatomic,strong)UIButton *selecbutton;
@property(nonatomic,strong)UIScrollView *scrollveiw;
@property(nonatomic,strong)NSMutableArray *detailArr;
@property(nonatomic,strong)NSMutableArray *menuArr;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;


@end

@implementation ListBBsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.more = @"1";
    self.navigationBarTitle  = self.titlestr;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
//    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tianjiafatie"] style:UIBarButtonItemStyleDone target:self action:@selector(addButtonClick:)];
//    searchBtn.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = searchBtn;
    [self presentLoadingTips];
    [self createtableveiw];
    [self requestlistData:0 category:self.parentid pagenum:self.page];
//    [self requestparentidData];
}

-(void)addButtonClick:(UIBarButtonItem *)btn{
    if ( NO == [UserModel online] )
    {
        
        [self showLogin:^(id response) {

        }];
        return;
    }
    PostViewController *postView = [[PostViewController alloc]init];
    [self.navigationController pushViewController:postView animated:YES];


}

-(NSMutableArray *)detailArr{

    if (_detailArr == nil) {
        _detailArr = [[NSMutableArray alloc]init];
    }

    return _detailArr;

}

-(NSMutableArray *)menuArr{
    
    if (_menuArr == nil) {
        _menuArr = [[NSMutableArray alloc]init];
    }
    
    return _menuArr;
    
}

-(void)createtableveiw{

    if (self.tableveiw == nil) {
        self.tableveiw = [[baseTableview alloc]initWithFrame:CGRectMake(0,64, SCREEN.size.width, SCREEN.size.height - 50) style:UITableViewStyleGrouped];
        _tableveiw.delegate = self;
        self.tableveiw.tag = 1000;
        _tableveiw.dataSource  = self;
        self.tableveiw.emptyDataSetSource = self;
        self.tableveiw.emptyDataSetDelegate = self;
        [_tableveiw registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableveiw registerNib:[UINib nibWithNibName:@"GovernmentPostTableViewCell" bundle:nil] forCellReuseIdentifier:@"tableveiwcCell"];
        [self.view addSubview:_tableveiw];
        [self setupRefresh:_tableveiw];
    }

    

}

-(void)createScrollview{
    self.scrollveiw = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width  + 5, 50)];
//    self.scrollveiw.backgroundImage  = [UIImage imageNamed:@"yiqigoufenleikuang"];
    self.scrollveiw.backgroundColor = JHBorderColor;
    [self.view addSubview:self.scrollveiw];
    
    CGFloat wide = 0.0;
    for (int i = 0; i < self.menuArr.count; i ++) {
        MenuModel *model = self.menuArr[i];
        CGSize size = [model.name selfadaption:14];
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(15 + i * 5 + wide, 10, size.width + 15, 30)];
        btn.tag = i + 200;
        if (self.link) {
            if ([self.link isEqualToString:model.id]) {
                [btn setBackgroundImage:[UIImage imageNamed:@"qiyigouyuanjiaojuxing"] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.selecbutton = btn;
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
        
        wide += size.width +15;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btn setTitle: model.name forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollveiw addSubview:btn];
    }
    if ((wide + 5 * self.menuArr.count )> SCREEN.size.width) {
        self.scrollveiw.contentSize = CGSizeMake((wide + 5 * self.menuArr.count + 50), 0);
    }else{
        
        self.scrollveiw.contentSize = CGSizeMake(0, 0);
    }
    
}

-(void)menuClick:(UIButton *)btn{

    self.page = 1;
    CGFloat wide = 15.0;
    for (int i = 0; i < btn.tag - 200; i ++) {
        MenuModel *model = self.menuArr[i];
        CGSize size = [model.name selfadaption:14];
        wide += size.width +15;
    }
    
    [self.selecbutton  setTitleColor:JHColor(51, 51, 51) forState:UIControlStateNormal];
    [self.selecbutton setBackgroundImage:nil forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"qiyigouyuanjiaojuxing"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (wide > SCREEN.size.width/2) {
        [self.scrollveiw setContentOffset:CGPointMake(wide -SCREEN.size.width/2, 0)animated:YES];
    }
    NSIndexPath * index = [NSIndexPath indexPathForRow:btn.tag - 200 inSection:0];
    [self.collectionview scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    MenuModel *model = self.menuArr[btn.tag - 200];
    [self requestlistData:btn.tag - 200 category:model.id pagenum:self.page];
    LFLog(@"%ld",(long)btn.tag);
//    UITableView *tb = [self.view viewWithTag:btn.tag - 200 + 1000];
//    LFLog(@"UITableView:%@",tb);
    
    self.selecbutton = btn;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

//    CGPoint pInView = [self.view convertPoint:self.collectionview.center toView:self.collectionview];
//    // 获取这一点的indexPath
//    NSIndexPath *indexPathNow = [self.collectionview indexPathForItemAtPoint:pInView];
//    // 赋值给记录当前坐标的变量
//    

    if (self.tableveiw == nil) {
        NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
        
        UIButton *button = [self.view viewWithTag:currentIndex + 200];
        if (button == self.selecbutton) {
            
        }else{
            [self menuClick:button];
        }
        
    }
    

}

-(void)createCollectionview{

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.itemSize = CGSizeMake(SCREEN.size.width - 1, SCREEN.size.height);
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

    self.collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 114, SCREEN.size.width, SCREEN.size.height - 64) collectionViewLayout:flowLayout];
//    self.collectionview.panEnabled = YES;
    self.collectionview.pagingEnabled = YES;
    self.collectionview.dataSource=self;
//    self.collectionview.scrollEnabled = YES;
    self.collectionview.backgroundColor = [UIColor whiteColor];
    self.collectionview.delegate=self;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:self.collectionview];

    [self tz_addPopGestureToView:self.collectionview];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.detailArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableveiw) {
        
        //        D0BBsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableveiwcCell"];
        
        GovernmentPostTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableveiwcCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.hotIm.hidden = YES;
        cell.delegate = self;
        cell.GovernmentModel = self.detailArr[indexPath.row];
        cell.contentLbLeft.constant = 60;
        CGSize h = [cell.GovernmentModel.content selfadap:14 weith:50];
        CGFloat HH = h.height + 10;
        if (HH > 105) {
            HH = 105;
        }
        cell.contentLbHeight.constant = HH;
        __weak typeof(cell) weakcell = cell;
        [cell setLikeblock:^(UIButton *sender) {
            [self upDataforpraise:weakcell.GovernmentModel.id index:indexPath.row cell:weakcell tableview:tableView];
        }];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        return cell;
    }else{
        
        GovernmentPostTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"D0BBsTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.hotIm.hidden = YES;
        cell.delegate = self;
        cell.GovernmentModel = self.detailArr[indexPath.row];
        cell.contentLbLeft.constant = 60;
        CGSize h = [cell.GovernmentModel.content selfadap:14 weith:50];
        CGFloat HH = h.height + 10;
        if (HH > 105) {
            HH = 105;
        }
        cell.contentLbHeight.constant = HH;
        __weak typeof(cell) weakcell = cell;
        [cell setLikeblock:^(UIButton *sender) {
            [self upDataforpraise:weakcell.GovernmentModel.id index:indexPath.row cell:weakcell tableview:tableView];
        }];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        return cell;
    }
    
    
}

#pragma mark点击小图，展示大图
- (void)imageViewClick:(NSInteger)index row:(NSInteger)row
{
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    D0BBBSmodel *model = [[D0BBBSmodel alloc]init];
    
    model = self.detailArr[row];
    NSMutableArray *muarr = [[NSMutableArray alloc]init];
    for (NSDictionary *imurl in model.imgurl) {
        [muarr addObject:imurl[@"imgurl"]];
    }
    //    self.imgListArray = muarr;
    //
    //    NSArray *arr =self.imgListArray;
    //    LFLog(@"%@",arr);
    if (muarr.count > 0) {
        STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:muarr currentIndex:index];
        [broser show];
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bview = [[UIView alloc]init];
    if (self.tableveiw == nil) {
        MenuModel *mo = [[MenuModel alloc]init];
        mo = self.menuArr[tableView.tag - 1000];
        UIImageView *banerimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.width *8 /25)];
        
        [banerimage sd_setImageWithURL:[NSURL URLWithString:mo.imgurl] placeholderImage:[UIImage imageNamed:@""]];
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 50, 20)];
        
        [banerimage addSubview:l];
        [bview addSubview:banerimage];
        
    }
    
    return nil;
    //    return bview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.tableveiw) {
        return 0.01;
    }
    return 0.01;
    //    return SCREEN.size.width *8 /25;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GovernmentModel *mo = self.detailArr[indexPath.row];
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
    
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    LFLog(@"帖子详情页面");
    DetailsViewController *de = [[DetailsViewController alloc]init];
    GovernmentModel *model = self.detailArr[indexPath.row];
    de.detailID = model.id;
    de.delegate = self;
    [self.navigationController pushViewController:de animated:YES];
    
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
    
    //    MenuModel *mo = [[MenuModel alloc]init];
    //    mo = self.menuArr[indexPath.row];
    //    UIImageView *banerimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.width *8 /25)];
    //
    //    [banerimage sd_setImageWithURL:[NSURL URLWithString:mo.imgurl] placeholderImage:[UIImage imageNamed:@""]];
    //    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 50, 20)];
    //    l.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    //    [banerimage addSubview:l];
    //    [cell.contentView addSubview:banerimage];
    UITableView *tableveiw = [self.view viewWithTag:indexPath.item + 1000];
    if (tableveiw == nil) {
        tableveiw = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN.size.width, SCREEN.size.height - 94 ) style:UITableViewStyleGrouped];
        tableveiw.delegate = self;
        tableveiw.tag = 1000 + indexPath.row;
        tableveiw.dataSource  = self;
        [tableveiw registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [tableveiw registerNib:[UINib nibWithNibName:@"GovernmentPostTableViewCell" bundle:nil] forCellReuseIdentifier:@"D0BBsTableViewCell"];
        [cell.contentView addSubview:tableveiw];
        [self setupRefresh:tableveiw];
        
        UIImageView *headImage = [[UIImageView alloc]init];
        MenuModel *mo = [[MenuModel alloc]init];
        mo = self.menuArr[tableveiw.tag - 1000];
        [headImage sd_setImageWithURL:[NSURL URLWithString:mo.imgurl] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image.size.width > 0) {
                headImage.frame = CGRectMake(0, 0, SCREEN.size.width, image.size.height/image.size.width *SCREEN.size.width);
                tableveiw.tableHeaderView = headImage;
            }
        }];
        
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



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark  帖子详情代理
- (void)BBSDeletePost:(GovernmentModel *)model isDelete:(BOOL)isDelete{
    
    NSArray *tempArr = [self.detailArr mutableCopy];
    int i = 0;
    for (GovernmentModel *gomodel in tempArr) {
        if ([gomodel.id isEqualToString:model.id]) {
            if (isDelete) {
                [self.detailArr removeObject:gomodel];
            }else{
                [self.detailArr replaceObjectAtIndex:i withObject:model];
            }
        }
        i ++;
    }
    
    [self.tableveiw reloadData];
    
}
#pragma mark 菜单栏
-(void)requestparentidData{
    NSDictionary *dt = @{@"parentid":self.parentid};
    [LFLHttpTool get:NSStringWithFormat(ZJBBsBaseUrl,@"8") params:dt success:^(id response) {
//        [UITableView.mj_header endRefreshing];
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            [self.menuArr removeAllObjects];

            for (NSDictionary *dt in response[@"note"]) {
                MenuModel *model = [[MenuModel alloc]initWithDictionary:dt error:nil];
                [self.menuArr addObject:model];
            }
            if (self.menuArr.count > 0) {
                [self createCollectionview];
                [self createScrollview];
                
                if (self.link) {
                    [self requestlistData:0 category:self.link pagenum:self.page];
                }else{
                    [self requestlistData:0 category:response[@"note"][0][@"id"] pagenum:self.page];
                }
                
            }else{
                [self createtableveiw];
                [self requestlistData:0 category:self.parentid pagenum:self.page];
            }
            
        }else{
            
            
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"加载失败！"];
    }];
    
}


#pragma mark 帖子列表
- (void)requestlistData:(NSInteger )tag category:(NSString *)category  pagenum:(NSInteger )pagenum{
    UITableView *tableview = [self.view viewWithTag:tag + 1000];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    [dt setObject:category forKey:@"cat_id"];
    LFLog(@"帖子列表:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSHomeListUrl) params:dt success:^(id response) {
        [tableview.mj_header endRefreshing];
        [tableview.mj_footer endRefreshing];
        LFLog(@"详情：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            if (pagenum == 1) {
                [self.detailArr removeAllObjects];
            }
            

//            if (isload) {
//                NSArray * arr = response[@"data"];
//                if (arr.count == 0) {
//                    [self presentLoadingTips:@"没有更多数据了~~"];
//                }
//            }else{
                NSArray * arr = response[@"data"];
                if (arr.count == 0) {
                    [self presentLoadingTips:@"暂无数据~~"];
                }
//                [self.detailArr removeAllObjects];
//            }
            for (NSDictionary *dt in response[@"data"]) {
                GovernmentModel *model=[[GovernmentModel alloc]initWithDictionary:dt error:nil];
                
                [self.detailArr addObject:model];
                
            }
            [tableview reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [tableview.mj_header endRefreshing];
        [tableview.mj_footer endRefreshing];
    }];
    
}


#pragma mark 点赞数据请求
-(void)upDataforpraise:(NSString *)articleid index:(NSInteger)index cell:(GovernmentPostTableViewCell *)cell tableview:(UITableView *)tableview{
    
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
        [tableview.mj_header endRefreshing];
        [tableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            
            GovernmentModel *model = self.detailArr[index];
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
            [self.detailArr replaceObjectAtIndex:index withObject:model];
            [tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            [self presentLoadingTips:response[@"err_msg"]];
            
        }
    } failure:^(NSError *error) {
        [tableview.mj_header endRefreshing];
    }];
    
}
-(void)postNotificationName:(NSString *)modelid{
    [Notification postNotificationName:modelid object:nil userInfo:@{@"dianzan":@"praise"}];
    
}
#pragma mark 集成刷新控件
- (void)setupRefresh:(UITableView *)tabview
{

//    }
    // 下拉刷新
    tabview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        if (self.tableveiw != tabview) {
            NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
            MenuModel * mo  = self.menuArr[currentIndex];
            [self requestlistData:currentIndex category:mo.id pagenum:self.page];
        }else{
            
            [self requestlistData:0 category:self.parentid pagenum:self.page];
            
        }
    }];
//    [tabview.mj_header beginRefreshing];
    tabview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多数据了"];
            [tabview.mj_footer endRefreshing];
        }else{
            if (self.tableveiw == nil) {
                NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
                MenuModel * mo  = self.menuArr[currentIndex];
                self.page ++;
                [self requestlistData:currentIndex category:mo.id pagenum:self.page];
            }else{
                self.page ++;
                [self requestlistData:0 category:self.parentid pagenum:self.page];
                
                
            }
        }
        
    }];
    
}

//-(BOOL)fd_interactivePopDisabled{
//
//    return YES;
//}

@end
