//
//  IndustrySuperviseViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/27.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "IndustrySuperviseViewController.h"
#import "D0BBsTableViewCell.h"
#import "MenuModel.h"
#import "NSString+selfSize.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "SDImageCache.h"
#import "STPhotoBroswer.h"
#import "IndustryPublishViewController.h"
#import "IndustryModel.h"
#import "IndustryArticleDetailViewController.h"
#import "SatisfactionListViewController.h"
@interface IndustrySuperviseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UICollectionView *collectionview;
@property(nonatomic,strong)UITableView *tableveiw;
@property(nonatomic,strong)UIButton *selecbutton;
@property(nonatomic,strong)UIScrollView *scrollveiw;
@property(nonatomic,strong)NSMutableArray *detailArr;
@property(nonatomic,strong)NSMutableArray *menuArr;
@property(nonatomic,assign)NSInteger page;

@end

@implementation IndustrySuperviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle  = @"行业监管";
    //    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    
    [self requestparentidData];
    [self createUIbarItem];
}
-(void)createUIbarItem{
    UIBarButtonItem *infoBtn =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tianjiafatie"] style:UIBarButtonItemStylePlain target:self action:@selector(PublishBtnClick:)];;
    infoBtn.tintColor = [UIColor whiteColor];
  
    self.navigationItem.rightBarButtonItem = infoBtn;

}
-(void)PublishBtnClick:(UIBarButtonItem *)btn{

    IndustryPublishViewController *pub = [[IndustryPublishViewController alloc]init];
    
    [self.navigationController pushViewController:pub animated:YES];

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
    
    self.tableveiw = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN.size.width, SCREEN.size.height + 40 ) style:UITableViewStyleGrouped];
    _tableveiw.delegate = self;
    self.tableveiw.tag = 1000;
    _tableveiw.dataSource  = self;
    [_tableveiw registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableveiw registerNib:[UINib nibWithNibName:@"D0BBsTableViewCell" bundle:nil] forCellReuseIdentifier:@"tableveiwcCell"];
    [self.view addSubview:_tableveiw];
    [self setupRefresh:_tableveiw];
    
    
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
    self.selecbutton = btn;
    if ([btn.titleLabel.text isEqualToString:@"满意度调查"]) {
        SatisfactionListViewController *hot = [[SatisfactionListViewController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
        return;
    }
    MenuModel *model = self.menuArr[btn.tag - 200];
    [self requestlistData:btn.tag - 200 category:model.id page:@"1" isLoad:NO];

    LFLog(@"%ld",(long)btn.tag);
    //    UITableView *tb = [self.view viewWithTag:btn.tag - 200 + 1000];
    //    LFLog(@"UITableView:%@",tb);
    
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //    CGPoint pInView = [self.view convertPoint:self.collectionview.center toView:self.collectionview];
    //    // 获取这一点的indexPath
    //    NSIndexPath *indexPathNow = [self.collectionview indexPathForItemAtPoint:pInView];
    //    // 赋值给记录当前坐标的变量
    //
    
    if (self.tableveiw == nil) {
        NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
        LFLog(@"currentIndex:%ld",(long)currentIndex);
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
        [tableveiw registerNib:[UINib nibWithNibName:@"D0BBsTableViewCell" bundle:nil] forCellReuseIdentifier:@"D0BBsTableViewCell"];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.detailArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableveiw) {
        
        D0BBsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableveiwcCell"];
        
        
        [cell setBlock:^(NSString *str,NSInteger index) {
            LFLog(@"点击在哪");
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.index = indexPath.row ;
        cell.IndustryModel = self.detailArr[indexPath.row];
        
        
        [cell setPriseBlock:^(NSString *str,NSInteger index) {
//        [self upDataforpraise: str index:index tag:tableView.tag];
        }];
        LFLog(@"点击在哪%@",cell.model);
        
        if (cell.model.imgurl.count == 0) {
            //没有图
            
            
        }else{
            
            
            LFLog(@"%ld",(long)cell.index);
            [cell setImageblock:^(NSInteger index) {
                
                [self imageViewClick:index row:indexPath.row];
                
            }];
            
        }
        
        return cell;
    }else{
        D0BBsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"D0BBsTableViewCell"];
        
        cell.IndustryModel = self.detailArr[indexPath.row];
        [cell setBlock:^(NSString *str,NSInteger index) {
            LFLog(@"点击在哪");
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.index = indexPath.row ;      
        [cell setPriseBlock:^(NSString *str,NSInteger index) {
            
            [self upDataforpraise: str index:index tag:tableView.tag];
        }];
        [cell setImageblock:^(NSInteger index) {
            [self imageViewClick:index row:indexPath.row];
        }];

            
        
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
    IndustryModel *model = [[IndustryModel alloc]init];
    
    model = self.detailArr[row];
    NSMutableArray *muarr = [[NSMutableArray alloc]init];
    for (NSDictionary *imurl in model.images) {
        [muarr addObject:imurl];
    }
    if (muarr.count > 0) {
        STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:muarr currentIndex:index];
        [broser show];
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bview = [[UIView alloc]init];
//    if (self.tableveiw == nil) {
//        MenuModel *mo = [[MenuModel alloc]init];
//        mo = self.menuArr[tableView.tag - 1000];
//        UIImageView *banerimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.width *8 /25)];
//        
//        [banerimage sd_setImageWithURL:[NSURL URLWithString:mo.imgurl] placeholderImage:[UIImage imageNamed:@""]];
//
//        banerimage.layer.masksToBounds = YES;
//        [bview addSubview:banerimage];
//        
//    }
    
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
//    if (self.tableveiw) {
//        return 0.01;
//    }

//    MenuModel *mo = self.menuArr[tableView.tag - 1000];
//    if (mo.imgurl.length > 0) {
//        return SCREEN.size.width *8 /25;
//    }
    return 0.01;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IndustryModel *mo = self.detailArr[indexPath.row];
    
    CGSize h = [mo.content selfadaption:12];
    CGFloat heigth ;
    if (h.height > 30) {
        heigth = 30;
    }else{
        
        heigth = h.height;
    }
    if (mo.images.count == 0) {
        return heigth + [UIImage imageNamed:@"placeholdertouxiang"].size.height + 90;
    }else{
        return (SCREEN.size.width-40)/2.0 +heigth + 110;
        
    }
    return 120;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IndustryArticleDetailViewController *detail = [[IndustryArticleDetailViewController alloc]init];
    
    detail.model = self.detailArr[indexPath.row];
    
    [self.navigationController pushViewController:detail animated:YES];
    
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


#pragma mark 菜单栏
-(void)requestparentidData{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,IndustryCategoryUrl) params:dt success:^(id response) {
        LFLog(@"行业监管分类：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self.menuArr removeAllObjects];
            
            for (NSDictionary *dt in response[@"data"]) {
                MenuModel *model = [[MenuModel alloc]initWithDictionary:dt error:nil];
                [self.menuArr addObject:model];
            }
            if (self.menuArr.count > 0) {
                [self createCollectionview];
                [self createScrollview];
                
//                if (self.link) {
//                    [self requestlistData:0 category:self.link page:@"1" isLoad:NO];
//                }else{
                
                    [self requestlistData:0 category:response[@"data"][0][@"id"] page:@"1" isLoad:NO];
//                }

            }
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                if ([error_code isEqualToString:@"100"]) {
                    [self showLogin:^(id response) {
                        if ([response isEqualToString:@"1"]) {
                            [self requestparentidData];
                        }
                        
                    }];
                }
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            [self.tableveiw reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
//    NSDictionary *dt = @{@"parentid":self.parentid};
//    [LFLHttpTool get:NSStringWithFormat(ZJBBsBaseUrl,IndustryCategoryUrl) params:dt success:^(id response) {
//        //        [UITableView.mj_header endRefreshing];
//        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
//        if ([str isEqualToString:@"0"]) {
//            
//                
//            }else{
//                
//                [self createtableveiw];
//                [self requestlistData:0 category:self.parentid page:@"1" isLoad:NO];
//            }
//            
//        }else{
//            
//            
//        }
//    } failure:^(NSError *error) {
//        
//    }];
    
}


#pragma mark 文章列表
- (void)requestlistData:(NSInteger )tag category:(NSString *)category page:(NSString *)page isLoad:(BOOL)isload{
    UITableView *tableview = [self.view viewWithTag:tag + 1000];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:category,@"category_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSDictionary *pagination = @{@"count":@"5",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"文章列表dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,IndustryArticleListUrl) params:dt success:^(id response) {
        [tableview.mj_header endRefreshing];
        [tableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"文章列表：%@",response);
        if ([str isEqualToString:@"1"]) {
            
            
            if (isload) {
                NSArray * arr = response[@"data"];
                if (arr.count == 0) {
                    [self presentLoadingTips:@"没有更多数据了~~"];
                }
            }else{
                NSArray * arr = response[@"data"];
                if (arr.count == 0) {
                    [self presentLoadingTips:@"暂无数据~~"];
                }
                [self.detailArr removeAllObjects];
            }
            for (NSDictionary *dt in response[@"data"]) {
                IndustryModel *model=[[IndustryModel alloc]initWithDictionary:dt error:nil];
                
                [self.detailArr addObject:model];
                
            }
            [tableview reloadData];
        }else{
            
            
        }
    } failure:^(NSError *error) {
        [tableview.mj_header endRefreshing];
        [tableview.mj_footer endRefreshing];
    }];
    
}


#pragma mark 点赞数据请求
-(void)upDataforpraise:(NSString *)articleid index:(NSInteger)index tag:(NSInteger )tag{
     UITableView *tableview = [self.view viewWithTag:tag];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:articleid,@"article_id",@"0",@"type", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"点赞dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,IndustryPraiseTreadUrl) params:dt success:^(id response) {
        LFLog(@"点赞：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {

            
            LFLog(@"detailArr%@",self.detailArr[index]);
            IndustryModel *model = self.detailArr[index];
            
            NSInteger praise = [model.like_count integerValue];
            if ([model.is_like isEqualToString:@"0"]) {
                model.is_like = @"1";
                praise ++;
                [self presentLoadingTips:@"点赞成功~~"];
            }else{
                model.is_like = @"0";
                praise --;
                [self presentLoadingTips:@"您已取消点赞"];
            }
            
            model.like_count = [NSString stringWithFormat:@"%d",(int)praise];
            [self.detailArr replaceObjectAtIndex:index withObject:model];
            LFLog(@"detailArr%@",self.detailArr[index]);
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
        
    }];
    
}
-(void)postNotificationName:(NSString *)modelid{
    [[NSNotificationCenter defaultCenter] postNotificationName:modelid object:nil userInfo:@{@"dianzan":@"praise"}];
    
}
#pragma mark 集成刷新控件
- (void)setupRefresh:(UITableView *)tabview
{
    
    //    }
    // 下拉刷新
    tabview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.tableveiw == nil) {
            NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
            MenuModel * mo  = self.menuArr[currentIndex];
            [self requestlistData:currentIndex category:mo.id page:@"1" isLoad:NO];
        }else{
            
            [self requestlistData:0 category:self.parentid page:@"1" isLoad:NO];
            
        }
    }];
    [tabview.mj_header beginRefreshing];
    tabview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.tableveiw == nil) {
            NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
            MenuModel * mo  = self.menuArr[currentIndex];
            self.page ++;
            [self requestlistData:currentIndex category:mo.id page:[NSString stringWithFormat:@"%d",(int)self.page] isLoad:YES];
        }else{
            self.page ++;
            [self requestlistData:0 category:self.parentid page:[NSString stringWithFormat:@"%d",(int)self.page] isLoad:YES];
            
            
        }
    }];
    
}
-(BOOL)fd_interactivePopDisabled{
    return YES;
}

@end
