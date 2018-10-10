//
//  VaccinationSumbitViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/24.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "VaccinationSumbitViewController.h"
#import "btnFootView.h"
#import "ShopOtherTableViewCell.h"
#import "SelectMedicalTableViewCell.h"
#import "MedicalModel.h"
#import "VaccinationPlanViewController.h"
#import "PickerChoiceView.h"
@interface VaccinationSumbitViewController ()<UITableViewDelegate,UITableViewDataSource,TFPickerDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView *alertView;
@property (strong,nonatomic)NSMutableArray *dateArr;
@property (strong,nonatomic)NSMutableArray *typeArray;
@property (strong,nonatomic)NSArray *phy_timeArr;
@property (strong,nonatomic)NSString *phy_time;
@property (strong,nonatomic)NSString *address;
@property (nonatomic,strong)btnFootView *footer;
@property(nonatomic,strong)baseTableview *alertTableView;

@end

@implementation VaccinationSumbitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"接种预约";
    [self createUI];
    [self addFootview];
    [self requestDataChildRelation:YES];
}
-(NSMutableArray *)typeArray{
    if (_typeArray == nil) {
        _typeArray = [[NSMutableArray alloc]init];;
    }
    return _typeArray;
}
-(NSMutableArray *)dateArr{
    if (_dateArr == nil) {
        _dateArr = [[NSMutableArray alloc]init];;
    }
    return _dateArr;
}
-(void)addFootview{
    self.footer = [[NSBundle mainBundle]loadNibNamed:@"btnFootView" owner:nil options:nil][0];
    self.footer.frame = CGRectMake(0, SCREEN.size.height - 50, SCREEN.size.width, 50);
    [self.footer.clickBtn setTitle:@"预约缴费" forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    [self.footer setBlock:^{//去支付
        [weakSelf submitClick];
    }];
    [self.view addSubview:self.footer];
    [self updateSelectPrice];
}
#pragma mark 更新价格
-(void)updateSelectPrice{
    double price = 0.0;
    for (ItemModel *model in self.typeArray) {
        if ([model.select isEqualToString:@"1"]) {
            price += [model.price doubleValue];
        }
    }

    NSString *current_price = [NSString stringWithFormat:@"%.2f",price];
    NSArray *priceArr = [current_price componentsSeparatedByString:@"."];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计： ￥ %@ ",current_price]];
    text.yy_font = [UIFont boldSystemFontOfSize:15];
    text.yy_color = JHMedicalAssistColor;
    if (priceArr.count > 1) {
        NSRange range0 =[[text string]rangeOfString:priceArr[0]];
        [text yy_setFont:[UIFont systemFontOfSize:20] range:range0];
    }
    
    self.footer.priceYYlb.attributedText = text;
}
-(baseTableview *)alertTableView{
    if (_alertTableView == nil) {
        _alertTableView = [[baseTableview alloc]initWithFrame:CGRectMake(0, _alertView.height - (200 + self.phy_timeArr.count * 50), SCREEN.size.width, (200 + self.phy_timeArr.count * 50)) style:UITableViewStyleGrouped];
        _alertTableView.delegate = self;
        _alertTableView.dataSource = self;
        _alertTableView.separatorColor = JHColor(222, 222, 222);
        [_alertTableView registerNib:[UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"alertcell"];
        _alertTableView.backgroundColor = [UIColor whiteColor];
        UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 40)];
        headerview.backgroundColor = [UIColor whiteColor];
        IndexBtn *btn = [[IndexBtn alloc]init];
        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(alertTableViewAction) forControlEvents:UIControlEventTouchUpInside];
        [headerview addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(60);
            make.right.offset(-10);
            make.top.offset(0);
            make.bottom.offset(0);
            
        }];
        _alertTableView.tableHeaderView = headerview;
    }
    return _alertTableView;
}
-(UIView *)alertView{
    if (_alertView == nil) {
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, - NaviH, SCREEN.size.width, SCREEN.size.height + NaviH)];
        _alertView.backgroundColor = [UIColor clearColor];
        UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, _alertView.height - (200 + self.phy_timeArr.count * 50))];
        //        backview.backgroundColor = [UIColor redColor];
        backview.backgroundColor = JHColoralpha(0, 0, 0, 0.5);
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self     action:@selector(alertTableViewAction)];
        //讲手势添加到指定的视图上
        [backview addGestureRecognizer:tap];
        [_alertView addSubview:backview];
        [_alertView addSubview:self.alertTableView];
    }
    return _alertView;
}
-(void)alertTableViewAction{
    [_alertView removeFromSuperview];
}
-(void)createUI{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 50) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = JHColor(222, 222, 222);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"timecell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectMedicalTableViewCell" bundle:nil] forCellReuseIdentifier:@"itemcell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return 2;
    }
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return self.typeArray.count;
        }else if (section == 1){
            return 2;
        }
        return 2;
    }
    return self.phy_timeArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (tableView != self.tableView && section == 0) {
//        return 35;
//    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        UIImageView *view = [[UIImageView alloc]init];
        view.image = [UIImage imageNamed:@"fengexiantongyong"];
        
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return 10;
    }
    return 0.001;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {

            SelectMedicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemcell"];
            ItemModel *model  = self.typeArray[indexPath.row];
            cell.nameLb.text =model.name;
            cell.priceLb.text = [NSString stringWithFormat:@"￥%@",model.price];
            if ([model.select isEqualToString:@"0"]) {
                cell.selectBtn.selected = NO;
                cell.priceLb.textColor = JHdeepColor;
            }else{
                cell.priceLb.textColor = JHMedicalAssistColor;
                cell.selectBtn.selected = YES;
            }
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
    ShopOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alertcell"];
    cell.rigthtIm.hidden = YES;
    cell.contentLbLeft.constant = 0;
    cell.contentRight.constant= 10;
    cell.nameLabel.text = self.phy_timeArr[indexPath.row];
    cell.nameHeight.constant = screenW - 20;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        if (indexPath.section == 0 ) {
            ItemModel *model  = self.typeArray[indexPath.row];
            if ([model.select isEqualToString:@"0"]) {
                model.select = @"1";
            }else{
                model.select = @"0";
            }
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self updateSelectPrice];
            return;
        }
        if (indexPath.section == 1 && indexPath.row == 0) {
            PickerChoiceView * _picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
            _picker.titlestr = @"请选择";
            _picker.inter =2;
            _picker.delegate = self;
            _picker.arrayType = HeightArray;
            for (NSString *str in self.dateArr) {
                [_picker.typearr addObject:str];
            }
            [self.view addSubview:_picker];
            return;
        }
        
    }
    
//    self.phy_time = self.phy_timeArr[indexPath.row];
//    [self alertTableViewAction];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)PickerSelectorIndixString:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    NSLog(@"%@",str);
    self.phy_time = str;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    
}
#pragma mark 详情
-(void)requestDataChildRelation:(BOOL)isFirst{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.tid) {
        [dt setObject:self.tid forKey:@"id"];
    }
    if (self.child_id) {
        [dt setObject:self.child_id forKey:@"child_id"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,VaccinationSubmitDetailUrl) params:dt success:^(id response) {
        LFLog(@"详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSDictionary class]] ) {
                if (([response[@"data"][@"vaccinate"] isKindOfClass:[NSArray class]] )) {
                    [self.typeArray removeAllObjects];
                    for (NSDictionary *str in response[@"data"][@"vaccinate"]) {
                        ItemModel *model = [[ItemModel alloc]initWithDictionary:str error:nil];
                        [self.typeArray addObject:model];
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
-(void)submitClick{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSMutableString *mstr = [NSMutableString string];
    for (ItemModel *model in self.typeArray) {
        if ([model.select isEqualToString:@"1"]) {
            if (mstr.length > 0) {
                [mstr appendFormat:@",%@",model.id];
            }else{
                [mstr appendString:model.id];
            }
        }
    }
    if (mstr.length == 0) {
        [self presentLoadingTips:@"请选择疫苗种类！"];
        return;
    }
    if (!self.phy_time) {
        [self presentLoadingTips:@"请选择预约时间！"];
        return;
    }
    [dt setObject:mstr forKey:@"vaccinate_id"];
    [dt setObject:self.phy_time forKey:@"date"];
    if (self.child_id) {
        [dt setObject:self.child_id forKey:@"child_id"];
    }
    if (self.tid) {
        [dt setObject:self.tid forKey:@"tid"];
    }
    [self upDateInfo:dt];
}
-(void)upDateInfo:(NSMutableDictionary *)dt{
    [self presentLoadingTips];
    
    LFLog(@"接种提交dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,VaccinationSubmitUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"接种提交：%@",response);
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
        if ([vc isKindOfClass:[VaccinationPlanViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
