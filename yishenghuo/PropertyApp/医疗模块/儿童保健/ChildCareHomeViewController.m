//
//  ChildCareHomeViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/21.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ChildCareHomeViewController.h"
#import "ChildCareHomeview.h"
#import "MedicalPlanTableViewCell.h"
#import "FSTableViewCell.h"
#import "RecommendArticleTableViewCell.h"
#import "HealthEducateDetailViewController.h"
#import "VaccinationPlanViewController.h"
#import "ChildVaccinationMainViewController.h"
#import "ChildAddInfoViewController.h"
#import "UIButton+WebCache.h"
@interface ChildCareHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,FSGridLayoutViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)ChildCareHomeview *headerview;
@property(nonatomic,strong)baseTableview *tableview;
@property (nonatomic,strong)UICollectionView * collectionview;
@property (nonatomic,strong)UICollectionView * menuCollectionview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *iconbtnArr;
@property(nonatomic,strong)NSMutableArray *articArray;
@property(nonatomic,strong)NSMutableArray *childArray;
@property (nonatomic, strong) NSDictionary *jsonDt;//栅格cell
@end

@implementation ChildCareHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationAlpha = 0;
    [self createUI];
}
-(NSMutableArray *)iconbtnArr{
    if (_iconbtnArr == nil) {
        _iconbtnArr = [NSMutableArray array];
    }
    return _iconbtnArr;
}
-(void)createUI{
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0, -statusRect.size.height, screenW, screenH + statusRect.size.height)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerNib:[UINib nibWithNibName:@"MedicalPlanTableViewCell" bundle:nil] forCellReuseIdentifier:@"childMedicCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"RecommendArticleTableViewCell" bundle:nil] forCellReuseIdentifier:@"ArticleCell"];
    [self.tableview registerClass:[FSTableViewCell class] forCellReuseIdentifier:@"fstChildcell"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"colleconcell"];
    self.tableview.tableHeaderView = self.headerview;
    
    [self setupRefresh];
    [self update];
}
-(void)update{
    [self requestData];
    [self requestDataArticle];
    [self requestDataPicture];
}

-(void)UpateHeaderview{
    CGFloat xx = 0;
    int i = 0;
    CGFloat ww = 50;
    CGFloat wid = 40;//小but的间隔
    if (self.childArray.count > 1) {
        CGFloat width = (screenW - 110)/(self.childArray.count -1);
        if (wid > width) {
            wid = width;
        }
    }
    [self.iconbtnArr removeAllObjects];
    for (NSDictionary *dt in self.childArray) {
        IndexBtn *btn = [[IndexBtn alloc]initWithFrame:CGRectMake(xx, 0, i == 0 ? 50 :(wid > 30 ? 30 : wid) , i == 0 ? 50 :(wid > 30 ? 30 : wid))];
        btn.index = i;
        btn.center = CGPointMake(xx + ww/2, 25);
        [btn sd_setImageWithURL:[NSURL URLWithString:dt[@"head_imgurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
//        [btn setImage:[UIImage imageNamed:@"touxaing_chlid"] forState:UIControlStateNormal];
        [self.headerview.iconView addSubview:btn];
        if (i == 0) {
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | %@",dt[@"child_name"],dt[@"child_age"]]];
            text.yy_font = [UIFont boldSystemFontOfSize:13];
            text.yy_color = JHdeepColor;
            NSRange range0 =[[text string]rangeOfString:[NSString stringWithFormat:@"%@ |",dt[@"child_name"]]];
            [text yy_setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15] range:range0];
            self.headerview.nameLb.attributedText = text;
            [self.headerview.locationBtn setTitle:dt[@"address"] forState:UIControlStateNormal];
        }else{
            btn.alpha = 0.7;
        }
        i ++;
        xx += ww;
        ww = wid;
        [btn addTarget:self action:@selector(childIconClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.iconbtnArr addObject:btn];
    }
    self.headerview.iconWidth.constant = xx ;
}
-(void)childIconClick:(IndexBtn *)sender{
    IndexBtn *btn = self.iconbtnArr[0];

//    sender.userInteractionEnabled  = NO;
    if (btn != sender) {
        self.headerview.userInteractionEnabled  = NO;
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            CGRect tem = sender.frame;
            sender.frame = btn.frame;
            btn.frame = tem;
            //        sender.frame = CGRectMake(0, 0, 50, 50);
            //        sender.center = CGPointMake(25, 25);
        } completion:^(BOOL finished) {
            btn.alpha = 0.7;
            sender.alpha = 1;
            [self.iconbtnArr exchangeObjectAtIndex:sender.index withObjectAtIndex:0];
            [self.childArray exchangeObjectAtIndex:sender.index withObjectAtIndex:0];
            btn.index = sender.index;
            sender.index = 0;
            [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
            NSDictionary *dt = self.childArray[0];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | %@",dt[@"child_name"],dt[@"child_age"]]];
            text.yy_font = [UIFont boldSystemFontOfSize:13];
            text.yy_color = JHdeepColor;
            NSRange range0 =[[text string]rangeOfString:[NSString stringWithFormat:@"%@ |",dt[@"child_name"]]];
            [text yy_setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15] range:range0];
            self.headerview.nameLb.attributedText = text;
            self.headerview.userInteractionEnabled  = YES;
//            sender.userInteractionEnabled  = YES;
        }];


    }else{
        
    }

}
-(NSMutableArray *)articArray{
    if (_articArray == nil) {
        _articArray = [[NSMutableArray alloc]init];
    }
    return _articArray;
    
}
-(NSMutableArray *)childArray{
    
    if (_childArray == nil) {
        _childArray = [[NSMutableArray alloc]init];
    }
    
    return _childArray;
    
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(ChildCareHomeview *)headerview{
    if (_headerview == nil) {
        _headerview = [[NSBundle mainBundle]loadNibNamed:@"ChildCareHomeview" owner:nil options:nil][0];
        _headerview.backgroundImage = [UIImage imageNamed:@"child_bg"];
        _headerview.frame = CGRectMake(0, 0, SCREEN.size.width, NaviH + 110);
        _headerview.iconTop.constant = NaviH;
        __weak typeof(self) weakSelf = self;
        [_headerview setAddblock:^{
            [weakSelf.navigationController pushViewController:[[ChildAddInfoViewController alloc]init] animated:YES];
        }];
    }
    return _headerview;
}
-(UICollectionView *)collectionview{
    if (_collectionview == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN.size.width-70)/2.3, 60);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width,180) collectionViewLayout:flowLayout];
        _collectionview.dataSource=self;
        _collectionview.delegate=self;
        [_collectionview setBackgroundColor:JHbgColor];
        [_collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"childCollcell"];
    }
    return _collectionview;
}
-(CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView{
    return CGPointMake(0, NaviH + 110 - 40);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return self.dataArray.count;
    if (section == 0) {
        if (self.childArray.count && [self.childArray[0][@"inoculation"] isKindOfClass:[NSArray class]]) {
            return [self.childArray[0][@"inoculation"] count];
        }
        return 0;
    }
    if (section == 1 && !self.jsonDt) {
        return 0;
    }
    if (section == 2 && !self.dataArray.count) {
        return 0;
    }
    if (section == 3) {
        return self.articArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MedicalPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"childMedicCell"];
        NSArray *inoculationArr = self.childArray[0][@"inoculation"];
        NSDictionary *dt = inoculationArr[indexPath.row];
        cell.nameLb.attributedText = [[NSString stringWithFormat:@"下一次%@",dt[@"title"]] AttributedString:dt[@"title"] backColor:nil uicolor:JHMedicalColor uifont:nil];
        cell.dateLb.text = dt[@"date"] ;
        cell.weekLb.text = [NSString stringWithFormat:@"  %@  ",dt[@"date1"]] ;
        [cell.laveTimeBtn setAttributedTitle:[[NSString stringWithFormat:@"距离接种日\n%@天",dt[@"differ_date"]] AttributedString:[NSString stringWithFormat:@"%@天",dt[@"differ_date"]] allcolor:JHsimpleColor backColor:nil uicolor:JHMedicalColor uifont:[UIFont systemFontOfSize:10]] forState:UIControlStateNormal];
        [cell.laveTimeBtn setTitleColor:JHsimpleColor forState:UIControlStateNormal];
        
        return cell;
    }else if (indexPath.section == 1){
        FSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fstChildcell"];
        cell.json = self.jsonDt;
        cell.layoutView.delegate = self;//必须放在json赋值之后
        return cell;
    }else if (indexPath.section == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"colleconcell"];
        [cell.contentView addSubview:self.collectionview];
        cell.contentView.backgroundColor = JHbgColor;
        [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
        return cell;
    }
    RecommendArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell"];
    NSDictionary *dt = self.articArray[indexPath.row];
    cell.nameLb.text = dt[@"title"];
    [cell.praiseBtn setTitle:[NSString stringWithFormat:@"   %@",dt[@"read_count"]] forState:UIControlStateNormal];
    [cell.commentBtn setTitle:[NSString stringWithFormat:@"   %@",dt[@"comment_count"]] forState:UIControlStateNormal];
    NSString *url = [NSString string];
    if (IS_IPHONE_6_PLUS) {
        url = dt[@"imgurl"];
    }else{
        url = dt[@"imgurl"];
    }
    [cell.picture sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else if (indexPath.section == 1){
        return self.jsonDt ? [FSGridLayoutView GridViewHeightWithJsonStr:self.jsonDt]:0;
    }else if (indexPath.section == 2){
        return 60;
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
//    DoctorInfoViewController *detail = [[DoctorInfoViewController alloc]init];
    //    detail.titieStr = self.titieStr;
    //    detail.listId = self.dataArray[indexPath.row][@"id"];
//    [self.navigationController pushViewController:detail animated:YES];
    if (indexPath.section == 0) {
        
        ChildVaccinationMainViewController *detail = [[ChildVaccinationMainViewController alloc]init];
        detail.child_id = self.childArray[0][@"child_id"];
        [self.navigationController pushViewController:detail animated:YES];
        return;
    }
    if (indexPath.section == 3) {
        HealthEducateDetailViewController *detail = [[HealthEducateDetailViewController alloc]init];
        detail.article_id = self.articArray[indexPath.row][@"id"];
        detail.urlStr = RecommendArticleDetailUrl;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}

#pragma mark - *************collectionView*************
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView == self.menuCollectionview) {
        return self.childArray.count;
    }
    return 1;
}
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionview) {
        return self.dataArray.count;
    }
    NSArray *menuArr = self.childArray[section][@"nav"];
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

        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"childCollcell" forIndexPath:indexPath];
        NSDictionary *dt = self.dataArray[indexPath.item];
        [cell.contentView removeAllSubviews];
        UIImageView *imageview = [[UIImageView alloc]init];
        imageview.layer.cornerRadius = 5;
        imageview.layer.masksToBounds = YES;
        imageview.contentMode = UIViewContentModeScaleToFill;
        NSString *url = [NSString string];
        if (IS_IPHONE_6_PLUS) {
            url = dt[@"imgurl3"];
        }else{
            url = dt[@"imgurl2"];
        }
        [imageview sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        [cell.contentView addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(0);
            make.bottom.offset(0);
            make.right.offset(0);
        }];

        return cell;
    }else{
        
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuUICollectionViewCell" forIndexPath:indexPath];
        
        return cell;
    }
}


// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.collectionview) {
        return 10;
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
        NSDictionary *dt = self.dataArray[indexPath.item];
        
        if ([dt[@"ios"] isKindOfClass:[NSDictionary class]]) {
            UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:dt[@"ios"] controller:self];
            if (board == nil) {
                [self presentLoadingTips:@"信息读取失败！"];
            }
            return;
        }
        
    }else{
      
    }
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionview) {
        return CGSizeMake((SCREEN.size.width-70)/2.3, 60);
    }else{
        return CGSizeZero;
    }
}
#pragma mark - --- FSGridLayoutViewDelegate ---
-(void)FSGridLayouClickCell:(FSGridLayoutView *)flview itemDt:(NSDictionary *)itemDt{
    LFLog(@"itemDt:%@",itemDt);
    if ([itemDt[@"ios"] isKindOfClass:[NSDictionary class]]) {
        
        if ([itemDt[@"ios"][@"ios_class"] isEqualToString:@"ChildVaccinationMainViewController"]) {
            if (!self.childArray.count) {
                [self.navigationController pushViewController:[[ChildAddInfoViewController alloc]init] animated:YES];
            }else{
                ChildVaccinationMainViewController *detail = [[ChildVaccinationMainViewController alloc]init];
                detail.child_id = self.childArray[0][@"child_id"];
                [self.navigationController pushViewController:detail animated:YES];
            }
            return;
        }
        UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:itemDt[@"ios"] controller:self];
        if (board == nil) {
            [self presentLoadingTips:@"信息读取失败！"];
        }
        return;
    }
}

#pragma mark - *************儿童保健*************
-(void)requestData{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }

    LFLog(@"儿童保健dt:%@",dt);
    //    if (self.cat_id) {
    //        [dt setObject:self.cat_id forKey:@"cat_id"];
    //    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ChildCareListUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"儿童保健:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.childArray removeAllObjects];
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dt in response[@"data"]) {
                    [self.childArray addObject:dt];
                }
                [self UpateHeaderview];
            }else{
                [self presentLoadingTips:@"数据格式错误！"];
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
#pragma mark - *************儿童保健图片*************
-(void)requestDataPicture{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    LFLog(@"儿童保健图片dt:%@",dt);
    //    if (self.cat_id) {
    //        [dt setObject:self.cat_id forKey:@"cat_id"];
    //    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ChildCareHomePictureUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"儿童保健图片:%@",response);
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
                        self.jsonDt = @{@"images":@[@{@"children":@[@{@"image":jzArr[0][keystr],@"data":jzArr[0],@"weight":@1},
                                                                    @{@"image":jzArr[1][keystr],@"data":jzArr[1],@"weight":@1}],
                                                      @"height":@65,@"orientation":@"h",@"Margins":@0,@"space":@0}]};
                    }
                }
                if ([response[@"data"][@"banner"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *tdt in response[@"data"][@"banner"]) {
                        [self.dataArray addObject:tdt];
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
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,RecommendArticleListUrl) params:dt success:^(id response) {
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

@end
