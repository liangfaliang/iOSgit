//
//  MedicalConfirmViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/18.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MedicalConfirmViewController.h"
#import "btnFootView.h"
#import "ShopOtherTableViewCell.h"
#import "MedicalModel.h"
#import "MedicalExaminationDetailViewController.h"
#import "AlertSelectTimeView.h"
@interface MedicalConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView *alertView;
@property (strong,nonatomic)NSMutableArray *subViewArray;
@property (strong,nonatomic)NSMutableArray *typeArray;
@property (strong,nonatomic)NSArray *nameArray;
@property (strong,nonatomic)NSArray *placeholderArr;
@property (strong,nonatomic)NSArray *phy_timeArr;
@property (strong,nonatomic)NSString *phy_time;
@property (nonatomic,strong)btnFootView *footer;
@property(nonatomic,strong)baseTableview *alertTableView;
@end
@implementation MedicalConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"确认信息";
    self.nameArray = @[@"体检人",@"性   别",@"手机号",@"身份证"];
    self.placeholderArr = @[@"请输入体检人姓名",@"",@"请输入手机号",@"请输入身份证号"];
    if (self.dataDt && [self.dataDt[@"phy_time"] isKindOfClass:[NSArray class]]) {
        self.phy_timeArr = self.dataDt[@"phy_time"];
        if (self.phy_timeArr.count) {
            self.phy_time = self.phy_timeArr[0];
        }
    }
    [self createUI];
    [self addFootview];
}

-(NSMutableArray *)typeArray{
    if (_typeArray == nil) {
        _typeArray = [[NSMutableArray alloc]init];;
    }
    return _typeArray;
}
-(NSMutableArray *)subViewArray{
    if (_subViewArray == nil) {
        _subViewArray = [[NSMutableArray alloc]init];;
    }
    return _subViewArray;
}
-(void)addFootview{
    self.footer = [[NSBundle mainBundle]loadNibNamed:@"btnFootView" owner:nil options:nil][0];
    self.footer.frame = CGRectMake(0, SCREEN.size.height - 50, SCREEN.size.width, 50);
    [self.footer.clickBtn setTitle:@"去支付" forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    [self.footer setBlock:^{//去支付
        [weakSelf submitClick];
    }];
    [self.view addSubview:self.footer];
    NSString *current_price = [NSString stringWithFormat:@"%.2f",self.price];
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
    
    for (int i = 0; i < self.nameArray.count; i ++) {
        if (i != 1) {
            UITextField *tf = [[UITextField alloc]init];
            tf.placeholder = self.placeholderArr[i];
//            tf.textAlignment = NSTextAlignmentRight;
            tf.font = [UIFont systemFontOfSize:15];
            tf.textColor = JHmiddleColor;
            if (i != 0) {
                tf.keyboardType = UIKeyboardTypeNumberPad;
            }
            [self.subViewArray addObject:tf];
        }else{
            NSArray *nameArr = @[@"   男",@"   女"];
            NSMutableArray *btnArr = [NSMutableArray array];
            for (int i = 0 ; i < nameArr.count; i ++) {
                IndexBtn *btn = [[IndexBtn alloc]init];
                btn.index = i;
                [btn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
                [btn setTitle:nameArr[i] forState:UIControlStateNormal];
                [btn setTitle:nameArr[i] forState:UIControlStateSelected];
                [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
                [btn setTitleColor:JHdeepColor forState:UIControlStateSelected];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                btn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
                [btn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                if (i == 0) {
                    btn.selected = YES;
                }
                [btnArr addObject:btn];
            }
            [self.subViewArray addObject:btnArr];
        }

    }
    LFLog(@"self.subViewArray:%@",self.subViewArray);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 50) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = JHColor(222, 222, 222);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"othercell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
}
#pragma mark 性别点击
-(void)sexBtnClick:(IndexBtn *)sender{
    sender.selected = YES;
    NSMutableArray *btnArr = self.subViewArray[1];
    for (IndexBtn *btn in btnArr) {
        if (btn != sender) {
            btn.selected = NO;
            return;
        }
    }
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
            return self.nameArray.count;
        }else if (section == 2){
            return self.ItemArr.count + 1;
        }
        return 2;
    }
    return self.phy_timeArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView != self.tableView && section == 0) {
        return 35;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView != self.tableView && section == 0) {
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = JHColor(236, 239, 235);
        UILabel *label = [[UILabel alloc]init];
        label.textColor = JHdeepColor;
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"请选择预约时间";
        [header addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(header.mas_centerY);
            
        }];
        return header;
    }
    return nil;
    
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
            NSString *CellIdentifier = [NSString stringWithFormat:@"creditcell%ld_%ld",(long)indexPath.section,(long)indexPath.row];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *label = [[UILabel alloc]init];
                label.textColor = JHColor(53, 53, 53);
                label.font = [UIFont systemFontOfSize:15];
                NSInteger row = indexPath.row;
                label.text = self.nameArray[row];
                CGSize lbsize = [label.text selfadaption:15];
                [cell.contentView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(10);
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                    make.width.offset(lbsize.width + 5);
                    
                }];
                if ([self.subViewArray[indexPath.row] isKindOfClass:[UITextField class]]) {
                    UITextField *tf = self.subViewArray[indexPath.row];
                    [cell.contentView addSubview:tf];
                    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.contentView.mas_centerY);
                        make.right.offset(-30);
                        make.left.equalTo(label.mas_right).offset(10);
                        
                    }];
                }else if ([self.subViewArray[indexPath.row] isKindOfClass:[NSArray class]]){
                    NSMutableArray *btnArr = self.subViewArray[indexPath.row];
                    int xx = lbsize.width + 30;
                    for (IndexBtn *btn in btnArr) {
                        btn.frame = CGRectMake( xx , 0, (SCREEN.size.width - lbsize.width -60)/2, 50);
                        [cell.contentView addSubview:btn];
                        xx += (SCREEN.size.width - lbsize.width -15)/2;
                    }
                }
            }
            
            return cell;
        }
        ShopOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"othercell"];
        cell.rigthtIm.hidden = YES;
        cell.contentLbLeft.constant = 10;
        if (indexPath.section == 1) {
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
                if (self.dataDt) {
                    cell.contentLb.text = self.dataDt[@"phy_address"];
                }
            }
            cell.nameHeight.constant = [cell.nameLabel.text selfadap:15 weith:20].width + 10;
        }else{
            cell.contentLb.font = [UIFont systemFontOfSize:13];
            cell.contentLb.textColor  =JHMedicalAssistColor;
            cell.contentLb.textAlignment = NSTextAlignmentRight;
            cell.contentRight.constant = 10;
            if (indexPath.row == 0) {
                if (self.dataDt) {
                    cell.nameLabel.text = self.dataDt[@"name"];
                }else{
                    cell.nameLabel.text =nil;
                }

                cell.contentLb.text = [NSString stringWithFormat:@"￥%.2f",self.price];
            }else{
                ItemModel *model = self.ItemArr[indexPath.row -1];
                cell.nameLabel.text = model.name;
                cell.contentLb.text = [NSString stringWithFormat:@"￥%@",model.price];
            }
            cell.nameHeight.constant = screenW - [cell.contentLb.text selfadap:13 weith:20].width -40;
        }

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
        if (indexPath.section == 1 && indexPath.row == 0) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
        }
        return;
    }
    
    self.phy_time = self.phy_timeArr[indexPath.row];
    [self alertTableViewAction];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)submitClick{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSArray *parameterArr = @[@"user_name",@"sex",@"mobile",@"cardid"];
    for (int i = 0 ; i < self.subViewArray.count; i ++) {
        if ([self.subViewArray[i] isKindOfClass:[UITextField class]]) {
            UITextField *tf = self.subViewArray[i];
            if (!tf.text.length) {
                [self presentLoadingTips:self.placeholderArr[i]];
                [tf becomeFirstResponder];
                return;
            }else{
                if (i == 2 && tf.text.length != 11) {
                    [self presentLoadingTips:@"请输入正确的手机号！"];
                    return;
                }
                if (i == 3 && tf.text.length != 18) {
                    [self presentLoadingTips:@"请输入正确的身份证号！"];
                    return;
                }
                [dt setObject:tf.text forKey:parameterArr[i]];
            }
        }else if ([self.subViewArray[i] isKindOfClass:[NSArray class]]){
            NSMutableArray *btnArr = self.subViewArray[i];
            for (IndexBtn *btn in btnArr) {
                if (btn.selected) {
                    [dt setObject:[NSString stringWithFormat:@"%ld",(long)btn.index] forKey:parameterArr[i]];
                }
            }
        }
    }
    if (self.dataDt) {
        [dt setObject:self.dataDt[@"id"] forKey:@"id"];
    }
    if (self.phy_time) {
        [dt setObject:self.phy_time forKey:@"phy_time"];
    }
    if (self.additional) {
        [dt setObject:self.additional forKey:@"additional"];
    }
    [self upDateInfo:dt];
}
-(void)upDateInfo:(NSMutableDictionary *)dt{
    [self presentLoadingTips];

    LFLog(@"体检提交dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,MedicalExaminationSubmitUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"体检提交：%@",response);
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
        if ([vc isKindOfClass:[MedicalExaminationDetailViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
