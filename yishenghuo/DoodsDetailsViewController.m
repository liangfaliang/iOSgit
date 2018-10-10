//
//  DoodsDetailsViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/17.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "DoodsDetailsViewController.h"
#import "JWCycleScrollView.h"
//#import "SelectCountControl.h"
#import "GoodsReviewTableViewCell.h"
#import "ConfirmOrderViewController.h"
#import "ShopListCollectionViewCell.h"
#import "ShoppingCartViewController.h"
#import "UIButton+WebCache.h"
#import "STPhotoBroswer.h"
#import "ShopReplyEvaluateViewController.h"
#import "CZCountDownView.h"
#import "ShopDoodsDetailsViewController.h"
#import "LPLabel.h"
#define headerhigth SCREEN.size.width
@interface DoodsDetailsViewController ()<UIWebViewDelegate,JWCycleScrollImageDelegate,UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>{
//    SelectCountControl *control;
    UIView *SpikeVIew;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)JWCycleScrollView *jwView;
@property (nonatomic,strong)UICollectionView * collectionview;
//@property(nonatomic,strong)UIView *footview;
@property(nonatomic,strong)UIView *tablefootview;
@property (nonatomic,strong)NSMutableArray *goodsArr;//详情
@property (nonatomic,strong)NSMutableArray *evaluateArr;//评论列表
@property(nonatomic,strong)UITableView *detailview;
@property(nonatomic,strong)UIView *detailHeaderview;
@property (strong, nonatomic) NSArray *segementArray;
@property (strong, nonatomic) NSArray *likeArray;//猜你喜欢
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIView *vline;
@property(nonatomic,strong)UIWebView *webview;
@property(nonatomic,strong)NSString *htmlStr;
@property(nonatomic,strong)UIView *popview;//弹出层视图
@property(nonatomic,strong)NSMutableArray * specArray;//规格id
@property(nonatomic,strong)CZCountDownView * countDown;//倒计时


@end

@implementation DoodsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBarTitle = @"商品详情";
    self.segementArray = @[@"商品详情",@"商品描述",@"商品评论"];
    self.likeArray = [NSArray array];
//    [self UploadDatagoodsdescribe];
//    [self UploadDatagoodsEvaluateList];
    self.view.backgroundColor = [UIColor whiteColor];

    [self createTableview];
    [self setupRefresh];
//     self.detailview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, SCREEN.size.height  - 50 - 64) style:UITableViewStyleGrouped];
//    self.detailview.delegate = self;
//    self.detailview.dataSource = self;
//    //    self.detailview.backgroundColor = [UIColor blueColor];
//    self.detailview.tableHeaderView = self.detailHeaderview;
//    [self.detailview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"detailview"];
//    [self.detailview registerNib:[UINib nibWithNibName:@"GoodsReviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsReviewTableViewCell"];
//    [self.view addSubview:self.detailview];
//        self.detailview.hidden = YES;
//    [self createFootview];
    [self presentLoadingTips];
    [self UploadDatagoods:NO];
    
}
-(void)addCart{
    [self UploadDatagoods:YES];
    
}
-(void)setBlock:(cartblockClick)block{
    _block = block;
}



- (NSMutableArray *)evaluateArr
{
    if (!_evaluateArr) {
        _evaluateArr = [[NSMutableArray alloc]init];
    }
    return _evaluateArr;
}
- (NSMutableArray *)specArray
{
    if (!_specArray) {
        _specArray = [[NSMutableArray alloc]init];
    }
    return _specArray;
}
- (NSMutableArray *)goodsArr
{
    if (!_goodsArr) {
        _goodsArr = [[NSMutableArray alloc]init];
    }
    return _goodsArr;
}


-(void)createTableview{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerhigth)];
    self.tablefootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 100)];
    UILabel *label = [[UILabel alloc]initWithFrame:self.tablefootview.frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = JHColor(102, 102, 102);
    
    label.text = @"上拉查看商品详情";
    [self.tablefootview addSubview:label];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, SCREEN.size.height - 64 ) style:UITableViewStyleGrouped];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView =  self.tablefootview;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsReviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"shopGoodsReview"];
    [self.view addSubview:self.tableView];
    
    
}

//图片轮播
- (void)ceratCycleScrollView
{
    //采用网络图片实现
    _jwView = nil;
    _jwView=[[JWCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerhigth)];
    //    self.headerView.frame = CGRectMake(0, 0, SCREEN.size.width, _jwView.frame.size.height + 30);
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    
    if (self.goodsArr.count == 0) {
        imagesURLStrings = [NSMutableArray arrayWithObjects:@"banner",nil];
        _jwView.localImageArray = imagesURLStrings;
    }else{
        for (NSDictionary *dt in self.goodsArr[0][@"pictures"]) {
            
            if ([userDefaults objectForKey:HeigthQuality]) {
                [imagesURLStrings addObject:dt[@"thumb"]];
            }else if ([userDefaults objectForKey:HeigthQuality]){
                [imagesURLStrings addObject:dt[@"small"]];
                
            }else{
                [imagesURLStrings addObject:dt[@"url"]];
            }
        }
        
        _jwView.imageURLArray=imagesURLStrings;
    }    // 图片配文字
    _jwView.imageMode = UIViewContentModeScaleAspectFill;
    _jwView.placeHolderColor=[UIColor grayColor];
    //轮播时间间隔
    _jwView.autoScrollTimeInterval=3.0f;
    //显示分页符
    _jwView.showPageControl=YES;
    //分页符位置
    _jwView.delegate=self;
    _jwView.pageControlAlignmentType=pageControlAlignmentTypeRight;
    _jwView.jwCycleScrollDirection=JWCycleScrollDirectionHorizontal; //横向
    [_jwView startAutoCarousel];
    
    [self.headerView addSubview:self.jwView];
    
}

#pragma mark JWCycleScrollImageDelegate
-(void)cycleScrollView:(JWCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dt in self.goodsArr[0][@"pictures"]) {
        [arr addObject:dt[@"url"]];
    }
    if (arr.count > 0) {
        STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:arr currentIndex:index];
        [broser show];
    }
    
}

#pragma mark - --- delegate 视图委托 ---
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    LFLog(@"scrollView.contentOffset:%f",scrollView.contentOffset.y + scrollView.frame.size.height - 64);
//    LFLog(@"scrollView.contentSize.heigh:%f",scrollView.contentSize.height +70);

    if (scrollView.contentOffset.y + scrollView.frame.size.height - 64>self.tableView.contentSize.height +70) {
        
        //        [UIView commitAnimations];
        //
        //        [UIView animateWithDuration:1.0 animations:^{
        //            //  frame发生的偏移量,距离底部往上提高60(可自行设定)
        //            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        //
        //            self.tableView.hidden = YES;
        //            self.detailview.hidden  = NO;
        //            [self.tableView addTransitionAnimationWithDuration:1.0 type:TransitionPageCurl subType:FROM_BOTTOM];
        //        } completion:^(BOOL finished) {
        //         self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //
        //
        //        }];
        LFLog(@"tableView.centerY:%f",self.tableView.centerY);
//        if (self.tableView.centerY > 0) {
//
//            [self.tableView.layer addAnimation:[self testPositionAnnimation:self.tableView.center toValue:CGPointMake(SCREEN.size.width/2, -SCREEN.size.height/2) value:@"xiahua" key:@"annikeymod"] forKey:nil ];
//        }
        
        
    }

    
}
// 下拉刷新的原理
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
//    if (scrollView.contentOffset.y < - 100) {
//        if (self.detailview.centerY < SCREEN.size.height) {
//   
//            [self.detailview.layer addAnimation:[self testPositionAnnimation:self.detailview.center toValue:CGPointMake(SCREEN.size.width/2, SCREEN.size.height/2 * 3) value:@"bottom" key:@"annikeybot"] forKey:nil ];
//        }
//        
//    }
}
#pragma mark 测试位置的动画
//-(CABasicAnimation *)testPositionAnnimation:(CGPoint )fromValue toValue:(CGPoint )toValue value:(NSString *)value key:(NSString *)key{
//    //核心动画使用步骤
//    //1.创建一个动画对象
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    
//    //设置动画类型
//    animation.keyPath = @"position";
//    animation.delegate = self;
//    //动画执行的 "初始状态"
//    animation.fromValue = [NSValue valueWithCGPoint:fromValue];
//    
//    //    动画执行的 "最终状态"
//    animation.toValue = [NSValue valueWithCGPoint:toValue];
//    
//    
//    //每次动画执行的  "增加值"
//    animation.byValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
//    
//    [animation setValue:value forKey:key];
//    //保存动画执行状态
//    //解决方案2：使动画保存执行之后的状态，只要设置动画的两个属性
//    //    animation.removedOnCompletion = NO;//动画对象不要移除
//    //    animation.fillMode = kCAFillModeForwards;//保存当前的状态
//    
//    
//    //2.往控件的图层添加动画
//    //    [self.imageView.layer addAnimation:animation forKey:nil];
//    return animation;
//}
//动画结束调用的方法
//-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    
//    if ([[anim valueForKey:@"annikeymod"] isEqualToString:@"xiahua"]) {
////        self.detailview.center =CGPointMake(SCREEN.size.width/2, SCREEN.size.height/2 + 50);
////        self.tableView.center =CGPointMake(SCREEN.size.width/2, -SCREEN.size.height/2);
////         self.tableView.frame = CGRectMake(0, -SCREEN.size.height/2, SCREEN.size.width, SCREEN.size.height  - 50 - 64);
//        self.tableView.hidden = YES;
//        self.detailview.hidden = NO;
//    }else if ([[anim valueForKey:@"annikeytop"] isEqualToString:@"top"]) {
//        
//    }else if ([[anim valueForKey:@"annikeybot"] isEqualToString:@"bottom"]) {
////        self.detailview.center =CGPointMake(SCREEN.size.width/2, SCREEN.size.height/2 * 3);
////        self.tableView.center =CGPointMake(SCREEN.size.width/2, SCREEN.size.height/2 );
////        self.tableView.frame = CGRectMake(0, 64, SCREEN.size.width, SCREEN.size.height  - 50 - 64);
//        self.detailview.hidden = YES;
//        self.tableView.hidden = NO;
//    }else if ([[anim valueForKey:@"annikeymod1"] isEqualToString:@"xiahua1"]) {
//        
//    }
//    
//    
//    
//    
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return 4;
    }
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 2) {
            if (self.goodsArr.count) {
                NSDictionary *dt = @{};
                if (![self.goodsArr[0][@"comment"] isKindOfClass:[NSNull class]]) {
                    if (![self.goodsArr[0][@"comment"][@"info"] isKindOfClass:[NSNull class]]) {
                        dt = self.goodsArr[0][@"comment"][@"info"];
                    }
                    
                }
                if (dt.count) {
                    return 1;
                }
            }

            return 0;
        }else if (section == 3){
            if (!self.likeArray.count) {
                return 0;
            }
        }else if (section == 1){
            if (self.goodsArr.count) {
                NSArray *arr = self.goodsArr[0][@"specification"];
                if (arr.count) {
                    return 1;
                }else{
                    return 0;
                }
            }else{
                return 0;
            }
        }
        return 1;
    }
    if (self.selectBtn.tag == 100) {
        return 1;
    }
    if (self.selectBtn.tag == 102) {
        if (self.evaluateArr.count) {
           return self.evaluateArr.count;
        }
        return 1;
    }
    if (self.goodsArr.count) {
        NSArray *array = self.goodsArr[0][@"properties"];
        if (array.count) {
            return array.count;
        }else{
            return 1;
            
        }
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return 0.01;
    }
    return 0.01;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        if (self.goodsArr.count) {
            if (indexPath.section == 0) {
                
                CGSize descsize = [self.goodsArr[0][@"goods_name"] selfadap:15 weith:20];
                //秒杀
                NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
                NSInteger endtimeTem  = [[NSString stringWithFormat:@"%@",self.goodsArr[0][@"promote_end_date"]] integerValue];
                NSInteger begaintimeTem  = [[NSString stringWithFormat:@"%@",self.goodsArr[0][@"promote_start_date"]] integerValue];
                CGFloat hh = 0;
                if ([self.goodsArr[0][@"goods_limit"] isKindOfClass:[NSString class]] && [self.goodsArr[0][@"goods_limit"] length]) {
                    hh += 30;
                }
                if ([self.goodsArr[0][@"give_integral"] isKindOfClass:[NSString class]] && [self.goodsArr[0][@"give_integral"] length]) {
                    hh += 30;
                }
                if (nowTime < endtimeTem && nowTime > begaintimeTem) {
                        return descsize.height + 110 + hh;
                }
                return descsize.height + 70 + hh;
            }else if (indexPath.section == 2){//评论
                
                NSDictionary *dt = @{};
                if (![self.goodsArr[0][@"comment"] isKindOfClass:[NSNull class]]) {
                    if (![self.goodsArr[0][@"comment"][@"info"] isKindOfClass:[NSNull class]]) {
                        dt = self.goodsArr[0][@"comment"][@"info"];
                    }

                }
                if (dt.count) {

                    NSInteger  count = [dt[@"comment_rank"] integerValue];
                    CGFloat HH = 0;
                    if (count > 0) {
                        HH += 20;
                    }
                    NSString *content = dt[@"content"];;
                    
                    HH += [content selfadap:14 weith:20].height;
                    NSArray *imarray = dt[@"images"];
                    if (imarray.count) {
                        HH += 100;
                    }
                    
                    NSString *str = dt[@"admin_content"];
                    if (str.length > 0) {
                        NSString *admin_content =  [NSString stringWithFormat:@"商家回复：%@",str];
                        HH += [admin_content selfadap:12 weith:20].height;
                    }
                    
                    
                    return HH + 105;
                    
                }
                return 0.001;
            }else if (indexPath.section == 3){
                if (self.likeArray.count) {
                    return (SCREEN.size.width-10)/3.5 * 25/21 + 120;
                }
                return 0.001;
            }

            return 60;
        }else{
      return 0.001;
     }
    }
    if (self.selectBtn.tag == 100) {
        return SCREEN.size.height - 164;
    }
    if (self.selectBtn.tag == 102) {
        if (self.evaluateArr.count) {
            NSDictionary *dt = self.evaluateArr[indexPath.row];
            NSInteger  count = [dt[@"rank"] integerValue];
            CGFloat HH = 0;
            if (count > 0) {
                HH += 20;
                
            }
            NSString *content = dt[@"content"];;
            
            HH += [content selfadap:14 weith:20].height;
            NSArray *imarray = dt[@"images"];
            if (imarray.count) {
                HH += 100;
            }
            
            NSString *str = dt[@"admin_content"];
            if (str.length > 0) {
                NSString *admin_content =  [NSString stringWithFormat:@"商家回复：%@",str];
                HH += [admin_content selfadap:12 weith:20].height;
            }
            
            
            return HH + 105;
        }
        
        return 100;

    }
    return 100;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        
        NSString *CellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *namelabel =[self.view viewWithTag:indexPath.section + 10];
        if ( namelabel == nil) {
            namelabel = [[UILabel alloc]init];
            namelabel.tag = indexPath.section + 10;
            namelabel.font =[UIFont systemFontOfSize:17];
            namelabel.textAlignment = NSTextAlignmentCenter;
            namelabel.textColor = JHColor(102, 102, 102);
            
        }
        if (indexPath.section == 0) {
            NSString *onecellid = @"onecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:onecellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:onecellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            for (UIView *subview in cell.contentView.subviews) {
                if (subview != SpikeVIew) {
                    [subview removeFromSuperview];
                }
            }
            if (self.goodsArr.count) {
                
                UILabel *descLabel = [cell viewWithTag:100];
                if (descLabel == nil) {
                    descLabel = [[UILabel alloc]init];
//                    descLabel.tag = 100;
                    descLabel.font = [UIFont systemFontOfSize:15];
                    descLabel.textColor  = JHColor(51, 51, 51);
                    [cell.contentView addSubview: descLabel];
                    descLabel.numberOfLines = 0;
                }
                descLabel.text = [NSString stringWithFormat:@"%@",self.goodsArr[0][@"goods_name"]];
                
                CGSize descsize = [descLabel.text selfadap:15 weith:20];
                [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(10);
                    make.right.offset(-10);
                    make.top.offset(10);
                    make.height.offset(descsize.height + 10);
                }];
                //秒杀
                NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
//                NSInteger timeTem = [[NSString stringWithFormat:@"%@",self.goodsArr[0][@"promote_start_date"]] integerValue];
                NSInteger endtimeTem  = [[NSString stringWithFormat:@"%@",self.goodsArr[0][@"promote_end_date"]] integerValue];
                NSInteger begaintimeTem  = [[NSString stringWithFormat:@"%@",self.goodsArr[0][@"promote_start_date"]] integerValue];
                if (nowTime < endtimeTem && nowTime > begaintimeTem) {
                    
                    if (SpikeVIew == nil) {
                        SpikeVIew = [[UIView alloc]initWithFrame:CGRectMake(0, descsize.height + 20, SCREEN.size.width, 40)];
                        SpikeVIew.backgroundColor = JHColor(255, 234, 234);
                        
                        self.countDown = [CZCountDownView countDown];

                        _countDown.timestamp = endtimeTem;
                        _countDown.font = 13;
                        _countDown.backColor = [UIColor redColor];
                        _countDown.textColor = [UIColor whiteColor];
                        //    countDown.backgroundImageName = @"search_k";
                        __weak typeof(self) weakSelf = self;
                        _countDown.timerStopBlock = ^{
                            NSLog(@"时间停止");
                            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                               [weakSelf.tableView reloadData];
                            });

                            
                        };
                        [SpikeVIew addSubview:_countDown];
                        [_countDown mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(SpikeVIew.mas_centerX);
                            make.centerY.equalTo(SpikeVIew.mas_centerY);
                            make.height.offset(25);
                            make.width.offset(135);
                        }];
                        NSArray *strArr = @[@"秒杀",@"结束"];
                        for (int i = 0; i < 2; i ++) {
                            UILabel *lb = [[UILabel alloc]init];
                            lb.text = strArr[i];
                            lb.font = [UIFont systemFontOfSize:14];
                            lb.textColor = [UIColor redColor];
                            lb.textAlignment = NSTextAlignmentCenter;
                            [SpikeVIew addSubview:lb];
                            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.centerY.equalTo(SpikeVIew.mas_centerY);
                                if (i == 0) {
                                    make.right.equalTo(_countDown.mas_left).offset(-10);
                                }else{
                                    make.left.equalTo(_countDown.mas_right).offset(10);
                                }
                            }];
                        }
                    }
                    [cell.contentView addSubview:SpikeVIew];

                }else{
                    [SpikeVIew removeAllSubviews];
                    [SpikeVIew removeFromSuperview];
                    SpikeVIew = nil;
                }
                
                //价格
                
                UILabel *priceLabel1 = [cell viewWithTag:101];
                if (priceLabel1 == nil) {
                    priceLabel1 = [[UILabel alloc]init];
                    priceLabel1.tag = 101;
                    priceLabel1.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
                    priceLabel1.textColor  = [UIColor redColor];
                    [cell.contentView addSubview: priceLabel1];
                }
                NSString *shop_price =@"";
                if (self.totailPrice) {
                    shop_price = self.totailPrice;
                }else{
                   shop_price =[NSString stringWithFormat:@"%@",self.goodsArr[0][@"shop_price"]];
                }
                NSArray *priceArr = [shop_price componentsSeparatedByString:@"."];
                if (priceArr.count > 1) {
                    NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:shop_price];
                    NSString *str = @".";
                    NSRange range =[[htinstr string]rangeOfString:str];
                    NSRange newrange = {range.location + 1,shop_price.length - range.location -1};
                    [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:newrange];
                    NSRange rangeSymbol =[[htinstr string]rangeOfString:@"￥"];
                    [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:rangeSymbol];
                    
                    priceLabel1.attributedText = htinstr;
                }else{
                    priceLabel1.text = [NSString stringWithFormat:@"%@",self.goodsArr[0][@"shop_price"]];
                }
                
                
                [priceLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(10);
                    if (nowTime < endtimeTem && nowTime > begaintimeTem) {
                        make.top.equalTo(SpikeVIew.mas_bottom).offset(10);
                    }else{
                       make.top.equalTo(descLabel.mas_bottom).offset(10);
                    }
                    make.height.offset(30);
                }];
                
                LPLabel *oldprice = [cell viewWithTag:102];
                if (oldprice == nil) {
                    oldprice = [[LPLabel alloc]init];
                    oldprice.strikeThroughEnabled = YES;
                    oldprice.tag = 102;
                    oldprice.numberOfLines = 1;
                    oldprice.textColor = JHsimpleColor;
                    oldprice.font = [UIFont systemFontOfSize:13];
                    oldprice.textAlignment = NSTextAlignmentRight;
                }
                
                NSMutableAttributedString *hintString =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.goodsArr[0][@"market_price"]]];
                
                NSRange range =[[hintString string]rangeOfString:self.goodsArr[0][@"market_price"]];
                //        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
//                [hintString addAttribute:NSStrikethroughColorAttributeName value:JHColor(102, 102, 102) range:range];
                [hintString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
                
                oldprice.attributedText = hintString;
                //        oldprice.text = dt[@"market_price"];
                oldprice.adjustsFontSizeToFitWidth = YES;
                [cell.contentView addSubview:oldprice];
                [oldprice mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(priceLabel1.mas_right).offset(10);
                    make.centerY.equalTo(priceLabel1.mas_centerY).offset(0);
                    
                }];
               //已售
                UILabel *alreadyLb = [cell viewWithTag:103];
                if (alreadyLb == nil) {
                    alreadyLb = [[UILabel alloc]init];
                    alreadyLb.tag = 103;
                    alreadyLb.font = [UIFont systemFontOfSize:13];
                    alreadyLb.textColor  = JHsimpleColor;
                    alreadyLb.textAlignment = NSTextAlignmentRight;
                }
                alreadyLb.text = [NSString stringWithFormat:@"已售%@件",self.goodsArr[0][@"sale_count"]];
                [cell.contentView addSubview: alreadyLb];
                [alreadyLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-10);
                    make.centerY.equalTo(priceLabel1.mas_centerY).offset(0);
                    
                }];
                
                //限购
                NSMutableArray *marr = [NSMutableArray array];
                if ([self.goodsArr[0][@"goods_limit"] isKindOfClass:[NSString class]] && [self.goodsArr[0][@"goods_limit"] length]) {
                    [marr addObject:@"限购"];
                }
                if ([self.goodsArr[0][@"give_integral"] isKindOfClass:[NSString class]] && [self.goodsArr[0][@"give_integral"] length]) {
                    [marr addObject:@"积分"];
                }
                if (marr.count) {
                    UIView *vline = [[UIView alloc]init];
                    vline.backgroundColor = JHBorderColor;
                    [cell.contentView addSubview:vline];
                    [vline mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(priceLabel1.mas_bottom).offset(10);
                        make.left.offset(0);
                        make.right.offset(0);
                        make.height.offset(1);
                    }];
                    for (int i = 0 ; i < marr.count; i ++) {
                        UIButton *tempBtn = [[UIButton alloc]init];
                        [tempBtn setTitleColor:JHsimpleColor forState:UIControlStateNormal];
                        tempBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                        tempBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        if ([marr[i] isEqualToString:@"限购"]) {
                            [tempBtn setTitle:[NSString stringWithFormat:@" %@",self.goodsArr[0][@"goods_limit"]] forState:UIControlStateNormal];
                            [tempBtn setImage:[UIImage imageNamed:@"xiangoubuttun"] forState:UIControlStateNormal];
                        }else if ([marr[i] isEqualToString:@"积分"]) {
                            [tempBtn setTitle:[NSString stringWithFormat:@" %@",self.goodsArr[0][@"give_integral"]] forState:UIControlStateNormal];
                            [tempBtn setImage:[UIImage imageNamed:@"jifen_buttun"] forState:UIControlStateNormal];
                        }
                        [cell.contentView addSubview:tempBtn];
                        [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(vline.mas_bottom).offset(i * 30);
                            make.left.offset(10);
                            make.height.offset(30);
                            make.width.offset(SCREEN.size.width - 20);
                        }];
                    }

                }
                
                
            }
            return cell;
        }else if (indexPath.section == 1){
            NSString *twocellid = @"twocell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twocellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:twocellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell.contentView addSubview:namelabel];
            namelabel.text = @"已选";
            //        namelabel.frame = CGRectMake(10, 0, 50, cell.height);
            [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.width.offset(40);
                make.centerY.equalTo(cell.contentView.mas_centerY);
            }];
            UILabel *accessories = [cell viewWithTag:103];
            if (accessories == nil) {
                accessories = [[UILabel alloc]init];
                accessories.tag = 103;
                accessories.numberOfLines = 0;
                accessories.font = [UIFont systemFontOfSize:15];
                accessories.textColor  = JHColor(51, 51, 51);
                [cell.contentView addSubview: accessories];
            }
            if (self.goodsArr.count) {
                NSArray *arr = self.goodsArr[0][@"specification"];
                if (arr.count) {
                    NSMutableString *parmastring = [NSMutableString string];
                    for (int i = 0; i < arr.count; i ++) {
                        NSArray *valuearr = arr[i][@"value"];
                        if ([arr[i][@"attr_type"] isEqualToString:@"1"]) {
                            if (valuearr.count) {
                                [parmastring appendFormat:@"%@",valuearr[0][@"label"]];
                            }
                            [self.specArray removeAllObjects];
                            [self.specArray addObject:valuearr[0][@"id"]];
                            if (i< arr.count-1) {
                                [parmastring appendString:@" "];
                            }
                        }
                        
                    }
                    accessories.text = parmastring;
                }else{
                    
                    accessories.text = @"此商品暂无可选属性";
                }
            }else{
                accessories.text = @"暂无法选择";
            }
            
            //        accessories.text = [NSString stringWithFormat:@"玫瑰金，全网通，128g"];
            [accessories mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(namelabel.mas_right).offset(10);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.offset(-30);
            }];
            
            UIImageView *rightimage = [cell viewWithTag:3333];
            if (rightimage == nil) {
                rightimage = [[UIImageView alloc]init];
                rightimage.tag = 3333;
                rightimage.image = [UIImage imageNamed:@"gerenzhongxinjiantou"];
                
            }
            [cell.contentView addSubview:rightimage];
            [rightimage mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.offset(-10);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                
            }];
            return cell;
        }else if (indexPath.section == 2){
            GoodsReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopGoodsReview"];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            if (self.goodsArr.count) {
                NSDictionary *dt = @{};
                if (![self.goodsArr[0][@"comment"] isKindOfClass:[NSNull class]]) {
                    if (![self.goodsArr[0][@"comment"][@"info"] isKindOfClass:[NSNull class]]) {
                       dt = self.goodsArr[0][@"comment"][@"info"];
                    }
                }
                if (dt.count) {
                    UIImage *im = [UIImage imageNamed:@"wuxing"];
                    NSInteger  count = [dt[@"comment_rank"] integerValue];
                    if (count > 0) {
                        cell.xxbackHeight.constant = 20;
                        cell.xxbackWidth.constant = im.size.width/5 * count;
                    }else{
                        cell.xxbackHeight.constant = 0;
                        cell.xxbackWidth.constant = 0;
                    }
                    
                    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:dt[@"headimage"]] placeholderImage:[UIImage imageNamed:@""]];
                    cell.nameLabel.text = [NSString stringWithFormat:@"%@",dt[@"user_name"]];
                    cell.timeLabel.text = [NSString stringWithFormat:@"%@",dt[@"add_time"]];
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",dt[@"content"]];
                    cell.contentHeight.constant = [cell.contentLabel.text selfadap:14 weith:20].height;
                    NSArray *imarray = dt[@"images"];
                    if (imarray.count) {
                        
                        cell.imageHeigth.constant = 100;
                        for (int i = 0; i < imarray.count; i ++) {
                            if (i == 0) {
                                [cell.image1 sd_setImageWithURL:[NSURL URLWithString:imarray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                                
                            }else if (i == 1){
                                cell.image2.backgroundColor = [UIColor redColor];
                                [cell.image2 sd_setImageWithURL:[NSURL URLWithString:imarray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                                
                            }else if (i == 2){
                                [cell.image3 sd_setImageWithURL:[NSURL URLWithString:imarray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                                //
                            }else if (i == 3){
                                [cell.image4 sd_setImageWithURL:[NSURL URLWithString:imarray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                                
                            }
                            
                        }
                        [cell setBlock:^(NSInteger index) {
                            if (index < imarray.count) {
                                STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:imarray currentIndex:index];
                                [broser show];
                            }
                            
                        }];
                        
                    }else{
                        cell.imageHeigth.constant = 10;
                        
                    }
                    NSString *admin_content = dt[@"admin_content"];
                    if (admin_content.length > 0) {
                        cell.BusinessLabel.text = [NSString stringWithFormat:@"商家回复：%@",admin_content];
                        cell.businessHeight.constant = [cell.BusinessLabel.text selfadap:12 weith:20].height;
                    }else{
                        cell.businessHeight.constant = 0;
                        
                    }
                    cell.replycount.text = dt[@"re_count"];
                }

            }
            

            return cell;
        }else if (indexPath.section == 20){
            NSString *threecellid = @"threecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:threecellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:threecellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell.contentView addSubview:namelabel];
            namelabel.text = @"数量";
            [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.width.offset(40);
                make.centerY.equalTo(cell.contentView.mas_centerY);
            }];
            //        SelectCountControl *control =[cell viewWithTag:107];
//            if (control == nil) {
//                control = [[SelectCountControl alloc]init];
//                control.tag = 107;
//                control.countLabel.delegate = self;
//                [cell.contentView addSubview:control];
//            }
//            NSInteger total = 0;
//            if (self.goodsArr.count) {
//                total = [self.goodsArr[0][@"goods_number"] integerValue];
//            }
//            __weak typeof(control) weakcontrol = control;
//            __weak typeof(self) weakself = self;
//            [control setBlock:^(BOOL isAdd) {
//                NSInteger num = [weakcontrol.countLabel.text integerValue];
//                if (isAdd) {
//                    num ++;
//                    if (num >= total) {
//                        [weakself presentLoadingTips:@"库存不足~~"];
//                        num = total;
//                    }
//                    weakcontrol.countLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
//                }else{
//                    num --;
//                    if (num < 1) {
//                        num = 0;
//                    }
//                    weakcontrol.countLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
//                }
//            }];
//            [control mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(namelabel.mas_right).offset(10);
//                make.centerY.equalTo(cell.contentView.mas_centerY);
//                make.height.offset(35);
//                make.width.offset(100);
//            }];
//            UILabel *googNum = [cell viewWithTag:105];
//            if (googNum == nil) {
//                googNum = [[UILabel alloc]init];
//                googNum.tag = 105;
//                googNum.font = [UIFont systemFontOfSize:15];
//                googNum.textColor  = JHColor(102, 102, 102);
//                [cell.contentView addSubview: googNum];
//            }
//            if (self.goodsArr.count) {
//                googNum.text = [NSString stringWithFormat:@"（库存：%@）",self.goodsArr[0][@"goods_number"]];
//            }
//            
//            [googNum mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(control.mas_right).offset(10);
//                make.centerY.equalTo(cell.contentView.mas_centerY);
//                make.height.offset(25);
//            }];
            
            
            return cell;
        }else if (indexPath.section == 3){
            NSString *thourcellid = @"thourcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:thourcellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:thourcellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (self.likeArray.count) {
                [cell.contentView addSubview:namelabel];
                namelabel.font =[UIFont systemFontOfSize:15];
                namelabel.textColor = JHdeepColor;
                namelabel.text = @"猜你喜欢";
                [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(10);
                    make.top.offset(10);
                    make.height.offset(20);
                }];
                
                if (self.collectionview == nil) {
                    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
                    
                    flowLayout.itemSize = CGSizeMake((SCREEN.size.width-10)/3.5 , (SCREEN.size.width-10)/3.5 * 25/21 + 80);
                    //    flowLayout.minimumInteritemSpacing = 5;
                    //    flowLayout.minimumLineSpacing = 1;
                    //    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
                    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                    //                [flowLayout setHeaderReferenceSize:CGSizeMake(110, 170)];
                    
                    if (self.collectionview == nil) {
                        self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0,40, SCREEN.size.width,(SCREEN.size.width-10)/3.5 * 25/21 + 80) collectionViewLayout:flowLayout];
                    }
                    self.collectionview.dataSource=self;
                    self.collectionview.delegate=self;
                    [self tz_addPopGestureToView:self.collectionview];
                    [self.collectionview setBackgroundColor:[UIColor whiteColor]];
                    //注册Cell，必须要有
                    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"goodDetailCell"];
                    [self.collectionview registerNib:[UINib nibWithNibName:@"ShopListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DetailShopListCollectionViewCell"];
                    
                    //                [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse"];
                    //                [self.collectionview registerNib:[UINib nibWithNibName:@"ShopListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"shopShopListCollectionViewCell"];//列表
                    [cell.contentView addSubview:self.collectionview];
                    
                }

            }

            return cell;
        }
        
        return cell;
        
    }else{
        NSString *CellIdentifier = @"detailview";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (self.selectBtn.tag == 100) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor yellowColor];
            if (self.webview == nil) {
                self.webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 164)];
                self.webview.scrollView.delegate = self;
                self.webview.scrollView.scrollEnabled = YES;
                
            }
            
            [self.webview loadHTMLString:self.htmlStr baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
            
            [cell.contentView addSubview:self.webview];
            return cell;
        }else if (self.selectBtn.tag == 101){
            NSString *cellid = @"parametercell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (self.goodsArr.count) {
                NSArray *array = self.goodsArr[0][@"properties"];
                if (array.count) {
                    cell.textLabel.text = array[indexPath.row][@"name"];
                    cell.detailTextLabel.text = array[indexPath.row][@"value"];
                }else{
                    cell.textLabel.text = @"亲！商家还没描述~~";
                }
            }else{
                cell.textLabel.text = @"亲！商家还没描述~~";
            }
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = JHColor(51, 51, 51);
            return cell;
        }else{
            if (self.evaluateArr.count) {
                GoodsReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsReviewTableViewCell"];
                cell.selectionStyle = UITableViewCellEditingStyleNone;
                UIImage *im = [UIImage imageNamed:@"wuxing"];
                NSDictionary *dt = self.evaluateArr[indexPath.row];
                NSInteger  count = [dt[@"rank"] integerValue];
                if (count > 0) {
                    cell.xxbackHeight.constant = 20;
                    cell.xxbackWidth.constant = im.size.width/5 * count;
                }else{
                    cell.xxbackHeight.constant = 0;
                    cell.xxbackWidth.constant = 0;
                }
                
                [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:dt[@"headimage"]] placeholderImage:[UIImage imageNamed:@""]];
                cell.nameLabel.text = dt[@"author"];
                cell.timeLabel.text = dt[@"create"];
                cell.contentLabel.text = dt[@"content"];
                cell.contentHeight.constant = [cell.contentLabel.text selfadap:14 weith:20].height;
                NSArray *imarray = dt[@"images"];
                if (imarray.count) {
                    
                    cell.imageHeigth.constant = 100;
                    for (int i = 0; i < imarray.count; i ++) {
                        if (i == 0) {
                            [cell.image1 sd_setImageWithURL:[NSURL URLWithString:imarray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                            
                        }else if (i == 1){
                            cell.image2.backgroundColor = [UIColor redColor];
                            [cell.image2 sd_setImageWithURL:[NSURL URLWithString:imarray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                            
                        }else if (i == 2){
                            [cell.image3 sd_setImageWithURL:[NSURL URLWithString:imarray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                            //
                        }else if (i == 3){
                            [cell.image4 sd_setImageWithURL:[NSURL URLWithString:imarray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                            
                        }
                        
                    }
                    [cell setBlock:^(NSInteger index) {
                        if (index < imarray.count) {
                            STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:imarray currentIndex:index];
                            [broser show];
                        }
                        
                    }];
                    
                }else{
                    cell.imageHeigth.constant = 10;
                    
                }
                NSString *admin_content = dt[@"admin_content"];
                if (admin_content.length > 0) {
                    cell.BusinessLabel.text = [NSString stringWithFormat:@"商家回复：%@",admin_content];
                    cell.businessHeight.constant = [cell.BusinessLabel.text selfadap:12 weith:20].height;
                }else{
                    cell.businessHeight.constant = 0;
                    
                }
                cell.replycount.text = dt[@"re_count"];
                
                
                return cell;

            }else{
                NSString *cellid = @"parametercell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
        
                cell.textLabel.text = @"亲！还没有人来评论~";
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.textLabel.textColor = JHColor(51, 51, 51);
                return cell;
            
            }
            
        }
        
        return cell;
        
        
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        if (self.goodsArr.count) {
            NSDictionary *dt = @{};
            if (![self.goodsArr[0][@"comment"] isKindOfClass:[NSNull class]]) {
                if (![self.goodsArr[0][@"comment"][@"info"] isKindOfClass:[NSNull class]]) {
                    dt = self.goodsArr[0][@"comment"][@"info"];
                }
                
            }
            if (dt.count) {
                return 50;
            }
        }
       
    }
    return 0.0001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
         if (self.goodsArr.count) {
             NSDictionary *dt = @{};
             if (![self.goodsArr[0][@"comment"] isKindOfClass:[NSNull class]]) {
                 if (![self.goodsArr[0][@"comment"][@"info"] isKindOfClass:[NSNull class]]) {
                     dt = self.goodsArr[0][@"comment"][@"info"];
                 }
                 
             }
             if (dt.count) {
                 UIView *header = [[UIView alloc]init];
                 header.backgroundColor =[UIColor whiteColor];
                 UILabel *lb = [[UILabel alloc]init];
                 lb.text = [NSString stringWithFormat:@"商品评价（%@）",self.goodsArr[0][@"comment"][@"count"]];
                 lb.font = [UIFont systemFontOfSize:15];
                 lb.textColor = JHdeepColor;
                 [header addSubview:lb];
                 [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.left.offset(10);
                     make.centerY.equalTo(header.mas_centerY);
                     
                 }];
                 
                 UIButton *btn = [[UIButton alloc]init];
                 [btn setImage:[UIImage imageNamed:@"chakanquanbu"] forState:UIControlStateNormal];
                 [btn setTitleColor:JHshopMainColor forState:UIControlStateNormal];
                 [btn addTarget:self action:@selector(AllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                 [header addSubview:btn];
                 [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.right.offset(-10);
                     make.centerY.equalTo(header.mas_centerY);
                 }];
                 return header;
             }

         }
    }
    return nil;
}
-(void)AllBtnClick:(UIButton *)btn{

    if (self.commentBlock) {
        self.commentBlock();
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField == control.countLabel) {
//        NSInteger total = 0;
//        if (self.goodsArr.count) {
//            total = [self.goodsArr[0][@"goods_number"] integerValue];
//        }
//        NSInteger num = [control.countLabel.text integerValue];
//        if (num >=total) {
//            control.countLabel.text = self.goodsArr[0][@"goods_number"];
//        }else if (num < 1){
//            control.countLabel.text = @"0";
//        }
//        
//    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (tableView == self.tableView) {
        if (indexPath.section == 1) {
            if (self.goodsArr.count) {
                
                NSArray *arr = self.goodsArr[0][@"specification"];
                if (arr.count) {
                    [self PopUplayer];
                }
                
            }
        }
        
    }else{
        if (self.selectBtn.tag == 102){
            if (self.evaluateArr.count) {
                ShopReplyEvaluateViewController *reply = [[ShopReplyEvaluateViewController alloc]init];
                [reply.dataArray addObject:self.evaluateArr[indexPath.row]];
                reply.goods_id = self.goods_id;
                [self.navigationController pushViewController:reply animated:YES];
            }
        }
    }
    
}

#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.likeArray.count;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.likeArray.count) {
        
        return CGSizeMake((SCREEN.size.width-5)/3.5, (SCREEN.size.width-10)/3.5 * 25/21 + 80);
        
    }
    return CGSizeZero;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        
    ShopListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailShopListCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor =[UIColor whiteColor];

    cell.contentView.backgroundImage = [UIImage imageNamed:@"shangpinditu"];
    cell.cartBtn.hidden = YES;
    NSDictionary *dt = self.likeArray[indexPath.item];
    [cell.imagePic sd_setImageWithURL:[NSURL URLWithString:dt[@"goods_thumb"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cell.contentLb.text = dt[@"goods_name"];
    cell.contentLb.font = [UIFont systemFontOfSize:13];
    cell.newpriceLb.font = [UIFont systemFontOfSize:13];
//    NSString *shop_price =[NSString stringWithFormat:@"%@",dt[@"shop_price"]];
//    NSArray *priceArr = [shop_price componentsSeparatedByString:@"."];
//    if (priceArr.count > 1) {
//        NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:shop_price];
//        NSString *str = @".";
//        NSRange range =[[htinstr string]rangeOfString:str];
//        NSRange newrange = {range.location + 1,shop_price.length - range.location -1};
//        [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:newrange];
//        
//        cell.newpriceLb.attributedText = htinstr;
//    }else{
        cell.newpriceLb.text = dt[@"price"];
//    }
    
    cell.PriceWidth.constant = [cell.newpriceLb.text selfadap:13 weith:SCREEN.size.width - 100].width + 10;
    cell.oldPrice.text = @"";
//    NSMutableAttributedString *hintString =[[NSMutableAttributedString alloc]initWithString:dt[@"market_price"]];
//    
//    NSRange range =[[hintString string]rangeOfString:dt[@"market_price"]];
//    //        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
//    [hintString addAttribute:NSStrikethroughColorAttributeName value:JHColor(102, 102, 102) range:range];
//    [hintString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
//    cell.oldPrice.attributedText = hintString;
//    //            cell.oldPrice.text = [NSString stringWithFormat:@"市场价:%@",dt[@"market_price"]];
//    cell.oldPrice.adjustsFontSizeToFitWidth = YES;




    return cell;
    
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
    if (self.likeArray.count) {
        ShopDoodsDetailsViewController * goods = [[ShopDoodsDetailsViewController alloc]init];
        //            DoodsDetailsViewController *goods =[[DoodsDetailsViewController alloc]init];
        goods.goods_id = self.likeArray[indexPath.row][@"goods_id"];
        [self.navigationController pushViewController:goods animated:YES];
    }
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


-(void)PopUplayer{
    if (self.goodsArr.count) {
        if (_popview == nil) {
            
            _popview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 50)];
            _popview.tag = 222;
            //    popview.alpha = 0.5;
            _popview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            [[UIApplication sharedApplication].keyWindow addSubview:_popview];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [_popview addGestureRecognizer:tap];
            UIScrollView *backview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN.size.height/2, SCREEN.size.width , SCREEN.size.height/2 - 50)];
//            backview.scrollEnabled = YES;
            backview.backgroundColor = JHColor(255, 255, 255);
            [_popview addSubview:backview];
            UIImageView *picture = [[UIImageView alloc]init];
            picture.backgroundColor = [UIColor whiteColor];
            if ([self.goodsArr[0][@"img"] isKindOfClass:[NSDictionary class]]) {
                [picture sd_setImageWithURL:[NSURL URLWithString:self.goodsArr[0][@"img"][@"url"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            }
            backview.layer.masksToBounds = NO;
            [backview addSubview:picture];
            [picture mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.top.offset(-20);
                make.width.offset(100);
                make.height.offset(120);
                
            }];
            
            UILabel *oldPrice = [[UILabel alloc]init];
            oldPrice.text = self.goodsArr[0][@"goods_name"];
            oldPrice.textColor = JHColor(51, 51, 51);
            oldPrice.numberOfLines = 0;
            oldPrice.font = [UIFont systemFontOfSize:13];
            CGSize oldsize = [oldPrice.text selfadap:13 weith:130];
            [backview addSubview:oldPrice];
            [oldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(picture.mas_right).offset(10);
                make.width.offset(SCREEN.size.width - 130 );
                make.bottom.equalTo(picture.mas_bottom);
                make.height.offset(oldsize.height + 5);
            }];
            UILabel *newPrice = [_popview viewWithTag:24];
            if (newPrice == nil) {
                newPrice = [[UILabel alloc]init];
                newPrice.tag = 24;
                newPrice.textColor = [UIColor redColor];
                newPrice.font = [UIFont systemFontOfSize:17];
            }
            
            newPrice.text = self.goodsArr[0][@"shop_price"];
            
            [backview addSubview:newPrice];
            [newPrice mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(picture.mas_right).offset(10);
                make.right.offset(-10);
                make.bottom.equalTo(oldPrice.mas_top);
            }];
            UIView *vline = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREEN.size.width, 1)];
            vline.backgroundColor = JHColor(229, 229, 229);
            [backview addSubview:vline];
            
            NSArray *arr = self.goodsArr[0][@"specification"];
            //    NSArray *arr = @[@"线控耳机",@"线控耳机",@"线控耳机",@"线控耳机"];
            CGFloat btnid = 0;
            CGFloat viewH = 121;
            for (int j = 0; j < arr.count; j ++) {
                UIButton *selectview = [[UIButton alloc]init];
                [backview addSubview:selectview];
                UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN.size.width - 40, 25)];
                if ([arr[j][@"attr_type"] isEqualToString:@"2"]) {
                    namelabel.text = [NSString stringWithFormat:@"%@（多选）",arr[j][@"name"]];
                    
                }else{
                    namelabel.text = [NSString stringWithFormat:@"%@（单选）",arr[j][@"name"]];
                }
                //        namelabel.text = arr[j][@"name"];
                
                namelabel.textColor = JHColor(102, 102, 102);
                namelabel.font = [UIFont systemFontOfSize:15];
                [selectview addSubview:namelabel];
                NSArray *valuearr = arr[j][@"value"];
                CGFloat wieth = 0;
                CGFloat heigth = 25;
                CGFloat totalwieth = 0;
                int count = 0;
                for (int i = 0; i < valuearr.count; i++) {
                    
                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
                    //            NSString *str = valuearr[i][@"label"];
                    NSString *str = [NSString stringWithFormat:@"%@",valuearr[i][@"label"]];;
                    [button setTitle:str forState:UIControlStateNormal];
                    CGSize size = [str selfadap:12 weith:30];
                    button.titleLabel.font = [UIFont systemFontOfSize:12];
                    button.frame = CGRectMake(15 + count* 15 + wieth, heigth, size.width + 10, 35);
                    NSString *str1 = [[NSString alloc]init];
                    
                    if (i == valuearr.count-1) {
                        
                    }else{
                        
                        //                str1 = valuearr[i+1][@"label"];
                        str1 = [NSString stringWithFormat:@"%@",valuearr[i+1][@"label"]];
                    }
                    LFLog(@"%@",str1);
                    CGSize size1 = [str1 selfadap:12 weith:30];
                    if (i < valuearr.count - 1) {
                        if (totalwieth + size1.width + size.width + count* 15 + 20 < SCREEN.size.width -30 ) {
                            
                            wieth  += size.width;
                            count ++;
                        }else{
                            heigth += 40;
                            totalwieth = 0;
                            wieth = 0;
                            count = 0;
                            
                        }
                    }
   
                    button.backgroundColor = JHbgColor;
                    [button setTitleColor:JHdeepColor forState:UIControlStateNormal];
                    if ([arr[j][@"attr_type"] isEqualToString:@"1"]) {
//                        if (i == 0) {//取消默认单选
//                            button.backgroundColor = JHshopMainColor;
//                            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                            newPrice.text = [NSString stringWithFormat:@"%ld",([[self.goodsArr[0][@"shop_price"] stringByReplacingOccurrencesOfString:@"￥" withString:@""] integerValue] +[valuearr[i][@"price"] integerValue])];
//                        }
                    }
                    
//                    button.layer.borderWidth = 1;
//                    button.layer.borderColor = [[UIColor colorWithRed:214/256.0 green:214/256.0 blue:214/256.0 alpha:1]CGColor];
                    button.tag = 1000 +btnid + i;
                    button.layer.cornerRadius = 3;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [selectview addSubview:button];
                    
                    totalwieth = 15 + count* 15 + wieth;
                    
                }
                btnid += valuearr.count;
                selectview.frame = CGRectMake(0, viewH , SCREEN.size.width, heigth + 45);
                viewH += heigth + 45;
                
            }
            if (backview.height < viewH + 20) {//20留白
                backview.frame = CGRectMake(0, SCREEN.size.height - (viewH + 20) - 50, SCREEN.size.width, viewH + 20);
                backview.contentSize =  CGSizeMake(0, viewH + 20);
            }
            
        }else{
            _popview.hidden = NO;
        }
    }
}

//配件点击事件
-(void)buttonClick:(UIButton *)btn{
    NSArray *arr = self.goodsArr[0][@"specification"];
    CGFloat btnid = 0;
    for (int j = 0; j < arr.count; j ++) {
        NSArray *valuearr = arr[j][@"value"];
        
        if ( (btn.tag - 1000) >= btnid && (btn.tag - 1000) < (btnid + valuearr.count)) {
            for (int i = 0; i < valuearr.count; i++) {
                LFLog(@"tag:%ld",(long)btn.tag);
                UIButton *button = [_popview viewWithTag:1000 +btnid + i];
                if ([arr[j][@"attr_type"] isEqualToString:@"1"]) {//单选
                    if (btn.tag == button.tag) {
                        btn.backgroundColor = JHshopMainColor;
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }else{
                        button.backgroundColor =JHbgColor;
                        [button setTitleColor:JHdeepColor forState:UIControlStateNormal];
                    }
                }else{
                    
                    if ([btn.backgroundColor isEqual:JHshopMainColor]) {
                        btn.backgroundColor = JHbgColor;
                        [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
                        [self ergodicButton];
                        return;
                        
                    }else{
                        btn.backgroundColor = JHshopMainColor;
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [self ergodicButton];
                        return;
                    }
                    
                    
                }
            }
            
        }
        
        
        btnid += valuearr.count;
        
        
    }
    [self ergodicButton];
}
//隐藏弹出层
-(void)tapClick:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
    if (!_popview.hidden) {
        _popview.hidden = YES;
        [self ergodicButton];
    }
    
}

//遍历选中配件的属性
-(void)ergodicButton{
    
    if (self.goodsArr.count) {
        NSArray *arr = self.goodsArr[0][@"specification"];
        if (arr.count) {
        UILabel *newPrice = [_popview viewWithTag:24];
        NSInteger price = 0;
        UILabel *accessories = [self.view viewWithTag:103];
        NSMutableString *mstr = [NSMutableString string];
        NSArray *arr = self.goodsArr[0][@"specification"];
        CGFloat btnid = 0;
        NSMutableArray *marray = [[NSMutableArray alloc]init];
        [self.specArray removeAllObjects];
        for (int j = 0; j < arr.count; j ++) {
            NSArray *valuearr = arr[j][@"value"];
            for (int i = 0; i < valuearr.count; i++) {
                
                UIButton *button = [_popview viewWithTag:1000 +btnid + i];
                if ([button.backgroundColor isEqual:JHshopMainColor]) {
                    NSDictionary *dt = [NSDictionary dictionaryWithObjectsAndKeys:valuearr[i][@"id"],@"id",valuearr[i][@"label"],@"label",valuearr[i][@"price"],@"price", nil];
                    [marray addObject:dt];
                    [self.specArray addObject:valuearr[i][@"id"]];
                    [mstr appendFormat:@"%@ ",valuearr[i][@"label"]];
                    price += [valuearr[i][@"price"] integerValue];
                }
                
            }
            
            btnid += valuearr.count;
        }
        
        self.totailPrice = [NSString stringWithFormat:@"￥%ld",([[self.goodsArr[0][@"shop_price"] stringByReplacingOccurrencesOfString:@"￥" withString:@""] integerValue] +price)];
            LFLog(@"totailPrice:%@",self.totailPrice);
        newPrice.text = self.totailPrice;
        self.priceLb.text = self.totailPrice;
         UILabel *priceLabel1 = [self.view viewWithTag:101];//cell上的价格
        NSArray *priceArr = [self.totailPrice componentsSeparatedByString:@"."];
        if (priceArr.count > 1) {
            NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:self.totailPrice];
            NSString *str = @".";
            NSRange range =[[htinstr string]rangeOfString:str];
            NSRange newrange = {range.location + 1,self.totailPrice.length - range.location -1};
            [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:newrange];
            NSRange rangeSymbol =[[htinstr string]rangeOfString:@"￥"];
            [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:rangeSymbol];
            
            priceLabel1.attributedText = htinstr;
        }else{
            priceLabel1.text = self.totailPrice;
        }
        accessories.text = mstr;
        LFLog(@"marray:%@",marray);
        }
        
    }

}
#pragma mark - *************商品详情请求*************
-(void)UploadDatagoods:(BOOL)isCart{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.goods_id,@"goods_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"商品详情请求dt:%@",dt);
    [LFLHttpTool get:NSStringWithFormat(ZJShopBaseUrl,goodsUrl) params:dt success:^(id response) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@"商品详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.goodsArr removeAllObjects];
            [self.goodsArr addObject:response[@"data"]];
            if (![self.goodsArr[0][@"like_goods"] isKindOfClass:[NSNull class]]) {
                self.likeArray = self.goodsArr[0][@"like_goods"];
            }
            if (self.goodsArr[0][@"shop_price"]) {
                self.totailPrice = [NSString stringWithFormat:@"%@",self.goodsArr[0][@"shop_price"]];
                self.priceLb.text = self.totailPrice;
            }
            //默认选中规格
            NSArray *arr = self.goodsArr[0][@"specification"];
            if (arr.count) {
                for (int i = 0; i < arr.count; i ++) {
                    NSArray *valuearr = arr[i][@"value"];
                    if ([arr[i][@"attr_type"] isEqualToString:@"1"]) {
                        [self.specArray removeAllObjects];
                        [self.specArray addObject:valuearr[0][@"id"]];
                    }
                    
                }
                
            }
            if (isCart) {
                [self UploadDatagoodsAddCart:NO iscart:YES];
            }else{
                [self ceratCycleScrollView];
                [self.tableView reloadData];
            }
        }else{
           
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
            
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - *************商品描述请求*************
-(void)UploadDatagoodsdescribe{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.goods_id,@"goods_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"goods_id:%@",self.goods_id);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,goodsDescUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
//            self.htmlStr = response[@"data"];
            self.htmlStr = response[@"data"];
            [self.detailview reloadData];
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}


#pragma mark - *************商品评论列表请求*************
-(void)UploadDatagoodsEvaluateList{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.goods_id,@"goods_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,OrderEvaluateListUrl) params:dt success:^(id response) {
        LFLog(@"商品评论列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {

            [self.evaluateArr removeAllObjects];
            for (NSDictionary *dict in response[@"data"]) {
                [self.evaluateArr addObject:dict];
            }
            [self.detailview reloadData];
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDatagoodsEvaluateList];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark - *************加购物车请求*************
-(void)UploadDatagoodsAddCart:(BOOL)isSettle iscart:(BOOL)iscart{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSString *num = [NSString string];
//    if (control.countLabel.text) {
//        num = control.countLabel.text;
//    }else{
        num = @"1";
//    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.goods_id,@"goods_id",num,@"number", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.specArray.count) {
        LFLog(@"self.specArray:%@",self.specArray);
        [dt setObject:self.specArray forKey:@"spec"];
    }
    LFLog(@"goods_id:%@",self.goods_id);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,createCartUrl) params:dt success:^(id response) {
        LFLog(@"添加购物车：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"添加购物车成功"];
            if (iscart) {
                if (_block) {
                    _block(nil);
                }
            }else{
                if (isSettle) {
                    ShoppingCartViewController *cart =[[ShoppingCartViewController alloc]init];
                    [self.navigationController pushViewController:cart animated:YES];
                }else{
                    
                }
            }
            
            
        }else{
            if (iscart) {
                if (_block) {
                    _block(response[@"status"][@"error_desc"]);
                }
            }else{
//                NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
//                if ([error_code isEqualToString:@"100"]) {
//                    [self showLogin];
//                }
                [self presentLoadingTips:response[@"status"][@"error_desc"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];

    
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self UploadDatagoods:NO];
    }];

    //    }];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];


}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     
    [self tapClick:nil];
    
    
}

@end
