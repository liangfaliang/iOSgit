//
//  PregnantAddItemViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/28.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PregnantAddItemViewController.h"
#import "SelectMedicalTableViewCell.h"
#import "PregnantReservationViewController.h"
#import "MedicalModel.h"
@interface PregnantAddItemViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView *alertView;
@property (strong,nonatomic)NSMutableArray *typeArray;


@end

@implementation PregnantAddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"产检预约";
    [self createUI];
    [self requestDataPregnant];
}
-(NSMutableArray *)typeArray{
    if (_typeArray == nil) {
        _typeArray = [[NSMutableArray alloc]init];;
    }
    return _typeArray;
}
-(void)createUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 50) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = JHColor(222, 222, 222);
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectMedicalTableViewCell" bundle:nil] forCellReuseIdentifier:@"itemcell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    UIButton * submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN.size.height - 50, SCREEN.size.width, 50)];
    submitBtn.backgroundColor = JHMedicalColor;
    [submitBtn setTitle:@"添加" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    //    [submitBtn setImage:[UIImage imageNamed:@"tijiaobuttun"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}
-(void)nextBtnClick{
    NSMutableString *mstr = [NSMutableString string];
    NSMutableArray *marray = [NSMutableArray array];
    for (ItemModel *model in self.typeArray) {
        if ([model.select isEqualToString:@"1"]) {
            [marray addObject:model.id];
            
        }
    }

    for (int i= 0; i < marray.count; i ++) {
        [mstr appendString:marray[i]];
        if (i < marray.count - 1) {
            [mstr appendString:@","];
        }
    }
    PregnantReservationViewController *next = [[PregnantReservationViewController alloc]init];
    next.planid  = self.planid;
    next.itemid = mstr;
    [self.navigationController pushViewController:next animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.typeArray.count;
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
    SelectMedicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemcell"];
    ItemModel *model = self.typeArray[indexPath.row];
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
            return;
        }
    }
}
#pragma mark - *************孕检计划项目*************
-(void)requestDataPregnant{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.planid) {
        [dt setObject:self.planid forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PregnantCheckPlanDetailUrl) params:dt success:^(id response) {
        LFLog(@"孕检计划项目:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.typeArray removeAllObjects];
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                for (NSDictionary *str in response[@"data"][@"vaccinate_isfree"]) {
                    ItemModel *model = [[ItemModel alloc]initWithDictionary:str error:nil];
                    model.select = @"1";
                    model.isFree = @"1";
                    [self.typeArray addObject:model];
                }
                for (NSDictionary *str in response[@"data"][@"vaccinate_notfree"]) {
                    ItemModel *model = [[ItemModel alloc]initWithDictionary:str error:nil];
                    model.select = @"0";
                    model.isFree = @"0";
                    [self.typeArray addObject:model];
                }
                [self.tableView reloadData];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    [self requestDataPregnant];
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        
                [self presentLoadingTips:@"请求失败！"];
    }];
    
}
@end
