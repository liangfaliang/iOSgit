//
//  ShopListingViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/28.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ShopListingViewController.h"
#import "ShopDoodsDetailsViewController.h"
#import "DoodsDetailsViewController.h"
#import "LFLUibutton.h"
#import "AlertsButton.h"
#import "ShoppingCartViewController.h"
#import "ShopCollectionViewCell.h"
#import "ShopListCollectionViewCell.h"
#import "ShopTheStoreViewController.h"
#import "UIButton+WebCache.h"
#import "sortLabelview.h"
//#import "uibu"
#define headerHeight SCREEN.size.width * 8/15

@interface ShopListingViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UIView *popShopview;//店铺选择类型
    
}
@property(nonatomic,strong)UICollectionView *collectionview;

@property(nonatomic,strong)UIButton * selectBtn;
@property(nonatomic,strong)NSArray * btnNameArr;
@property(nonatomic,assign)BOOL isRotating;//图片旋转
@property(nonatomic,strong)UIView *popview;//弹出层视图
@property(nonatomic,strong)NSMutableArray * screenArr;//筛选
@property(nonatomic,strong)AlertsButton *alertbtn;//购物车按钮

@property(nonatomic,strong)NSMutableArray * storeArr;//店铺
@property(nonatomic,strong)UILabel *priceLb;//店铺商品价格
@property(nonatomic,strong)NSMutableArray * brandArr;//筛选品牌
@property(nonatomic,strong)NSMutableArray * priceArr;//筛选价格
@property(nonatomic,strong)NSDictionary * brandDict;//存储品牌
@property(nonatomic,strong)NSDictionary * priceDict;//存储价格
@property(nonatomic,strong)NSMutableArray * sortArr;//分类标签
@property(nonatomic,assign)NSInteger page;//存储价格
@property(nonatomic,strong)NSString *more;//是否加载更多
@end

@implementation ShopListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = self.natitle;
    self.isRotating = YES;//默认第一次旋转
    self.btnNameArr = @[@"店铺 ",@"销量 ",@"价格 ",@"筛选 "];
    self.page = 1;
    self.more = @"1";
    [self createBaritem];
    [self createTableview];
    [self createHeaderview];
    if (!self.listArr.count) {
        [self UploadDatagoods:ShopListprice_asclistUrl page:0];
        [self setupRefresh];
    }
//    [self UploadDataShopListSortUrl];
    [self UploadDataFilter:FilterBrandUrl];
    [self UploadDataFilter:FilterPriceUrl];
    
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
    UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, 50)];
    headerview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerview];
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
//            button.selected = YES;
//            self.selectBtn = button;
        }else{
            if (i == 2) {
                button.selected = YES;
                self.selectBtn = button;
            }
            if (i == 3) {
                
                [button setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"shaixuanxuanzhong"] forState:UIControlStateSelected];
            }else{
                [button setImage:[UIImage imageNamed:@"shangjiantoumoren"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"shangjiantouhongse"] forState:UIControlStateSelected];
            }

        
        }
        
        [headerview addSubview:button];
   
    }

    
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
    self.more = @"1";
    if (btn.tag == 53) {
        [self PopUplayer];
        return;
    }
    if (!_popview.hidden) {
        _popview.hidden = YES;
    }
    if (self.selectBtn.tag == btn.tag) {
        self.selectBtn.selected = YES;
        if (btn.tag == 52) {
            if (self.isRotating) {
                [self UploadDatagoods:ShopListprice_desclistUrl page:0];
                btn.imageView.layer.transform = CATransform3DMakeRotation(M_PI , 0, 0, 1);
                self.isRotating = NO;
            }else{
                [self UploadDatagoods:ShopListprice_asclistUrl page:0];
                btn.imageView.layer.transform = CATransform3DMakeRotation(0 , 0, 0, 1);
                self.isRotating = YES;
            }
        }else if (btn.tag == 51){
        [self UploadDatagoods:ShopListstoreDescUrl page:0];
        }else if (btn.tag == 50){
            [self UploadDatagoods:ShopListstoreDescUrl page:0];
        }

    }else{
        self.isRotating = YES;
        self.selectBtn.imageView.layer.transform = CATransform3DMakeRotation(0 , 0, 0, 1);
        self.selectBtn.selected = NO;
        self.selectBtn = btn;
        btn.selected = YES;
        if (btn.tag == 50) {
            [self UploadDatagoods:ShopListstoreDescUrl page:0];
        }else if (btn.tag == 51){
            [self UploadDatagoods:ShopListstoreDescUrl page:0];
        }else if (btn.tag == 52){
            [self UploadDatagoods:ShopListprice_asclistUrl page:0];
        }
    }
   self.page = 1;
    

}
#pragma mark 选择店铺类型
-(void)popupShopbutton:(UIButton *)btn{
    if (!btn.selected) {
        btn.selected = YES;
    }
    for (int i = 0 ; i < 2; i ++) {
        UIButton *button = [self.view viewWithTag:80 + i];
        if (btn.tag != button.tag) {
            if (btn.selected) {
                button.selected = NO;
            }else{
                button.selected = YES;
            }
        }

    }

    popShopview.hidden = YES;
}
-(void)createTableview{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((SCREEN.size.width-5)/2, (SCREEN.size.width-10)/2 * 25/21 + 80);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    [flowLayout setHeaderReferenceSize:CGSizeMake(SCREEN.size.width, headerHeight + 160 + 51)];
    
    if (self.collectionview == nil) {
        self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, SCREEN.size.width,SCREEN.size.height - 50) collectionViewLayout:flowLayout];
    }
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview setBackgroundColor:JHbgColor];
    //注册Cell，必须要有
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"confirmCell"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"ShopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShopCollectionViewCell"];//店铺
     [self.collectionview registerNib:[UINib nibWithNibName:@"ShopListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShopListCollectionViewCell"];//列表
    [self.view addSubview:self.collectionview];
    
    
}

#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.storeArr.count) {
        if (self.selectBtn.tag == 50) {
            return self.storeArr.count;
        }
    }
    
    if (self.listArr.count) {
        return self.listArr.count;
    }
    return 1;
    
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBtn.tag == 50) {
        if (self.storeArr.count) {
        ShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopCollectionViewCell" forIndexPath:indexPath];
            
        [cell setBlock:^(NSString *str) {//进店
            ShopTheStoreViewController *store = [[ShopTheStoreViewController alloc]init];
            store.suppliers_id = self.storeArr[indexPath.item][@"suppliers_id"];
            [self.navigationController pushViewController:store animated:YES];
        }];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:self.storeArr[indexPath.item][@"suppliers_logo"]] placeholderImage:[UIImage imageNamed:@""]];
        cell.shopName.text = self.storeArr[indexPath.item][@"suppliers_name"];
        cell.shopDescLb.text = [NSString stringWithFormat:@"销量%@ 共%@件宝贝",self.storeArr[indexPath.item][@"sale_count"],self.storeArr[indexPath.item][@"goods_count"]];
        NSArray *goodlistArr = self.storeArr[indexPath.item][@"goods_list"];
            cell.button1.hidden = YES;
            cell.button2.hidden = YES;
            cell.button3.hidden = YES;
            cell.label1.hidden = YES;
            cell.label2.hidden = YES;
            cell.label3.hidden = YES;
            for (int i = 0; i < (goodlistArr.count <= 3 ? goodlistArr.count : 3 ); i ++) {
                
                if (i == 0) {
                    
                    [cell.button1 sd_setBackgroundImageWithURL:[NSURL URLWithString:goodlistArr[i][@"img"][@"url"]] forState:UIControlStateNormal];
                    
                    cell.label1.text = goodlistArr[i][@"shop_price"];
                    cell.button1.hidden = NO;
                    cell.label1.hidden = NO;
                }else if (i == 1) {
                    //                [cell.button2 removeAllSubviews];
                    [cell.button2 sd_setBackgroundImageWithURL:[NSURL URLWithString:goodlistArr[i][@"img"][@"url"]] forState:UIControlStateNormal];
                    
                    cell.label2.text = goodlistArr[i][@"shop_price"];
                    cell.button2.hidden = NO;
                    cell.label2.hidden = NO;
                }else if (i == 2) {
                    //                [cell.button3 removeAllSubviews];
                    [cell.button3 sd_setBackgroundImageWithURL:[NSURL URLWithString:goodlistArr[i][@"img"][@"url"]] forState:UIControlStateNormal];
                    
                    cell.label3.text = goodlistArr[i][@"shop_price"];
                    cell.button3.hidden = NO;
                    cell.label3.hidden = NO;
                }
                
            }

        [cell setShopblock:^(NSInteger index) {
            ShopDoodsDetailsViewController *goods =[[ShopDoodsDetailsViewController alloc]init];
            goods.goods_id = goodlistArr[index][@"goods_id"];
            [self.navigationController pushViewController:goods animated:YES];
        }];
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
    }else{
        if (self.listArr.count) {
    ShopListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopListCollectionViewCell" forIndexPath:indexPath];

    cell.contentView.backgroundImage = [UIImage imageNamed:@"shangpinditu"];
    NSDictionary *dt = self.listArr[indexPath.item];

    [cell.imagePic sd_setImageWithURL:[NSURL URLWithString:dt[@"img"][@"url"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];

    cell.contentLb.text = dt[@"name"];

    cell.newpriceLb.text = dt[@"shop_price"];
    cell.PriceWidth.constant = [cell.newpriceLb.text selfadap:16 weith:SCREEN.size.width - 100].width + 5;
    NSMutableAttributedString *hintString =[[NSMutableAttributedString alloc]initWithString:dt[@"market_price"]];
    
    NSRange range =[[hintString string]rangeOfString:dt[@"market_price"]];
    //        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
    [hintString addAttribute:NSStrikethroughColorAttributeName value:JHColor(102, 102, 102) range:range];
    [hintString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
    cell.oldPrice.text = [NSString stringWithFormat:@"市场价:%@",dt[@"market_price"]];
    cell.oldPrice.adjustsFontSizeToFitWidth = YES;
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

    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.storeArr.count) {
        if (self.selectBtn.tag == 50) {
            return CGSizeMake(SCREEN.size.width, 200);
        }
    }
    if (self.listArr.count) {
        
        return CGSizeMake((SCREEN.size.width-5)/2, (SCREEN.size.width-10)/2 * 25/21 + 80);
        
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        
        return;
    }
    if (self.selectBtn.tag != 50) {
        if (self.listArr.count) {
            ShopDoodsDetailsViewController *goods =[[ShopDoodsDetailsViewController alloc]init];
            goods.goods_id = self.listArr[indexPath.item][@"goods_id"];
            [self.navigationController pushViewController:goods animated:YES];
        }

    }

    
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
-(void)PopUplayer{
//    if (self.screenArr.count) {
        if (_popview == nil) {
            
            _popview = [[UIView alloc]initWithFrame:CGRectMake(0, 114, SCREEN.size.width, SCREEN.size.height - 114)];
            _popview.tag = 222;
            //    popview.alpha = 0.5;
            _popview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            [[UIApplication sharedApplication].keyWindow addSubview:_popview];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [_popview addGestureRecognizer:tap];
            UIScrollView *backview = [[UIScrollView alloc]initWithFrame:CGRectMake(SCREEN.size.width/2, 0, SCREEN.size.width/2, SCREEN.size.height - 150)];
            backview.scrollEnabled = YES;
            backview.backgroundColor = JHColor(255, 255, 255);
            [_popview addSubview:backview];
            NSArray *seleArr = @[@"重置",@"确定"];
            for (int i = 0; i < 2; i++) {
                CGFloat right = 0;

                UIButton *selecBtn = [[UIButton alloc]init];
                [selecBtn setTitle:seleArr[i] forState:UIControlStateNormal];
                if (i == 0) {
                    right = backview.width/2;
                    selecBtn.backgroundColor = [UIColor whiteColor];
                    [selecBtn setTitleColor:JHColor(51, 51, 51) forState:UIControlStateNormal];
                }else{
                    [selecBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    selecBtn.backgroundColor = [UIColor redColor];
                }
                selecBtn.tag = 77 + i;
                selecBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [selecBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_popview addSubview:selecBtn];
                [selecBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.offset(0);
                    make.top.equalTo(backview.mas_bottom).offset(0);
                    make.width.offset(backview.width/2);
                    make.right.offset(-right);
                }];
            }
    
//            NSArray *arr = self.screenArr[0][@"specification"];
                NSArray *arr = [NSArray array];
            if (self.brandArr.count && self.priceArr.count) {
                arr = @[@"品牌",@"价格"];
            }else if (self.brandArr.count){
                arr = @[@"品牌"];
            }else if (self.priceArr.count){
                arr = @[@"价格"];
            }
            CGFloat btnid = 0;
            CGFloat viewH = 20;
            for (int j = 0; j < arr.count; j ++) {
                UIButton *selectview = [[UIButton alloc]init];
                [backview addSubview:selectview];
                UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN.size.width/2 - 40, 25)];
//                if ([arr[j][@"attr_type"] isEqualToString:@"2"]) {
//                    namelabel.text = [NSString stringWithFormat:@"%@（多选）",arr[j][@"name"]];
//                    
//                }else{
//                    namelabel.text = [NSString stringWithFormat:@"%@（单选）",arr[j][@"name"]];
//                }
                        namelabel.text = arr[j];
                
                namelabel.textColor = JHColor(102, 102, 102);
                namelabel.font = [UIFont systemFontOfSize:15];
                [selectview addSubview:namelabel];
//                NSArray *valuearr = arr[j][@"value"];
                NSArray *valuearr = [NSArray array];
                if (self.brandArr.count && self.priceArr.count) {
                    if (j == 0) {
                        valuearr = self.brandArr;
                    }else if (j == 1){
                        valuearr = self.priceArr;
                    }
                }else if (self.brandArr.count){
                    valuearr = self.brandArr;
                }else if (self.priceArr.count){
                    valuearr = self.priceArr;
                }

                CGFloat wieth = 0;
                CGFloat heigth = 25;
                CGFloat totalwieth = 0;
                int count = 0;
                for (int i = 0; i < valuearr.count; i++) {
                    
                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
                    NSString *str =[NSString string];
                    if (self.brandArr.count && self.priceArr.count) {
                        if (j == 0) {
                            str = [NSString stringWithFormat:@"%@",valuearr[i][@"brand_name"]];
                        }else if (j == 1){
                            str = [NSString stringWithFormat:@"%@-%@",valuearr[i][@"price_min"],self.priceArr[i][@"price_max"]];
                        }
                    }else if (self.brandArr.count){
                        str = [NSString stringWithFormat:@"%@",valuearr[i][@"brand_name"]];
                    }else if (self.priceArr.count){
                        str = [NSString stringWithFormat:@"%@-%@",valuearr[i][@"price_min"],self.priceArr[i][@"price_max"]];
                    }
  
                
                    [button setTitle:str forState:UIControlStateNormal];
                    CGSize size = [str selfadap:12 weith:30];
                    button.titleLabel.font = [UIFont systemFontOfSize:12];
                    button.frame = CGRectMake(15 + count* 15 + wieth, heigth, size.width + 10, 21);
                    NSString *str1 = [[NSString alloc]init];
                    
                    if (i == valuearr.count-1) {
                        
                    }else{
                        
                        if (self.brandArr.count && self.priceArr.count) {
                            if (j == 0) {
                                str1 = [NSString stringWithFormat:@"%@",valuearr[i+1][@"brand_name"]];
                            }else if (j == 1){
                                str1 = [NSString stringWithFormat:@"%@-%@",valuearr[i+1][@"price_min"],self.priceArr[i][@"price_max"]];
                            }
                        }else if (self.brandArr.count){
                            str1 = [NSString stringWithFormat:@"%@",valuearr[i+1][@"brand_name"]];
                        }else if (self.priceArr.count){
                            str1 = [NSString stringWithFormat:@"%@-%@",valuearr[i+1][@"price_min"],self.priceArr[i][@"price_max"]];
                        }

                    }
                    
                    CGSize size1 = [str1 selfadap:12 weith:30];
                    if (totalwieth + size1.width + size.width + count* 15 + 20 < SCREEN.size.width/2 -30 ) {
                        
                        wieth  += size.width + 10;
                        count ++;
                    }else{
                        heigth += 25;
                        totalwieth = 0;
                        wieth = 0;
                        count = 0;
                        
                    }
                    
//                    button.layer.borderWidth = 1;
//                    button.layer.borderColor = [JHColor(240, 240, 240) CGColor];
                    button.backgroundColor = JHColor(240, 240, 240);
                    button.tag = 1000 +btnid + i;
                    button.layer.cornerRadius = 5;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:JHColor(51, 51, 51) forState:UIControlStateNormal];
                    [selectview addSubview:button];
                    
                    totalwieth = 15 + count* 15 + wieth;
                    
                }
                btnid += valuearr.count;
                selectview.frame = CGRectMake(0, viewH , SCREEN.size.width/2, heigth + 25);
                viewH += heigth + 25;
                
            }
            if (backview.height < viewH + 20) {//20留白
//                backview.frame = CGRectMake(0, SCREEN.size.height - (viewH + 20) - 50, SCREEN.size.width/2, SCREEN.size.height);
                backview.contentSize =  CGSizeMake(0, viewH + 20);
            }
            
        }else{
            _popview.hidden = NO;
        }
//    }
}
#pragma mark 筛选条件确定事件
-(void)selectBtnClick:(UIButton *)btn{
    if (btn.tag == 77) {//重置
        [self ergodicButton:YES];
        self.priceDict = nil;
        self.brandDict = nil;
    }else{//确定
        [self tapClick:nil];
    
    }
}
//配件点击事件
-(void)buttonClick:(UIButton *)btn{
    NSArray *arr = @[@"品牌",@"价格"];
    CGFloat btnid = 0;
    for (int j = 0; j < arr.count; j ++) {
        NSArray *valuearr = [NSArray array];
        if (self.brandArr.count && self.priceArr.count) {
            if (j == 0) {
                valuearr = self.brandArr;
            }else if (j == 1){
                valuearr = self.priceArr;
            }
        }else if (self.brandArr.count){
            valuearr = self.brandArr;
        }else if (self.priceArr.count){
            valuearr = self.priceArr;
        }
        if ( (btn.tag - 1000) >= btnid && (btn.tag - 1000) < (btnid + valuearr.count)) {
            for (int i = 0; i < valuearr.count; i++) {
                UIButton *button = [_popview viewWithTag:1000 +btnid + i];
                    if (btn.tag == button.tag) {
                        btn.backgroundColor = JHAssistColor;
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }else{
                        [button setTitleColor:JHColor(51, 51, 51) forState:UIControlStateNormal];
                        button.backgroundColor =JHColor(240, 240, 240);
                        
                    }
             
            }
            
        }
        
        
        btnid += valuearr.count;
        
        
    }

//       [self ergodicButton:NO];
}
//隐藏弹出层
-(void)tapClick:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
    if (!_popview.hidden) {
        
        [self ergodicButton:NO];
        [self.collectionview.mj_header beginRefreshing];
        _popview.hidden = YES;
    }
    
}

//遍历选中配件的属性
-(void)ergodicButton:(BOOL)isReset{
    
    NSArray *arr = @[@"品牌",@"价格"];
    CGFloat btnid = 0;
    for (int j = 0; j < arr.count; j ++) {
        NSArray *valuearr = [NSArray array];
        if (self.brandArr.count && self.priceArr.count) {
            if (j == 0) {
                valuearr = self.brandArr;
            }else if (j == 1){
                valuearr = self.priceArr;
            }
        }else if (self.brandArr.count){
            valuearr = self.brandArr;
        }else if (self.priceArr.count){
            valuearr = self.priceArr;
        }
        

    for (int i = 0; i < valuearr.count; i++) {
        UIButton *btn = [_popview viewWithTag:1000 +btnid + i];
        if (isReset) {
            btn.backgroundColor = JHColor(240, 240, 240);
            [btn setTitleColor:JHColor(51, 51, 51) forState:UIControlStateNormal];
        }else{
            
            
            if ([btn.backgroundColor isEqual:JHAssistColor]) {
                if (self.brandArr.count && self.priceArr.count) {
                    if (j == 0) {
                        self.brandDict = valuearr[i];
                    }else if (j == 1){
                        self.priceDict = valuearr[i];
                    }
                }else if (self.brandArr.count){
                    self.brandDict = valuearr[i];
                }else if (self.priceArr.count){
                    self.priceDict = valuearr[i];
                }

            }else{
                
                
            }
        }
 
        
    }
    
        btnid += valuearr.count;
  
    }
    

}

#pragma mark - *************商品列表请求*************
-(void)UploadDatagoods:(ShopListType)ShopListType page:(NSInteger )pagenum{
    NSString *urlstr = [NSString string];
    switch (ShopListType) {
        case ShopListstoreDescUrl:{
            urlstr = storelistDescUrl;
        }
            break;
        case ShopListstoreAscUrl:{
            urlstr = storelistAscUrl;
        }
            break;
        case ShopListis_hotlistUrl:{
            urlstr = is_hotlistUrl;
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
    NSString *url = [NSString string];
    if (self.selectBtn.tag == 50) {
         urlstr = @"";
        url = storelistUrl;
    }else{
        url = searchUrl;
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:pagination,@"pagination", nil];
    NSMutableDictionary *filter = [[NSMutableDictionary alloc]init];
    if (self.category_id) {//分类id
        [filter setObject:self.category_id forKey:@"category_id"];
    }
    if (self.keywords) {//搜索关键词
        [filter setObject:self.keywords forKey:@"keywords"];
    }
    if (urlstr.length > 0) {
        [filter setObject:urlstr forKey:@"sort_by"];
    }
    LFLog(@"筛选条件：品牌：%@\n价格：%@",self.brandDict,self.priceDict);
    if (self.brandDict) {
        [filter setObject:self.brandDict[@"brand_id"] forKey:@"brand_id"];
    }
    if (self.priceDict) {
        NSDictionary *pDt = @{@"price_min":self.priceDict[@"price_min"],@"price_max":self.priceDict[@"price_max"]};
        [filter setObject:pDt forKey:@"price_range"];
    }
    
    [dt setObject:filter forKey:@"filter"];
    LFLog(@"dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        LFLog(@"商品列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (pagenum == 0) {
              [self.listArr removeAllObjects];
                [self.storeArr removeAllObjects];
            }
            if ([url isEqualToString:searchUrl]) {
                for (NSDictionary *dt in response[@"data"]) {
                    [self.listArr addObject:dt];
                }
            }else{
                for (NSDictionary *dt in response[@"data"]) {
                    [self.storeArr addObject:dt];
                }
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
#pragma mark - *************筛选条件请求*************
-(void)UploadDataFilter:(NSString *)urlstr{
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.category_id,@"category_id", nil];
    LFLog(@"dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,urlstr) params:dt success:^(id response) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        LFLog(@"筛选条件:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([urlstr isEqualToString:FilterBrandUrl]) {
                [self.brandArr removeAllObjects];
                for (NSDictionary *dt in response[@"data"]) {
                    [self.brandArr addObject:dt];
                }
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
                for (NSString *dt in response[@"data"]) {
                    [self.sortArr addObject:dt];
                }
            sortLabelview *soreview = [[sortLabelview alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, 100)];
            [soreview initWithsortArray:self.sortArr currentIndex:0 sortH:40 font:14];
            
            [self.view addSubview:soreview];
            
        }else{
            
            
            
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
        self.page = 1;
        self.more = @"1";
        if (self.selectBtn.tag == 50) {
            [self UploadDatagoods:ShopListstoreDescUrl page:0];
        }else if (self.selectBtn.tag == 51) {
            [self UploadDatagoods:ShopListstoreDescUrl page:0];
        }else if (self.selectBtn.tag == 52) {
            if (self.isRotating) {
                [self UploadDatagoods:ShopListprice_desclistUrl page:0];
            }else{
            [self UploadDatagoods:ShopListprice_asclistUrl page:0];
            
            }
            
        }else if (self.selectBtn.tag == 53) {
            
        }
    }];
    
    _collectionview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多商品了"];
            [self.collectionview.mj_footer endRefreshing];
        }else{
            self.page ++;
            if (self.selectBtn.tag == 50) {
                [self UploadDatagoods:ShopListstoreDescUrl page:self.page];
            }else if (self.selectBtn.tag == 51) {
                [self UploadDatagoods:ShopListstoreDescUrl page:self.page];
            }else if (self.selectBtn.tag == 52) {
                [self UploadDatagoods:ShopListprice_asclistUrl page:self.page];
            }else if (self.selectBtn.tag == 53) {
                
            }
        }

    }];
}
@end
