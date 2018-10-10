//
//  ShopDoodsDetailsViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/19.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "ShopDoodsDetailsViewController.h"
#import "DoodsDetailsViewController.h"
#import "ShopAppraiseViewController.h"
#import "SelectorCustomView.h"
#import "CZCountDownView.h"
#import "AlertsButton.h"
#import "ShoppingCartViewController.h"
@interface ShopDoodsDetailsViewController ()<UIScrollViewDelegate,SelectorCustomViewDelegate>

@property(nonatomic,strong)UIView *footview;
@property(nonatomic,strong)AlertsButton *alertbtn;//购物车按钮
@property(nonatomic,strong)UILabel *priceLb;
@property(nonatomic,strong)DoodsDetailsViewController *DetailContro;
@property(nonatomic,strong)ShopAppraiseViewController *AppraiseContro;

@end

@implementation ShopDoodsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view.
//    CZCountDownView *countDown = [CZCountDownView countDown];
////    countDown.frame = CGRectMake(0, 100, SCREEN.size.width, 30);
//    countDown.backgroundColor = JHbgColor;
//    countDown.timestamp = 1493087859;
//    countDown.font = 14;
//    countDown.backColor = [UIColor redColor];
//    countDown.textColor = [UIColor whiteColor];
//    //    countDown.backgroundImageName = @"search_k";
//    countDown.timerStopBlock = ^{
//        NSLog(@"时间停止");
//    };
//    [self.view addSubview:countDown];
//    [countDown mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_centerY);
//        make.height.offset(30);
//        make.width.offset(135);
//    }];
    self.navigationBarTitle = @"商品详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTable];
    [self createFoot];
//    [self createBaritem];
}
//-(void)createBaritem{
//    self.alertbtn = [[AlertsButton alloc]init];
//    self.alertbtn.alertLabel.textnum = @"0";
//    UIImage *im =[UIImage imageNamed:@"gouwuchebaise"];
//    self.alertbtn.frame =CGRectMake(0, 0, im.size.width, im.size.height);
//    [self.alertbtn setImage:im forState:UIControlStateNormal];
//    [self.alertbtn addTarget:self action:@selector(rightCartClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.alertbtn];
//    self.navigationItem.rightBarButtonItem = rightBtn;
//    
//    
//}
-(void)createFoot{
    if (self.footview == nil) {
        self.footview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN.size.height - 50, SCREEN.size.width, 50)];
        self.footview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.footview];
        
        self.alertbtn = [[AlertsButton alloc]init];
        self.alertbtn.alertLabel.textnum = @"0";
        UIImage *im =[UIImage imageNamed:@"gouwuchebaise"];
        self.alertbtn.frame =CGRectMake(10, (50 - im.size.height)/2, im.size.width, im.size.height);
        [self.alertbtn setImage:im forState:UIControlStateNormal];
        [self.alertbtn addTarget:self action:@selector(rightCartClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.footview addSubview:self.alertbtn];
        self.priceLb = [[UILabel alloc]initWithFrame:CGRectMake(im.size.width + 10, 0, SCREEN.size.width/3 * 2 - im.size.width - 80, 50)];
        self.priceLb.textAlignment = NSTextAlignmentCenter;
        self.priceLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.priceLb.textColor = JHshopMainColor;
        [self.footview addSubview: self.priceLb];
        self.DetailContro.priceLb = self.priceLb;
        UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake( SCREEN.size.width/3 * 2 - 30, 0, SCREEN.size.width/3 + 30, 50)];
        //        btn.tag = 20 + i;
        btn.backgroundColor = JHColor(247, 76, 49);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"加购物车" forState:UIControlStateNormal];
        btn.layer.borderColor = [JHColor(247, 76, 49)CGColor];
        btn.layer.borderWidth = 1;
        [btn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.footview addSubview:btn];
    }
    
    
    
}
#pragma mark 点击购买
-(void)buyBtnClick:(UIButton *)btn{
    
//    if (btn.tag == 20) {//加购物车
        __weak typeof(self) weakSelf = self;
        [self.DetailContro setBlock:^(NSString *str) {
            if (str.length) {
                [weakSelf presentLoadingTips:str];
            }else{
                [weakSelf updateCratCount];
                [weakSelf.DetailContro tapClick:nil];
            }

        }];
        [self.DetailContro UploadDatagoodsAddCart:NO iscart:YES];
        
//    }else{//买买买
//        //加购物车
//        [self.DetailContro UploadDatagoodsAddCart:NO iscart:YES];
////        [self.DetailContro UploadDatagoodsAddCart:YES iscart:NO];
//        
//    }
    
    
}

-(void)rightCartClick:(UIButton *)btn{
    
    ShoppingCartViewController *cart =[[ShoppingCartViewController alloc]init];
    [self.navigationController pushViewController:cart animated:YES];
    
}

-(void)createtitleView{
    SelectorCustomView *selectview = [[SelectorCustomView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    [selectview initWithsubArray:@[@"商品",@"详情",@"评价"] currentIndex:0 lineColor:JHshopMainColor font:15 selectColor:JHdeepColor Color:JHdeepColor];
    selectview.delegate = self;
    self.navigationItem.titleView = selectview;
    

}
-(void)SelectorCustomViewSelectBtnClick:(CGFloat )index titleName:(NSString *)titleName{
    LFLog(@"titleName:%@ index:%f",titleName,index);

}
-(void)createTable{
    
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN.size.width, SCREEN.size.height -64)];
    [self.view addSubview:_scrollview];
    _scrollview.contentSize = CGSizeMake(0, SCREEN.size.height *2);
    _scrollview.pagingEnabled = YES;
    _scrollview.delegate = self;
    self.DetailContro = [[DoodsDetailsViewController alloc] init];
    self.DetailContro .goods_id = self.goods_id;
    __weak typeof(self) weakSelf = self;
    self.DetailContro.commentBlock = ^(){
        [weakSelf.scrollview setContentOffset:CGPointMake(0, weakSelf.scrollview.height) animated:YES];
        [weakSelf.AppraiseContro.selectBtn setTitleColor:JHColor(53, 53, 53) forState:UIControlStateNormal];
        weakSelf.AppraiseContro.selectBtn = [weakSelf.AppraiseContro.view viewWithTag:102];
        [weakSelf.AppraiseContro.selectBtn setTitleColor:JHshopMainColor forState:UIControlStateNormal];
        [weakSelf.AppraiseContro segmentclick:weakSelf.AppraiseContro.selectBtn];
    };
    [self addChildViewController:self.DetailContro ];
    
    self.AppraiseContro = [[ShopAppraiseViewController alloc] init];
    self.AppraiseContro.goods_id = self.goods_id;
    self.AppraiseContro.main = self;
    [self addChildViewController:self.AppraiseContro];
    
    
    for (int i = 0; i<2; i++) {
        UIViewController *vc = self.childViewControllers[i];
        // 如果子控制器的view已经在上面，就直接返回
        if (vc.view.superview) return;
        
        // 添加
        CGFloat vcW = _scrollview.frame.size.width;
        CGFloat vcH = _scrollview.frame.size.height;
        CGFloat vcX = 0;
        CGFloat vcY = i *vcH;
        vc.view.frame = CGRectMake(vcX, vcY, vcW, vcH);
        
        [_scrollview addSubview:vc.view];
    }
//    pc = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 50, W, 5)];
//    //设置基本属性
//    pc.backgroundColor = [UIColor redColor];
//    //透明度
//    pc.alpha = 0.5;
//    
//    //设置当前页对应圆圈的颜色
//    
//    //设置触发事件
//    [pc addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventTouchUpInside];
//    //设置pagecontroll有几页
//    pc.numberOfPages = 5;
    
    //[self.view addSubview:pc];
    
    
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
@end
