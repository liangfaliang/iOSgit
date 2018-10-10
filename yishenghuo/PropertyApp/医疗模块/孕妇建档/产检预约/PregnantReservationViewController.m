//
//  PregnantReservationViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/28.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PregnantReservationViewController.h"
#import "ShopOtherTableViewCell.h"
#import "PregnantFileHomeViewController.h"
#import "AlertSelectTimeView.h"
@interface PregnantReservationViewController ()<UITableViewDelegate,UITableViewDataSource,AlertSelectTimeViewDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (strong,nonatomic)NSMutableArray *freeArr;//免费
@property (strong,nonatomic)NSMutableArray *chargeArr;//收费
@property (strong,nonatomic)NSMutableArray *dateArr;
@property (strong,nonatomic)NSArray *phy_timeArr;
@property (strong,nonatomic)NSString *phy_time;
@property (strong,nonatomic)NSString *address;
@property(nonatomic,strong)baseTableview *alertTableView;
@property (assign,nonatomic)BOOL isUnfold;//是否展开
@property (nonatomic,strong)AlertSelectTimeView *alertView;
@end

@implementation PregnantReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isUnfold = NO;
    self.navigationBarTitle = @"产检预约";
    [self createUI];
    [self requestDataChildRelation:YES];
}
-(NSMutableArray *)dateArr{
    if (_dateArr == nil) {
        _dateArr = [[NSMutableArray alloc]init];
    }
    return _dateArr;
}
-(NSMutableArray *)chargeArr{
    if (_chargeArr == nil) {
        _chargeArr = [[NSMutableArray alloc]init];
        
    }
    return _chargeArr;
}
-(NSMutableArray *)freeArr{
    if (_freeArr == nil) {
        _freeArr = [[NSMutableArray alloc]init];
    }
    return _freeArr;
}
-(AlertSelectTimeView *)alertView{
    if (_alertView == nil) {
        _alertView = [[AlertSelectTimeView alloc]initWithFrame:CGRectMake(0, - NaviH, SCREEN.size.width, SCREEN.size.height + NaviH)];
        _alertView.backgroundColor = [UIColor clearColor];
        _alertView.delegate = self;
    }
    return _alertView;
}
-(void)createUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height ) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = JHColor(222, 222, 222);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"itemcell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"timecell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    UIView * foootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 300)];
    UIButton * submitBtn = [[UIButton alloc]init];
    [submitBtn setImage:[UIImage imageNamed:@"yuyueyunfu"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(employsubmitClick) forControlEvents:UIControlEventTouchUpInside];
    [foootview addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(70);
        make.centerX.equalTo(foootview.mas_centerX);
    }];
    self.tableView.tableFooterView = foootview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return 3;
    }
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            if (self.isUnfold) {
                return self.freeArr.count;
            }
            return self.freeArr.count > 2 ? 2 :self.freeArr.count;
        }else if (section == 1){
            return self.chargeArr.count;
        }
        return 2;
    }
    return self.phy_timeArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && self.freeArr.count) {
        return 50;
    }
    if (section == 1 && self.chargeArr.count) {
        return 50;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 1 || (section == 0 && !self.freeArr.count) || (section == 1 && !self.chargeArr.count)) {
        return nil;
    }
    UIView *header = [[UIView alloc]init];
    UIButton *btn  =[[UIButton alloc]init];
    [header addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(header.mas_centerY);
    }];
    [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    if (section ==0) {
        [btn setTitle:@"   免费检查项目" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"mianfei_yunfu"] forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"   自费检查项目" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"zifei_yunfu"] forState:UIControlStateNormal];
    }
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        UIButton *btn = [[UIButton alloc]init];
       
        if (section ==0) {
            if (self.freeArr.count > 2) {
                btn.backgroundColor = JHColor(233, 241, 228);
                [btn addTarget:self action:@selector(unfoldClick) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitleColor:JHsimpleColor forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                if (self.isUnfold) {
                    [btn setImage:[UIImage imageNamed:@"shouqi_yunfu"] forState:UIControlStateNormal];
                }else{
                    [btn setImage:[UIImage imageNamed:@"shouqidown_yunfu"] forState:UIControlStateNormal];
                }
                [btn setTitle:@"   展开" forState:UIControlStateNormal];
            }
        }
        if (section ==1) {
             btn.backgroundColor = JHColor(229, 233, 233);
        }
        if (section == 2) {
            double price = 0.0;
            for (NSDictionary *free in self.freeArr) {
                price += [free[@"price"] doubleValue];
            }
            for (NSDictionary *free in self.chargeArr) {
                price += [free[@"price"] doubleValue];
            }
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:JHMedicalColor forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"合计费用： ￥%.2f",price] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
        return btn;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if (section == 0 && self.freeArr.count > 2 ) {
            return 30;
        }
        if (section == 1 && self.chargeArr.count) {
            return 10;
        }
        if (section == 2) {
            return 40;
        }
    }
    return 0.001;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section ==1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemcell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@   ￥%@",self.freeArr[indexPath.row][@"name"],self.freeArr[indexPath.row][@"price"]];
            cell.contentView.backgroundColor = JHColor(244, 248, 241);
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"%@   ￥%@",self.chargeArr[indexPath.row][@"name"],self.chargeArr[indexPath.row][@"price"]];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        cell.textLabel.textColor = JHdeepColor;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    ShopOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timecell"];
    cell.rigthtIm.hidden = YES;
    cell.contentLbLeft.constant = 10;
    cell.contentLb.textColor  =JHdeepColor;
    cell.contentLb.font = [UIFont systemFontOfSize:15];
    cell.contentLbLeft.constant = 0;
    if (indexPath.row == 0) {
        cell.nameLabel.text = @"体检时间：";
        if (self.phy_time) {
            cell.contentLb.text = self.phy_time;
        }else{
            cell.contentLb.text =nil;
        }
        cell.contentLb.textAlignment = NSTextAlignmentRight;
        cell.contentRight.constant = 40;
        cell.rigthtIm.hidden = NO;
        
    }else{
        cell.nameLabel.text = @"体检地点：";
        cell.contentLb.textAlignment = NSTextAlignmentLeft;
        if (self.address) {
            cell.contentLb.text = self.address;
        }
    }
    cell.nameHeight.constant = [cell.nameLabel.text selfadap:15 weith:20].width + 10;
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self.alertView showAlertview:self.dateArr];
    }
    
}
#pragma mark AlertSelectTimeViewDelegate
-(void)AlertSelectTimeViewDidSelectCell:(AlertSelectTimeView *)alertview phy_timeArr:(NSArray *)phyArr Indexpath:(NSIndexPath *)indexpath{
    LFLog(@"phyArr:%@",phyArr[indexpath.row]);
    self.phy_time = phyArr[indexpath.row];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)PickerSelectorIndixString:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    NSLog(@"%@",str);

    
}
-(void)unfoldClick{
    self.isUnfold = !self.isUnfold;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark 详情
-(void)requestDataChildRelation:(BOOL)isFirst{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.planid) {
        [dt setObject:self.planid forKey:@"tid"];
    }
    if (self.itemid) {
        [dt setObject:self.itemid forKey:@"cid"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PregnantCheckPlanSumbitDetailUrl) params:dt success:^(id response) {
        LFLog(@"详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSDictionary class]] ) {
                [self.freeArr removeAllObjects];
                [self.chargeArr removeAllObjects];
                if (([response[@"data"][@"vaccinate_isfree"] isKindOfClass:[NSArray class]] )) {
                    for (NSDictionary *freedt in response[@"data"][@"vaccinate_isfree"]) {
                        [self.freeArr addObject:freedt];
                    }
                    
                }
                if (([response[@"data"][@"vaccinate_notfree"] isKindOfClass:[NSArray class]] )) {
                    for (NSDictionary *freedt in response[@"data"][@"vaccinate_notfree"]) {
                        [self.chargeArr addObject:freedt];
                    }
                    
                }
                if (([response[@"data"][@"date"] isKindOfClass:[NSArray class]] )) {
                    [self.dateArr removeAllObjects];
                    for (NSString *str in response[@"data"][@"date"]) {
                        [self.dateArr addObject:str];
                        if (!self.phy_time) {
                            self.phy_time = str;
                        }
                    }
                }
                if (([response[@"data"][@"address"] isKindOfClass:[NSString class]] )) {
                    self.address = response[@"data"][@"address"];
                }
            }
            [self.tableView reloadData];
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self requestDataChildRelation:YES];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"请求失败！"];
    }];
    
}


#pragma mark 提交
-(void)employsubmitClick{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }

    if (!self.phy_time) {
        [self presentLoadingTips:@"请选择预约时间！"];
        return;
    }
    [dt setObject:self.phy_time forKey:@"expect_time"];
    [self upDateInfo:dt];
}
-(void)upDateInfo:(NSMutableDictionary *)dt{
    [self presentLoadingTips];
    
    LFLog(@"产检提交dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PregnantCheckPlanSumbitUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"产检提交：%@",response);
        [self dismissTips];
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"提交成功"];
            [self performSelector:@selector(successClick) withObject:nil afterDelay:.2];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"提交失败，网络错误！"];
    }];
}
-(void)successClick{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[PregnantFileHomeViewController class]]) {
            [((PregnantFileHomeViewController *)vc) update];
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
