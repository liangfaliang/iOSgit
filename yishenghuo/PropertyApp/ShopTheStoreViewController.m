//
//  ShopTheStoreViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/16.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ShopTheStoreViewController.h"
#import "DoodsDetailsViewController.h"
#import "ShopDoodsDetailsViewController.h"
#import "ShopDoodsDetailsViewController.h"
#import "LFLUibutton.h"
#import "AlertsButton.h"
#import "ShoppingCartViewController.h"
#import "ShopListCollectionViewCell.h"
#import "ShopListingViewController.h"
#define headerHeight SCREEN.size.width * 8/15
@interface ShopTheStoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UIView *popShopview;//店铺选择类型
    
}
@property(nonatomic,strong)UICollectionView *collectionview;

@property(nonatomic,strong)UIButton * selectBtn;
@property(nonatomic,strong)NSArray * btnNameArr;
@property(nonatomic,assign)BOOL isRotating;//图片旋转
@property(nonatomic,strong)UIView *header;//弹出层视图
@property(nonatomic,strong)NSMutableArray * screenArr;//筛选
@property(nonatomic,strong)AlertsButton *alertbtn;//购物车按钮
@property(nonatomic,strong)NSDictionary * storeInfoDict;//筛选
@end

@implementation ShopTheStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isRotating = YES;//默认第一次旋转
    self.btnNameArr = @[@"全部 ",@"销量 ",@"价格 ",@"人气 "];
    [self createBaritem];
    [self createTableview];
    [self createHeaderview];
    [self setupRefresh];
    [self UploadDataStoreInfo];
    [self UploadDatagoods:ShopListis_hotlistUrl page:0];
    
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
-(void)createBaritem{
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
        return ;
    }
    ShoppingCartViewController *cart =[[ShoppingCartViewController alloc]init];
    [self.navigationController pushViewController:cart animated:YES];
    
}
-(void)createHeaderview{
    self.header = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, 175)];
    self.header.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.header];
    
    UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 125, SCREEN.size.width, 50)];
    headerview.backgroundColor = [UIColor whiteColor];
    [self.header addSubview:headerview];
    for (int i = 0; i < 4; i ++) {
        LFLUibutton *button = [[LFLUibutton alloc]initWithFrame:CGRectMake(i * SCREEN.size.width/4, 0, SCREEN.size.width/4, 50)];
        button.Ratio = 0.7;
        [button.imageView setContentMode:UIViewContentModeCenter];
        [button.titleLabel setTextAlignment:NSTextAlignmentRight];
        [button setTitle:self.btnNameArr[i] forState:UIControlStateNormal];
        
        [button setTitleColor:JHColor(102, 102, 102) forState:UIControlStateNormal];
        [button setTitleColor:JHAssistColor forState:UIControlStateSelected];
        //        [button setAttributedTitle:[self AttributedString:self.btnNameArr[i] image:[UIImage imageNamed:@"shangjiantoumoren"] UIcolor:JHColor(51, 51, 51)] forState:UIControlStateNormal];
        //        [button setAttributedTitle:[self AttributedString:self.btnNameArr[i] image:[UIImage imageNamed:@"shangjiantouhongse"] UIcolor:[UIColor redColor]] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(listClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 50 + i;
        if (i == 0) {
            button.selected = YES;
            self.selectBtn = button;
        }else{
       
                [button setImage:[UIImage imageNamed:@"shangjiantoumoren"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"shangjiantouhongse"] forState:UIControlStateSelected];
            
            
            
        }
        
        [headerview addSubview:button];
        
    }
    
    
}
-(void)createHeaderImage{
    self.navigationBarTitle = self.storeInfoDict[@"suppliers_name"];
    UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 125)];
    [imageview sd_setImageWithURL:[NSURL URLWithString:self.storeInfoDict[@"suppliers_bg"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    UIView *blackView = [[UIView alloc]initWithFrame:imageview.frame];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [imageview addSubview:blackView];
    UIImageView *imView = [[UIImageView alloc]init];
    [imView sd_setImageWithURL:[NSURL URLWithString:self.storeInfoDict[@"suppliers_logo"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    [imageview addSubview:imView];
    [imView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(-15);
        make.width.offset(60);
        make.height.offset(60);
    }];
    UILabel *conLb = [[UILabel alloc]init];
    conLb.textColor = [UIColor whiteColor];
    conLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    conLb.text = self.storeInfoDict[@"suppliers_name"];
    [imageview addSubview:conLb];
    [conLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imView.mas_centerY);
        make.left.equalTo(imView.mas_right).offset(14);
    }];

    UIImageView *googImview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dianpushangpinshu"]];
    [imageview addSubview:googImview];
    [googImview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.bottom.offset(-15);
        make.height.offset(33);
        make.width.offset(55);
    }];
    NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n商品数",self.storeInfoDict[@"goods_count"]]];
    NSString *str = self.storeInfoDict[@"goods_count"];
    NSRange range =[[htinstr string]rangeOfString:str];
    [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
    UILabel *goodsLb = [[UILabel alloc]init];
//    goodsLb.backgroundImage = [UIImage imageNamed:@"weizhangchaxunanniu"];
    goodsLb.layer.contents = (id)[UIImage imageNamed:@"dianpushangpinshu"].CGImage;
//    goodsLb.backgroundColor = [UIColor redColor];
    goodsLb.textColor = [UIColor whiteColor];
    goodsLb.font = [UIFont systemFontOfSize:12];
    goodsLb.attributedText = htinstr;
    goodsLb.numberOfLines = 0;
    goodsLb.textAlignment = NSTextAlignmentCenter;
    [googImview addSubview:goodsLb];
    [goodsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.bottom.offset(0);
        make.top.offset(0);
        make.left.offset(0);
    }];
    
    [self.header addSubview:imageview];
    
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
    if (self.selectBtn.tag == btn.tag) {
        self.selectBtn.selected = YES;
        if (btn.tag == 51 || btn.tag == 52) {
            if (self.isRotating) {
                if (btn.tag == 51) {
                    [self UploadDatagoods:ShopListstoreDescUrl page:0];
                }else{
                 [self UploadDatagoods:ShopListprice_desclistUrl page:0];
                }
                btn.imageView.layer.transform = CATransform3DMakeRotation(M_PI , 0, 0, 1);
                self.isRotating = NO;
            }else{
                if (btn.tag == 51) {
                    [self UploadDatagoods:ShopListstoreAscUrl page:0];
                }else{
                    [self UploadDatagoods:ShopListprice_asclistUrl page:0];
                }
                btn.imageView.layer.transform = CATransform3DMakeRotation(0 , 0, 0, 1);
                self.isRotating = YES;
            }
        }else if (btn.tag == 50){
                 [self UploadDatagoods:ShopListis_hotlistUrl page:0];
        }else if (btn.tag == 53){
                 [self UploadDatagoods:ShopListis_hotlistUrl page:0];
        }
        
    }else{
        self.isRotating = YES;
        self.selectBtn.imageView.layer.transform = CATransform3DMakeRotation(0 , 0, 0, 1);
        self.selectBtn.selected = NO;
        self.selectBtn = btn;
        btn.selected = YES;
                 if (btn.tag == 50) {
                     [self UploadDatagoods:ShopListis_hotlistUrl page:0];
                }else if (btn.tag == 51) {
                    [self UploadDatagoods:ShopListstoreAscUrl page:0];
                }else if (btn.tag == 52){
                    [self UploadDatagoods:ShopListprice_asclistUrl page:0];
                }else if (btn.tag == 53){
                    [self UploadDatagoods:ShopListis_hotlistUrl page:0];
                }
    }

    
    
    //    if (btn.tag == 50) {
    //        popShopview.hidden = NO;
    //    }else{
    //        popShopview.hidden = YES;
    //    }
    //    self.collectionview.mj_header.
    //    [self.collectionview reloadData];

    
    
    //    if (btn.selected) {
    //        btn.selected = NO;
    //    }else{
    //        btn.selected = YES;
    //
    //    }
}

-(void)createTableview{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((SCREEN.size.width-5)/2, (SCREEN.size.width-10)/2 * 408/370 + 10);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //    [flowLayout setHeaderReferenceSize:CGSizeMake(SCREEN.size.width, headerHeight + 160 + 51)];
    
    if (self.collectionview == nil) {
        self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 175, SCREEN.size.width,SCREEN.size.height) collectionViewLayout:flowLayout];
    }
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview setBackgroundColor:JHColor(241, 241, 241)];
    //注册Cell，必须要有
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"ShopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShopCollectionViewCell"];//店铺
    [self.collectionview registerNib:[UINib nibWithNibName:@"ShopListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShopListCollectionViewCell"];//列表
    [self.view addSubview:self.collectionview];
    
    
}

#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.listArr.count;
    
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

        
        ShopListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopListCollectionViewCell" forIndexPath:indexPath];
        
        cell.contentView.backgroundImage = [UIImage imageNamed:@"shangpinditu"];
        NSDictionary *dt = self.listArr[indexPath.item];
        
        [cell.imagePic sd_setImageWithURL:[NSURL URLWithString:dt[@"img"][@"url"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        
        cell.contentLb.text = dt[@"name"];
        
        
        cell.newpriceLb.text = dt[@"shop_price"];
        
        NSMutableAttributedString *hintString =[[NSMutableAttributedString alloc]initWithString:dt[@"market_price"]];
        
        NSRange range =[[hintString string]rangeOfString:dt[@"market_price"]];
        //        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        [hintString addAttribute:NSStrikethroughColorAttributeName value:JHColor(102, 102, 102) range:range];
        [hintString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
        cell.oldPrice.attributedText = hintString;
        [cell setBlock:^(NSString *str) {
            if ( NO == [UserModel online] )
            {
                [self showLogin:^(id response) {
                }];
                return;
            }
            DoodsDetailsViewController *goods =[[DoodsDetailsViewController alloc]init];
            goods.goods_id = self.listArr[indexPath.item][@"goods_id"];
            [goods addCart];
            [goods setBlock:^(NSString *str) {
                if (str) {
                    [self presentLoadingTips:str];
                }else{
                    [self presentLoadingTips:@"添加购物车成功"];
                    [self updateCratCount];
                }
                
                
            }];
            
        }];
        
        
        
        return cell;
        
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake((SCREEN.size.width-5)/2, (SCREEN.size.width-10)/2 * 408/370 + 10);
}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        return;
    }
    ShopDoodsDetailsViewController *goods =[[ShopDoodsDetailsViewController alloc]init];
    goods.goods_id = self.listArr[indexPath.item][@"goods_id"];
    [self.navigationController pushViewController:goods animated:YES];
    
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
#pragma mark - *************商品列表请求*************
-(void)UploadDataStoreInfo{

    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.suppliers_id,@"suppliers_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }

    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,storeInfoUrl) params:dt success:^(id response) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
                LFLog(@"店铺详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            self.storeInfoDict = response[@"data"];
            [self createHeaderImage];
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDataStoreInfo];
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
#pragma mark - *************商品列表请求*************
-(void)UploadDatagoods:(ShopListType)ShopListType page:(NSInteger )pagenum{
    NSString *urlstr = [NSString string];
    switch (ShopListType) {
        case ShopListstoreDescUrl:{
            urlstr = storeGoodsSaleDescUrl;
        }
            break;
        case ShopListstoreAscUrl:{
            urlstr = storeGoodsSaleAscUrl;
        }
            break;
        case ShopListis_hotlistUrl:{
            urlstr = @"";
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

    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"5",@"page":page};
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:pagination,@"pagination", nil];
    NSMutableDictionary *filter = [[NSMutableDictionary alloc]init];
    if (self.suppliers_id) {
        [dt setObject:self.suppliers_id forKey:@"suppliers_id"];
    }
    if (urlstr.length > 0) {
        [filter setObject:urlstr forKey:@"sort_by"];
    }
    if (filter.count) {
        [dt setObject:filter forKey:@"filter"];
    }
    LFLog(@"dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,storeGoodsUrl) params:dt success:^(id response) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        LFLog(@"商品列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (pagenum == 0) {
                [self.listArr removeAllObjects];
               
            }
            
            for (NSDictionary *dt in response[@"data"]) {
                [self.listArr addObject:dt];
            }
          
            [self.collectionview reloadData];
            
        }else{
            
            
            
        }
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    popShopview.hidden = YES;
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
        //        [self updata];
        [self UploadDatagoods:ShopListis_hotlistUrl page:0];
    }];
    
    _collectionview.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        if (self.selectBtn.tag == 50) {
            
        }else if (self.selectBtn.tag == 51) {
            
        }else if (self.selectBtn.tag == 52) {
            
        }else if (self.selectBtn.tag == 53) {
            
        }else if (self.selectBtn.tag == 54) {
            
        }
        
    }];
}
@end

