//
//  IntegralShopListViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/9/9.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "IntegralShopListViewController.h"
#import "JWCycleScrollView.h"
#import "ShopListCollectionViewCell.h"

#import "IndexBtn.h"
#import "MyIntegralViewController.h"
#import "IntegralShopDetailViewController.h"
#import "ShopNoPaymentViewController.h"//订单记录
#define headerHt SCREEN.size.width * 12/25
@interface IntegralShopListViewController ()<JWCycleScrollImageDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UISearchBarDelegate>
@property (nonatomic,strong)NSMutableArray * cateArray;
@property (nonatomic,strong)NSMutableArray * hotArray;

@property (nonatomic,strong)UICollectionView * collectionview;
@property (nonatomic,strong)NSMutableArray *pictureArr;//存储的信息数组
@property (nonatomic, strong) JWCycleScrollView * jwView;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;

@end

@implementation IntegralShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitle = @"积分商城";
    self.more = @"1";
    self.page = 1;
    [self createTableview];
    [self setupRefresh];
    [self updata];
}

-(void)updata{
    
    
    //    [self UploadDatalatesnotice];
    [self UploadDatadynamic:1];
    [self rotatePicture];
    
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

-(void)createTableview{
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake((SCREEN.size.width-5)/2, (SCREEN.size.width-10)/2 * 408/370 + 10);
    //    flowLayout.minimumInteritemSpacing = 5;
    //    flowLayout.minimumLineSpacing = 1;
    //    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [flowLayout setHeaderReferenceSize:CGSizeMake(SCREEN.size.width, headerHt + 102 + 51)];
    
    if (self.collectionview == nil) {
        self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width,SCREEN.size.height) collectionViewLayout:flowLayout];
    }
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview setBackgroundColor:[UIColor whiteColor]];
    //注册Cell，必须要有
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"homecell"];
    
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"ShopListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"integralShopListCell"];//列表
    [self.view addSubview:self.collectionview];
    
    
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
            if (self.pictureArr.count) {
                if ([self.pictureArr[0][@"ios"] isKindOfClass:[NSDictionary class]]) {
                    UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:self.pictureArr[0][@"ios"] controller:self];
                    if (board == nil) {
                        [self presentLoadingTips:@"信息读取失败！"];
                    }
                }
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
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionview) {
        return self.hotArray.count;
    }
    return self.cateArray.count;
    
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionview) {
        ShopListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"integralShopListCell" forIndexPath:indexPath];
        cell.contentView.backgroundImage = [UIImage imageNamed:@"shangpinditu"];
        cell.cartBtn.hidden = YES;
        cell.integralImage.hidden = NO;
        NSDictionary *dt = self.hotArray[indexPath.item];
        NSString *url = @"";
        if (IS_IPHONE_6_PLUS) {
            url = dt[@"img"][@"imgurl2"];
        }else{
            url = dt[@"img"][@"imgurl3"];
        }
        [cell.imagePic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        cell.contentLb.text = dt[@"goods_name"];
        cell.newpriceLb.text = dt[@"exchange_integral"];
        cell.PriceLeft.constant = [UIImage imageNamed:@"jifenicon"].size.width + 15;
        cell.newpriceLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        cell.PriceWidth.constant = [cell.newpriceLb.text selfadapUifont:[UIFont fontWithName:@"Helvetica-Bold" size:16] weith:SCREEN.size.width/2 - 40].width + 10;
        cell.oldPrice.text = @"";
        
        
        
        
        return cell;
    }else{
        
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuUICollectionViewCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor =[UIColor whiteColor];
        [cell.contentView removeAllSubviews];
        NSDictionary *dt = self.cateArray[indexPath.item];
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
    IntegralShopDetailViewController *class =[[IntegralShopDetailViewController alloc]init];
    class.goods_id = self.hotArray[indexPath.item][@"goods_id"];
    [self.navigationController pushViewController:class animated:YES];
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
//头视图尺寸
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN.size.width, headerHt + 80 );
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionview) {
        return CGSizeMake((SCREEN.size.width-5)/2, (SCREEN.size.width-10)/2 * 25/21 + 80);
    }else{
        return CGSizeMake( (SCREEN.size.width - 2)/4, 89);
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
        reusableview.backgroundColor = JHbgColor;
        [reusableview removeAllSubviews];
        [_jwView removeFromSuperview];
        _jwView = nil;
        _jwView=[[JWCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerHt)];
        //    self.headerView.frame = CGRectMake(0, 0, SCREEN.size.width, _jwView.frame.size.height + 30);
        NSMutableArray *imagesURLStrings = [NSMutableArray array];
        
        if (self.pictureArr.count == 0) {
            imagesURLStrings = [NSMutableArray arrayWithObjects:@"placeholderImage",nil];
            _jwView.localImageArray = imagesURLStrings;
        }else{
            if (IS_IPHONE_6_PLUS) {
                [imagesURLStrings addObject:self.pictureArr[0][@"imgurl2"]];
            }else{
                [imagesURLStrings addObject:self.pictureArr[0][@"imgurl3"]];
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
        
        [reusableview addSubview:_jwView];
        
        
        UIView *Vf = [[UIView alloc]initWithFrame:CGRectMake(0, headerHt, SCREEN.size.width, 45)];
        
        Vf.backgroundColor = [UIColor whiteColor];
        
        [reusableview addSubview:Vf];
        for (int i =0; i < 2; i ++) {
            IndexBtn *but = [[IndexBtn alloc]initWithFrame:CGRectMake(i * SCREEN.size.width/2, 0, SCREEN.size.width/2, Vf.height)];
            but.index = i;
            but.titleLabel.font = [UIFont systemFontOfSize:16];
            [but setTitleColor:JHdeepColor forState:UIControlStateNormal];
            NSString *titlestr = @"";
            if (i == 0) {
                [but setImage:[UIImage imageNamed:@"jifenicon"] forState:UIControlStateNormal];
                NSString *integal = [userDefaults objectForKey:@"user_pay_points"];
                if (integal == nil) {
                    integal = @"";
                }
                titlestr  = [NSString stringWithFormat:@"   积分   %@",integal];
                [but setAttributedTitle:[titlestr AttributedString:integal backColor:nil uicolor:JHColor(255, 79, 0) uifont:nil]  forState:UIControlStateNormal];
            }else{
                [but setImage:[UIImage imageNamed:@"duihuanjiluicon"] forState:UIControlStateNormal];
                [but setTitle:@"   兑换记录" forState:UIControlStateNormal];
            }
            
            [but addTarget:self action:@selector(integralBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [Vf addSubview:but];
        }
        UIView *vline = [[UIView alloc]initWithFrame:CGRectMake(SCREEN.size.width/2, 10, 1, Vf.height - 20)];
        vline.backgroundColor = JHbgColor;
        [Vf addSubview:vline];
        
        UIImageView *headerimage = [[UIImageView alloc]init];
        headerimage.image = [UIImage imageNamed:@"dajiadouzaidui"];
        headerimage.contentMode = UIViewContentModeScaleAspectFit;
        headerimage.backgroundColor = [UIColor clearColor];
        [reusableview addSubview:headerimage];
        [headerimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(Vf.mas_bottom).offset(0);
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
        reusableview.backgroundColor = JHbgColor;
        return reusableview;
    }else{
        return nil;
    }
    
}
//积分记录
-(void)integralBtnClick:(IndexBtn *)btn{
    
    if (btn.index == 0) {
        MyIntegralViewController * Integ = [[MyIntegralViewController alloc]init];//积分
        [self.navigationController pushViewController:Integ animated:YES];
    }else{
        ShopNoPaymentViewController * list = [[ShopNoPaymentViewController alloc]init];//积分记录
        list.is_Integral = @"is_Integral";
        list.titlename = @"兑换记录";
        [self.navigationController pushViewController:list animated:YES];
    }
    
}

#pragma mark 轮播图数据
-(void)rotatePicture{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"json":session};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ShopIntegraBannerlUrl) params:dt success:^(id response) {
        LFLog(@"轮播图数据:%@",response);
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.pictureArr removeAllObjects];
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                [self.pictureArr addObject:response[@"data"]];
            }
            [self.collectionview reloadData];
        }
        
        
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
    
}

#pragma mark - *************列表请求*************
-(void)UploadDatadynamic:(NSInteger )pagenum{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    //    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    //    NSDictionary *pagination = @{@"count":@"5",@"page":page};
    //    [dt setObject:pagination forKey:@"pagination"];
    [LFLHttpTool get:NSStringWithFormat(ZJShopBaseUrl,ShopIntegraListlUrl) params:dt success:^(id response) {
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
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self UploadDatadynamic:self.page];
                    }
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.collectionview reloadData];
    } failure:^(NSError *error) {
        [self presentLoadingTips:@"请求失败"];
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self updata];
    }];
    _collectionview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多商品了"];
            [self.collectionview.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self UploadDatadynamic:self.page];
        }

    }];
    
    
}

@end

