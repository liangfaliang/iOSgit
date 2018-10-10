
//
//  ChangeUserInfoViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/29.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ChangeUserInfoViewController.h"
#import "ShopOtherTableViewCell.h"
@interface ChangeUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)NSArray *array1;
@property (nonatomic,strong)UITextField *tfname;
@end

@implementation ChangeUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = self.nameTitle;
    
    if (self.tag == 100) {
        UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
        rightBtn.tintColor = JHAssistColor;
        self.navigationItem.rightBarButtonItem = rightBtn;
    }else if (self.tag == 101) {
    self.array1 = @[@"保密",@"男",@"女"];
    }else if (self.tag == 90) {//志愿者选择性别
        self.array1 = @[@"男",@"女"];
    }
    [self createTableview];
    
}
-(void)rightClick:(UIBarButtonItem *)btn{
    if ([self.tfname.text isIncludeSpecialCharact]) {
        [self presentLoadingTips:@"昵称不能包含特殊字符"];
        return;
    }
    
    if (self.tfname.text.length >=2 && self.tfname.text.length <=20) {
        [self upDateNickname];
    }else{
        [self presentLoadingTips:@"请输入4-20个字符"];
    }
    
    
}
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = JHbgColor;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChangeUserInfoViewController"];
    [self.view addSubview:self.tableview];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.tag == 101 || self.tag == 90) {
        return self.array1.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.tag == 100) {
        return 20;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (self.tag == 100) {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"    4-20个字符，可有中英文、数字、""_""、""-""组成";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = JHColor(151,151, 151);
        label.backgroundColor = JHbgColor;
        return label;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangeUserInfoViewController"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.MustImHeight.constant = 0;
 
    if (self.tag == 100) {
        [cell.contentView removeAllSubviews];
        if (self.tfname == nil) {
            self.tfname = [[UITextField alloc]init];
            self.tfname.text = self.name;
            self.tfname.font = [UIFont systemFontOfSize:14];
            self.tfname.textColor = JHColor(51, 51, 51);
            self.tfname.clearButtonMode = UITextFieldViewModeAlways;
            [cell.contentView addSubview:self.tfname];
            [self.tfname mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.right.offset(-10);
                make.top.offset(0);
                make.bottom.offset(0);
            }];
        }
    }else if (self.tag == 101 || self.tag == 90) {
        if ([self.name isEqualToString:self.array1[indexPath.row]]) {
          cell.rigthtIm.image = [UIImage imageNamed:@"duihaotongyong"];
        }else{
        cell.rigthtIm.image = nil;
        }
        
        cell.nameLabel.text = self.array1[indexPath.row];
        CGSize namesize = [cell.nameLabel.text selfadaption:15];
        cell.nameHeight.constant = namesize.width + 5;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tag == 101 || self.tag == 90) {
        for (int i = 0; i < 3; i ++) {
            NSIndexPath *inPath = [NSIndexPath indexPathForRow:i inSection:0];
            ShopOtherTableViewCell *cell = [tableView cellForRowAtIndexPath:inPath];
            if (i == indexPath.row) {
                 cell.rigthtIm.image = [UIImage imageNamed:@"duihaotongyong"];
            }else{
                cell.rigthtIm.image = nil;
            }
        }

        if (self.tag == 101) {
            [self upDateSex:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }else{
            if (self.Block) {
                self.Block(self.array1[indexPath.row]);
            }
            [self.navigationController popViewControllerAnimated:YES];
        
        }
        
    }
       
}

#pragma mark 修改性别
-(void)upDateSex:(NSString *)sex{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [dt setObject:sex forKey:@"sex"];
    
    LFLog(@"性别:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,UserSexUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"修改性别：%@",response);
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"修改成功"];
            [self performSelector:@selector(popview) withObject:nil afterDelay:1.0];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}


#pragma mark 修改昵称
-(void)upDateNickname{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }

    [dt setObject:self.tfname.text forKey:@"nickname"];

    LFLog(@"昵称:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,UserNicknameUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"修改昵称：%@",response);
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"修改成功"];
            [self performSelector:@selector(popview) withObject:nil afterDelay:1.0];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
-(void)popview{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
