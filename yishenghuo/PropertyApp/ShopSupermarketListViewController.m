//
//  ShopSupermarketListViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/6/15.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "ShopSupermarketListViewController.h"
#import "LFLUibutton.h"
#import "AlertsButton.h"
#import "ShoppingCartViewController.h"
#import "ShopSupermarketlCollectionViewCell.h"
#import "ShopTheStoreViewController.h"
#import "UIButton+WebCache.h"
#import "sortLabelview.h"
#import "JWCycleScrollView.h"
#import "AlertsButton.h"
#import "ShopDoodsDetailsViewController.h"

@interface ShopSupermarketListViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JWCycleScrollImageDelegate,sortLabelviewDelegate,UISearchBarDelegate>{
    UIView *popShopview;//店铺选择类型
    UIView *headerview;
    sortLabelview *soreview;//分类标签
    
}
@property(nonatomic,strong)UICollectionView *collectionview;

@property(nonatomic,strong)UIButton * selectBtn;
@property(nonatomic,strong)NSArray * btnNameArr;
@property(nonatomic,assign)BOOL isRotating;//图片旋转
@property(nonatomic,strong)UIView *popview;//弹出层视图
@property(nonatomic,strong)NSMutableArray * screenArr;//筛选
@property(nonatomic,strong)AlertsButton *alertbtn;//购物车按钮
@property (nonatomic, strong) JWCycleScrollView * jwView;
@property(nonatomic,strong)NSMutableArray * storeArr;//店铺
@property(nonatomic,strong)UILabel *priceLb;//店铺商品价格
@property(nonatomic,strong)NSMutableArray * brandArr;//筛选品牌
@property(nonatomic,strong)NSMutableArray * priceArr;//筛选价格
@property(nonatomic,strong)NSDictionary * brandDict;//存储品牌
@property(nonatomic,strong)NSDictionary * priceDict;//存储价格
@property(nonatomic,strong)NSMutableArray * sortArr;//分类标签
@property(nonatomic,strong)NSMutableArray *pictureArr;//轮播图
@property(nonatomic,assign)NSInteger page;//存储价格
@property(nonatomic,strong)NSString *more;//是否加载更多
@property(nonatomic,strong)NSString *sort;//标签


@end

@implementation ShopSupermarketListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isRotating = YES;//默认第一次旋转
    
    self.page = 1;
    self.more = @"1";

    if (self.category_id) {
        [self createSearch];
        if (self.natitle) {
            self.btnNameArr = @[self.natitle,@"品牌",@"销量 ",@"价格 "];
        }
        if (self.keywords) {
            self.btnNameArr = @[@"品牌",@"销量 ",@"价格 "];
        }
        
    }else{
        self.btnNameArr = @[@"默认",@"品牌",@"销量 ",@"价格 "];
        self.navigationBarTitle = self.natitle;
    }
    [self createBaritem];
    [self createHeaderview];
    [self createTableview];
    [self setupRefresh];
    if (self.category_id) {
//        [self rotatePicture];
        
        if (self.keywords) {
            [self UploadDataFilter:FilterBrandUrl];//品牌筛选
        }else{
            [self UploadDataShopListSortUrl];//分类标签
        }
//        [self UploadDataFilter:FilterPriceUrl];//价格筛选
    }
    [self UploadDatagoods:-1 page:0];
//    [self UploadDataFilter:FilterBrandUrl];//品牌筛选
    
    
    
    
}

-(NSMutableArray *)pictureArr{
    
    if (_pictureArr == nil) {
        _pictureArr = [[NSMutableArray alloc]init];
    }
    
    return _pictureArr;
}
-(NSMutableArray *)sortArr{
    
    if (_sortArr == nil) {
        _sortArr = [[NSMutableArray alloc]init];
    }
    
    return _sortArr;
}
-(NSMutableArray *)brandArr{
    
    if (_brandArr == nil) {
        _brandArr = [[NSMutableArray alloc]init];
    }
    
    return _brandArr;
}
-(NSMutableArray *)storeArr{
    
    if (_storeArr == nil) {
        _storeArr = [[NSMutableArray alloc]init];
    }
    
    return _storeArr;
}
-(NSMutableArray *)priceArr{
    
    if (_priceArr == nil) {
        _priceArr = [[NSMutableArray alloc]init];
    }
    
    return _priceArr;
}
-(NSMutableArray *)screenArr{
    
    if (_screenArr == nil) {
        _screenArr = [[NSMutableArray alloc]init];
    }
    
    return _screenArr;
}
-(NSMutableArray *)listArr{
    
    if (_listArr == nil) {
        _listArr = [[NSMutableArray alloc]init];
    }
    
    return _listArr;
}
-(void)createSearch{
    
    self.searchbar = nil;
    self.searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(60, 20, SCREEN.size.width - 120, 20)];
    self.searchbar.layer.cornerRadius = 5;
    self.searchbar.layer.masksToBounds = YES;
    self.searchbar.placeholder = @"搜索所需商品";
    self.searchbar.delegate = self;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    [_searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"sousuokuangshangcheng"] forState:UIControlStateNormal];
    //    self.searchbar.backgroundColor = [UIColor clearColor];
    if (self.keywords) {
        self.searchbar.text = self.keywords;
    }
    self.navigationItem.titleView = self.searchbar;
    
    
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
//    [self reloadShopData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    LFLog(@"searchBar.text:%@",searchBar.text);
    [self.searchbar resignFirstResponder];
    self.keywords = self.searchbar.text;
    [self listClick:self.selectBtn];
}
-(void)createBaritem{
    self.alertbtn = [[AlertsButton alloc]init];
    self.alertbtn.alertLabel.textnum = @"0";
    UIImage *im =[UIImage imageNamed:@"gouwuchebaise"];
    self.alertbtn.frame =CGRectMake(0, 0, im.size.width, im.size.height);
    [self.alertbtn setImage:im forState:UIControlStateNormal];
    [self.alertbtn addTarget:self action:@selector(rightCartClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.alertbtn];
    //    rightBtn.tintColor = JHdeepColor;
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
}
-(void)rightCartClick:(UIButton *)btn{
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
            
        }];
        return ;
    }
    ShoppingCartViewController *cart =[[ShoppingCartViewController alloc]init];
    [self.navigationController pushViewController:cart animated:YES];
    
}
-(void)createHeaderview{
    if (headerview == nil) {
        headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width,  50)];
        headerview.backgroundColor = [UIColor whiteColor];
    }
    
    //    [self.view addSubview:headerview];
    if (soreview) {
        headerview.frame = CGRectMake(0, 0, SCREEN.size.width, soreview.height + 50);
    }else{
        headerview.frame = CGRectMake(0, 0, SCREEN.size.width, 50);
    }
    

    for (int i = 0; i < self.btnNameArr.count; i ++) {
        UIButton *button = [headerview viewWithTag:(54 - self.btnNameArr.count) + i];
        if (button == nil) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * SCREEN.size.width/self.btnNameArr.count, 0, SCREEN.size.width/self.btnNameArr.count, 50)];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [button.imageView setContentMode:UIViewContentModeCenter];
            [button setTitle:self.btnNameArr[i] forState:UIControlStateNormal];
            [button setTitleColor:JHmiddleColor forState:UIControlStateNormal];
            [button setTitleColor:JHshopMainColor forState:UIControlStateSelected];
            //        [button setAttributedTitle:[self AttributedString:self.btnNameArr[i] image:[UIImage imageNamed:@"shangjiantoumoren"] UIcolor:JHColor(51, 51, 51)] forState:UIControlStateNormal];
            //        [button setAttributedTitle:[self AttributedString:self.btnNameArr[i] image:[UIImage imageNamed:@"shangjiantouhongse"] UIcolor:[UIColor redColor]] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(listClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = (54 - self.btnNameArr.count) + i;
            UIImage *image = [UIImage imageNamed:@"shangjiantoumoren"];
            if (i == 0) {
                [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
//                button.Ratio = 1;
                //            button.selected = YES;
                //            self.selectBtn = button;
            }else{
                [button.titleLabel setTextAlignment:NSTextAlignmentRight];
//                button.Ratio = 0.7;

                if (button.tag > 51) {
                    
                    [button setImage:image forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:@"shangjiantouhongse"] forState:UIControlStateSelected];
                }
               
            }
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width , 0, image.size.width )];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0,[button.titleLabel.text selfadap:15 weith:20].width + 10, 0, -[button.titleLabel.text selfadap:15 weith:20].width )];
            if (i == 0) {
                button.selected = YES;
                self.selectBtn = button;
            }
            [headerview addSubview:button];
        }else{
            button.frame = CGRectMake(i * SCREEN.size.width/self.btnNameArr.count,  0, SCREEN.size.width/self.btnNameArr.count, 50);
        }
        
        
    }
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (soreview) {
        soreview.frame = CGRectMake(0, 50, soreview.frame.size.width, soreview.frame.size.height);

        headerview.frame =  CGRectMake(0, 0, SCREEN.size.width, soreview.height + 50);

        
    }else{
        headerview.frame =  CGRectMake(0, 0, SCREEN.size.width, 50);
    }
    [self.collectionview reloadData];
}



-(void)createpopShopview{
    NSArray *shopArr = @[@"全部",@"自营"];
    popShopview = [[UIView alloc]initWithFrame:CGRectMake(0, 114, SCREEN.size.width, SCREEN.size.height - 114)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popshopviewClick:)];
    [popShopview addGestureRecognizer:tap];
    [self.view addSubview:popShopview];
    UIView *shopview = [[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN.size.width/4 - 20, 90)];
    shopview.backgroundColor = [UIColor whiteColor];
    shopview.layer.borderColor = [JHColor(229, 229, 229) CGColor];
    shopview.layer.borderWidth = 1;
    [popShopview addSubview:shopview];
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, i * (shopview.height/2 + 1), shopview.width, shopview.height/2 - 1)];
        
        [button setTitle:shopArr[i] forState:UIControlStateNormal];
        button.tag = 80 + i;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:JHColor(102, 102, 102) forState:UIControlStateNormal];
        [button setTitleColor:JHAssistColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(popupShopbutton:) forControlEvents:UIControlEventTouchUpInside];
        [shopview addSubview:button];
        
    }
    UIView *vline = [[UIView alloc]init];
    vline.backgroundColor = [UIColor redColor];
    [shopview addSubview:vline];
    [vline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shopview.mas_centerY);
        make.height.offset(1);
        make.left.offset(5);
        make.right.offset(-5);
        
    }];
    
}
//点击隐藏店铺烈性
-(void)popshopviewClick:(UITapGestureRecognizer *)tap{
    popShopview.hidden = YES;
}
-(NSMutableAttributedString *)AttributedString:(NSString *)text image:(UIImage *)image UIcolor:(UIColor *)color{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName : color}];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
    
    attachment.image = image;
    attachment.bounds = CGRectMake(5, 0, 10, 10);
    
    NSAttributedString *imstr = [NSAttributedString attributedStringWithAttachment:attachment];
    [str insertAttributedString:imstr atIndex:2];
    return str;
    
}
-(void)listClick:(UIButton *)btn{
    [self.view endEditing:YES];
    self.more = @"1";
    self.page = 1;
    self.sort = nil ;
    self.brandDict = nil;
    [soreview removeFromSuperview];
    soreview = nil;
    [self.sortArr removeAllObjects];
    if (!_popview.hidden) {
        _popview.hidden = YES;
    }
    if (self.selectBtn.tag == btn.tag) {
        self.selectBtn.selected = YES;
        if (btn.tag == 53) {
            if (self.isRotating) {
                [self UploadDatagoods:ShopListprice_desclistUrl page:0];
                btn.imageView.layer.transform = CATransform3DMakeRotation(M_PI , 0, 0, 1);
                self.isRotating = NO;
            }else{
                [self UploadDatagoods:ShopListprice_asclistUrl page:0];
                btn.imageView.layer.transform = CATransform3DMakeRotation(0 , 0, 0, 1);
                self.isRotating = YES;
            }
        }else if (btn.tag == 52){
            if (self.isRotating) {
                [self UploadDatagoods:ShopListstoreDescUrl page:0];
                btn.imageView.layer.transform = CATransform3DMakeRotation(M_PI , 0, 0, 1);
                self.isRotating = NO;
            }else{
                [self UploadDatagoods:ShopListstoreAscUrl page:0];
                btn.imageView.layer.transform = CATransform3DMakeRotation(0 , 0, 0, 1);
                self.isRotating = YES;
            }
            //            [self UploadDatagoods:ShopListstoreDescUrl page:0];
        }else if (btn.tag == 50){
            [self UploadDatagoods:-1 page:0];
            [self UploadDataShopListSortUrl];
        }else if(btn.tag == 51){
            [self UploadDatagoods:-1 page:0];
            [self UploadDataFilter:FilterBrandUrl];//品牌筛选
        }
        
    }else{
        self.isRotating = YES;
        self.selectBtn.imageView.layer.transform = CATransform3DMakeRotation(0 , 0, 0, 1);
        self.selectBtn.selected = NO;
        self.selectBtn = btn;
        btn.selected = YES;
        if (btn.tag == 50) {
            [self UploadDatagoods:-1 page:0];
            [self UploadDataShopListSortUrl];
        }else if(btn.tag == 51){
            [self UploadDatagoods:-1 page:0];
            [self UploadDataFilter:FilterBrandUrl];//品牌筛选
        }else if (btn.tag == 52){
            [self UploadDatagoods:ShopListstoreAscUrl page:0];
        }else if (btn.tag == 53){
            [self UploadDatagoods:ShopListprice_asclistUrl page:0];
        }
    }
    self.page = 1;
    
    
}

-(void)createTableview{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN.size.width, 100);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //    [flowLayout setHeaderReferenceSize:CGSizeMake(SCREEN.size.width, headerHeight + 160 + 51)];
    
    if (self.collectionview == nil) {
        self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width,SCREEN.size.height ) collectionViewLayout:flowLayout];
    }
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview setBackgroundColor:[UIColor whiteColor]];
    //注册Cell，必须要有
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"confirmCell"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"ShopSupermarketlCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShopSupermarketlCollectionViewCell"];//列表
    [self.view addSubview:self.collectionview];
    
    
}

#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    if (self.storeArr.count) {
    //        if (self.selectBtn.tag == 50) {
    //            return self.storeArr.count;
    //        }
    //    }
    
    if (self.listArr.count) {
        return self.listArr.count;
    }
    return 1;
    
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        if (self.listArr.count) {
        ShopSupermarketlCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopSupermarketlCollectionViewCell" forIndexPath:indexPath];
        NSMutableDictionary *mdt = self.listArr[indexPath.item];
        [cell.countLb setBlock:^(BOOL isAdd) {//加减商品数量
            NSInteger num = 0;
            if (mdt[@"cart_count"]) {
                num = [mdt[@"cart_count"] integerValue];
            }
            if (isAdd) {
                num ++;
                [self UploadDataCartListUpdate:mdt[@"goods_id"] new_number:nil isDelete:NO index:indexPath.item num:num];//添加
            }else{
                if (num > 1) {
                    num --;
                    [self UploadDataCartListUpdate:mdt[@"rec_id"] new_number:[NSString stringWithFormat:@"%ld",(long)num] isDelete:NO index:indexPath.item num:num];//减少
                }else{
                    num = 0;
                    [self UploadDataCartListUpdate:mdt[@"rec_id"] new_number:nil isDelete:YES index:indexPath.item num:num];//删除购物车商品
                }
                
            }

        }];
        
        cell.countLb.countLabel.enabled = NO;
        cell.nameLb.text = mdt[@"name"];

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
        UICollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"confirmCell" forIndexPath:indexPath];
        
        [cell.contentView removeAllSubviews];
        UIImageView *plImview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuneirong"]];
        [cell.contentView addSubview:plImview];
        [plImview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20);
            make.centerX.equalTo(cell.contentView.mas_centerX);
        }];
        return cell;
        
        
    }
    
    //    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (self.storeArr.count) {
    //        if (self.selectBtn.tag == 50) {
    //            return CGSizeMake(SCREEN.size.width, 200);
    //        }
    //    }
    if (self.listArr.count) {
        
        return CGSizeMake(SCREEN.size.width, 100);
        
    }
    return CGSizeMake(SCREEN.size.width, SCREEN.size.height - 50);
}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}
//头视图尺寸
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (collectionView == self.collectionview) {
        
        return CGSizeMake(SCREEN.size.width, headerview.height );
    }else{
        return CGSizeZero;
    }
    
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionview) {
        UICollectionReusableView *reusableview = nil;
        NSLog(@"kind = %@", kind);
        if (kind == UICollectionElementKindSectionHeader){
            
            UIView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse" forIndexPath:indexPath];
            
            reusableview = (UICollectionReusableView *)headerV;
        }
        [reusableview addSubview:headerview];
        
        return reusableview;
    }else{
        return nil;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        
        return;
    }
    //    if (self.selectBtn.tag != 50) {
    if (self.listArr.count) {
        ShopDoodsDetailsViewController *goods =[[ShopDoodsDetailsViewController alloc]init];
        goods.goods_id = self.listArr[indexPath.item][@"goods_id"];
        [self.navigationController pushViewController:goods animated:YES];
    }
    
    //    }
 
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

#pragma mark 分类标签点击
-(void)sortLabelviewSelectSort:(NSString *)sort isSelect:(BOOL)isSelect{
    LFLog(@"标签：%@",sort);
    if (self.selectBtn.tag == 50) {
        self.sort = sort;
    }else if(self.selectBtn.tag == 51){
        if (![sort isEqualToString:@"全部商品"]) {
            for (NSDictionary *dt in self.brandArr) {
                if ([dt[@"brand_name"] isEqualToString:sort]) {
                    self.brandDict = dt;
                }
            }
        }else{
            self.brandDict = nil;
        }

    }
    [self UploadDatagoods:-1 page:0];
    
}
-(void)sortLabelviewMoreBtnClick:(UIButton *)btn{//点击更多或收起
    LFLog(@"soreview.height:%f",soreview.height);
    headerview.frame = CGRectMake(0, 0, SCREEN.size.width, soreview.height + 50);
    [self.collectionview reloadData];
    //    [self viewDidLayoutSubviews];
}
#pragma mark 轮播图数据
-(void)rotatePicture{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary *dt = [NSMutableDictionary dictionary] ;
    if (self.category_id) {//分类id
        [dt setObject:self.category_id forKey:@"category_id"];
    }
    LFLog(@"轮播图数据dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ShopListWheelUrl) params:dt success:^(id response) {
        LFLog(@"轮播图数据:%@",response);
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            
            [self.pictureArr removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                
                [self.pictureArr addObject:dt];
                
            }
            [self createHeaderview];
            [self viewDidLayoutSubviews];
            //            [self.collectionview reloadData];
            
            
        }
        
        
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
    
}
#pragma mark - *************商品列表请求*************
-(void)UploadDatagoods:(ShopListType)ShopListType page:(NSInteger )pagenum{
    NSString *urlstr = [NSString string];
    switch (ShopListType) {
        case ShopListstoreDescUrl:{
            urlstr = SaleslistAscUrl;
        }
            break;
        case ShopListstoreAscUrl:{
            urlstr = SaleslistDescUrl;
        }
            break;
        case ShopListis_hotlistUrl:{
            //            urlstr = is_hotlistUrl;
        }
            break;
        case ShopListprice_asclistUrl:{
            urlstr = price_asclistUrl;
        }
            break;
        case ShopListprice_desclistUrl:{
            urlstr = price_desclistUrl;
        }
            break;
            
        default:
            break;
    }
    NSString *url = ShopDirectlistUrl;
    //    if (self.selectBtn.tag == 50) {
    //        urlstr = @"";
    //        url = storelistUrl;
    //    }else{
    //        url = searchUrl;
    //    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:pagination,@"pagination", nil];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    NSMutableDictionary *filter = [[NSMutableDictionary alloc]init];
    if (self.category_id) {//分类id
        [filter setObject:self.category_id forKey:@"category_id"];
    }
    //    self.keywords = self.searchbar.text;
    if (self.keywords.length) {//搜索关键词
        [filter setObject:self.keywords forKey:@"keywords"];
    }
    if (urlstr.length > 0) {
        [filter setObject:urlstr forKey:@"sort_by"];
    }
    //    LFLog(@"筛选条件：品牌：%@\n价格：%@",self.brandDict,self.priceDict);
    if (self.brandDict) {
        [filter setObject:self.brandDict[@"brand_id"] forKey:@"brand_id"];
    }
    
    if (self.priceDict) {
        NSDictionary *pDt = @{@"price_min":self.priceDict[@"price_min"],@"price_max":self.priceDict[@"price_max"]};
        [filter setObject:pDt forKey:@"price_range"];
    }
    if (self.sort) {
        [filter setObject:self.sort forKey:@"tag"];
    }
    [dt setObject:filter forKey:@"filter"];
    [self viewDidLayoutSubviews];//刷新头视图页面
    LFLog(@"商品列表dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ShopDirectlistUrl) params:dt success:^(id response) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        LFLog(@"商品列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (pagenum == 0) {
                [self.listArr removeAllObjects];
//                [self.storeArr removeAllObjects];
            }
            //            if ([url isEqualToString:ShopDirectlistUrl]) {
            for (NSDictionary *dt in response[@"data"]) {
                NSMutableDictionary *mdt = [NSMutableDictionary dictionaryWithDictionary:dt];
                [self.listArr addObject:mdt];
            }
            [self.collectionview reloadData];
            
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self reloadShopData];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
    
    
}
#pragma mark - *************筛选条件请求*************
-(void)UploadDataFilter:(NSString *)urlstr{
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.category_id,@"category_id", nil];

    if (self.category_id) {
        [dt setObject:self.category_id forKey:@"category_id"];
    }
    if (self.keywords) {
        [dt setObject:self.keywords forKey:@"keywords"];
    }
    LFLog(@"筛选条件dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,urlstr) params:dt success:^(id response) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        LFLog(@"筛选条件:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([urlstr isEqualToString:FilterBrandUrl]) {
                [self.brandArr removeAllObjects];
                [self.sortArr removeAllObjects];
                [self.sortArr addObject:@"全部商品"];
                for (NSDictionary *dt in response[@"data"]) {
                    [self.brandArr addObject:dt];
                    [self.sortArr addObject:dt[@"brand_name"]];
                }
                if (soreview == nil) {
                    soreview = [[sortLabelview alloc]initWithFrame:CGRectMake(0, self.selectBtn.frame.origin.y + 50, SCREEN.size.width, 100)];
                    
                    soreview.delegate = self;
                    [headerview addSubview:soreview];
                }
                [soreview initWithsortArray:self.sortArr currentIndex:0 sortH:40 font:14];
                [self viewDidLayoutSubviews];
            }else{
                [self.priceArr removeAllObjects];
                for (NSDictionary *dt in response[@"data"]) {
                    [self.priceArr addObject:dt];
                }
                
            }
            
        }else{
            
            
            
        }
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
    
    
}
#pragma mark - *************分类标签请求*************
-(void)UploadDataShopListSortUrl{
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.category_id,@"category_id", nil];
    LFLog(@"分类标签dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ShopListSortUrl) params:dt success:^(id response) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        LFLog(@"分类标签:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            
            [self.sortArr removeAllObjects];
            //            [self.sortArr addObject:@"全部"];
            for (NSString *dt in response[@"data"]) {
                [self.sortArr addObject:dt];
                
            }
            if (soreview == nil) {
                soreview = [[sortLabelview alloc]initWithFrame:CGRectMake(0, self.selectBtn.frame.origin.y + 50, SCREEN.size.width, 100)];
                
                soreview.delegate = self;
                [headerview addSubview:soreview];
            }
            [soreview initWithsortArray:self.sortArr currentIndex:0 sortH:40 font:14];
            [self viewDidLayoutSubviews];
            //            headerview.frame =  CGRectMake(0, 0, SCREEN.size.width, soreview.height + self.pictureArr.count ? headerHeight + 50:50);
            //            [self.collectionview reloadData];
            
        }else{
            
            
        }
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
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
            
            [self UploadSingleGoods:self.listArr[index][@"goods_id"] index:index];
            [self updateCratCount];
        }else{
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            [self.collectionview reloadData];
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
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"单个商品详情：%@",response);
        if ([str isEqualToString:@"1"]) {
            NSMutableDictionary *mdt = [NSMutableDictionary dictionaryWithDictionary:response[@"data"]];
            [self.listArr replaceObjectAtIndex:index withObject:mdt];
            [self.collectionview reloadData];
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _popview.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self updateCratCount];
}
//更新购物车数量
-(void)updateCratCount{
    
    ShoppingCartViewController *cart =[ShoppingCartViewController sharedShoppingCartViewController];
    [cart UploadDataCartList];
    [cart setBlock:^(NSArray *cartArr ,NSInteger count) {
        self.alertbtn.alertLabel.textnum = [NSString stringWithFormat:@"%lu",count];
    }];
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadShopData];
    }];
    
    _collectionview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多商品了"];
            [self.collectionview.mj_footer endRefreshing];
        }else{
            self.page ++;
            if (self.selectBtn.tag == 50) {
                [self UploadDatagoods:-1 page:self.page];
            }else if (self.selectBtn.tag == 52) {
                [self UploadDatagoods:ShopListstoreDescUrl page:self.page];
            }else if (self.selectBtn.tag == 53) {
                [self UploadDatagoods:ShopListprice_asclistUrl page:self.page];
            }else if (self.selectBtn.tag == 53) {
                
            }
        }
        
    }];
}
-(void)reloadShopData{
    
    self.page = 1;
    self.more = @"1";
    if (self.selectBtn.tag == 50) {
        [self UploadDatagoods:-1 page:0];
        [self UploadDataShopListSortUrl];
    }else if(self.selectBtn.tag == 51){
        [self UploadDatagoods:-1 page:0];
        [self UploadDataFilter:FilterBrandUrl];//品牌筛选
    }else if (self.selectBtn.tag == 52) {
        [self UploadDatagoods:ShopListstoreDescUrl page:0];
    }else if (self.selectBtn.tag == 53) {
        if (self.isRotating) {
            [self UploadDatagoods:ShopListprice_desclistUrl page:0];
        }else{
            [self UploadDatagoods:ShopListprice_asclistUrl page:0];
            
        }
        
    }
    
}
@end
