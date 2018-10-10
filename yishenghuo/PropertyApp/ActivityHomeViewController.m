//
//  ActivityHomeViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/5/3.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ActivityHomeViewController.h"
#import "JWCycleScrollView.h"
#import "DoodsDetailsViewController.h"
#import "ShopListingViewController.h"
#import "AlertsButton.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "ShoppingCartViewController.h"
#import "ShopSearchViewController.h"
#import "ShopListCollectionViewCell.h"
#import "ShopClassifyViewController.h"
#import "PeripheralBusinessViewController.h"//周边商业
#import "ShopSortListViewController.h"
#import "ShopDoodsDetailsViewController.h"//新商品详情
#import "CreditLoanViewController.h"//信用贷
#import "AttestViewController.h"//业主认证
#import "ShopSupermarketViewController.h"//超市直购
#import "IntegralShopListViewController.h"//积分商城
#import "PhoneOpenDoorViewController.h"
#import "HomeWorkViewController.h"
#import "AttestViewController.h"
#import "LoginViewController.h"
#define headerHt SCREEN.size.width * 12/25
@interface ActivityHomeViewController ()<JWCycleScrollImageDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UISearchBarDelegate,UITabBarControllerDelegate>{
    UIButton *leftBtn;
}

@property (nonatomic,strong)NSMutableArray * cateArray;
@property (nonatomic,strong)NSMutableArray * hotArray;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic,strong)UICollectionView * collectionview;
@property (nonatomic,strong)UICollectionView * menuCollectionview;
@property (nonatomic,strong)NSMutableArray *pictureArr;//存储的信息数组
@property (nonatomic, strong) JWCycleScrollView * jwView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, assign) CGFloat headerHeight;
@property(nonatomic,assign)BOOL isAppear;
@property(nonatomic,strong)UISearchBar *searchbar;//搜索
@property(nonatomic,strong)AlertsButton *alertbtn;//购物车按钮
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;

@end

@implementation ActivityHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate = self;
    // Do any additional setup after loading the view.
    self.more = @"1";
    self.navigationItem.titleView = self.titleView;
    self.page = 1;
    //    self.navigationAlpha = 0;
    LFLog(@"session:%@",[userDefaults objectForKey:@"session"]);
    [self createSearch];
    [self createBaritem];
    [self createTableview];
    [self setupRefresh];
    [self updata];
}

-(void)updata{
    
    
    [self UploadDatalatesnotice];
    [self UploadDatadynamic:1];
    [self rotatePicture];
    
}
-(void)createBaritem{
    self.alertbtn = [[AlertsButton alloc]init];
    self.alertbtn.alertLabel.textnum = @"0";
    UIImage *im =[UIImage imageNamed:@"gouwuchebaisebaise"];
    self.alertbtn.frame =CGRectMake(0, 0, im.size.width, im.size.height);
    [self.alertbtn setImage:im forState:UIControlStateNormal];
    [self.alertbtn addTarget:self action:@selector(rightCartClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.alertbtn];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    UIImage *imclass = [UIImage imageNamed:@"fenlei_shfw"];
    leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, imclass.size.width, imclass.size.height)];
    [leftBtn addTarget:self action:@selector(leftBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:imclass forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"fenlei_shfw"] forState:UIControlStateSelected];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
//分类
-(void)leftBarClick:(UIButton *)btn{
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
            
        }];
        return;
    }
    ShopClassifyViewController *cart =[[ShopClassifyViewController alloc]init];
    [self.navigationController pushViewController:cart animated:YES];
    
}
//购物车
-(void)rightCartClick:(UIButton *)btn{
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        LFLog(@"23456789");
    });
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        return;
    }
    ShoppingCartViewController *cart =[[ShoppingCartViewController alloc]init];
    [self.navigationController pushViewController:cart animated:YES];
    
}
- (NSMutableArray *)pictureArr
{
    if (!_pictureArr) {
        _pictureArr = [[NSMutableArray alloc]init];
    }
    return _pictureArr;
}

- (NSMutableArray *)cateArray
{
    if (!_cateArray) {
        _cateArray = [[NSMutableArray alloc]init];
    }
    return _cateArray;
}

- (NSMutableArray *)hotArray
{
    if (!_hotArray) {
        _hotArray = [[NSMutableArray alloc]init];
    }
    return _hotArray;
}
-(void)createSearch{
    
    self.searchbar = nil;
    self.searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width - 120, 40)];
    self.searchbar.layer.cornerRadius = 5;
    self.searchbar.layer.masksToBounds = YES;
    self.searchbar.placeholder = @"  输入关键词";
    UITextField *searchField = [self.searchbar valueForKey:@"_searchField"];
    if (searchField) {
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    }
    [self.searchbar setImage:[UIImage imageNamed:@"sousuoshangcheng"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.searchbar.delegate = self;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    [_searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"sousuokuangshangcheng"] forState:UIControlStateNormal];
    UIView *seachview = [[UIView alloc]initWithFrame:CGRectMake(60, 20, SCREEN.size.width - 120, 40)];
    [seachview addSubview:_searchbar];
    if (iOS11) {
        self.navigationItem.titleView = seachview;
    }else{
        self.navigationItem.titleView = _searchbar;
    }
    
    
    
}
//searchbar的协议方法、、
//进入编辑状态时
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        return NO;
    }
    ShopSearchViewController*search = [[ShopSearchViewController alloc]init];
    //    for (NSDictionary *dt in self.cateArray) {
    //        [search.dataArray addObject:dt];
    //    }
    [self.navigationController pushViewController:search animated:YES];
    return NO;
}
#pragma mark - --- delegate 视图委托 ---
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentInset.top + scrollView.contentOffset.y;
    //    CGFloat progress = offsetY / (self.headerHeight - 20);
    CGFloat progressChange = offsetY / (self.headerHeight - 64 - 44);
    //    NSLog(@"%s, %f, %f, %f", __FUNCTION__ ,progressChange, progress, offsetY);
    //    if (self.isAppear) {
    //        if (progressChange >= 1) {
    //            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    //            [self.navigationController setNavigationAlpha:(progressChange - 1) animated:YES];
    //            self.titleView.alpha = (progressChange - 1);
    //            if (progressChange > 1.3) {
    //                leftBtn.selected = YES;
    //                [self.alertbtn setImage:[UIImage imageNamed:@"gouwuchebaise"] forState:UIControlStateNormal];
    //            }
    //        }else {
    //            [self.alertbtn setImage:[UIImage imageNamed:@"gouwuchebaisebaise"] forState:UIControlStateNormal];
    //            leftBtn.selected = NO;
    //            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //            self.titleView.alpha = 0;
    //            [self.navigationController setNavigationAlpha:0 animated:YES];
    //
    //        }
    //    }
    
}

#pragma mark - --- getters and setters 属性 ---


- (UILabel *)titleView
{
    if (!_titleView) {
        CGFloat viewX = 0;
        CGFloat viewY = 0;
        CGFloat viewW = 0;
        CGFloat viewH = 44;
        _titleView = [[UILabel alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        _titleView.text = @"商城";
        _titleView.textColor = [UIColor whiteColor];
        [_titleView sizeToFit];
    }
    return _titleView;
}

- (CGFloat)headerHeight
{
    return SCREEN.size.width / 2;
}
-(void)createTableview{
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake((SCREEN.size.width-5)/2, (SCREEN.size.width-10)/2 * 408/370 + 10);
    //    flowLayout.minimumInteritemSpacing = 5;
    //    flowLayout.minimumLineSpacing = 1;
    //    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [flowLayout setHeaderReferenceSize:CGSizeMake(SCREEN.size.width, headerHt + 102 + 51)];
    
    //    CGFloat tabY = (kDevice_Is_iPhoneX ? -84 :-64);
    if (self.collectionview == nil) {
        self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width,SCREEN.size.height) collectionViewLayout:flowLayout];
    }
    if (iOS11) {
        self.collectionview.height = SCREEN.size.height - 50;
    }
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview setBackgroundColor:[UIColor whiteColor]];
    //注册Cell，必须要有
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"homecell"];
    
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"ShopListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"shopShopListCollectionViewCell"];//列表
    [self.view addSubview:self.collectionview];
    
    
}


-(void)cycleScrollView:(JWCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    if (cycleScrollView==_jwView)
    {
        //        NSLog(@"22222222=自动滚动到%ld页",(long)index);
    }
}


-(void)cycleScrollView:(JWCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index
{
    if (cycleScrollView==_jwView)
    {
        //判断网络状态
        if (![userDefaults objectForKey:NetworkReachability]) {
            [self presentLoadingTips:@"网络貌似掉了~~"];
        }else{
            LFLog(@"---点击了第%ld张图片", (long)index);
            NSDictionary *dt = self.pictureArr[index];
            if ([dt[@"ios"] isKindOfClass:[NSDictionary class]]) {
                UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:dt[@"ios"] controller:self];
                if (board == nil) {
                    [self presentLoadingTips:@"信息读取失败！"];
                }
                return;
            }
            if ([[NSString stringWithFormat:@"%@",dt[@"link_type"]] isEqualToString:@"cate"]) {
                ShopSortListViewController *class =[[ShopSortListViewController alloc]init];
                class.category_id = dt[@"id"];
                class.natitle = dt[@"banner_name"];
                [self.navigationController pushViewController:class animated:YES];
            }else if ([[NSString stringWithFormat:@"%@",dt[@"link_type"]] isEqualToString:@"goods"]){
                ShopDoodsDetailsViewController * goods = [[ShopDoodsDetailsViewController alloc]init];
                //            DoodsDetailsViewController *goods =[[DoodsDetailsViewController alloc]init];
                goods.goods_id = dt[@"id"];
                [self.navigationController pushViewController:goods animated:YES];
            }
        }
        
    }
}



-(void)buttonClock:(UIButton *)btn{
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        return;
    }
    LFLog(@"%@",self.cateArray[btn.tag - 100]);
    
    
    
}






#pragma mark - *************collectionView*************
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView == self.menuCollectionview) {
        return self.cateArray.count;
    }
    return 1;
}
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionview) {
        return self.hotArray.count;
    }
    NSArray *menuArr = self.cateArray[section][@"nav"];
    return menuArr.count;
    //    if (self.cateArray.count > 1) {
    //        if (section == 0) {
    //            return self.cateArray.count/2 + self.cateArray.count%2;
    //        }
    //        return self.cateArray.count/2;
    //    }else if (self.cateArray.count == 1){
    //        if (section == 0) {
    //            return 1;
    //        }
    //    }
    //    return 0;
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionview) {
        //        ShopListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shopShopListCollectionViewCell" forIndexPath:indexPath];
        //
        //        cell.contentView.backgroundImage = [UIImage imageNamed:@"shangpinditu"];
        //        NSDictionary *dt = self.hotArray[indexPath.item];
        //
        //        [cell.imagePic sd_setImageWithURL:[NSURL URLWithString:dt[@"img"][@"url"]] placeholderImage:nil];
        //
        //        cell.contentLb.text = dt[@"name"];
        //
        //
        //        cell.newpriceLb.text = dt[@"shop_price"];
        //
        //        NSMutableAttributedString *hintString =[[NSMutableAttributedString alloc]initWithString:dt[@"market_price"]];
        //
        //        NSRange range =[[hintString string]rangeOfString:dt[@"market_price"]];
        //        //        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        //        [hintString addAttribute:NSStrikethroughColorAttributeName value:JHColor(102, 102, 102) range:range];
        //        [hintString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
        //        cell.oldPrice.attributedText = hintString;
        //        [cell setBlock:^(NSString *str) {
        //            if ( NO == [UserModel online] )
        //            {
        //                [self showLogin];
        //                return;
        //            }
        //            DoodsDetailsViewController *goods =[[DoodsDetailsViewController alloc]init];
        //            goods.goods_id = self.hotArray[indexPath.item][@"id"];
        //            [goods addCart];
        //            [goods setBlock:^(NSString *str) {
        //                if (str) {
        //                    [self presentLoadingTips:str];
        //                }else{
        //                    [self presentLoadingTips:@"添加购物车成功"];
        //                    [self updateCratCount];
        //                }
        //
        //
        //            }];
        //
        //        }];
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homecell" forIndexPath:indexPath];
        NSDictionary *dt = self.hotArray[indexPath.item];
        [cell.contentView removeAllSubviews];
        UIImageView *imageview = [[UIImageView alloc]init];
        imageview.contentMode = UIViewContentModeScaleToFill;
        [imageview sd_setImageWithURL:[NSURL URLWithString:dt[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            LFLog(@"图片img_width:%f",image.size.width);
            LFLog(@"img_height:%f",image.size.height);
        }];
        [cell.contentView addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(0);
            make.bottom.offset(-10);
            make.right.offset(0);
        }];
        
        UIImageView *Bottomview = [[UIImageView alloc]init];
        Bottomview.contentMode = UIViewContentModeScaleToFill;
        Bottomview.image = [UIImage imageNamed:@"fengexiantongyong"];
        [cell.contentView addSubview:Bottomview];
        [Bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.height.offset(10);
            make.bottom.offset(0);
            make.right.offset(0);
        }];
        
        
        
        return cell;
    }else{
        
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuUICollectionViewCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor =[UIColor whiteColor];
        [cell.contentView removeAllSubviews];
        NSArray *menuArr = self.cateArray[indexPath.section][@"nav"];
        NSDictionary *dt = menuArr[indexPath.item];
        UIImageView *iconview = [[UIImageView alloc]init];
        
        [cell.contentView addSubview:iconview];
        NSString *url = [NSString string];
        if (IS_IPHONE_6_PLUS) {
            url = dt[@"imgurl3"];
        }else{
            
            url = dt[@"imgurl2"];
            
        }
        [iconview sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [iconview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(image.size.height);
            }];
        }];
        [iconview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.centerX.equalTo(cell.contentView.mas_centerX);
            
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.top.equalTo(iconview.mas_bottom);
            make.bottom.offset(0);
            
        }];
        
        label.text = dt[@"name"];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = JHColor(51, 51, 51);
        return cell;
    }
}


// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.collectionview) {
        return 0.001;
    }
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
    if (collectionView == self.collectionview) {
        NSDictionary *dt = self.hotArray[indexPath.item];
        
        if ([dt[@"ios"] isKindOfClass:[NSDictionary class]]) {
            UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:dt[@"ios"] controller:self];
            if (board == nil) {
                [self presentLoadingTips:@"信息读取失败！"];
            }
            return;
        }
        if ([[NSString stringWithFormat:@"%@",dt[@"link_type"]] isEqualToString:@"category"]) {
            ShopSortListViewController *class =[[ShopSortListViewController alloc]init];
            class.category_id = self.hotArray[indexPath.item][@"id"];
            class.natitle = self.hotArray[indexPath.item][@"name"];
            [self.navigationController pushViewController:class animated:YES];
        }else if ([[NSString stringWithFormat:@"%@",dt[@"link_type"]] isEqualToString:@"goods"]){
            ShopDoodsDetailsViewController * goods = [[ShopDoodsDetailsViewController alloc]init];
            //            DoodsDetailsViewController *goods =[[DoodsDetailsViewController alloc]init];
            goods.goods_id = self.hotArray[indexPath.item][@"id"];
            [self.navigationController pushViewController:goods animated:YES];
        }
    }else{
        
        NSArray *menuArr = self.cateArray[indexPath.section][@"nav"];
        LFLog(@"menuArr:%@",menuArr);
        if ([menuArr[indexPath.row][@"ios"] isKindOfClass:[NSDictionary class]]) {
            UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:menuArr[indexPath.row][@"ios"] controller:self];
            if (board == nil) {
                [self presentLoadingTips:@"信息读取失败！"];
            }
            return;
        }
        NSString *str = menuArr[indexPath.row][@"keyword"];
        if ([str isEqualToString:@"zbsy"]) {
            PeripheralBusinessViewController *list = [[PeripheralBusinessViewController alloc]init];
            [self.navigationController pushViewController:list animated:YES];
        }else if ([str isEqualToString:@"jrfw"]){
            LFLog(@"信用贷");
            if ([UserModel Certification]) {
                CreditLoanViewController *hot = [[CreditLoanViewController alloc]init];
                [self.navigationController pushViewController:hot animated:YES];
            }else{
                AttestViewController *att = [[AttestViewController alloc]init];
                [self.navigationController pushViewController:att animated:YES];
            }
            
            
        }else if ([str isEqualToString:@"cszg"]){
            LFLog(@"超市直购");
            
            ShopSupermarketViewController *hot = [[ShopSupermarketViewController alloc]init];
            hot.cateryId = menuArr[indexPath.item][@"category_id"];
            hot.titlename = menuArr[indexPath.item][@"name"];
            [self.navigationController pushViewController:hot animated:YES];
            
        }else if ([str isEqualToString:@"jfsc"]){
            LFLog(@"积分商城");
            //            PhoneOpenDoorViewController *goods = [[PhoneOpenDoorViewController alloc]init];
            IntegralShopListViewController * goods = [[IntegralShopListViewController alloc]init];
            [self.navigationController pushViewController:goods animated:YES];
            
        }else if ([str isEqualToString:@"runtime"]){
            LFLog(@"runtime");
            UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:self.cateArray[indexPath.row]  controller:self];
            if (board == nil) {
                [self presentLoadingTips:@"信息读取失败！"];
            }
        }else{
            ShopSortListViewController *list = [[ShopSortListViewController alloc]init];
            //            ShopListingViewController *list = [[ShopListingViewController alloc]init];
            list.category_id = menuArr[indexPath.item][@"category_id"];
            list.natitle = menuArr[indexPath.item][@"name"];
            [self.navigationController pushViewController:list animated:YES];
        }
        //        ShopSortListViewController
        
    }
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
//头视图尺寸
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (collectionView == self.collectionview) {
        CGFloat HH = 10;
        int i = 0;
        for (NSDictionary *dt in self.cateArray) {
            NSDictionary *nav_head = dt[@"nav_head"];
            if ([nav_head isKindOfClass:[NSDictionary class]] ) {
                HH += 35;
            }
            NSArray *menuArr = dt[@"nav"];
            if (menuArr.count) {
                if (i == 0) {
                    HH +=100;
                }else{
                    HH +=90;
                }
                
            }
            i ++;
        }
        return CGSizeMake(SCREEN.size.width,headerHt + HH);
        //        if (self.cateArray.count > 1) {
        //            return CGSizeMake(SCREEN.size.width, headerHt + 180 +70 + 10);
        //        }else if (self.cateArray.count == 1){
        //            return CGSizeMake(SCREEN.size.width, headerHt + 90 +70 + 10);
        //        }
        //        return CGSizeMake(SCREEN.size.width,headerHt + 70+ 10);
        //        if (self.cateArray.count == 0) {
        //            return CGSizeMake(SCREEN.size.width, headerHt );
        //        }else if (self.cateArray.count <= 3) {
        //            return CGSizeMake(SCREEN.size.width, headerHt + 90 + 10+ 10 );
        //        }else if (self.cateArray.count <= 6) {
        //            return CGSizeMake(SCREEN.size.width, headerHt + 180 +10 + 10);
        //        }
        //        return CGSizeMake(SCREEN.size.width, headerHt + 210 +10+ 10 );
    }else{
        NSDictionary *nav_head = self.cateArray[section][@"nav_head"];
        if ([nav_head isKindOfClass:[NSDictionary class]]) {
            return CGSizeMake(SCREEN.size.width, 35);
        }
        return CGSizeZero;
    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionview) {
        NSDictionary *dt = self.hotArray[indexPath.item];
        float img_width = [dt[@"img_width"] floatValue];
        float img_height = [dt[@"img_height"] floatValue];
        return CGSizeMake(SCREEN.size.width, (img_height/img_width) * SCREEN.size.width +10);
    }else{
        NSArray *menuArr = self.cateArray[indexPath.section][@"nav"];
        if (menuArr.count) {
            if (indexPath.section == 0) {
                return CGSizeMake( (SCREEN.size.width - 2)/menuArr.count, 99);
            }
            return CGSizeMake( (SCREEN.size.width - 2)/menuArr.count, 89);
        }
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
        [_jwView removeAllSubviews];
        [_jwView removeFromSuperview];
        _jwView = nil;
        _jwView=[[JWCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerHt)];
        //        _jwView.contentType = contentNewTypeImage;
        //    self.headerView.frame = CGRectMake(0, 0, SCREEN.size.width, _jwView.frame.size.height + 30);
        NSMutableArray *imagesURLStrings = [NSMutableArray array];
        
        if (self.pictureArr.count == 0) {
            imagesURLStrings = [NSMutableArray arrayWithObjects:@"banner",nil];
            _jwView.localImageArray = imagesURLStrings;
        }else{
            for (NSDictionary *dt in self.pictureArr) {
                if ([userDefaults objectForKey:HeigthQuality]) {
                    [imagesURLStrings addObject:dt[@"imgurl"]];
                }else if ([userDefaults objectForKey:HeigthQuality]){
                    [imagesURLStrings addObject:dt[@"imgurl"]];
                    
                }else{
                    [imagesURLStrings addObject:dt[@"imgurl"]];
                }
                
            }
            
            _jwView.imageURLArray=imagesURLStrings;
        }    // 图片配文字
        
        _jwView.placeHolderColor=[UIColor grayColor];
        _jwView.autoScrollTimeInterval=3.0f;
        _jwView.showPageControl=YES;
        _jwView.delegate=self;
        _jwView.pageControlAlignmentType=pageControlAlignmentTypeRight;
        _jwView.jwCycleScrollDirection=JWCycleScrollDirectionHorizontal; //横向
        
        [_jwView startAutoCarousel];
        //        UIImageView *GradientImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"daohangtiaoyinying"]];
        //        [_jwView addSubview:GradientImage];
        //        [GradientImage mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.offset(0);
        //            make.left.offset(0);
        //            make.right.offset(0);
        //        }];
        [reusableview addSubview:_jwView];
        UIView *Vf = [self.view viewWithTag:55];
        if (Vf == nil) {
            Vf = [[UIView alloc]init];
            Vf.tag = 55;
        }
        //        [self.pageControl removeFromSuperview];
        //        self.pageControl = nil;
        //        if (self.cateArray.count == 0) {
        //            Vf.frame = CGRectMake(0, headerHt,SCREEN.size.width , 0);
        //        }else if (self.cateArray.count <= 3) {
        //            Vf.frame = CGRectMake(0, headerHt,SCREEN.size.width , 90+ 10);
        //        }else if (self.cateArray.count <= 6) {
        //            Vf.frame = CGRectMake(0, headerHt,SCREEN.size.width , 180+ 10);
        //        }else{
        //            Vf.frame = CGRectMake(0, headerHt,SCREEN.size.width , 210+ 10);
        //            if (self.pageControl == nil) {
        //                self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 190, SCREEN.size.width, 30)];
        //                self.pageControl.numberOfPages = 2;
        //                self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        //                self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        //                [Vf addSubview:self.pageControl];
        //            }
        //
        //        }
        Vf.backgroundColor = [UIColor whiteColor];
        [reusableview addSubview:Vf];
        [Vf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.top.offset(headerHt);
            make.bottom.offset(-10);
        }];
        
        if (self.menuCollectionview == nil) {
            UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
            flowLayout.itemSize = CGSizeMake((SCREEN.size.width-2)/4, 90);
            //            flowLayout.minimumInteritemSpacing = 10;
            //            flowLayout.minimumLineSpacing = 1;
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            self.menuCollectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, SCREEN.size.width,90) collectionViewLayout:flowLayout];
            self.menuCollectionview.backgroundColor = [UIColor whiteColor];
            //        self.menuCollectionview.backgroundColor = JHColor(222, 222, 222);
            self.menuCollectionview.dataSource=self;
            self.menuCollectionview.delegate=self;
            //           [self.collectionview setBackgroundColor:[UIColor clearColor]];
            [self.menuCollectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MenuHeaderReuse"];
            //注册Cell，必须要有
            [self.menuCollectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"menuUICollectionViewCell"];
            self.menuCollectionview.contentSize = CGSizeMake(SCREEN.size.width *2, 0);
        }
        //        self.menuCollectionview.frame = CGRectMake(0, 0, SCREEN.size.width,Vf.height );
        [Vf addSubview:self.menuCollectionview];
        [self.menuCollectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.top.offset(0);
            make.bottom.offset(0);
        }];
        
        //        UIImageView *headerimage = [[UIImageView alloc]init];
        //        headerimage.image = [UIImage imageNamed:@"tiantiantejia"];
        //        headerimage.contentMode = UIViewContentModeScaleAspectFit;
        //        headerimage.backgroundColor = [UIColor whiteColor];
        //        [reusableview addSubview:headerimage];
        //        [headerimage mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(Vf.mas_bottom).offset(0);
        //            make.left.offset(0);
        //            make.right.offset(0);
        //            make.bottom.offset(0);
        //        }];
        reusableview.backgroundColor = JHbgColor;
        return reusableview;
    }else{
        UICollectionReusableView *Menureusableview = nil;
        NSLog(@"kind = %@", kind);
        if (kind == UICollectionElementKindSectionHeader){
            UIView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MenuHeaderReuse" forIndexPath:indexPath];
            Menureusableview = (UICollectionReusableView *)headerV;
        }
        [Menureusableview removeAllSubviews];
        
        NSDictionary *nav_head = self.cateArray[indexPath.section][@"nav_head"];
        if ([nav_head isKindOfClass:[NSDictionary class]]) {
            UIImageView *headerimage = [[UIImageView alloc]init];
            NSString *url = [NSString string];
            if (IS_IPHONE_6_PLUS) {
                url = nav_head[@"imgurl3"];
            }else{
                url = nav_head[@"imgurl2"];
            }
            [headerimage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
            headerimage.contentMode = UIViewContentModeScaleAspectFit;
            headerimage.backgroundColor = [UIColor whiteColor];
            [Menureusableview addSubview:headerimage];
            [headerimage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.left.offset(0);
                make.right.offset(0);
                make.bottom.offset(0);
            }];
        }
        
        return Menureusableview;
    }
    
}
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    if (scrollView == self.menuCollectionview) {
//        CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
//        targetContentOffset->x = targetOffset.x;
//        targetContentOffset->y = targetOffset.y;
//    }
//
//}
- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    //    LFLog(@"偏移量：%f",offset.x);
    if (offset.x >0) {
        self.pageControl.currentPage = 1;
        return CGPointMake(SCREEN.size.width, 0);
    }else{
        self.pageControl.currentPage = 0;
        return CGPointMake(0, 0);
    }
    //    CGFloat pageSize = BUBBLE_DIAMETER + BUBBLE_PADDING;
    //    NSInteger page = roundf(offset.x / pageSize);
    //    CGFloat targetX = pageSize * page;
    
}
#pragma mark 轮播图数据
-(void)rotatePicture{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,wheelUrl) params:dt success:^(id response) {
        LFLog(@"轮播图数据:%@",response);
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.pictureArr removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                [self.pictureArr addObject:dt];
            }
            [self.collectionview reloadData];
            
        }
        
        
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
    
}


#pragma mark - *************分类请求*************
-(void)UploadDatalatesnotice{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,navNewUrl) params:dt success:^(id response) {
        LFLog(@"分类请求：%@",response);
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.cateArray removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                [self.cateArray addObject:dt];
            }
            [self.collectionview reloadData];
            [self.menuCollectionview reloadData];
            //                [self createUI];
        }
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
    
    
}
#pragma mark - *************热门请求*************
-(void)UploadDatadynamic:(NSInteger )pagenum{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    //    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    //    NSDictionary *pagination = @{@"count":@"5",@"page":page};
    //    [dt setObject:pagination forKey:@"pagination"];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ShopAdsUrl) params:dt success:^(id response) {
        LFLog(@"热门请求:%@",response);
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (pagenum == 1) {
                [self.hotArray removeAllObjects];
            }
            for (NSDictionary *dt in response[@"data"]) {
                [self.hotArray addObject:dt];
            }
            [self.collectionview reloadData];
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
        }else{
            
            
            
        }
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
    
    
}

//-(CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset{
//
//
//}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self updata];
    }];
    //    _collectionview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //        if ([self.more isEqualToString:@"0"]) {
    //            [self presentLoadingTips:@"没有更多商品了"];
    //            [self.collectionview.mj_footer endRefreshing];
    //        }else{
    //            self.page ++;
    //            [self UploadDatadynamic:self.page];
    //        }
    //
    //    }];
    
    
}
#pragma mark tabbar点击
-(void)tabbarDoubleClick:(BOOL)isDouble{
    if (isDouble) {//双击
    }
    [_collectionview.mj_header beginRefreshing];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showTabbar];
    [self updateCratCount];
    if (@available(iOS 11.0, *)) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(0.2, dispatch_get_main_queue(), ^{
            [weakSelf scrollViewDidScroll:weakSelf.collectionview];
        });
    } else {
        [self scrollViewDidScroll:self.collectionview];
    }
}

//更新购物车数量
-(void)updateCratCount{
    
    ShoppingCartViewController *cart =[ShoppingCartViewController sharedShoppingCartViewController];
    [cart UploadDataCartList];
    [cart setBlock:^(NSArray *cartArr ,NSInteger count) {
        self.alertbtn.alertLabel.textnum = [NSString stringWithFormat:@"%lu",count];
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self hideTabbar];
    [self.navigationController setNavigationAlpha:1.0 animated:YES];
    
    //    [self.navigationController.navigationBar st_reset];
    //    self.titleviewalph = self.titleView.alpha;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //    self.titleView.alpha = self.titleviewalph;
    //    [self.navigationController setNavigationColor:JHMaincolor animated:YES];
    self.isAppear = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationAlpha:1.0 animated:YES];
    //    [self.navigationController setNavigationColor:self.navigationColor animated:NO];
    //        [self.navigationController.navigationBar st_reset];
    self.isAppear = NO;
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UINavigationController *na = (UINavigationController *)viewController;
    LFLog(@"viewController:%@",[na.topViewController class]);
    UIViewController *vc =((UINavigationController *)tabBarController.selectedViewController).topViewController;
    LFLog(@"selectedViewController:%@",[vc class]);
    if ([na.topViewController isKindOfClass:[HomeWorkViewController class]]) {
        if ( NO == [UserModel online] )
        {
            LoginViewController *login = [[LoginViewController alloc]init];
            [vc.navigationController pushViewController:login animated:YES];
            return NO;
        }
        //        if (![UserModel Certification]) {
        //            AttestViewController *att = [[AttestViewController alloc]init];
        //            [vc.navigationController pushViewController:att animated:YES];
        //            return NO;
        //        }
    }
    return YES;
}
@end
