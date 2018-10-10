//
//  PregnantFileHomeViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/24.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PregnantFileHomeViewController.h"
#import "PregnantHeaderView.h"
#import "FSTableViewCell.h"
#import "ChildVaccinationMainViewController.h"
#import "PregnantAddInfoViewController.h"
#import "UIButton+WebCache.h"
#import "ArticleListViewController.h"
#import "ArticleListTableViewCell.h"
#import "RecommendArticleTableViewCell.h"
#import "ArticleDetailViewController.h"
@interface PregnantFileHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,FSGridLayoutViewDelegate>
@property(nonatomic,strong)PregnantHeaderView *headerview;
@property(nonatomic,strong)baseTableview *tableview;
@property (nonatomic,strong)UICollectionView * collectionview;
@property (nonatomic,strong)UICollectionView * menuCollectionview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *iconbtnArr;
@property(nonatomic,strong)NSMutableArray *articArray;
@property(nonatomic,strong)NSDictionary *PregnantArr;
@property (nonatomic, strong) NSDictionary *jsonDt1;//栅格cell
@property (nonatomic, strong) NSDictionary *jsonDt2;//栅格cell
@end

@implementation PregnantFileHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"孕产妇建档";
//    self.jsonDt1 = @{@"images":@[@{@"children":@[@{@"image":@"https://i.huim.com/miaoquan/14966511524892.SS2!/both/300x300/unsharp/true",@"weight":@1},@{@"image":@"https://i.huim.com/miaoquan/14966511524892.SS2!/both/300x300/unsharp/true",@"weight":@1}],@"height":@75,@"orientation":@"h"}]};
//    self.jsonDt2 = @{@"images":@[@{@"children":@[@{@"image":@"https://i.huim.com/miaoquan/14966511524892.SS2!/both/300x300/unsharp/true",@"weight":@1},
//                                  @{@"children":@[@{@"image":@"https://i.huim.com/miaoquan/14963170206106.jpg!/both/300x300/unsharp/true",@"weight":@1},
//                                  @{@"image":@"https://i.huim.com/miaoquan/14968041079523.jpg!/compress/true/both/300x300",@"weight":@1}],@"weight":@2,@"orientation":@"v",@"Margins":@10,@"space":@20}],
//                                   @"height":@212,@"orientation":@"h",@"Margins":@10,@"space":@5}]};
    [self createUI];

}

-(NSMutableArray *)iconbtnArr{
    if (_iconbtnArr == nil) {
        _iconbtnArr = [NSMutableArray array];
    }
    return _iconbtnArr;
}
-(void)createUI{
    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0,0, screenW, screenH)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[FSTableViewCell class] forCellReuseIdentifier:@"childMedicCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ArticleListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ArticleListTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"RecommendArticleTableViewCell" bundle:nil] forCellReuseIdentifier:@"ArticleCell"];
    [self.tableview registerClass:[FSTableViewCell class] forCellReuseIdentifier:@"fstChildcell001"];
    [self.tableview registerClass:[FSTableViewCell class] forCellReuseIdentifier:@"fstChildcell002"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"colleconcell"];
    self.tableview.tableHeaderView = self.headerview;
    [self UpateHeaderview];
    [self setupRefresh];
    [self update];
    __weak typeof(self) weakSelf = self;
    [self.headerview setAddblock:^{
        PregnantAddInfoViewController *add = [[PregnantAddInfoViewController alloc]init];
        [weakSelf.navigationController pushViewController:add animated:YES];
    }];
}
-(void)update{
    [self requestData];
    [self requestDataArticle];
    [self requestDataPicture];
}

-(void)UpateHeaderview{

    if (self.PregnantArr) {
        self.headerview.iconAddbtn.userInteractionEnabled = NO;
        self.headerview.nameBtn.userInteractionEnabled = NO;
        self.headerview.timeTypeLb.hidden = NO;
        self.headerview.laveLb.hidden = NO;
        [self.headerview nameBtnBoderIshide:YES];
        NSDictionary *dt = self.PregnantArr;
        [self.headerview.iconAddbtn sd_setImageWithURL:[NSURL URLWithString:dt[@"head_imgurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        self.headerview.timeTypeLb.text = dt[@"child_age"];
        [self.headerview.nameBtn setTitle:dt[@"gra_name"] forState:UIControlStateNormal];
        self.headerview.laveLb.text = [NSString stringWithFormat:@"距离宝宝出生还有%@天",dt[@"child_cs"]];
        self.headerview.timeTypeWidth.constant = [self.headerview.timeTypeLb.text selfadaption:13].width + 15;
    }else{
        self.headerview.iconAddbtn.userInteractionEnabled = YES;
        self.headerview.nameBtn.userInteractionEnabled = YES;
        [self.headerview nameBtnBoderIshide:NO];
        self.headerview.timeTypeLb.hidden = YES;
        self.headerview.laveLb.hidden = YES;
    }

}
-(NSMutableArray *)articArray{
    if (_articArray == nil) {
        _articArray = [[NSMutableArray alloc]init];
    }
    return _articArray;
    
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(PregnantHeaderView *)headerview{
    if (_headerview == nil) {
        _headerview = [[NSBundle mainBundle]loadNibNamed:@"PregnantHeaderView" owner:nil options:nil][0];
        _headerview.frame = CGRectMake(0, 0, SCREEN.size.width, 190);
        __weak typeof(self) weakSelf = self;
        
//        [_headerview setAddblock:^{
//            [weakSelf.navigationController pushViewController:[[ChildAddInfoViewController alloc]init] animated:YES];
//        }];
    }
    return _headerview;
}
-(CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView{
    return CGPointMake(0, 190 - 40);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return self.dataArray.count;
    if (section == 0) {
        if (self.PregnantArr.count && [self.PregnantArr[@"message"] isKindOfClass:[NSDictionary class]]) {
            return 1;
        }
        return 0;
    }
    if (section == 1 && !self.jsonDt1) {
        return 0;
    }
    if (section == 2 && !self.jsonDt2) {
        return 0;
    }
    if (section == 3) {
        return self.articArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"childMedicCell"];
        cell.imageView.image = [UIImage imageNamed:@"xiaoxiyunfu"];
        cell.textLabel.text = self.PregnantArr[@"message"][@"title"];
        cell.textLabel.textColor = JHdeepColor;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }else if (indexPath.section == 1){
        FSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fstChildcell001"];
        cell.json = self.jsonDt1;
        cell.layoutView.delegate = self;//必须放在json赋值之后
        return cell;
    }else if (indexPath.section == 2){
        FSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fstChildcell002"];
        cell.json = self.jsonDt2;
        cell.layoutView.delegate = self;//必须放在json赋值之后
        return cell;
    }else{
        NSDictionary *dt = self.articArray[indexPath.row];
        NSArray *imgurlArr = dt[@"imgurl"];
        if (imgurlArr.count >= 3) {
            ArticleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleListTableViewCell"];
            cell.nameLb.text = dt[@"title"];
            [cell setimviewSubview:imgurlArr];
            cell.scroceLb.text = [NSString stringWithFormat:@"%@       %@",dt[@"author"],dt[@"add_time"]];
            return cell;
        }else{
            RecommendArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell"];
            cell.nameLb.text = dt[@"title"];
            [cell.praiseBtn setTitle:[NSString stringWithFormat:@"   %@",dt[@"read_count"]] forState:UIControlStateNormal];
            [cell.commentBtn setTitle:[NSString stringWithFormat:@"   %@",dt[@"comment_count"]] forState:UIControlStateNormal];
            if (imgurlArr.count) {
                [cell.picture sd_setImageWithURL:[NSURL URLWithString:imgurlArr[0]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            }
            return cell;
        }

    }
//    RecommendArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell"];
//    NSDictionary *dt = self.articArray[indexPath.row];
//    cell.nameLb.text = dt[@"title"];
//    [cell.praiseBtn setTitle:[NSString stringWithFormat:@"   %@",dt[@"read_count"]] forState:UIControlStateNormal];
//    [cell.commentBtn setTitle:[NSString stringWithFormat:@"   %@",dt[@"comment_count"]] forState:UIControlStateNormal];
//    NSString *url = [NSString string];
//    if (IS_IPHONE_6_PLUS) {
//        url = dt[@"imgurl"];
//    }else{
//        url = dt[@"imgurl"];
//    }
//    [cell.picture sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
//    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }else if (indexPath.section == 1){
        return self.jsonDt1 ? [FSGridLayoutView GridViewHeightWithJsonStr:self.jsonDt1]:0;
    }else if (indexPath.section == 2){
        return self.jsonDt2 ? [FSGridLayoutView GridViewHeightWithJsonStr:self.jsonDt2]:0;
    }
    NSDictionary *dt = self.articArray[indexPath.row];
    NSArray *imgurlArr = dt[@"imgurl"];
    if (imgurlArr.count >= 3) {
        NSString * nameLb = dt[@"title"];
        CGSize size = [nameLb selfadap:17 weith:20 Linespace:10];
        return 105 + (size.height+ 10 > 30 ? size.height + 10 : 30);
    }
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3 && self.articArray.count) {
        return 44;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3 && self.articArray.count) {
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = [UIColor whiteColor];
        
        IndexBtn *sender = [[IndexBtn alloc]init];;
        sender.section = section;
        [sender setTitle:@"推荐文章" forState:UIControlStateNormal];
        [sender setTitleColor:JHdeepColor forState:UIControlStateNormal];
        sender.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        [header addSubview:sender];
        [sender mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(header.mas_centerY).offset(0);
            
        }];
        
        ImRightBtn *btn = [[ImRightBtn alloc]init];
        btn.section = section;
        [btn setImage:[UIImage imageNamed:@"gerenzhongxinjiantou"] forState:UIControlStateNormal];
        [btn setTitle:@"查看更多 " forState:UIControlStateNormal];
        [btn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(header.mas_centerY);
            make.right.offset(-10);
        }];
        
        return header;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = JHbgColor;
    return foot;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.PregnantArr && [self.PregnantArr[@"message"][@"ios"] isKindOfClass:[NSDictionary class]]) {
            [[UserModel shareUserModel] runtimePushviewController:self.PregnantArr[@"message"][@"ios"] controller:self];
            return;
        }
    }

    if (indexPath.section == 3) {
        ArticleDetailViewController *detail = [[ArticleDetailViewController alloc]init];
//        detail.article_id = self.articArray[indexPath.row][@"id"];
//        detail.urlStr = RecommendArticleDetailUrl;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}
-(void)moreBtnClick{
    ArticleListViewController *ati = [[ArticleListViewController alloc]init];
    [self.navigationController pushViewController:ati animated:YES];
}
#pragma mark - --- FSGridLayoutViewDelegate ---
-(void)FSGridLayouClickCell:(FSGridLayoutView *)flview itemDt:(NSDictionary *)itemDt{
    LFLog(@"itemDt:%@",itemDt);
//    ChildVaccinationMainViewController *plan = [[ChildVaccinationMainViewController alloc]init];
//    [self.navigationController pushViewController:plan animated:YES];
//    return;
    if ([itemDt[@"ios"] isKindOfClass:[NSDictionary class]]) {

        UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:itemDt[@"ios"] controller:self];
        if (board == nil) {
            [self presentLoadingTips:@"信息读取失败！"];
        }
        return;
    }
}

#pragma mark - *************孕妇建档*************
-(void)requestData{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    LFLog(@"孕妇建档dt:%@",dt);
    //    if (self.cat_id) {
    //        [dt setObject:self.cat_id forKey:@"cat_id"];
    //    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PregnantListUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"孕妇建档:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            self.PregnantArr = nil;
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                self.PregnantArr =  response[@"data"];
                [self UpateHeaderview];
            }else{
//                [self presentLoadingTips:@"数据格式错误！"];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self update];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"请求失败！"];
        [self createFootview];
        [_tableview.mj_footer endRefreshing];
        [_tableview.mj_header endRefreshing];
    }];
    
}
#pragma mark - *************孕妇建档图片*************
-(void)requestDataPicture{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    LFLog(@"孕妇建档图片dt:%@",dt);
    //    if (self.cat_id) {
    //        [dt setObject:self.cat_id forKey:@"cat_id"];
    //    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PregnantHomePictureUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"孕妇建档图片:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                if ([response[@"data"][@"jz"] isKindOfClass:[NSArray class]]) {
                    NSArray *jzArr = response[@"data"][@"jz"];
                    if (jzArr.count > 1) {
                        NSString *keystr = @"imgurl2";
                        if (IS_IPHONE_6_PLUS) {
                            keystr = @"imgurl3";
                        }
                        self.jsonDt1 = @{@"images":@[@{@"children":@[@{@"image":jzArr[0][keystr],@"data":jzArr[0],@"weight":@1},
                                                                    @{@"image":jzArr[1][keystr],@"data":jzArr[1],@"weight":@1}],
                                                      @"height":@65,@"orientation":@"h",@"Margins":@0,@"space":@0}]};
                    }
                    
                }
                if ([response[@"data"][@"banner"] isKindOfClass:[NSArray class]]) {
                    NSArray *bannerArr = response[@"data"][@"banner"];
                    if (bannerArr.count > 2) {
                        NSString *keystr = @"imgurl2";
                        if (IS_IPHONE_6_PLUS) {
                            keystr = @"imgurl3";
                        }
                        self.jsonDt2 = @{@"images":@[@{@"children":@[@{@"image":bannerArr[0][keystr],@"data":bannerArr[0],@"weight":@29},
                                                                     @{@"children":@[@{@"image":bannerArr[1][keystr],@"data":bannerArr[1],@"weight":@1},
                                                                                     @{@"image":bannerArr[2][keystr],@"data":bannerArr[2],@"weight":@1}],@"weight":@44,@"orientation":@"v",@"Margins":@10,@"space":@20}],
                                                       @"height":@150,@"orientation":@"h",@"Margins":@10,@"space":@5}]};
                    }
                    
                }
               
                [self.tableview reloadData];
            }else{
                [self presentLoadingTips:@"数据格式错误！"];
            }
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"请求失败！"];
        [self createFootview];
        [_tableview.mj_footer endRefreshing];
        [_tableview.mj_header endRefreshing];
    }];
    
}

#pragma mark - *************推荐文章*************
-(void)requestDataArticle{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    LFLog(@"推荐文章dt:%@",dt);
    //    if (self.cat_id) {
    //        [dt setObject:self.cat_id forKey:@"cat_id"];
    //    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PregnantRecommendArticleListUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"推荐文章:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.articArray removeAllObjects];
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dt in response[@"data"]) {
                    [self.articArray addObject:dt];
                }
                [self.tableview reloadData];
                //                [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [self presentLoadingTips:@"数据格式错误！"];
            }
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"请求失败！"];
        [self createFootview];
        [_tableview.mj_footer endRefreshing];
        [_tableview.mj_header endRefreshing];
    }];
    
}
-(void)refeshData{
    [self update];
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self update];
    }];
}

@end
