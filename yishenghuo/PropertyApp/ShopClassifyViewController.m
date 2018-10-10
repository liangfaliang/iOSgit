//
//  ShopClassifyViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/15.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ShopClassifyViewController.h"
#import "AlertsButton.h"
#import "ShoppingCartViewController.h"
#import "ShopListCollectionViewCell.h"
#import "ShopSortListViewController.h"
@interface ShopClassifyViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView * collectionview;
@property(nonatomic,strong)UISearchBar *searchbar;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)AlertsButton *alertbtn;//购物车按钮
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *classArray;
@property(nonatomic,strong)UILabel *nameLabel;
@end

@implementation ShopClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //店铺品牌
    self.view.backgroundColor = JHColor(240, 244, 244);
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = JHColor(51, 51, 51);
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    self.navigationBarTitle = @"商品分类";
//    [self createSearch];
    [self createTableview];
    [self createCollectionview];
    [self UploadDataCategory];
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(NSMutableArray *)classArray{
    if (_classArray == nil) {
        _classArray = [[NSMutableArray alloc]init];
    }
    return _classArray;
}
-(void)createSearch{
    self.searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.searchbar.layer.cornerRadius = 5;
    self.searchbar.placeholder = @"搜索";
    self.searchbar.delegate = self;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    //    UIView *searchview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    //    searchview.backgroundColor = [UIColor colorWithRed:0 green:107/256.0 blue:218/256.0 alpha:1];
    //     searchview.layer.cornerRadius = 5;
    //    [searchview addSubview:self.searchbar];
    self.navigationItem.titleView = self.searchbar;
    
    self.alertbtn = [[AlertsButton alloc]init];
    self.alertbtn.alertLabel.textnum = @"0";
    UIImage *im =[UIImage imageNamed:@"gouwuchebaise"];
    self.alertbtn.frame =CGRectMake(0, 0, im.size.width, im.size.height);
    [self.alertbtn setImage:im forState:UIControlStateNormal];
    [self.alertbtn addTarget:self action:@selector(rightCartClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.alertbtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}


-(void)rightCartClick:(UIButton *)btn{
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        return;
    }
    ShoppingCartViewController *cart =[[ShoppingCartViewController alloc]init];
    [self.navigationController pushViewController:cart animated:YES];
    
}

-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 95, SCREEN.size.height  + 50)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//     [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"classCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopCartTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopCartTableViewCell"];
    [self.view addSubview:self.tableview];
    
}
-(void)createCollectionview{
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake((SCREEN.size.width - 120 -1)/3,110  );
//    flowLayout.minimumInteritemSpacing = 5;
//    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    [flowLayout setHeaderReferenceSize:CGSizeMake(SCREEN.size.width- 120, 50)];
    
    if (self.collectionview == nil) {
        self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(105, 74, SCREEN.size.width - 120,SCREEN.size.height - 74) collectionViewLayout:flowLayout];
    }
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview setBackgroundColor:JHColor(255, 255, 255)];
    //注册Cell，必须要有
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"classUICollectionViewCell"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"ShopListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"classShopListCollectionViewCell"];//列表
    [self.view addSubview:self.collectionview];
    
    
}

#pragma mark tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"classCell"];
        if (indexPath.row == 0) {
            cell.selected = YES;
        }
    }
    cell.textLabel.text = self.dataArray[indexPath.row][@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (cell.selected) {
        cell.textLabel.textColor = JHColor(255, 86, 18);
    }else{
        cell.textLabel.textColor = JHdeepColor;
    }
    UIView *backview = [[UIView alloc]init];
    backview.backgroundColor = JHColor(240, 244, 244);
    cell.selectedBackgroundView = backview;
    cell.textLabel.highlightedTextColor = JHshopMainColor;
    cell.backgroundColor = [UIColor whiteColor];

    return cell;
}

//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    LFLog(@"didDeselect:%ld",(long)indexPath.row);
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor whiteColor];
//    cell.textLabel.textColor = JHColor(51, 51, 51);
//    
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = JHColor(255, 86, 18);
    [self UploadDatadynamic:self.dataArray[indexPath.row][@"id"]];
    self.nameLabel.text =self.dataArray[indexPath.row][@"name"];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = JHdeepColor;

}
#pragma mark -- 让cell的分割线顶头
-(void)viewDidLayoutSubviews {
    
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark collectionview代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (self.classArray.count) {
        return self.classArray.count;
    }
    return 1;
    
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classUICollectionViewCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [cell.contentView removeAllSubviews];

    UIImageView *imageveiw  = [[UIImageView alloc]init];
    imageveiw.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imageveiw];
    if (self.classArray.count) {
        NSString *url = [NSString string];
        if (SCREEN.size.width < 750) {
            url = self.classArray[indexPath.row][@"imgurl2"];
        }else{
            
            url = self.classArray[indexPath.row][@"imgurl3"];
        }
        [imageveiw sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
        
        [imageveiw mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.offset(0);
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.height.offset(85);
            
        }];
        
        UILabel *lab  = [[UILabel alloc]init];
        
        lab.text = self.classArray[indexPath.row][@"name"];
        lab.font = [UIFont systemFontOfSize:12];
        lab.textAlignment = NSTextAlignmentCenter;
        [lab setTextColor:[UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1]];
        lab.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5);
            make.right.offset(-5);
            make.top.equalTo(imageveiw.mas_bottom);
            make.bottom.offset(0);
            
        }];
    }else{
        imageveiw.image = [UIImage imageNamed:@"wuneirong"];
        [imageveiw mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.offset(0);
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.left.offset(0);
            make.right.offset(0);
        }];
    
    }

    
    
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.classArray.count) {
        return CGSizeMake((SCREEN.size.width - 120 -1)/3,110  );
    }else{
        return CGSizeMake( SCREEN.size.width - 120 , SCREEN.size.height);
    }
    
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.classArray.count) {
        if ( NO == [UserModel online] )
        {
            [self showLogin:^(id response) {
            }];
            return;
        }
        NSIndexPath* iPath = [self.tableview indexPathForSelectedRow];
        ShopSortListViewController *goods =[[ShopSortListViewController alloc]init];
        LFLog(@"indexPath.row:%ld",(long)iPath.row);
        if ([self.dataArray[iPath.row][@"id"] isEqualToString:@"-1"]) {
            goods.supplires_id = self.classArray[indexPath.item][@"id"];
        }else{
            goods.category_id = self.classArray[indexPath.item][@"id"];
        }
        goods.natitle = self.classArray[indexPath.item][@"name"];
        [self.navigationController pushViewController:goods animated:YES];
    }  
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    NSLog(@"kind = %@", kind);
    if (kind == UICollectionElementKindSectionHeader){
        
        UIView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse" forIndexPath:indexPath];
        
        reusableview = (UICollectionReusableView *)headerV;
    }
//    UIView *Vf = [self.view viewWithTag:55];
//    if (Vf == nil) {
//        Vf = [[UIView alloc]init];
//        //        if (self.bannerModel.banners.count) {
//        Vf.frame = CGRectMake(0, headerHt,SCREEN.size.width , 160);
//        //        }else{
//        //
//        //          Vf.frame = CGRectMake(0, 0,SCREEN.size.width , 160);
//        //        }
//        Vf.tag = 55;
//    }
//    
//    Vf.backgroundColor = [UIColor grayColor];
//    //    [self.view addSubview:Vf];
//    [Vf removeAllSubviews];
//
//    [reusableview addSubview:Vf];
    
//    UIImageView *headerimage = [[UIImageView alloc]init];
//    headerimage.image = [UIImage imageNamed:@"tiantiantejia"];
//    headerimage.contentMode = UIViewContentModeScaleAspectFit;
//    headerimage.backgroundColor = [UIColor whiteColor];
//    [reusableview addSubview:headerimage];
//    [headerimage mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(Vf.mas_bottom).offset(1);
//        make.left.offset(0);
//        make.right.offset(0);
//        make.bottom.offset(0);
//    }];

    reusableview.backgroundColor = JHColor(241, 241, 241);
    [reusableview addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(Vf.mas_bottom).offset(1);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(-10);
    }];
    return nil;
    
}
#pragma mark - *************一级分类数据请求*************
-(void)UploadDataCategory{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"json", nil];

    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,CategoryFirstUrl) params:dt success:^(id response) {
        [self.collectionview.mj_header endRefreshing];
        [self.tableview.mj_header endRefreshing];
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:@{@"id":@"-1",@"name":@"店铺品牌"}];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"一级分类列表：%@",response);
        if ([str isEqualToString:@"1"]) {
            for (NSDictionary *dt in response[@"data"]) {
                [self.dataArray addObject:dt];
            }
            NSDictionary *dict = self.dataArray[0];
            self.nameLabel.text = dict[@"name"];
            [self UploadDatadynamic:dict[@"id"]];
            
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        [self.tableview reloadData];
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableview selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.tableview.mj_header endRefreshing];
    }];
    
    
}
#pragma mark - *************二级分类数据请求*************
-(void)UploadDatadynamic:(NSString *)cateryId{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]init];
    NSString *url = CategorySecondUrl;
    if ([cateryId isEqualToString:@"-1"]) {
        url = ShopSupplierListUrl;
    }else{
        if (cateryId) {
            [dt setObject:cateryId forKey:@"id"];
        }
        
    }
    [dt setObject:session forKey:@"session"];
    LFLog(@"dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [self.collectionview.mj_header endRefreshing];
        [self.tableview.mj_header endRefreshing];
        LFLog(@"二级分类列表：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        [self.classArray removeAllObjects];
        if ([str isEqualToString:@"1"]) {
            for (NSDictionary *dt in response[@"data"]) {
                [self.classArray addObject:dt];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.collectionview reloadData];
    } failure:^(NSError *error) {
         [self.classArray removeAllObjects];
        [self presentLoadingTips:@"加载失败！"];
        [self.collectionview reloadData];
        [self.collectionview.mj_header endRefreshing];
        [self.tableview.mj_header endRefreshing];
    }];
    
    
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
//    NSInteger selectedIndex = 0;
//    
//    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
//    
//    [self.tableview selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    if (self.dataArray.count) {
//        [self UploadDatadynamic:self.dataArray[0][@"id"]];
//        self.nameLabel.text =self.dataArray[0][@"name"];
//    }
}
@end
