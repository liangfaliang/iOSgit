//
//  SelectStyleViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/2.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "SelectStyleViewController.h"
#import "ConfirmOrderViewController.h"
@interface SelectStyleViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITextField *tf;
}
@property (nonatomic,strong)UITableView * tableview;

@end

@implementation SelectStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.tag == 103) {
        [self createTextfiled];
    }else{
        [self createTableview];
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
-(void)createTextfiled{
    
    tf = [[UITextField alloc]initWithFrame:CGRectMake(10, 84, SCREEN.size.width - 20, 30)];
    
    [self.view addSubview:tf];
    tf.backgroundColor = JHColor(229, 229, 229);
    tf.placeholder = @"发票信息";
    tf.font = [UIFont systemFontOfSize:14];
    tf.textColor = JHColor(51, 51, 51);
    UIButton *confirmBtn = [[UIButton alloc]init];
    confirmBtn.backgroundColor = [UIColor redColor];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = 3;
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(50);
        make.right.offset(-50);
        make.bottom.offset(-10);
        make.height.offset(30);
    }];
    
    
    
}
-(void)confirmClick:(UIButton *)btn{
    NSArray *vcarr = self.navigationController.viewControllers;
    for (UIViewController *vc in vcarr) {
        if ([vc isKindOfClass:[ConfirmOrderViewController class]]) {
            ConfirmOrderViewController *con = (ConfirmOrderViewController *)vc;
            con.bill = tf.text;
            [con.tableview reloadData];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height  + 50)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"selectstylecell"];
    [self.view addSubview:self.tableview];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectstylecell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = JHdeepColor;
    if (self.tag == 100) {
        cell.textLabel.text = self.dataArray[indexPath.row][@"pay_name"];
        [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"imgurl"]] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            cell.imageView.image = image;
        }];
        if ([self.dataArray[indexPath.row][@"pay_code"] isEqualToString:@"balance"]) {
            if (self.userMoney) {
                NSString *text = [NSString stringWithFormat:@"%@（可用余额￥%@）",self.dataArray[indexPath.row][@"pay_name"],self.userMoney];
                cell.textLabel.attributedText = [text AttributedString:[NSString stringWithFormat:@"（可用余额￥%@）",self.userMoney] backColor:nil uicolor:JHsimpleColor uifont:[UIFont systemFontOfSize:12]];
            }
            
        }
    }else if (self.tag == 101){
        NSString *text = [NSString stringWithFormat:@"%@（%@）",self.dataArray[indexPath.row][@"shipping_name"],self.dataArray[indexPath.row][@"format_shipping_fee"]];
        cell.textLabel.attributedText = [text AttributedString:[NSString stringWithFormat:@"（%@）",self.dataArray[indexPath.row][@"format_shipping_fee"]] backColor:nil uicolor:JHsimpleColor uifont:[UIFont systemFontOfSize:12]];
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *vcarr = self.navigationController.viewControllers;
    for (UIViewController *vc in vcarr) {
        if ([vc isKindOfClass:[ConfirmOrderViewController class]]) {
            ConfirmOrderViewController *con = (ConfirmOrderViewController *)vc;
            if (self.tag == 100) {
                con.payDict = self.dataArray[indexPath.row];
            }else if (self.tag == 101){
                con.expressDict = self.dataArray[indexPath.row];
                
            }
            [con.tableview reloadData];
            [con updateTableview];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
