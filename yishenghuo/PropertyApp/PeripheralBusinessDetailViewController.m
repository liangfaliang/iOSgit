//
//  PeripheralBusinessDetailViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/2/24.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "PeripheralBusinessDetailViewController.h"
#import "JWCycleScrollView.h"
#import "UIButton+WebCache.h"
#import "STPhotoBroswer.h"
#import "CZCountDownView.h"
#import "LPLabel.h"
#import <WebKit/WebKit.h>
//#import "UIView+TYAlertView.h"
#import "XX_image.h"
#import <CoreLocation/CoreLocation.h>//定位
#import "CommentListTableViewCell.h"
#import "PBusyModel.h"
#import "CommentSubmitViewController.h"
#import "CommentListViewController.h"
#import "JXTAlertManagerHeader.h"
#define headerhigth SCREEN.size.width

@interface PeripheralBusinessDetailViewController ()<JWCycleScrollImageDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
{
    UIView *foot;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)JWCycleScrollView *jwView;
//@property(nonatomic,strong)UIView *footview;
@property(nonatomic,strong)UIView *tablefootview;
@property (nonatomic,strong)NSMutableArray *dataArray;//详情
@property (nonatomic,strong)NSMutableArray *commentArr;//评论列表
@property (strong, nonatomic) NSArray *likeArray;//猜你喜欢
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)NSDictionary *countDt;//统计
@end

@implementation PeripheralBusinessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isCarnival) {
        self.navigationBarTitle = @"春节嘉年华";
    }else{
        self.navigationBarTitle = @"周边商业";
    }
    self.navigationBarRightItem = [UIImage imageNamed:@"buttun_fenxiang"];
    __weak __typeof(&*self)weakSelf =self;
    [self setRightBarBlock:^(UIBarButtonItem *sender) {
        LFLog(@"分享");
        if (weakSelf.dataArray.count) {
            if ([weakSelf.dataArray[0][@"share"] isKindOfClass:[NSDictionary class]]) {
                [[ShareSingledelegate sharedShareSingledelegate] ShareContent:weakSelf.view content:weakSelf.dataArray[0][@"share"][@"title"] title:weakSelf.dataArray[0][@"share"][@"title"] url:weakSelf.dataArray[0][@"share"][@"url"] image:weakSelf.dataArray[0][@"share"][@"imgurl"]];
            }
            
        }
        
    }];
    [self createTableview];
    [self UploadDatagoods];
//    [self commentUploadData];

}


- (NSMutableArray *)commentArr
{
    if (!_commentArr) {
        _commentArr = [[NSMutableArray alloc]init];
    }
    return _commentArr;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


-(void)createTableview{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerhigth )];
    self.tablefootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 0)];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsReviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"shopGoodsReview"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentListTableViewCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
    [self setupRefresh];
    foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 50)];
    foot.backgroundColor = [UIColor whiteColor];
    UIButton *allBtn = [[UIButton alloc]init];
    [allBtn setImage:[UIImage imageNamed:@"chakanquanbu_zbsy"] forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:allBtn];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(foot.mas_centerX);
        make.centerY.equalTo(foot.mas_centerY);
    }];
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
    if (self.dataArray.count == 0) {
        imagesURLStrings = [NSMutableArray arrayWithObjects:@"placeholderImage",nil];
        _jwView.localImageArray = imagesURLStrings;
    }else{
        for (NSString *imstr in self.dataArray[0][@"imgurl"]) {
            if (IS_IPHONE_6_PLUS) {
                [imagesURLStrings addObject:imstr];
            }else{
                [imagesURLStrings addObject:imstr];
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
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark JWCycleScrollImageDelegate
-(void)cycleScrollView:(JWCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dt in self.dataArray[0][@"pictures"]) {
        [arr addObject:dt[@"url"]];
    }
    if (arr.count > 0) {
        STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:arr currentIndex:index];
        [broser show];
    }
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 4) {
        return self.commentArr.count;
    }
    if (self.dataArray.count) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count) {
        if (indexPath.section == 0) {
            CGSize descsize = [self.dataArray[0][@"shop_name"] selfadapUifont:[UIFont fontWithName:@"Helvetica-Bold" size:16] weith:20];
            return ((descsize.height + 10) > 30 ? (descsize.height + 10):30) + 40 ;
        }else if (indexPath.section == 1 ){//评论
            CGSize addsize = [[NSString stringWithFormat:@"%@",self.dataArray[0][@"shop_address"]] selfadap:15 weith:80];
            return addsize.height + [UIImage imageNamed:@"dingwijuli_zbsy"].size.height + 30;
        }else if (indexPath.section == 2 ){//更多
            CGSize moresize = [[NSString stringWithFormat:@"%@",self.dataArray[0][@"shop_desc"]] selfadap:13 weith:20 Linespace:10];
            return moresize.height + 45;
        }else if (indexPath.section == 3){
            return 100;
        }

    }
    if (indexPath.section == 4) {
        PBusyModel *mo = self.commentArr[indexPath.row];
        CGSize h = [mo.content selfadap:14 weith:70];
        CGFloat HH = h.height + 10;
        if (HH > 105) {
            HH = 105;
        }
        if (mo.imgurl.count) {
            CGFloat imgWidth = (SCREEN.size.width - 90)/3 + 10;
            return HH + 110 + imgWidth;
        }else{
            return HH + 110;
        }
    }
    return 0.001;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section != 4) {
        NSString *onecellid = [NSString stringWithFormat:@"pbussDtailcell_%ld",(long)indexPath.section];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:onecellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:onecellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.contentView removeAllSubviews];
        if (indexPath.section == 0) {
            
            if (self.dataArray.count) {
                //名字
                UILabel *descLabel = [[UILabel alloc]init];
                //                    descLabel.tag = 100;
                descLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
                descLabel.textColor  = JHdeepColor;
                [cell.contentView addSubview: descLabel];
                descLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"shop_name"]];
                descLabel.numberOfLines = 0;
                CGSize descsize = [descLabel.text selfadapUifont:descLabel.font weith:20];
                [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(10);
                    make.right.offset(-10);
                    make.top.offset(10);
                    make.height.offset((descsize.height + 10) > 30 ? (descsize.height + 10):30);
                }];
                //星星
                XX_image *XX = [[XX_image alloc]init];
                XX.scale = [self.dataArray[0][@"rank"] doubleValue]/5.0;
                XX.image = [UIImage imageNamed:@"xingxing_huise"];
                XX.selImage = [UIImage imageNamed:@"xingxing_chense"];
                [cell.contentView addSubview:XX];
                [XX mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(descLabel.mas_bottom).offset(0);
                    make.left.offset(10);
                    make.bottom.offset(0);
                    make.width.offset(XX.image.size.width);
                }];
                
                UILabel *priceLabel1 = [[UILabel alloc]init];
                priceLabel1.textColor  = JHAssistColor;
                priceLabel1.font = [UIFont systemFontOfSize:12];
                priceLabel1.attributedText = [[NSString stringWithFormat:@"人均:  %@",self.dataArray[0][@"shop_price"]] AttributedString:@"人均:" backColor:nil uicolor:JHsimpleColor uifont:nil];
                [cell.contentView addSubview: priceLabel1];
                [priceLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(XX.mas_right).offset(20);
                    make.centerY.equalTo(XX.mas_centerY);
                }];
                
            }
            return cell;
        }else if (indexPath.section == 1){
            //地址
            UILabel *AddLb = [[UILabel alloc]init];
            //                    descLabel.tag = 100;
            AddLb.font = [UIFont systemFontOfSize:15];
            AddLb.textColor  = JHdeepColor;
            [cell.contentView addSubview: AddLb];
            AddLb.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"shop_address"]];
            AddLb.numberOfLines = 0;
            CGSize descsize = [AddLb.text selfadap:15 weith:80];
            [AddLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.right.offset(-70);
                make.top.offset(10);
                make.height.offset(descsize.height + 5);
            }];
            //距离
            UIButton *alreadyLb = [[UIButton alloc]init];
            [alreadyLb setImage:[UIImage imageNamed:@"dingwijuli_zbsy"] forState:UIControlStateNormal];
            [alreadyLb setTitle:[NSString stringWithFormat:@"  %@",self.dataArray[0][@"distance"]] forState:UIControlStateNormal];
            alreadyLb.titleLabel.font = [UIFont systemFontOfSize:12];
            [alreadyLb setTitleColor:JHMaincolor forState:UIControlStateNormal];
            [cell.contentView addSubview: alreadyLb];
            [alreadyLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(AddLb.mas_bottom).offset(0);
                make.left.offset(10);
                make.bottom.offset(0);
            }];
            //打电话
            UIButton *phoneBtn = [[UIButton alloc]init];
            [phoneBtn setImage:[UIImage imageNamed:@"icon_zhoubianshangye_dianhua"] forState:UIControlStateNormal];
            [phoneBtn addTarget:self action:@selector(phoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview: phoneBtn];
            [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.offset(0);
                make.width.offset(60);
            }];
            return cell;
        }else if (indexPath.section == 2){
            //更多
            UILabel *moreLb = [[UILabel alloc]init];
            //                    descLabel.tag = 100;
            moreLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
            moreLb.textColor  = JHdeepColor;
            [cell.contentView addSubview: moreLb];
            moreLb.text = @"更多信息";
            [moreLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.right.offset(-10);
                make.top.offset(10);
                make.height.offset(25);
            }];
            //信息
            UILabel *infoLb = [[UILabel alloc]init];
            //                    descLabel.tag = 100;
            infoLb.font = [UIFont systemFontOfSize:13];
            infoLb.textColor  = JHmiddleColor;
            [cell.contentView addSubview: infoLb];
            infoLb.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"shop_desc"]];
            if (infoLb.text) {
                [infoLb NSParagraphStyleAttributeName:10];
            }
            infoLb.numberOfLines = 0;
            [infoLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(moreLb.mas_bottom).offset(0);
                make.left.offset(10);
                make.right.offset(-10);
                make.bottom.offset(0);
            }];
            return cell;
        }else if (indexPath.section == 3){
            cell.contentView.backgroundColor = JHbgColor;
            //评论条数
            UIView *commentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 44)];
            commentView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:commentView];
            //地址
            UILabel *commentLb = [[UILabel alloc]init];
            //                    descLabel.tag = 100;
            commentLb.font = [UIFont systemFontOfSize:12];
            commentLb.textColor  = JHsimpleColor;
            [commentView addSubview: commentLb];
            NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)self.commentArr.count];
            if (self.countDt) {
                count = [NSString stringWithFormat:@"%@",self.countDt[@"all_count"]];
            }
            commentLb.attributedText = [[NSString stringWithFormat:@"评论 (%@条评论)",count] AttributedString:@"评论" backColor:nil uicolor:JHdeepColor uifont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
            commentLb.numberOfLines = 0;
            [commentLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.top.offset(0);
                make.bottom.offset(0);
            }];
            //写评论
            UIButton *writeBtn = [[UIButton alloc]init];
            [writeBtn setImage:[UIImage imageNamed:@"xiepinglun_zbsys"] forState:UIControlStateNormal];
            [writeBtn addTarget:self action:@selector(writeBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [commentView addSubview: writeBtn];
            [writeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(commentView.mas_centerY);
                make.right.offset(-10);
            }];
            //星星
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, SCREEN.size.width, 54)];
            backView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:backView];
            XX_image *XX = [[XX_image alloc]init];
            XX.image = [UIImage imageNamed:@"dahuise_zbsy"];
            XX.scale = [self.dataArray[0][@"rank"] doubleValue]/5.0;
            XX.selImage = [UIImage imageNamed:@"dachengse_zbsy"];
            [backView addSubview:XX];
            [XX mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(backView.mas_centerY);
                make.centerX.equalTo(backView.mas_centerX);
                make.width.offset(XX.image.size.width);
            }];
            UILabel *rankLb = [[UILabel alloc]init];
            //                    descLabel.tag = 100;
            rankLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
            rankLb.textColor  = JHdeepColor;
            [backView addSubview: rankLb];
            rankLb.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"rank"]];
            [rankLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(backView.mas_centerY);
                make.right.equalTo(XX.mas_left).offset(-10);;
            }];
            return cell;
        }
    }
    
    CommentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.pbmodel = self.commentArr[indexPath.row];
    cell.contentLbLeft.constant = 60;
    CGSize h = [cell.pbmodel.content selfadap:14 weith:50];
    CGFloat HH = h.height + 10;
    if (HH > 105) {
        HH = 105;
    }
    cell.contentLbHeight.constant = HH;
    __weak typeof(cell) weakcell = cell;
    [cell setLikeblock:^(UIButton *sender) {
        [self upDataforpraise:weakcell.pbmodel.comment_id index:indexPath.row cell:weakcell];
    }];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section < 3) {
        return 10;
    }
    return 0.0001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = JHbgColor;
    return foot;
}

#pragma mark 写评论
-(void)writeBtnClick{
    CommentSubmitViewController *write = [[CommentSubmitViewController alloc]init];
    if (self.isCarnival) {
        write.isCarnival = self.isCarnival;
    }
    write.detailid = self.detailid;
    [self.navigationController pushViewController:write animated:YES];
}
#pragma mark 查看更多
-(void)moreBtnClick{
    CommentListViewController *more = [[CommentListViewController alloc]init];
    if (self.isCarnival) {
        more.isCarnival = self.isCarnival;
    }
    more.detailid = self.detailid;
    more.countDt = self.countDt;
    [self.navigationController pushViewController:more animated:YES];
}
#pragma mark 打电话
-(void)phoneBtnClick{

    if (self.dataArray.count ) {
        NSString *shop_mobile = self.dataArray[0][@"shop_mobile"];
        NSString *shop_tel = self.dataArray[0][@"shop_tel"];
        NSMutableArray *marr = [NSMutableArray array];
        if (shop_mobile.length) {
            [marr addObject:shop_mobile];
        }
        
        if (shop_tel.length) {
            if (shop_mobile != shop_tel) {
                [marr addObject:shop_tel];
            }
        }
        [self jxt_showActionSheetWithTitle:@"拨打电话" message:@"" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.
            addActionCancelTitle(@"取消");
            for (int i = 0 ; i < marr.count; i ++) {
                alertMaker.
                addActionDefaultTitle(marr[i]);
            };
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            
            if (![action.title isEqualToString:@"取消"]) {
                NSString *tell = [NSString stringWithFormat:@"telprompt://%@",action.title];
                NSURL *url = [NSURL URLWithString:tell];
                NSComparisonResult compare = [[UIDevice currentDevice].systemName compare:@"10.0"];
                if (compare == NSOrderedDescending || compare == NSOrderedSame) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }else{
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
            
        }];
        

    }
}

#pragma mark - *************详情请求*************
-(void)UploadDatagoods{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.detailid,@"id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.LocationArr.count) {
        CLLocation *newLocation = self.LocationArr[0];
        if (newLocation.coordinate.longitude > 0) {
            [dt setObject:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude] forKey:@"coordinate_x"];
            [dt setObject:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude] forKey:@"coordinate_y"];
        }
    }
    NSString *url = PBusinessdetailUrl;
    if (self.isCarnival) {
        url = CarnivaldetailUrl;
    }
    LFLog(@"详情请求dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@"详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObject:response[@"data"]];
            NSArray *imageArr = response[@"data"][@"imgurl"];
            if (imageArr.count) {
                [self ceratCycleScrollView];
            }else{
                self.tableView.tableHeaderView = nil;
            }
            [self.tableView reloadData];
        }else{
//            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
//            if ([error_code isEqualToString:@"100"]) {
//                [self showLogin:^(id response) {
//                    if ([response isEqualToString:@"1"]) {
//                        [self UploadDatagoods];
//                    }
//
//                }];
//            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}
#pragma mark - *************评论列表*************
-(void)commentUploadData{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.detailid,@"id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSDictionary *pagination = @{@"count":@"2",@"page":@"1"};
    [dt setObject:pagination forKey:@"pagination"];
    NSString *url = PBusyCommentListUrl;
    if (self.isCarnival) {
        url = CarnivalCommentListUrl;
    }
    LFLog(@"评论列表dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@"评论列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.commentArr removeAllObjects];
            for (NSDictionary *comDt in response[@"data"]) {
                PBusyModel *model= [[PBusyModel alloc]initWithDictionary:comDt error:nil];
                [self.commentArr addObject:model];
            }

            [self.tableView reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDatagoods];
                        [self commentUploadData];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark 点赞数据请求
-(void)upDataforpraise:(NSString *)articleid index:(NSInteger)index cell:(CommentListTableViewCell *)cell{
    
    if ( NO == [UserModel online] )
    {
        
        [self showLogin:nil];
        return;
    }
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session",articleid,@"id", nil];
    LFLog(@"点赞dt：%@",dt);
    NSString *url = PBusyCommentClickUrl;
    if (self.isCarnival) {
        url = CarnivalCommentClickUrl;
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            
            PBusyModel *model = self.commentArr[index];
            NSInteger praise = [model.agree_count integerValue];
            if ([model.is_agree isEqualToString:@"0"]) {
                [self presentLoadingTips:@"点赞成功~~"];
                model.is_agree = @"1";
                praise ++;
            }else{
                [self presentLoadingTips:@"取消点赞~~"];
                model.is_agree = @"0";
                praise --;
                
            }
            model.agree_count = [NSString stringWithFormat:@"%d",(int)praise];
            [self.commentArr replaceObjectAtIndex:index withObject:model];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:4]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
    
}
#pragma mark - *************评论列表统计*************
-(void)commentUploadStatistical
{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.detailid,@"id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"评论列表统计dt:%@",dt);
    NSString *url = PBusyCommentListCountUrl;
    if (self.isCarnival) {
        url = CarnivalCommentListCountUrl;
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@"评论列表统计:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                self.countDt = response[@"data"];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
                NSInteger allount = [response[@"data"][@"all_count"] integerValue];
                if (allount > 2) {
                    self.tableView.tableFooterView = foot;
                }else{
                    self.tableView.tableFooterView = nil;
                }
            }
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self UploadDatagoods];
        [self commentUploadData];
        [self commentUploadStatistical];
    }];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self UploadDatagoods];
    [self commentUploadData];
    [self commentUploadStatistical];
}



@end
