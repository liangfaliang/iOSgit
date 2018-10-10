//
//  BusinessStoreDetailsViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/30.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BusinessStoreDetailsViewController.h"
//#import "UINavigationBar+Awesome.h"
#import "GNRLinkageTableView.h"
#import "GNRShoppingBar.h"
#import "ShoppingCartViewController.h"

@interface BusinessStoreDetailsViewController ()<GNRGoodsNumberChangedDelegate,GNRLinkageTableViewDelegate,CAAnimationDelegate>

@property (nonatomic,strong) CALayer *dotLayer;//小圆点
@property (nonatomic,assign) CGFloat endPointX;
@property (nonatomic,assign) CGFloat endPointY;
@property (nonatomic,strong) UIBezierPath *path;
@property(nonatomic,strong)NSMutableArray * categoryArr;//类别
@property (nonatomic, strong)GNRLinkageTableView * goodsListView;
@property (nonatomic, strong)GNRShoppingBar * shoppingBar;

@end

@implementation BusinessStoreDetailsViewController
-(NSMutableArray *)categoryArr{
    if (_categoryArr == nil) {
        _categoryArr = [[NSMutableArray alloc]init];
    }
    return _categoryArr;
}
- (GNRLinkageTableView *)goodsListView{
    if (!_goodsListView) {
        _goodsListView = [[GNRLinkageTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-[GNRShoppingBar defaultHeight])];
        _goodsListView.target = self;
        _goodsListView.delegate = self;
        _goodsListView.shop_id =  self.shop_id;
        
    }
    return _goodsListView;
}

- (GNRShoppingBar *)shoppingBar{
    if (!_shoppingBar) {
        _shoppingBar = [GNRShoppingBar barWithStyle:GNRShoppingBarStyleDefault showInView:self.view];
        _shoppingBar.cartView.target = self;
        [_shoppingBar.cartView.header.cleanBtn addTarget:self action:@selector(cleanGoodsCartAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect rect = [self.view convertRect:_shoppingBar.shoppingBarView.shoppingCartIcon.frame fromView:_shoppingBar.shoppingBarView];
        
        _endPointX = rect.origin.x + rect.size.width/2.0;
        _endPointY = rect.origin.y + rect.size.height/2.0;
        WEAKSELF;
        _shoppingBar.payBtnBlock = ^(GNRGoodsListModel *goodsList) {
            ShoppingCartViewController *con = [[ShoppingCartViewController alloc]init];
            [weakSelf.navigationController pushViewController:con animated:YES];
        };
    }
    return _shoppingBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationAlpha = 0;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.goodsListView];
    [self initData];
    [self.view addSubview:self.shoppingBar];
    if (self.dict) {
        [self.goodsListView setHeaderDataForDict:self.dict];
    }else{
        [self UpData];
    }
}

-(void)UpData{
    [self getDataShop];
}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
////    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
//}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self scrollViewDidScrollForPositionY:self.goodsListView.rightTbView.contentOffset.y];
    [self.navigationController setNavigationAlpha:0 animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationAlpha:1.0 animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = true;
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = false;
}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
////    [self.navigationController.navigationBar lt_reset];
//}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    //设置导航栏背景图片为一个空的image，这样就透明了
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = true;
//    //去掉透明后导航栏下边的黑边
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//    self.navigationController.navigationBar.translucent = false;
//}
- (void)initData{
//    NSArray * arr = @[
//                      @{@"title" : @"精选特卖",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤", @"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤"]
//                        },
//                      @{@"title" : @"饭后(含有茶点)",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤"]
//                        },
//                      @{@"title" : @"茶点(含有茶点)",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤"]
//                        },
//                      @{@"title" : @"素材水果拼盘",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",]
//                        },
//                      @{@"title" : @"水果拼盘生鲜果",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤",]
//                        },
//                      @{@"title" : @"拼盘",
//                        @"list" : @[@"甜点组合"]
//                        },
//                      @{@"title" : @"烤鱼盘",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤"]
//                        },
//                      @{@"title" : @"饮料",
//                        @"list": @[@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤"]
//                        },
//                      @{@"title": @"小吃",
//                        @"list": @[@"甜点组合", @"毛肚"]
//                        },
//                      @{@"title" : @"作料",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤"]
//                        },
//                      @{@"title" : @"主食",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤"]
//                        },
//                      ];
    
//    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        GNRGoodsGroup * goodsGroup = [GNRGoodsGroup new];
//        goodsGroup.classesName = [obj objectForKey:@"title"];
//        NSArray * list = [obj objectForKey:@"list"];
//        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            GNRGoodsModel * goods = [GNRGoodsModel new];
//            goods.goodsName = obj;
//            goods.goodsPrice = [NSString stringWithFormat:@"%.2f",(float)arc4random_uniform(100)+50.f];
//            [goodsGroup.goodsList addObject:goods];
//        }];
//        [_goodsListView.goodsList.goodsGroups addObject:goodsGroup];
//    }];
//    [_goodsListView reloadData];
    
    [self UploadDataCategoryUrl];
    self.shoppingBar.goodsList = _goodsListView.goodsList;
}

- (void)scrollViewDidScrollForPositionY:(CGFloat)y{
    if (y<=64.f) {
//        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithWhite:1 alpha:y/64.f]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self.navigationController setNavigationAlpha:y/64.f animated:YES];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        [self.navigationController.navigationBar setShadowImage:nil];
        [self.navigationController setNavigationAlpha:1 animated:YES];
    }
}

//clean
- (void)cleanGoodsCartAction:(id)sender{
    [self.goodsListView.goodsList.shoppingCart clear];
    [self.shoppingBar.cartView dismiss];
    [self.shoppingBar refreshCartBar];
    [self.goodsListView.rightTbView reloadData];
}

#pragma mark - stepper delegate
- (void)stepper:(GNRCountStepper *)stepper valueChangedForCount:(NSInteger)count goods:(GNRGoodsModel *)goods{
    if (stepper.style == GNRCountStepperStyleGoodsList) {
        //更新购物车中的商品
        [self.goodsListView.goodsList.shoppingCart.bags.firstObject updateGoods:goods];
        //更新badgeValue
        [self.shoppingBar reloadData];
    }else{//购物车中的
        if (count==0) {
            [self.goodsListView.goodsList.shoppingCart.bags.firstObject updateGoods:goods];
        }
        [self.goodsListView.rightTbView reloadData];
        if (!self.goodsListView.goodsList.shoppingCart.goodsTotalNumber) {
            [self.shoppingBar.cartView dismiss];
            [self.shoppingBar refreshCartBar];
        }else{
            [self.shoppingBar reloadData];
        }
    }
}

- (void)stepper:(GNRCountStepper *)stepper addSender:(UIButton *)sender cell:(UITableViewCell *)cell{
    CGRect parentRect = [stepper convertRect:stepper.addBtn.frame toView:self.view];
    [self jumpToCartAnimationWithAddBtnRect:parentRect];
}

#pragma mark - 跳入购物车动画
-(void)jumpToCartAnimationWithAddBtnRect:(CGRect)rect{
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    
    _path= [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(startX, startY)];
    //三点曲线
    [_path addCurveToPoint:CGPointMake(_endPointX, _endPointY)
             controlPoint1:CGPointMake(startX, startY)
             controlPoint2:CGPointMake(startX - 180, startY - 200)];
    
    _dotLayer = [CALayer layer];
    _dotLayer.backgroundColor = [UIColor blackColor].CGColor;
    _dotLayer.frame = CGRectMake(0, 0, 14, 14);
    _dotLayer.cornerRadius = 14/2.f;
    [self.view.layer addSublayer:_dotLayer];
    [self groupAnimation];
}

#pragma mark - 开始组合动画
-(void)groupAnimation{
    //路径
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    //alpha
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.35f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation];
    groups.duration = 0.6f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [_dotLayer addAnimation:groups forKey:nil];
    
    [self performSelector:@selector(removeFromLayer:) withObject:_dotLayer afterDelay:0.6f];
}

//移除layer
- (void)removeFromLayer:(CALayer *)layerAnimation{
    [layerAnimation removeFromSuperlayer];
}

#pragma mark - CAAnimationDelegate
//组合动画结束后 购物车 缩放动画
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shakeAnimation.duration = 0.1f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:1];
        shakeAnimation.toValue = [NSNumber numberWithFloat:1.2];
        shakeAnimation.autoreverses = YES;
        [_shoppingBar.shoppingBarView.shoppingCartIcon.layer addAnimation:shakeAnimation forKey:nil];
    }
}
#pragma mark - *************分类请求*************
-(void)UploadDataCategoryUrl{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.shop_id ) {
        [dt setObject:self.shop_id forKey:@"shop_id"];
    }
    LFLog(@"分类标签dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BusinessShopCategoryUrl) params:dt success:^(id response) {
        LFLog(@"分类标签:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.categoryArr removeAllObjects];
            [GNRGoodsGroup mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"classesName" : @"cate_name"};
            }];
            int i =0;
            for (NSDictionary *caDt in response[@"data"]) {
                GNRGoodsGroup *model = [GNRGoodsGroup mj_objectWithKeyValues:caDt];
                [self requestData:model index:i];
                [self.categoryArr addObject:model];
                i ++;
            }
            [GNRGoodsGroup mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
            self.goodsListView.goodsList.goodsGroups = self.categoryArr;
            [self.goodsListView reloadData];
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark - *************请求数据*************
-(void)requestData:(GNRGoodsGroup * )model index:(NSInteger )index{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.shop_id ) {
        [dt setObject:self.shop_id forKey:@"shop_id"];
    }
    if (model && model.cate_id) {
        [dt setObject:model.cate_id forKey:@"cate_id"];
    }
    LFLog(@"周边商业dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BusinessShopGoodsUrl) params:dt success:^(id response) {
        LFLog(@"周边商业:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            NSMutableArray *marr = [NSMutableArray array];
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *temDt in response[@"data"]) {
                    GNRGoodsModel *gmo = [GNRGoodsModel mj_objectWithKeyValues:temDt];
                    [marr addObject:gmo];
                }
                model.goodsList = marr;
//                if (index == 0) {
                    [self.goodsListView reloadData];
//                }
            }
        }else{

            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {

    }];
    
}
#pragma mark - *************店铺信息*************
-(void)getDataShop{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.shop_id ) {
        [dt setObject:self.shop_id forKey:@"shop_id"];
    }
    LFLog(@"店铺信息dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BusinessdetailUrl) params:dt success:^(id response) {
        LFLog(@"店铺信息:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                self.dict = response[@"data"];
                [self.goodsListView setHeaderDataForDict:self.dict];
            }
        }else{
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
@end
