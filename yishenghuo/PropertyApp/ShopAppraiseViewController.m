
//
//  ShopAppraiseViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/19.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "ShopAppraiseViewController.h"
#import "GoodsReviewTableViewCell.h"
#import "UIButton+WebCache.h"
#import "STPhotoBroswer.h"
#import "ShopReplyEvaluateViewController.h"
#import <WebKit/WebKit.h>
@interface ShopAppraiseViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray *evaluateArr;//评论列表
@property(nonatomic,strong)NSString *htmlStr;
@property(nonatomic,strong)UIView *detailHeaderview;
@property(nonatomic,strong)UIView *vline;
@property (strong, nonatomic) NSArray *segementArray;
@property(nonatomic,strong)UIWebView *webview;
@property (nonatomic,strong)NSMutableArray *goodsArr;//详情
@property (nonatomic,strong)NSDictionary *countDt;//详情
@property (nonatomic,strong)UIView *commentHeaderView;//评论个数
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;

@property(nonatomic,strong)NSString *rank_type;//	评论类型
@property(nonatomic,strong)NSString *is_imgurl;//是否有图片

@end

@implementation ShopAppraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.rank_type = @"0";
    self.is_imgurl = @"0";
    self.more = @"1";
    self.page = 1;
    self.segementArray = @[@"商品详情",@"规格参数",@"商品评论"];
    [self createTableview];
    [self setupRefresh];
    [self createdetailHeaderview];
    [self UploadDatagoods];
    [self UploadDatagoodsdescribe];
    [self UploadDatagoodsEvaluateCount];
    [self UploadDatagoodsEvaluateList:self.page];
}
- (NSMutableArray *)evaluateArr
{
    if (!_evaluateArr) {
        _evaluateArr = [[NSMutableArray alloc]init];
    }
    return _evaluateArr;
}
- (NSMutableArray *)goodsArr
{
    if (!_goodsArr) {
        _goodsArr = [[NSMutableArray alloc]init];
    }
    return _goodsArr;
}
-(void)createTableview{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 64) style:UITableViewStyleGrouped];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.detailHeaderview;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"detailview"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsReviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsReviewTableViewCell"];
    [self.view addSubview:self.tableView];
}


-(void)createdetailHeaderview{
    self.detailHeaderview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 50)];
    //    [self.view1 addSubview:self.segment];
    self.detailHeaderview.backgroundColor = JHColor(235, 235, 241);
    
    for (int i = 0; i < 3; i ++) {
        UIButton *segbtn = [[UIButton alloc]initWithFrame:CGRectMake(i * SCREEN.size.width/3, 0, SCREEN.size.width/3, 48)];
        segbtn.tag = i + 100;
        segbtn.backgroundColor = [UIColor whiteColor];
        [segbtn setTitle:self.segementArray[i] forState:UIControlStateNormal];
        segbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        segbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.detailHeaderview addSubview:segbtn];
        if (i == 0) {
            [segbtn setTitleColor:JHshopMainColor forState:UIControlStateNormal];
            self.selectBtn = segbtn;
            
            
        }else{
            [segbtn setTitleColor:JHColor(53, 53, 53) forState:UIControlStateNormal];
            
            
        }
        [segbtn addTarget:self action:@selector(segmentclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.vline =[[UIView alloc]initWithFrame:CGRectMake(0, 48, SCREEN.size.width/3, 2)];
    self.vline.backgroundColor = JHshopMainColor ;
    [self.detailHeaderview addSubview:self.vline];
    self.tableView.tableHeaderView = self.detailHeaderview;
}
#pragma mark 选择按钮
-(void)segmentclick:(UIButton *)seg{
    
    
    if (self.selectBtn.tag !=seg.tag) {
        [self.selectBtn setTitleColor:JHColor(53, 53, 53) forState:UIControlStateNormal];
        [seg setTitleColor:JHshopMainColor forState:UIControlStateNormal];
    }
    self.selectBtn = seg;
    NSInteger Index = seg.tag - 100;
    if (Index == 0) {
        self.tableView.mj_header.hidden = YES;
        self.vline.center = CGPointMake(SCREEN.size.width/3/2, 49);
        [self.tableView reloadData];
        
    }else if (Index == 1){
        self.vline.center = CGPointMake(SCREEN.size.width/2 , 49);
        self.tableView.mj_header.hidden = YES;
        [self.tableView reloadData];
    }else{
        
        self.tableView.mj_header.hidden = NO;
        self.vline.center = CGPointMake(SCREEN.size.width - SCREEN.size.width/3/2 , 49);
        
        [self.tableView reloadData];
    }
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

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

    return 0.01;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.selectBtn.tag == 100) {
        return SCREEN.size.height - 50 -64;
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
            
            NSString *str = @"";
            if ([dt[@"admin_reply"] isKindOfClass:[NSNull class]]) {
                str = dt[@"admin_reply"][@"content"];
            }

            if (str.length > 0) {
                NSString *admin_content =  [NSString stringWithFormat:@"商家回复：%@",str];
                HH += [admin_content selfadap:12 weith:20].height;
            }
            
            
            return HH + 105;
        }
        
        return SCREEN.size.height - 50;
        
    }else  if (self.selectBtn.tag == 101){
        if (self.goodsArr.count) {
            NSArray *array = self.goodsArr[0][@"properties"];
            if (array.count) {
                return 50;
            }
        }
    }
   return SCREEN.size.height - 50;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *CellIdentifier = @"detailview";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (self.selectBtn.tag == 100) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        if (self.webview == nil) {
            self.webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 164)];
            self.webview.scrollView.delegate = self;
//            self.webview.scrollView.scrollEnabled = NO;
            
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
        cell.imageView.image = [UIImage imageNamed:@"wuneirong"];
        cell.textLabel.text = @"";
        if (self.goodsArr.count) {
            NSArray *array = self.goodsArr[0][@"properties"];
            if (array.count) {
                cell.textLabel.text = array[indexPath.row][@"name"];
                cell.detailTextLabel.text = array[indexPath.row][@"value"];
                cell.imageView.image = nil;
            }
        }
        [cell.contentView addSubview:cell.imageView];
        [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20);
            make.centerX.equalTo(cell.contentView.mas_centerX);
        }];
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
            
            [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:dt[@"headimage"]] placeholderImage:[UIImage imageNamed:@"morentouxiang-zhijie"]];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",dt[@"username"]];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@",dt[@"add_time"]];
            cell.buyTimeLb.text = [NSString stringWithFormat:@"购买日期：%@",dt[@"buy_time"]];
            cell.contentLabel.text = [NSString stringWithFormat:@"%@",dt[@"content"]];
            cell.replycount.text = [NSString stringWithFormat:@"%@",dt[@"re_count"]];
            cell.likeLabel.text = [NSString stringWithFormat:@"%@",dt[@"agree_count"]];
            if ([[NSString stringWithFormat:@"%@",dt[@"is_agree"]] isEqualToString:@"0"]) {//未点赞
                [cell.likeView setImage:[UIImage imageNamed:@"dianzanmoren"] forState:UIControlStateNormal];
            }else{
                [cell.likeView setImage:[UIImage imageNamed:@"dianzna123"] forState:UIControlStateNormal];
            }
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
            NSString *admin_content = @"";
            if ([dt[@"admin_reply"] isKindOfClass:[NSNull class]]) {
                admin_content = dt[@"admin_reply"][@"content"];
            }
            if (admin_content.length > 0) {
                cell.BusinessLabel.text = [NSString stringWithFormat:@"商家回复：%@",admin_content];
                cell.businessHeight.constant = [cell.BusinessLabel.text selfadap:12 weith:20].height;
            }else{
                cell.businessHeight.constant = 0;
                
            }
            __weak typeof(self) weakSelf = self;
            cell.likeBlock = ^(){
                [weakSelf UploadDatagoodsEvaluationLike:dt[@"id"] index:indexPath.row];
            };
            
            
            return cell;
            
        }else{
            NSString *cellid = @"parametercell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.imageView.image = [UIImage imageNamed:@"wuneirong"];
            [cell.contentView addSubview:cell.imageView];
            [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(20);
                make.centerX.equalTo(cell.contentView.mas_centerX);
            }];
            return cell;
            
        }
        
    }
    
    return cell;


}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (self.selectBtn.tag == 102) {
        if (self.countDt.count) {
            return 55;
        }
        
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.selectBtn.tag == 102) {
        if (self.countDt.count) {
            if (self.commentHeaderView == nil) {
                self.commentHeaderView = [[UIView alloc]init];
                self.commentHeaderView.backgroundColor = [UIColor whiteColor];
                NSArray *nameArr = @[@"全部评价",@"好评",@"中评",@"差评",@"晒图"];
                NSArray *keyArr = @[@"all",@"good",@"commonly",@"bad",@"imgurl"];
                for (int i = 0; i < nameArr.count ; i ++) {
                    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN.size.width/5 * i, 0, SCREEN.size.width/5, 55)];
                    [btn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    UILabel *lb = [[UILabel alloc]initWithFrame:btn.frame];
                    
                    lb.numberOfLines = 0;
                    
                    NSString *text = [NSString stringWithFormat:@"%@\n%@",nameArr[i],self.countDt[keyArr[i]]];
                    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
                    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                    [paragraphStyle1 setLineSpacing:8];
                    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
                    [lb setAttributedText:attributedString1];
                    if (i == 0) {
                        lb.textColor = JHshopMainColor;
                    }else{
                        lb.textColor = JHdeepColor;
                    }
                    
                    lb.font = [UIFont systemFontOfSize:15];
                    lb.textAlignment = NSTextAlignmentCenter;
                    [self.commentHeaderView addSubview:lb];
                    [self.commentHeaderView addSubview:btn];
                    
                }
            }
            
            return self.commentHeaderView;
        }
        
    }
    return nil;

}
-(void)commentBtnClick:(UIButton *)btn{

    CGFloat index = btn.frame.origin.x / (SCREEN.size.width/5);
    LFLog(@"btn.frame.origin.x:%f",btn.frame.origin.x);
    LFLog(@"SCREEN.size.width/5:%f",SCREEN.size.width/5);
    LFLog(@"index:%f",index);
    self.page = 1;
    self.more = @"1";
    if (index != 4) {
        self.rank_type = [NSString stringWithFormat:@"%f",index];
        self.is_imgurl = @"0";
    }else{
        self.rank_type = @"0";
        self.is_imgurl = @"2";
    }
    [self UploadDatagoodsEvaluateList:self.page];
    for (UILabel *lb in self.commentHeaderView.subviews) {
        if ([lb isKindOfClass:[UILabel class]]) {
            if (lb.frame.origin.x == btn.frame.origin.x) {
                lb.textColor = JHshopMainColor;
            }else{
                lb.textColor = JHdeepColor;
            }
        }

    }
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (self.selectBtn.tag == 102){
        if (self.evaluateArr.count) {
            ShopReplyEvaluateViewController *reply = [[ShopReplyEvaluateViewController alloc]init];
            [reply.dataArray addObject:self.evaluateArr[indexPath.row]];
            reply.goods_id = self.goods_id;
            [self.navigationController pushViewController:reply animated:YES];
        }
    }
    

}


// 下拉刷新的原理
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self.selectBtn.tag == 100) {
        if (scrollView.contentOffset.y < - 50) {
            //        if (scrollView == self.main.scrollview) {
            [self.main.scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
            //            self.main.scrollview.contentOffset = CGPointMake(0, 0);
            //        }
        }
    }

}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.selectBtn.tag == 100) {
        if (scrollView.contentOffset.y < - 50) {
            CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
            targetContentOffset->x = targetOffset.x;
            targetContentOffset->y = targetOffset.y;
        }
    }
//    if (scrollView == self.main.scrollview) {

//    }
    
}
- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    //    LFLog(@"偏移量：%f",offset.x);
    if (offset.y >0) {
        return CGPointMake(0, SCREEN.size.height);
    }else{
       
        return CGPointMake(0, 0);
    }
    //    CGFloat pageSize = BUBBLE_DIAMETER + BUBBLE_PADDING;
    //    NSInteger page = roundf(offset.x / pageSize);
    //    CGFloat targetX = pageSize * page;
    
}
#pragma mark - *************商品详情请求*************
-(void)UploadDatagoods{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.goods_id,@"goods_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
   LFLog(@"商品详情dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,goodsUrl) params:dt success:^(id response) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@"商品详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.goodsArr removeAllObjects];
            [self.goodsArr addObject:response[@"data"]];

            [self.tableView reloadData];
            
        }else{
//            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
//            if ([error_code isEqualToString:@"100"]) {
//                [self showLogin];
//            }
//            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
            
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
            [self.tableView reloadData];
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - *************商品评论个数请求*************
-(void)UploadDatagoodsEvaluateCount{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.goods_id,@"goods_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,OrderEvaluateCountStatiUrl) params:dt success:^(id response) {
        LFLog(@"商品评论列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (response[@"data"]) {
                self.countDt = response[@"data"];
                [self.tableView reloadData];
            }
            
            
        }else{
            //            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            //            if ([error_code isEqualToString:@"100"]) {
            //                [self showLogin];
            //            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

#pragma mark - *************商品评论列表请求*************
-(void)UploadDatagoodsEvaluateList:(NSInteger )pagenum{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.goods_id,@"goods_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.rank_type) {
        [dt setObject:self.rank_type forKey:@"rank_type"];
    }
    if (self.is_imgurl) {
        [dt setObject:self.is_imgurl forKey:@"is_imgurl"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"10",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"商品评论列表dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,OrderEvaluateListUrl) params:dt success:^(id response) {
        LFLog(@"商品评论列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            [self.evaluateArr removeAllObjects];
            for (NSDictionary *dict in response[@"data"]) {
                NSMutableDictionary *mdt = [NSMutableDictionary dictionaryWithDictionary:dict];
                [self.evaluateArr addObject:mdt];
            }
            [self.tableView reloadData];
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    self.page = 1;
                    self.more = @"1";
                    [self UploadDatagoodsEvaluateList:self.page];
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark - *************商品点赞
-(void)UploadDatagoodsEvaluationLike:(NSString *)parent_id index:(NSInteger )index{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.goods_id,@"goods_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (parent_id) {
        [dt setObject:parent_id forKey:@"parent_id"];
    }
    
    LFLog(@"dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,OrderEvaluateLikeUrl) params:dt success:^(id response) {
        [self dismissTips];
        LFLog(@"评价：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            
            NSMutableDictionary *mdt = self.evaluateArr[index];
            if ([[NSString stringWithFormat:@"%@",mdt[@"is_agree"]] isEqualToString:@"0"]) {
                [self presentLoadingTips:@"您已点赞成功"];
                [mdt setObject:@"1" forKey:@"is_agree"];
            }else{
                [self presentLoadingTips:@"您已取消"];
                [mdt setObject:@"0" forKey:@"is_agree"];
            }
            
            [self.tableView reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"评价error：%@",error);
        [self dismissTips];
    }];
    
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self UploadDatagoodsEvaluateList:self.page];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多数据了"];
            [self.tableView.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self UploadDatagoodsEvaluateList:self.page];
        }
        
    }];
    
    
}

@end
