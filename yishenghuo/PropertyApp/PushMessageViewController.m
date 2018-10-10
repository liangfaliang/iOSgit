//
//  PushMessageViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/27.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "PushMessageViewController.h"
#import "PushMessageTableViewCell.h"
#import "APPheadlinesViewController.h"//APP头条
#import "ActivityViewController.h"//社区活动
#import "ShopDoodsDetailsViewController.h"//商品详情
#import "CateringViewController.h"//社区食堂
#import "SatisfactionListViewController.h"//满意度调查
#import "HouseRentingViewController.h"//房屋租售
#import "PayViewController.h"//物业缴费
#import "CityNewsViewController.h"//城市新闻
#import "PeripheralBusinessViewController.h"//周边商业
#import "InformationViewController.h"//社区资讯
@interface PushMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableveiw;

@end

@implementation PushMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"消息中心";
    [self creatableveiw];
//    if (!self.dataArray.count) {
//        [self UploadDatalateContingency];
//    }

}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}

-(void)creatableveiw{
    
    self.tableveiw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableveiw.delegate = self;
    self.tableveiw.dataSource = self;
    self.tableveiw.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableveiw registerClass:[UITableViewCell class] forCellReuseIdentifier:@"attendcell"];
    [self.view addSubview:self.tableveiw];
    [self.tableveiw registerNib:[UINib nibWithNibName:@"PushMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"PushMessageTableViewCell"];
    self.tableveiw.emptyDataSetSource = self;
    self.tableveiw.emptyDataSetDelegate = self;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PushMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PushMessageTableViewCell"];
    NSDictionary *dt = self.dataArray[indexPath.section];
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dt[@"index_img"]]] placeholderImage:[UIImage imageNamed:@""]];
    cell.typeLabel.text = [NSString stringWithFormat:@"%@",dt[@"desc"]];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@",dt[@"add_time"]];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",dt[@"title"]];
    cell.timeLbWidth.constant = [cell.timeLabel.text selfadap:12 weith:20].width + 5;
    if ([[NSString stringWithFormat:@"%@",dt[@"is_read"]] isEqualToString:@"0"]) {
        cell.markView.hidden = NO;
    }else{
        cell.markView.hidden = YES;
    }
    
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *board = nil;
    NSDictionary *dt = self.dataArray[indexPath.section];
    NSString *keyid = [NSString stringWithFormat:@"%@",dt[@"type_id"]];
    NSString *keywords = [NSString stringWithFormat:@"%@",dt[@"type"]];
    if ([keywords isEqualToString:@"goods"]) {//商品
        ShopDoodsDetailsViewController *good = [[ShopDoodsDetailsViewController alloc]init];
        good.goods_id = keyid;
        board = good;
    }
    if ([keywords isEqualToString:@"sqst"]) {//社区食堂
        board = [[CateringViewController alloc]init];
    }
    if ([keywords isEqualToString:@"myddc"]) {//满意度调查
        board = [[SatisfactionListViewController alloc]init];
    }
    if ([keywords isEqualToString:@"fwzs"]) {//房屋租售
        board = [[HouseRentingViewController alloc]init];
    }
    if ([keywords isEqualToString:@"sqhd"]) {//社区新活动
        board = [[ActivityViewController alloc]init];
    }
    if ([keywords isEqualToString:@"wyjf"]) {//物业缴费
        board = [[PayViewController alloc]init];
    }
    if ([keywords isEqualToString:@"apptt"]) {//物业头条
        board = [[APPheadlinesViewController alloc]init];
    }
    if ([keywords isEqualToString:@"csxw"]) {//城市新闻
        board = [[CityNewsViewController alloc]init];
    }
    if ([keywords isEqualToString:@"zbsy"]) {//周边商业
        board = [[PeripheralBusinessViewController alloc]init];
    }
    if ([keywords isEqualToString:@"sqzx"]) {//社区资讯
        board = [[InformationViewController alloc]init];
    }
    if ([keywords isEqualToString:@"runtime"]) {//runtime跳转
        board = [[UserModel shareUserModel] runtimePushviewController:dt controller:self];
        // 类名
//        NSString *class =[NSString stringWithFormat:@"%@", dt[@"ios_class"]];
//        const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
//        
//        // 从一个字串返回一个类
//        Class newClass = objc_getClass(className);
//        if (!newClass)
//        {
//            // 创建一个类
//            Class superClass = [NSObject class];
//            newClass = objc_allocateClassPair(superClass, className, 0);
//            // 注册你创建的这个类
//            objc_registerClassPair(newClass);
//        }
//        // 创建对象
//        id instance = [[newClass alloc] init];
//        
//        NSDictionary *propertys = dt[@"property"];
//        [propertys enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            // 检测这个对象是否存在该属性
//            if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
//                // 利用kvc赋值
//                [instance setValue:obj forKey:key];
//            }
//        }];
//        LFLog(@"instance:%@",instance);
//        board = instance;
//        
//        if (![board respondsToSelector:@selector(viewDidLoad)]) {
//            board = nil;
//        }
        
        
    }
    

    if (board) {
        [self UploadDataHaveRead:dt[@"log_id"]];
        [self.navigationController pushViewController:board animated:YES];
    }else{
        [self presentLoadingTips:@"消息读取失败！"];
    }



    
}

/**
 *  检测对象是否存在该属性
 */
- (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName
{
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    return NO;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIImageView *view = [[UIImageView alloc]init];
    view.image = [UIImage imageNamed:@"fengexiantongyong"];
    
    return view;
    
}
-(NSMutableAttributedString *)AttributedString:(NSString *)allstr attstring:(NSString *)attstring{
    NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:allstr];
    NSString *str = attstring;
    NSRange range =[[htinstr string]rangeOfString:str];
    [htinstr addAttribute:NSForegroundColorAttributeName value:JHColor(102, 102, 102) range:range];
    [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    return htinstr;
    
}
#pragma mark - *************推送消息*************
-(void)UploadDatalateContingency{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PushMessageListUrl) params:dt success:^(id response) {
        LFLog(@"推送消息：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                [self.dataArray addObject:dt];
            }
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDatalateContingency];
                    }
                    
                }];
            }
            [self presentLoadingTips:[NSString stringWithFormat:@"%@",response[@"status"][@"error_desc"]]];
        }
        [self.tableveiw reloadData];
        
    } failure:^(NSError *error) {
        [_tableveiw.mj_header endRefreshing];
    }];
    
}

#pragma mark - *************推送消息已读*************
-(void)UploadDataHaveRead:(NSString *)log_id{
    NSDictionary * nameuser =[userDefaults objectForKey:@"nameuser"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (nameuser) {
        [dt setObject:nameuser forKey:@"tag"];
    }
    if (log_id) {
        [dt setObject:log_id forKey:@"log_id"];
    }
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PushMessageReadUrl) params:dt success:^(id response) {
        LFLog(@"推送消息反馈：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
        }else{
        }
    } failure:^(NSError *error) {
        [_tableveiw.mj_header endRefreshing];
    }];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self UploadDatalateContingency];
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableveiw.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self UploadDatalateContingency];
    }];
    
    
}


@end
