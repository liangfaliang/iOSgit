//
//  SelectMedicalViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/16.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "SelectMedicalViewController.h"
#import "MedicalModel.h"
#import "MJExtension.h"
#import "SelectMedicalTableViewCell.h"
#import "btnFootView.h"
#import "MedicalConfirmViewController.h"
@interface SelectMedicalViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UILabel *totalLabel;
@property(nonatomic,strong)UIButton *allSelectBtn;
@property (nonatomic,strong)btnFootView *footer;
@end

@implementation SelectMedicalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"选择加项";
    [self createTableview];
    [self addFootview];
    [self UploadDataItemList];
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)addFootview{
    self.footer = [[NSBundle mainBundle]loadNibNamed:@"btnFootView" owner:nil options:nil][0];
    self.footer.frame = CGRectMake(0, SCREEN.size.height - 50, SCREEN.size.width, 50);
    [self.footer.clickBtn setTitle:@"下一步" forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    [self.footer setBlock:^{//下一步
        NSMutableString *mstr = [NSMutableString string];
        NSMutableArray *marray = [NSMutableArray array];
        NSMutableArray *itemArr = [NSMutableArray array];
        double price = 0.0;
        for (MedicalModel *mo in weakSelf.dataArray) {
            for (ItemModel *model in mo.list) {
                if ([model.select isEqualToString:@"1"]) {
                    [marray addObject:model.id];
                    [itemArr addObject:model];
                    price += [model.price doubleValue];
                }
            }
        }
        if (weakSelf.dataDt) {
            price += [weakSelf.dataDt[@"current_price"] doubleValue];
        }
        for (int i= 0; i < marray.count; i ++) {
            [mstr appendString:marray[i]];
            if (i < marray.count - 1) {
                [mstr appendString:@","];
            }
        }
        MedicalConfirmViewController *con = [[MedicalConfirmViewController alloc]init];
        if (mstr.length > 0) {
            con.additional = mstr;
        }
        con.price = price;
        con.ItemArr = itemArr;
        con.dataDt = weakSelf.dataDt;
        [weakSelf.navigationController pushViewController:con animated:YES];
        
        
    }];
    [self.view addSubview:self.footer];
    [self updateSelectPrice];
}
#pragma mark 更新价格
-(void)updateSelectPrice{
    double price = 0.0;
    for (MedicalModel *model in self.dataArray) {
        for (ItemModel *imo in model.list) {
            if ([imo.select isEqualToString:@"1"]) {
                price += [imo.price doubleValue];
            }
        }
    }
    if (self.dataDt) {
        price += [self.dataDt[@"current_price"] doubleValue];
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
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height -50)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerNib:[UINib nibWithNibName:@"SelectMedicalTableViewCell" bundle:nil] forCellReuseIdentifier:@"SelectMedicalTableViewCell"];
    [self.tableview registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"headrView"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cartfirmCell"];
    [self.view addSubview:self.tableview];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MedicalModel *model = self.dataArray[section];
    return model.list.count;;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    MedicalModel *mo = self.dataArray[section];
    YYLabel *nameLb = [[YYLabel alloc]init];
    nameLb.textColor = JHdeepColor;
    nameLb.font = [UIFont systemFontOfSize:20];
    nameLb.numberOfLines = 0;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",mo.name,mo.desc]];
    CGSize size = [text selfadaption:20];
    return (size.height + 10) > 60 ?(size.height + 10) :60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *hview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headrView"];
    hview.contentView.backgroundColor = [UIColor whiteColor];
    [hview.contentView removeAllSubviews];
    MedicalModel *mo = self.dataArray[section];
    YYLabel *nameLb = [[YYLabel alloc]init];
    nameLb.textColor = JHdeepColor;
    nameLb.font = [UIFont systemFontOfSize:20];
    nameLb.numberOfLines = 0;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",mo.name,mo.desc]];
    NSRange range =[[text string]rangeOfString:[NSString stringWithFormat:@"\n%@",mo.desc]];
    text.yy_color = JHdeepColor;
    text.yy_font = [UIFont systemFontOfSize:20];
    text.yy_lineSpacing = 10;
    [text yy_setFont:[UIFont systemFontOfSize:12] range:range];
    [text yy_setColor:JHmiddleColor range:range];
    nameLb.attributedText = text;
    [hview addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    return hview;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectMedicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectMedicalTableViewCell"];
    MedicalModel *mo = self.dataArray[indexPath.section];
    ItemModel *model  = mo.list[indexPath.row];
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
    MedicalModel *mo = self.dataArray[indexPath.section];
    ItemModel *model  = mo.list[indexPath.row];
    if ([model.select isEqualToString:@"0"]) {
        model.select = @"1";
    }else{
        model.select = @"0";
    }
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self updateSelectPrice];//更新价格
   
}


#pragma mark - *************购物车列表请求*************
-(void)UploadDataItemList{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.itemId) {
        [dt setObject:self.itemId forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,MedicalExaminationItemlUrl) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        LFLog(@"购物车列表：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
//        NSMutableArray *copyArr = [self.dataArray mutableCopy];
        [self.dataArray removeAllObjects];
        double price = 0.0;
        NSInteger count = 0;
        if ([str isEqualToString:@"1"]) {
            for (NSDictionary *temDt in response[@"data"]) {
                MedicalModel *model = [[MedicalModel alloc]initWithDictionary:temDt error:nil];
                [self.dataArray addObject:model];
            }
//            for (NSDictionary *supdt in response[@"data"][@"suppliers"]) {
//                NSMutableDictionary *mdt = [[NSMutableDictionary alloc]init];
//                [mdt setObject:supdt[@"suppliers_name"] forKey:@"suppliers_name"];
//                [mdt setObject:supdt[@"suppliers_id"] forKey:@"suppliers_id"];
//                [mdt setObject:supdt[@"bonus"] forKey:@"bonus"];
//                NSString *allSelect = @"1";
//                NSMutableArray *marray = [NSMutableArray array];
//                for (NSMutableDictionary *listdt in supdt[@"goods_list"]) {
//                    MedicalModel *model = [MedicalModel objectWithKeyValues:listdt];
//                    BOOL isChange = NO;
//                    for (NSMutableDictionary *copyDt in copyArr) {
//                        if ([copyDt[@"suppliers_id"] isEqualToString:supdt[@"suppliers_id"]]) {
//                            for (MedicalModel *oldModel in copyDt[@"goods_list"]) {
//                                if ([model.rec_id isEqualToString:oldModel.rec_id]) {
//                                    model.select = oldModel.select;
//                                    isChange = YES;
//                                }
//                            }
//                        }
//
//                    }
//                    if (!isChange) {
//                        model.select = @"0";
//                    }
//                    [marray addObject:model];
//                    if ([model.select isEqualToString:@"1"]) {
//                        price += [[listdt[@"subtotal"] stringByReplacingOccurrencesOfString:@"￥" withString:@""] doubleValue];
//                        LFLog(@"%f",price);
//                    }else{
//                        allSelect = @"0";
//                    }
//                    count ++;
//                }
//                [mdt setObject:allSelect forKey:@"allSelect"];//是否全选 0未全选
//                [mdt setObject:marray forKey:@"goods_list"];
//                [self.dataArray addObject:mdt];
//            }

        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDataItemList];
                    }
                    
                }];
            }
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
        self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",(float)price];
        [self.tableview reloadData];
        //        LFLog(@"self.dataArray:%@",self.dataArray);
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
    }];
    
    
}


#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self UploadDataItemList];
    }];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}
@end
