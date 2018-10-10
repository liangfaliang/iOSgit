//
//  MedicalExaminationDetailViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/12.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MedicalExaminationDetailViewController.h"
#import "JWCycleScrollView.h"
#import "btnFootView.h"
#import "SelectMedicalViewController.h"
#define headerHt SCREEN.size.width * 12/25
@interface MedicalExaminationDetailViewController ()<JWCycleScrollImageDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)NSArray *nameArr;
@property (nonatomic,strong)btnFootView *footer;
@property(nonatomic,strong)JWCycleScrollView *jwView;
@property (nonatomic,strong)NSDictionary *dataDt;//详情

@end

@implementation MedicalExaminationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"套餐详情";
    self.nameArr = @[@"适宜人群",@"温馨提示",@"套餐包含项目"];
    [self createTableview];
    
    [self UploadDatagoods];
}

-(void)createTableview{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerHt )];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height -50) style:UITableViewStyleGrouped];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsReviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"shopGoodsReview"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentListTableViewCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
    [self setupRefresh];
    [self.view addSubview:self.tableView];
    
}
//图片轮播
- (void)ceratCycleScrollView
{
    //采用网络图片实现
    _jwView = nil;
    _jwView=[[JWCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerHt)];
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    if (!self.dataDt) {
        imagesURLStrings = [NSMutableArray arrayWithObjects:@"placeholderImage",nil];
        _jwView.localImageArray = imagesURLStrings;
    }else{
        [imagesURLStrings addObject:self.dataDt[@"imgurl"]];
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
    if (self.dataDt && self.dataDt[@"imgurl"] && [self.dataDt[@"imgurl"] length]) {
        STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:@[self.dataDt[@"imgurl"]] currentIndex:index];
        [broser show];
    }
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.nameArr.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.dataDt) {
        return 0;
    }
    if (section == 3) {
        if ([self.dataDt[@"payexa_project"] isKindOfClass:[NSArray class]]) {
            NSArray * arr = self.dataDt[@"payexa_project"];
            return arr.count;
        }
        return 0;
    }

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataDt) {
        if (indexPath.section == 0) {
            CGSize descsize = [self.dataDt[@"name"] selfadapUifont:[UIFont fontWithName:@"Helvetica-Bold" size:16] weith:20];
            CGSize numbersize = [[NSString stringWithFormat:@"%@人已预约",self.dataDt[@"join_count"]] selfadap:15 weith:20];
            CGSize contentsize = [self.dataDt[@"desc"] selfadap:15 weith:SCREEN.size.width - (numbersize.width + 10 + 20)];
            return ((descsize.height + 10) > 30 ? (descsize.height + 10):30) + 20 + contentsize.height + 10;
        }else if (indexPath.section == 1 || indexPath.section == 2){//
            NSString *str = nil;
            UIFont* font = [UIFont systemFontOfSize:15];
            if (indexPath.section == 1) {
                str = [NSString stringWithFormat:@"%@",self.dataDt[@"suitable"]];
            }else{
                font = [UIFont systemFontOfSize:13];
                str = [NSString stringWithFormat:@"%@",self.dataDt[@"kindly_reminder"]];
            }
            CGSize addsize = [str selfadapUifont:font weith:20];
            return addsize.height + 30;
        }else if (indexPath.section == 3 ){//更多
            NSDictionary *dt = self.dataDt[@"payexa_project"][indexPath.row];
            CGSize moresize = [dt[@"name"] selfadap:15 weith:20];
            CGSize infosize = [dt[@"content"] selfadap:13 weith:20];
            return moresize.height + infosize.height + 40;
        }

    }

    return 0.001;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *onecellid = [NSString stringWithFormat:@"pbussDtailcell_%ld",(long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:onecellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:onecellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.contentView removeAllSubviews];
    if (indexPath.section == 0) {
        
        if (self.dataDt) {
            //名字
            UILabel *descLabel = [[UILabel alloc]init];
            //                    descLabel.tag = 100;
            descLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
            descLabel.textColor  = JHdeepColor;
            [cell.contentView addSubview: descLabel];
            descLabel.text = [NSString stringWithFormat:@"%@",self.dataDt[@"name"]];
            descLabel.numberOfLines = 0;
            CGSize descsize = [descLabel.text selfadapUifont:descLabel.font weith:20];
            [cell.contentView addSubview:descLabel];
            [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.right.offset(-10);
                make.top.offset(10);
                make.height.offset((descsize.height + 10) > 30 ? (descsize.height + 10):30);
            }];
            
            UILabel *numberLb = [[UILabel alloc]init];
            //                    descLabel.tag = 100;
            numberLb.font = [UIFont systemFontOfSize:15];
            numberLb.textColor  = JHmiddleColor;
            [cell.contentView addSubview: numberLb];
            numberLb.text = [NSString stringWithFormat:@"%@人已预约",self.dataDt[@"join_count"]];
            CGSize numbersize = [numberLb.text selfadapUifont:numberLb.font weith:20];
            [cell.contentView addSubview:numberLb];
            [numberLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-10);
                make.top.equalTo(descLabel.mas_bottom).offset(0);
                make.width.offset(numbersize.width + 10);
            }];
            
            UILabel *contentLb = [[UILabel alloc]init];
            //                    descLabel.tag = 100;
            contentLb.font = [UIFont systemFontOfSize:15];
            contentLb.textColor  = JHmiddleColor;
            [cell.contentView addSubview: contentLb];
            contentLb.text = [NSString stringWithFormat:@"%@",self.dataDt[@"desc"]];
            contentLb.numberOfLines = 0;
            CGSize contentsize = [contentLb.text selfadapUifont:contentLb.font weith:SCREEN.size.width - (numbersize.width + 10 + 20)];
            [cell.contentView addSubview:contentLb];
            [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.right.equalTo(numberLb.mas_left);
                make.top.equalTo(descLabel.mas_bottom).offset(0);
                make.height.offset(contentsize.height + 10);
            }];
            

          
            
        }
        return cell;
    }else if (indexPath.section == 1 || indexPath.section == 2){
        //地址
        UILabel *contentLb = [[UILabel alloc]init];
        //                    descLabel.tag = 100;
        
        [cell.contentView addSubview: contentLb];
        if (indexPath.section == 1) {
            contentLb.font = [UIFont systemFontOfSize:15];
            contentLb.textColor  = JHdeepColor;
            contentLb.text = [NSString stringWithFormat:@"%@",self.dataDt[@"suitable"]];
        }else{
            contentLb.font = [UIFont systemFontOfSize:13];
            contentLb.textColor  = JHmiddleColor;
            contentLb.text = [NSString stringWithFormat:@"%@",self.dataDt[@"kindly_reminder"]];
        }

        CGSize descsize = [contentLb.text selfadapUifont:contentLb.font weith:20];
        contentLb.numberOfLines = 0;
        [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-70);
            make.top.offset(10);
            make.height.offset(descsize.height + 5);
        }];
        
        return cell;
    }else if (indexPath.section == 3){
        NSDictionary *dt = self.dataDt[@"payexa_project"][indexPath.row];
        //套餐项目
        UILabel *moreLb = [[UILabel alloc]init];
        //                    descLabel.tag = 100;
        moreLb.font = [UIFont systemFontOfSize:15];
        moreLb.text = dt[@"name"];
        moreLb.numberOfLines = 0;
        moreLb.textColor  = JHdeepColor;
        [cell.contentView addSubview: moreLb];
        CGSize moresize = [moreLb.text selfadapUifont:moreLb.font weith:20];
        [moreLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.top.offset(10);
            make.height.offset(moresize.height + 10);
        }];
        //信息
        UILabel *infoLb = [[UILabel alloc]init];
        infoLb.numberOfLines = 0;
        infoLb.font = [UIFont systemFontOfSize:13];
        infoLb.textColor  = JHmiddleColor;
        [cell.contentView addSubview: infoLb];
        infoLb.text = dt[@"content"];
//        if (infoLb.text) {
//            [infoLb NSParagraphStyleAttributeName:10];
//        }
        infoLb.numberOfLines = 0;
        [infoLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(moreLb.mas_bottom).offset(0);
            make.left.offset(10);
            make.right.offset(-10);
            make.bottom.offset(0);
        }];
        return cell;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section > 0 && self.dataDt) {
        return 30;
    }
    return 0.0001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor whiteColor];
    if (section > 0 && self.dataDt) {
        UIButton * btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"shuxian"] forState:UIControlStateNormal];
        [btn setTitle:[NSString stringWithFormat:@" %@",self.nameArr[section - 1]] forState:UIControlStateNormal];
        [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
        btn.titleLabel.font =[UIFont systemFontOfSize:15];
        [header addSubview:btn];
        [btn  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(header.mas_centerY);
        }];
    }
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section > 0) {
        return 10;
    }
    return 0.0001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = JHbgColor;
    return foot;
}


#pragma mark - *************详情请求*************
-(void)UploadDatagoods{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.listId) {
        [dt setObject:self.listId forKey:@"id"];
    }
    LFLog(@"详情请求dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,MedicalExaminationDetailUrl) params:dt success:^(id response) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@"详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (!self.footer) {
                self.footer = [[NSBundle mainBundle]loadNibNamed:@"btnFootView" owner:nil options:nil][0];
                self.footer.frame = CGRectMake(0, SCREEN.size.height - 50, SCREEN.size.width, 50);
                [self.footer.clickBtn setTitle:@"立即预约" forState:UIControlStateNormal];
                __weak typeof(self) weakSelf = self;
                [self.footer setBlock:^{//立即预约
                    SelectMedicalViewController *select = [[SelectMedicalViewController alloc]init];
                    select.itemId = weakSelf.dataDt[@"id"];
                    select.dataDt = weakSelf.dataDt;
                    [weakSelf.navigationController pushViewController:select animated:YES];
                }];
                [self.view addSubview:self.footer];
            }
            self.dataDt = response[@"data"];
            NSString *imageArr = response[@"data"][@"imgurl"];
            if (imageArr && imageArr.length) {
                [self ceratCycleScrollView];
            }else{
                self.tableView.tableHeaderView = nil;
            }
            NSString *original_price = (self.dataDt[@"original_price"] ? self.dataDt[@"original_price"] :@"");
            NSString *current_price = (self.dataDt[@"current_price"] ? self.dataDt[@"current_price"] :@"");
            NSArray *priceArr = [current_price componentsSeparatedByString:@"."];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@ 起",current_price]];
            text.yy_font = [UIFont boldSystemFontOfSize:15];
            text.yy_color = JHMedicalAssistColor;
            if (priceArr.count > 1) {
                NSRange range0 =[[text string]rangeOfString:priceArr[0]];
                [text yy_setFont:[UIFont systemFontOfSize:20] range:range0];
            }
            CGSize strSize = [text selfadaption:130];
            self.footer.priceYYlb.attributedText = text;
            self.footer.lpLb.text = original_price;
            self.footer.lpLbWidth.constant = SCREEN.size.width - 120 -strSize.width -10;
            [self.tableView reloadData];
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDatagoods];
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

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self UploadDatagoods];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}


@end
