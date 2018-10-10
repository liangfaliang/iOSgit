//
//  ShopSupermarketViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/6/14.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "ShopSupermarketViewController.h"
#import "AlertsButton.h"
#import "ShoppingCartViewController.h"
#import "ShopSupermarketTableViewCell.h"
#import "ShopDoodsDetailsViewController.h"
#import "ShopSupermarketListViewController.h"
#import "ShopSearchViewController.h"//搜索页面
@interface ShopSupermarketViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView * collectionview;
@property(nonatomic,strong)UISearchBar *searchbar;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UITableView *Listtableview;
@property(nonatomic,strong)AlertsButton *alertbtn;//购物车按钮

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *classArray;

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)NSDictionary *secondSort;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
@end

@implementation ShopSupermarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JHColor(240, 244, 244);
    self.page = 1;
    self.more = @"1";
    self.navigationBarTitle = self.titlename;
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = JHColor(51, 51, 51);
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [self createSearch];
    [self createTableview];
    [self createListtableview];
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
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, 49)];
    header.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:header];
    
    UIButton *filterBtn = [[UIButton alloc]init];
    [filterBtn setImage:[UIImage imageNamed:@"shaixuanzhigou"] forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview: filterBtn];
    [filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header.mas_centerY);
        make.right.offset(-10);
        make.width.offset(filterBtn.imageView.image.size.width);
    }];
    
    self.searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.searchbar.placeholder = @"  搜索所需商品";
    self.searchbar.delegate = self;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    _searchbar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchbar.bounds.size];
    [_searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"sousuokuangshangcheng"] forState:UIControlStateNormal];
    [header addSubview:self.searchbar];
    [_searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header.mas_centerY);
        make.right.equalTo(filterBtn.mas_left).offset(-10);
        make.left.offset(10);
    }];
    
    
    self.alertbtn = [[AlertsButton alloc]init];
    self.alertbtn.alertLabel.textnum = @"0";
    UIImage *im =[UIImage imageNamed:@"gouwuchebaise"];
    self.alertbtn.frame =CGRectMake(0, 0, im.size.width, im.size.height);
    [self.alertbtn setImage:im forState:UIControlStateNormal];
    [self.alertbtn addTarget:self action:@selector(rightCartClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.alertbtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
}
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    ShopSearchViewController *search = [[ShopSearchViewController alloc]init];
    search.cateryId = self.cateryId;
    [self.navigationController pushViewController:search animated:YES];
    return NO;
}
-(void)filterBtnClick:(UIButton *)btn{

    if (self.secondSort) {
        ShopSupermarketListViewController *list = [[ShopSupermarketListViewController alloc]init];
        list.category_id = self.secondSort[@"id"];
        list.natitle = self.secondSort[@"name"];
        [self.navigationController pushViewController:list animated:YES];
    }


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
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, 83, SCREEN.size.height  - 114)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"classCell"];
    [self.view addSubview:self.tableview];
    
}
-(void)createListtableview{
    
    
//    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//    
//    flowLayout.itemSize = CGSizeMake((SCREEN.size.width - 120 -1)/3,100  );
//    //    flowLayout.minimumInteritemSpacing = 5;
//    //    flowLayout.minimumLineSpacing = 1;
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    [flowLayout setHeaderReferenceSize:CGSizeMake(SCREEN.size.width- 120, 50)];
//    
//    if (self.collectionview == nil) {
//        self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(110, 64, SCREEN.size.width - 120,SCREEN.size.height) collectionViewLayout:flowLayout];
//    }
//    self.collectionview.dataSource=self;
//    self.collectionview.delegate=self;
//    [self.collectionview setBackgroundColor:JHColor(255, 255, 255)];
//    //注册Cell，必须要有
//    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"classUICollectionViewCell"];
//    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse"];
//    [self.collectionview registerNib:[UINib nibWithNibName:@"ShopListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"classShopListCollectionViewCell"];//列表
//    [self.view addSubview:self.collectionview];
    
    if (self.Listtableview == nil) {
        self.Listtableview = [[UITableView alloc]initWithFrame:CGRectMake(83, 114, SCREEN.size.width - 83,SCREEN.size.height - 114)];
        self.Listtableview.delegate = self;
        self.Listtableview.dataSource = self;
        self.Listtableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.Listtableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cartfirmCell"];
        [self.Listtableview registerNib:[UINib nibWithNibName:@"ShopSupermarketTableViewCell" bundle:nil] forCellReuseIdentifier:@"listTableViewCell"];
        [self.view addSubview:self.Listtableview];
        [self setupRefresh];
    }


    
    
}

#pragma mark tableview代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.tableview) {
        return 1;
    }
    if (self.classArray.count) {
        return self.classArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableview) {
        return self.dataArray.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableview) {
        return 50;
    }
    if (self.classArray.count) {
        return 100;
    }
    return SCREEN.size.height - 114;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableview) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"classCell"];
            if (indexPath.row == 0) {
                cell.selected = YES;
            }
        }
        [cell.contentView removeAllSubviews];
        UILabel *textLabel = [[UILabel alloc]init];
        textLabel.text = self.dataArray[indexPath.row][@"name"];
        textLabel.font = [UIFont systemFontOfSize:13];
        UIView *backview = [[UIView alloc]init];
        backview.backgroundColor = JHColor(245, 245, 245);
        cell.selectedBackgroundView = backview;
        if (cell.selected) {
             textLabel.textColor = JHColor(255, 86, 18);
        }else{
        
             textLabel.textColor = JHColor(51, 51, 51);
        }
        cell.backgroundColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.top.offset(0);
            make.bottom.offset(0);
        }];
        return cell;
    }
    if (self.classArray.count) {
        ShopSupermarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableDictionary *mdt = self.classArray[indexPath.section];
        [cell.countLb setBlock:^(BOOL isAdd) {//加减商品数量
            NSInteger num = 0;
            if (mdt[@"cart_count"]) {
                num = [mdt[@"cart_count"] integerValue];
            }

                if (isAdd) {
                    num ++;
                    [self UploadDataCartListUpdate:mdt[@"goods_id"] new_number:nil isDelete:NO index:indexPath.section num:num];//添加
                }else{
                    if (num > 1) {
                        num --;
                        
                        [self UploadDataCartListUpdate:mdt[@"rec_id"] new_number:[NSString stringWithFormat:@"%ld",(long)num] isDelete:NO index:indexPath.section num:num];//减少
                    }else{
                        num = 0;
                        [self UploadDataCartListUpdate:mdt[@"rec_id"] new_number:nil isDelete:YES index:indexPath.section num:num];//删除购物车商品
                        
                    }
                    
                }

        }];

        cell.countLb.countLabel.enabled = NO;
        cell.nameLb.text = mdt[@"name"];
//        NSMutableString *mstr = [NSMutableString string];
//        if (model.goods_attr.count) {
//            for (int i = 0; i < model.goods_attr.count; i ++) {
//                [mstr appendFormat:@"%@ ", model.goods_attr[i][@"value"]];
//            }
//        }
//        cell.styleLabel.text = mstr;
        cell.NewPriceLb.attributedText = [[NSString stringWithFormat:@"%@",mdt[@"shop_price"]] AttributedString:@"￥" backColor:nil uicolor:nil uifont:[UIFont systemFontOfSize:12]];
        cell.NewPriceWidth.constant = [cell.NewPriceLb.text selfadap:17 weith:20].width;
        cell.oldPriceLb.text = mdt[@"market_price"];
        NSInteger number = [mdt[@"cart_count"] integerValue];
        if (number > 0) {
            cell.countLb.countLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
            cell.countLb.minusBtn.hidden = NO;
            cell.oldPriceRight.constant = 5;
        }else{
            cell.oldPriceRight.constant = -50;
            cell.countLb.minusBtn.hidden = YES;
            cell.countLb.countLabel.text = nil;
        }
        
        [cell.picture sd_setImageWithURL:[NSURL URLWithString:mdt[@"img"][@"url"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartfirmCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView removeAllSubviews];
        UIImageView *plImview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuneirong"]];
        [cell.contentView addSubview:plImview];
        [plImview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.left.offset(10);
            make.right.offset(-10);
        }];
        return cell;
    }
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
    if (tableView == self.tableview) {
        LFLog(@"选中：%ld",(long)indexPath.row);
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        for (UIView *subview in cell.contentView.subviews) {
            if ([subview isKindOfClass:[UILabel class]]) {
                UILabel *titlelabel = (UILabel *)subview;
                titlelabel.textColor = JHColor(255, 86, 18);
            }
        }
        self.secondSort = self.dataArray[indexPath.row];
        [self UploadDatadynamic:self.secondSort[@"id"] pagenum:self.page];
//        self.nameLabel.text =self.dataArray[indexPath.row][@"name"];
//        [self.tableview reloadData];
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell.selected = YES;
//        [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        if (self.classArray.count) {
            ShopDoodsDetailsViewController *goods =[[ShopDoodsDetailsViewController alloc]init];
            goods.goods_id = self.classArray[indexPath.section][@"goods_id"];
            [self.navigationController pushViewController:goods animated:YES];
        }
    }
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableview) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        for (UIView *subview in cell.contentView.subviews) {
            if ([subview isKindOfClass:[UILabel class]]) {
                UILabel *titlelabel = (UILabel *)subview;
                titlelabel.textColor = JHdeepColor;
            }
        }
    }
     LFLog(@"取消选中：%ld",(long)indexPath.row);
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.selected = NO;
//    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
    
    return self.classArray.count;
    
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classUICollectionViewCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [cell.contentView removeAllSubviews];
    UIImageView *imageveiw  = [[UIImageView alloc]init];
    imageveiw.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *url = [NSString string];
    if (SCREEN.size.width < 750) {
        url = self.classArray[indexPath.row][@"imgurl2"];
    }else{
        
        url = self.classArray[indexPath.row][@"imgurl3"];
        
    }
    [imageveiw sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
    [cell.contentView addSubview:imageveiw];
    [imageveiw mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(0);
        make.centerX.equalTo(cell.contentView.mas_centerX);
        make.height.offset(60);
        
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
    
    
    
    return cell;
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
    
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        return;
    }
//    ShopListingViewController *goods =[[ShopListingViewController alloc]init];
//    goods.category_id = self.classArray[indexPath.item][@"id"];
//    goods.natitle = self.classArray[indexPath.item][@"name"];
//    [self.navigationController pushViewController:goods animated:YES];
    
    
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
    return reusableview;
    
}
#pragma mark - *************一级分类数据请求*************
-(void)UploadDataCategory{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]init];
    if (self.cateryId) {
        [dt setObject:self.cateryId forKey:@"id"];
    }
    [dt setObject:session forKey:@"session"];
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,CategorySecondUrl) params:dt success:^(id response) {
        [self.collectionview.mj_header endRefreshing];
        [self.tableview.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"一级分类列表：%@",response);
        if ([str isEqualToString:@"1"]) {
            
            [self.dataArray removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                [self.dataArray addObject:dt];
            }
            [self.tableview reloadData];
            if (self.dataArray.count) {
                [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            NSDictionary *dict = self.dataArray[0];
            self.nameLabel.text = dict[@"name"];
            self.secondSort = dict;
            [self UploadDatadynamic:dict[@"id"] pagenum:self.page];
            
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self UploadDataCategory];
                    }
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.tableview.mj_header endRefreshing];
    }];
    
    
}
#pragma mark - *************二级分类数据请求*************
-(void)UploadDatadynamic:(NSString *)category_id pagenum:(NSInteger)pagenum{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *filter = [[NSMutableDictionary alloc]init];
    if (category_id) {
        [filter setObject:category_id forKey:@"category_id"];
    }
    [dt setObject:session forKey:@"session"];
    [dt setObject:filter forKey:@"filter"];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"二级分类dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ShopDirectlistUrl) params:dt success:^(id response) {
        [self.Listtableview.mj_header endRefreshing];
        [self.Listtableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"二级分类列表：%@",response);
        if ([str isEqualToString:@"1"]) {
            
            [self.classArray removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                NSMutableDictionary *mdt = [NSMutableDictionary dictionaryWithDictionary:dt];
                [mdt setValue:[NSNumber numberWithInt:0] forKey:@"number"];
                [self.classArray addObject:mdt];
            }
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            [self.Listtableview reloadData];
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self.Listtableview.mj_header endRefreshing];
        [self.Listtableview.mj_footer endRefreshing];
    }];
    
    
}
#pragma mark - *************购物车添加请求*************
-(void)UploadDataCartListUpdate:(NSString *)shopid new_number:(NSString *)new_number isDelete:(BOOL)isdelete index:(NSInteger )index num:(NSInteger )num{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    if (isdelete) {//是否删除
        [dt setObject:shopid forKey:@"rec_id"];
    }else{
        
        if (new_number) {//是否减少
            [dt setObject:shopid forKey:@"rec_id"];
            [dt setObject:new_number forKey:@"new_number"];
        }else{
            [dt setObject:shopid forKey:@"goods_id"];
            [dt setObject:@"1" forKey:@"number"];
        }
    }
    LFLog(@"购物车更新dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,(isdelete ? CartDeleteUrl:(new_number ? CartUpdateUrl:createCartUrl))) params:dt success:^(id response) {
        LFLog(@"购物车更新：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {

//            NSMutableDictionary *mdt = self.classArray[index];
//            if (response[@"data"]) {
//                if ([response[@"data"][@"rec_id"] isKindOfClass:[NSString class]]) {
//                    [mdt setObject:response[@"data"][@"rec_id"] forKey:@"rec_id"];//第一次添加购物车，更新rec_id
//                }
//            }
//            
//            [mdt setObject:[NSString stringWithFormat:@"%ld",(long)num] forKey:@"cart_count"];
            [self UploadSingleGoods:self.classArray[index][@"goods_id"] index:index];
            [self updateCratCount];
        }else{
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
    } failure:^(NSError *error) {

        [self presentLoadingTips:@"连接失败！"];
    }];
    
    
}
#pragma mark - *************单个商品详情数据请求*************
-(void)UploadSingleGoods:(NSString *)good_id index:(NSInteger )index{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (good_id) {
        [dt setObject:good_id forKey:@"goods_id"];
    }
    LFLog(@"单个商品详情dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ShopSingleGoodsUrl) params:dt success:^(id response) {
        [self.Listtableview.mj_header endRefreshing];
        [self.Listtableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"单个商品详情：%@",response);
        if ([str isEqualToString:@"1"]) {
            NSMutableDictionary *mdt = [NSMutableDictionary dictionaryWithDictionary:response[@"data"]];
            [self.classArray replaceObjectAtIndex:index withObject:mdt];
            [self.Listtableview reloadData];
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self.Listtableview.mj_header endRefreshing];
        [self.Listtableview.mj_footer endRefreshing];
    }];
    
    
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _Listtableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self UploadDatadynamic:self.secondSort[@"id"] pagenum:self.page];
    }];
    _Listtableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多了"];
            [_Listtableview.mj_footer endRefreshing];
        }else{
            self.page ++;
           [self UploadDatadynamic:self.secondSort[@"id"] pagenum:self.page];
        }
        
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
    
}
@end
