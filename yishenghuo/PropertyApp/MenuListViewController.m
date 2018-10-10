//
//  MenuListViewController.m
//  shop
//
//  Created by 梁法亮 on 16/7/27.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "MenuListViewController.h"
#import "PostViewController.h"

@interface MenuListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableview;

@end

@implementation MenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"请选择";
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height ) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    LFLog(@"%@",self.dataArr);
}

-(NSMutableArray *)dataArr{

    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    
    return _dataArr;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = self.dataArr[indexPath.row][@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    NSArray *vcArr = self.navigationController.viewControllers;
    for (UIViewController *vc in vcArr) {
        if ([vc isKindOfClass:[PostViewController class]]) {
            
            NSLog(@"自控制器：%@",[vc class]);
            PostViewController *att = (PostViewController *)vc;
            att.dit = self.dataArr[indexPath.row];
            NSString *str = att.lab.text;
            att.lab.text = [NSString stringWithFormat:@"%@ - %@",str,att.dit[@"name"]];
            [self.navigationController popToViewController:att animated:YES];
        }
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
