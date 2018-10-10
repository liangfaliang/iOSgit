//
//  ExpressViewController.m
//  shop
//
//  Created by 梁法亮 on 16/8/22.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "ExpressViewController.h"
#import "ExpressTableViewCell.h"
#import "Expressmodel.h"
#import "finishModel.h"
@interface ExpressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableveiw;

@property (strong,nonatomic)UIView *view1;
@property (strong, nonatomic) NSArray *segementArray;


@property(strong,nonatomic)UIView *footview;

@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIView *vline;

@property(strong,nonatomic)UIImageView *imagefootview;
@property(nonatomic,strong)NSMutableArray *NotgetArr;
@property(nonatomic,strong)NSMutableArray *finishArr;
//数据请求对象
@property(nonatomic,strong)NSMutableArray *requestArr;

@property(nonatomic,assign)CGSize cellsize;
@end

@implementation ExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle = @"快递通知";
    self.segementArray = @[@"待领快递",@"已领快递"];
    self.cellsize = [UIImage imageNamed:@"tupian_kuaiditongzhi-"].size;
    self.view.backgroundColor = [UIColor whiteColor];

    [self creatSegment];
    [self creatableveiw];
    [self setupRefresh];
    [self UploadDatalateContingency];
    [self UploadDatalatefinish];
    
}
- (NSMutableArray *)requestArr
{
    if (_requestArr == nil) {
        _requestArr = [[NSMutableArray alloc]init];
    }
    return _requestArr;
}

- (NSMutableArray *)NotgetArr
{
    if (_NotgetArr == nil) {
        _NotgetArr = [[NSMutableArray alloc]init];
    }
    return _NotgetArr;
}
- (NSMutableArray *)finishArr
{
    if (_finishArr == nil) {
        _finishArr = [[NSMutableArray alloc]init];
    }
    return _finishArr;
}



- (void)creatSegment
{
    

    
    self.view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 60)];
    //    [self.view1 addSubview:self.segment];
    self.view1.backgroundColor = JHColor(235, 235, 241);
    
    for (int i = 0; i < 2; i ++) {
        UIButton *segbtn = [[UIButton alloc]initWithFrame:CGRectMake(i * SCREEN.size.width/2, 0, SCREEN.size.width/2, 48)];
        segbtn.tag = i;
        segbtn.backgroundColor = [UIColor whiteColor];
        [segbtn setTitle:self.segementArray[i] forState:UIControlStateNormal];
        [self.view1 addSubview:segbtn];
        if (i == 0) {
            [segbtn setTitleColor:JHMaincolor forState:UIControlStateNormal];
            self.selectBtn = segbtn;
            
            
        }else{
            [segbtn setTitleColor:JHColor(53, 53, 53) forState:UIControlStateNormal];
            
            
        }
        [segbtn addTarget:self action:@selector(segmentclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.vline =[[UIView alloc]initWithFrame:CGRectMake(10, 48, SCREEN.size.width/2 - 20, 2)];
    self.vline.backgroundColor = JHMaincolor ;
    [self.view1 addSubview:self.vline];
}
#pragma mark 选择按钮
-(void)segmentclick:(UIButton *)seg{
    
    
    if (self.selectBtn.tag !=seg.tag) {
        [self.selectBtn setTitleColor:JHColor(53, 53, 53) forState:UIControlStateNormal];
        [seg setTitleColor:JHMaincolor forState:UIControlStateNormal];
        
    }
        self.selectBtn = seg;
    NSInteger Index = seg.tag;
    if (Index == 0) {
        
        self.vline.center = CGPointMake(SCREEN.size.width/4, 49);

        [self.tableveiw reloadData];
    }else{
        
        self.vline.center = CGPointMake(SCREEN.size.width/4 * 3, 49);
     
        [self.tableveiw reloadData];
    }
    
    

}



-(void)creatableveiw{
    
    self.tableveiw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableveiw.delegate = self;
    self.tableveiw.dataSource = self;
    self.tableveiw.tableHeaderView = self.view1;

    self.tableveiw.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableveiw registerClass:[ExpressTableViewCell class] forCellReuseIdentifier:@"ExpressTableViewCell"];
    [self.tableveiw registerClass:[ExpressTableViewCell class] forCellReuseIdentifier:@"attendcell"];
    
    [self.view addSubview:self.tableveiw];
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    

    return 10;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.selectBtn.tag == 0) {
        return self.NotgetArr.count;
        
    }
    
    return self.finishArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectBtn.tag == 0) {
  
            return self.cellsize.height + 140;
   
    }else{
        
        return 150;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectBtn.tag == 0) {
        ExpressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpressTableViewCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.NotgetArr[indexPath.section];
  
        [cell setBlock:^(NSString *str) {
            [self affirmUploadDatalate:str];
            
        }];
        return cell;
    }else{
        
        ExpressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attendcell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.finishmodel = self.finishArr[indexPath.section];
        
        return cell;
        
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *footview = [[UIView alloc]init];
    footview.backgroundImage = [UIImage imageNamed:@"caitiao"];
    

    return footview;
}

-(NSMutableAttributedString *)AttributedString:(NSString *)allstr attstring:(NSString *)attstring{
    NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:allstr];
    NSString *str = attstring;
    NSRange range =[[htinstr string]rangeOfString:str];
    [htinstr addAttribute:NSForegroundColorAttributeName value:JHColor(102, 102, 102) range:range];
    [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    return htinstr;
    
}

#pragma mark - *************待领快递*************
-(void)UploadDatalateContingency{
    NSString *usid = [UserDefault objectForKey:@"useruid"];
    if (usid == nil) {
        usid = @"";
    }
    LFLog(@"usid:%@",usid);
    NSDictionary *dt = @{@"userid":usid};
    
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"59") params:dt success:^(id response) {
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
        LFLog(@"response:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
                [self.NotgetArr removeAllObjects];
                for (NSDictionary *dt in response[@"note"]) {
                    Expressmodel *model = [[Expressmodel alloc]initWithDictionary:dt error:nil];
                    [self.NotgetArr addObject:model];
                    
                }
                [self.tableveiw reloadData];
            }
        
    } failure:^(NSError *error) {
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - *************确认领取*************
-(void)affirmUploadDatalate:(NSString *)expressId{
    NSString *usid = [UserDefault objectForKey:@"useruid"];
    if (usid == nil) {
        usid = @"";
    }
    LFLog(@"usid:%@",usid);
    NSDictionary *dt = @{@"userid":usid,@"id":expressId};
    
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"60") params:dt success:^(id response) {
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
        LFLog(@"response:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            
            [self presentLoadingTips:@"领取成功"];
            [self UploadDatalatefinish];
            UIButton *btn = [self.view viewWithTag:1];
            [self segmentclick:btn];
        }else{
            
            [self presentLoadingTips:response[@"err_msg"]];
        }
        
    } failure:^(NSError *error) {
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - *************已领快递*************
-(void)UploadDatalatefinish{
    NSString *usid = [UserDefault objectForKey:@"useruid"];
    if (usid == nil) {
        usid = @"";
    }
    LFLog(@"usid:%@",usid);
    NSDictionary *dt = @{@"userid":usid};
    
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"58") params:dt success:^(id response) {
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
        LFLog(@"response:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            [self.finishArr removeAllObjects];
            for (NSDictionary *dt in response[@"note"]) {
                
                finishModel *model = [[finishModel alloc]initWithDictionary:dt error:nil];
                [self.finishArr addObject:model];
                
            }
            [self.tableveiw reloadData];
        }
        
    } failure:^(NSError *error) {
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
    }];
    
    
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableveiw.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.selectBtn.tag == 0) {
            [self UploadDatalateContingency];
            
        }else{
            [self UploadDatalatefinish];
        }
    }];
    
}


@end
