//
//  ShoppingCartViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/1.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShopCartTableViewCell.h"
#import "ConfirmOrderViewController.h"
#import "ShopCartModel.h"
#import "ShopDoodsDetailsViewController.h"
#import "CouponExchangeViewController.h"
@interface ShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UILabel *totalLabel;
@property(nonatomic,strong)UIButton *allSelectBtn;
@end

@implementation ShoppingCartViewController
SYNTHESIZE_SINGLETON_FOR_CLASS(ShoppingCartViewController);
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationBarTitle = @"购物车";
//    [self createTableview];
//    [self createFootview];
//    [self setupRefresh];
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)setBlock:(cartBlock)block{
    _block = block;
}

-(void)createFootview{
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN.size.height - 50, SCREEN.size.width, 50)];
    footview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footview];
    UIButton *subButton = [[UIButton alloc]init];
    subButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:17];
    [subButton setTitle:@"去结算" forState:UIControlStateNormal];
    subButton.backgroundColor = [UIColor redColor];
    [subButton addTarget:self action:@selector(subButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:subButton];
    [subButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.bottom.offset(0);
        make.top.offset(0);
        make.width.offset(120);
    }];
    self.totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN.size.width - 220, 50)];
    self.totalLabel.text = @"￥0.0 ";
    self.totalLabel.textColor = [UIColor redColor];
    self.totalLabel.font = [UIFont systemFontOfSize:14];
    [footview addSubview:self.totalLabel];
    
    //    UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 40, 50)];
    //    payLabel.textColor = JHColor(51, 51, 51);
    //    payLabel.text = @"合计：";
    //    payLabel.font = [UIFont systemFontOfSize:14];
    //    payLabel.textAlignment = NSTextAlignmentRight;
    //    [footview addSubview:payLabel];
    
    self.allSelectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 60, 50)];
    [_allSelectBtn setAttributedTitle:[self AttributedString:@" 全选" image:[UIImage imageNamed:@"xuanze"] UIcolor:JHColor(51, 51, 51)] forState:UIControlStateNormal];
    [_allSelectBtn setAttributedTitle:[self AttributedString:@" 全选" image:[UIImage imageNamed:@"xuanzhong"] UIcolor:JHColor(51, 51, 51)] forState:UIControlStateSelected];
    [_allSelectBtn addTarget:self action:@selector(AllSlelctClick:) forControlEvents:UIControlEventTouchUpInside];
    _allSelectBtn.selected = NO;
//    [footview addSubview:_allSelectBtn];
    
}
-(NSMutableAttributedString *)AttributedString:(NSString *)text image:(UIImage *)image UIcolor:(UIColor *)color{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName : color}];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
    
    attachment.image = image;
    attachment.bounds = CGRectMake(0, -5, 20, 20);
    
    NSAttributedString *imstr = [NSAttributedString attributedStringWithAttachment:attachment];
    [str insertAttributedString:imstr atIndex:0];
    return str;
    
}
#pragma mark 确认订单
-(void)subButtonClick:(UIButton *)btn{
    NSMutableString *mstr = [NSMutableString string];
    NSMutableArray *marray = [NSMutableArray array];
    for (int i =0; i <self.dataArray.count; i++) {
        for (ShopCartModel *model in self.dataArray[i][@"goods_list"]) {
            if ([model.select isEqualToString:@"1"]) {
                [marray addObject:model.rec_id];
            }
        }
    }

    for (int i= 0; i < marray.count; i ++) {
        [mstr appendString:marray[i]];
        if (i < marray.count - 1) {
            [mstr appendString:@","];
        }
    }
    
    if (mstr.length > 0) {
        ConfirmOrderViewController *con = [[ConfirmOrderViewController alloc]init];
        con.rec_id = mstr;
        [self.navigationController pushViewController:con animated:YES];
        
    }else{
        [self presentLoadingTips:@"请选择要结算的商品"];
    }
    
    
}
-(void)AllSlelctClick:(UIButton *)btn{
    
    //    if (btn.tag == 20) {
    btn.selected = !btn.selected;
    if (!btn.selected) {
        self.dataArray = [self shopSelectState:self.dataArray select:@"0"];
    }else{
        self.dataArray = [self shopSelectState:self.dataArray select:@"1"];
    }
    [self shopSelectPrice:self.dataArray];//计算选择价格
    //    }
    
    [self.tableview reloadData];
}
#pragma mark 设置选中状态
-(NSMutableArray *)shopSelectState:(NSMutableArray *)marray select:(NSString *)select{
    
    NSMutableArray *newmarray = [NSMutableArray array];
    [marray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ShopCartModel *model = (ShopCartModel *)obj;
        model.select = select;
        [newmarray addObject:model];
    }];
    return newmarray;
    
}

#pragma mark 计算选中价格
-(void)shopSelectPrice:(NSMutableArray *)marray{
    double price = 0.0;
    for (ShopCartModel *model in marray) {
        if ([model.select isEqualToString:@"1"]) {
            price +=  [[model.subtotal stringByReplacingOccurrencesOfString:@"￥" withString:@""] doubleValue];
        }
        
    }
    self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",(float)price];
}
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height -50)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopCartTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopCartTableViewCell"];
    [self.tableview registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"headrView"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cartfirmCell"];
    [self.view addSubview:self.tableview];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *marray = self.dataArray[section][@"goods_list"];
    return marray.count;;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *hview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headrView"];
    hview.backgroundColor = JHbgColor;
    [hview.contentView removeAllSubviews];
    NSString *bonus = self.dataArray[section][@"bonus"];
    NSString *allSelect = self.dataArray[section][@"allSelect"];
    
    int count = 1;
    if (bonus && bonus.length) {
        count = 2;
    }
    IndexBtn *supBtn = nil;
    for (int i = 0; i < count; i ++) {
        IndexBtn *btn = [[IndexBtn alloc]init];
        btn.index = i;
        btn.section = section;
        if (i == 0) {
            if ([allSelect isEqualToString:@"0"]) {
                [btn setImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
            }else{
                btn.selected =YES;
                [btn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];//选中
            }
            NSString *suppliers_name =[NSString stringWithFormat:@"  %@",self.dataArray[section][@"suppliers_name"]];
            [btn setTitle:suppliers_name forState:UIControlStateNormal];
            [btn setTitle:suppliers_name forState:UIControlStateSelected];
            [btn setTitleColor:JHdeepColor forState:UIControlStateSelected];
            [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            supBtn = btn;
        }else{
            [btn setTitle:bonus forState:UIControlStateNormal];
            [btn setTitleColor:JHAssistRedColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        [hview.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.bottom.offset(0);
            if (i == 0) {
                make.left.offset(10);
                make.width.offset(btn.imageView.image.size.width + [btn.titleLabel.text selfadap:15 weith:20].width + 20);
            }else{
                make.left.equalTo(supBtn.mas_right);
            }
        }];
        [btn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return hview;
}
-(void)headerBtnClick:(IndexBtn *)btn{
    if (btn.index == 0) {
        btn.selected = !btn.selected;
        [self cancelOtherSupSelect:btn.section];
        NSMutableDictionary *mdt = self.dataArray[btn.section];
        NSMutableArray *marray = mdt[@"goods_list"];
        if (!btn.selected) {
            [mdt setObject:@"0" forKey:@"allSelect"];
            marray = [self shopSelectState:marray select:@"0"];
        }else{
            [mdt setObject:@"1" forKey:@"allSelect"];
            marray = [self shopSelectState:marray select:@"1"];
        }
        [self shopSelectPrice:marray];//计算选择价格
        [self.tableview reloadData];
    }else{
        CouponExchangeViewController *room= [[CouponExchangeViewController alloc]init];//优惠券
        [self.navigationController pushViewController:room animated:YES];
    }

}
//取消其他店铺的选择
-(void)cancelOtherSupSelect:(NSInteger)index{
    for (int i =0; i <self.dataArray.count; i++) {
        if (i != index) {
            NSMutableDictionary *mdt = self.dataArray[i];
            NSMutableArray *marray = mdt[@"goods_list"];
            [mdt setObject:@"0" forKey:@"allSelect"];
            marray = [self shopSelectState:marray select:@"0"];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCartTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary *mdt = self.dataArray[indexPath.section];
    NSMutableArray *marray = mdt[@"goods_list"];
    ShopCartModel *model = marray[indexPath.row];
//    __weak typeof(cell) weakcell = cell;
    __weak typeof(self) weakSelf = self;
    [cell setSelectblock:^(BOOL seleted, NSString *str) {//商品是否选中 0未选中 1是选中
        [self cancelOtherSupSelect:indexPath.section];
        if (seleted) {
            model.select = @"1";
        }else{
//            weakSelf.allSelectBtn.selected = NO;
            model.select = @"0";
        }
        if (indexPath.section == 0) {
            [marray replaceObjectAtIndex:indexPath.row withObject:model];
            [weakSelf shopSelectPrice:marray];//计算选择价格
        }
        CGFloat num = 0;
        for (ShopCartModel *allModel in marray) {
            if ([allModel.select isEqualToString:@"1"]) {
                num ++;
            }
        }
        if (num == marray.count) {
            [mdt setObject:@"1" forKey:@"allSelect"];
        }else{
            [mdt setObject:@"0" forKey:@"allSelect"];
        }
        [weakSelf.tableview reloadData];
//        UITableViewHeaderFooterView *hview = [tableView headerViewForSection:indexPath.section];
//
//        for (UIView *subview in hview.contentView.subviews) {
//            if ([subview isKindOfClass:[IndexBtn class]]) {
//                if (((IndexBtn *)subview).index == 0) {
//                    IndexBtn *supBtn = (IndexBtn *)subview;
//
//                }
//            }
//        }

    }];
    [cell.countView setBlock:^(BOOL isAdd) {//加减商品数量
        NSInteger num = [cell.countView.countLabel.text integerValue];
        LFLog(@"indexPath.row:%ld",(long)indexPath.row);
        if (isAdd) {
            num ++;
            [weakSelf UploadDataCartListUpdate:model.rec_id new_number:[NSString stringWithFormat: @"%d", (int)num]];
        }else{
            if (num > 1) {
                num --;
                [weakSelf UploadDataCartListUpdate:model.rec_id new_number:[NSString stringWithFormat: @"%d", (int)num]];
            }else{
                [weakSelf alertController:@"提示" prompt:@"是否移除该商品" sure:@"确定" cancel:@"取消" success:^{
                    [weakSelf UploadDataCartListdelete:model.rec_id];
                } failure:^{
                    
                }];
            }
            
        }
    }];
    if ([self.dataArray[indexPath.section][@"allSelect"] isEqualToString:@"1"]) {
        cell.selectBtn.selected = YES;
    }else if([model.select isEqualToString:@"0"]){
        cell.selectBtn.selected = NO;
    }else if([model.select isEqualToString:@"1"]){
        cell.selectBtn.selected = YES;
    }
    cell.countView.countLabel.delegate =self;
    cell.countView.countLabel.enabled = NO;
    cell.nameLabel.text = model.goods_name;
    NSMutableString *mstr = [NSMutableString string];
    if (model.goods_attr.count) {
        for (int i = 0; i < model.goods_attr.count; i ++) {
            [mstr appendFormat:@"%@ ", model.goods_attr[i][@"value"]];
        }
    }
    cell.styleLabel.text = mstr;
    cell.priceLabel.text = model.subtotal;
    cell.countView.countLabel.text = model.goods_number;
    [cell.pictureIm sd_setImageWithURL:[NSURL URLWithString:model.img[@"thumb"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *marray = self.dataArray[indexPath.section][@"goods_list"];
    ShopCartModel *model = marray[indexPath.row];
    ShopDoodsDetailsViewController *good = [[ShopDoodsDetailsViewController alloc]init];
    good.goods_id = model.goods_id;
    [self.navigationController pushViewController:good animated:YES];
//    if ([model.select isEqualToString:@"0"]) {
//        model.select = @"1";
//
//    }else{
//        self.allSelectBtn.selected = NO;
//        model.select = @"0";
//    }
//
//    [self shopSelectPrice:marray];//计算选择价格
//    CGFloat num = 0;
//    for (ShopCartModel *allModel in marray) {
//        if ([allModel.select isEqualToString:@"1"]) {
//            num ++;
//        }
//    }
//    if (num == marray.count) {
////        self.allSelectBtn.selected = YES;
//    }
//    [self.tableview reloadData];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return   UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count) {
        return YES;
    }else{
        return NO;
    }
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    WS(weakself);
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ShopCartModel *model = self.dataArray[indexPath.section][@"goods_list"][indexPath.row];
        [self alertController:@"提示" prompt:@"是否移除该商品" sure:@"确定" cancel:@"取消" success:^{
            [self UploadDataCartListdelete:model.rec_id];
        } failure:^{
            
        }];
        
        
    }
}

//提示框
-(void)alertController:(NSString *)recid{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否移除该商品" preferredStyle:UIAlertControllerStyleAlert];
    //        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self UploadDataCartListdelete:recid];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - *************购物车列表请求*************
-(void)UploadDataCartList{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,CartListUrl) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        LFLog(@"购物车列表：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        NSMutableArray *copyArr = [self.dataArray mutableCopy];
        [self.dataArray removeAllObjects];
        double price = 0.0;
        NSInteger count = 0;
        if ([str isEqualToString:@"1"]) {
            for (NSDictionary *supdt in response[@"data"][@"suppliers"]) {
                NSMutableDictionary *mdt = [[NSMutableDictionary alloc]init];
                [mdt setObject:supdt[@"suppliers_name"] forKey:@"suppliers_name"];
                [mdt setObject:supdt[@"suppliers_id"] forKey:@"suppliers_id"];
                [mdt setObject:supdt[@"bonus"] forKey:@"bonus"];
                NSString *allSelect = @"1";
                NSMutableArray *marray = [NSMutableArray array];
                for (NSMutableDictionary *listdt in supdt[@"goods_list"]) {
                    ShopCartModel *model = [[ShopCartModel alloc]initWithDictionary:listdt error:nil];
                    BOOL isChange = NO;
                    for (NSMutableDictionary *copyDt in copyArr) {
                        if ([copyDt[@"suppliers_id"] isEqualToString:supdt[@"suppliers_id"]]) {
                            for (ShopCartModel *oldModel in copyDt[@"goods_list"]) {
                                if ([model.rec_id isEqualToString:oldModel.rec_id]) {
                                    model.select = oldModel.select;
                                    isChange = YES;
                                }
                            }
                        }

                    }
                    if (!isChange) {
                        model.select = @"0";
                    }
                    [marray addObject:model];
                    if ([model.select isEqualToString:@"1"]) {
                        price += [[listdt[@"subtotal"] stringByReplacingOccurrencesOfString:@"￥" withString:@""] doubleValue];
                        LFLog(@"%f",price);
                    }else{
                        allSelect = @"0";
                    }
                    count ++;
                }
                [mdt setObject:allSelect forKey:@"allSelect"];//是否全选 0未全选
                [mdt setObject:marray forKey:@"goods_list"];
                [self.dataArray addObject:mdt];
            }
            
            if (_block) {
                _block(nil,count);
            }
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDataCartList];
                    }
                    
                }];
            }
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        if (self.tableview == nil) {
            [self createTableview];
            [self createFootview];
            [self setupRefresh];
        }
        self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",(float)price];
        [self.tableview reloadData];
//        LFLog(@"self.dataArray:%@",self.dataArray);
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
    }];
    
    
}
#pragma mark - *************购物车更新请求*************
-(void)UploadDataCartListUpdate:(NSString *)rec_id new_number:(NSString *)new_number{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:rec_id,@"rec_id",new_number,@"new_number", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,CartUpdateUrl) params:dt success:^(id response) {
        LFLog(@"购物车更新：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self UploadDataCartList];
            
        }else{
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            [self.tableview reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark - *************购物车删除请求*************
-(void)UploadDataCartListdelete:(NSString *)rec_id{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:rec_id,@"rec_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,CartDeleteUrl) params:dt success:^(id response) {
        LFLog(@"购物车删除：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self UploadDataCartList];
            
        }else{
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            [self.tableview reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self UploadDataCartList];
    }];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self UploadDataCartList];
    
}
@end
