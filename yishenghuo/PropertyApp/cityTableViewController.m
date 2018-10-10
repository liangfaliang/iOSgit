//
//  cityTableViewController.m
//  shop
//
//  Created by 梁法亮 on 16/4/8.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "cityTableViewController.h"
#import "companyTableViewController.h"

@interface cityTableViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *rightGesture;


@property(nonatomic,strong)UITableView *tableview;
@end

@implementation cityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle = @"";
    self.view.backgroundColor = [UIColor whiteColor];
     self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height)];
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"citycell"];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    self.rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    [self.view addGestureRecognizer:self.rightGesture];
}


-(void)handleSwipes:(UIGestureRecognizer *)sender{

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    


}
-(NSMutableArray *)cityaArray{

    if (_cityaArray == nil) {
        _cityaArray = [[NSMutableArray alloc]init];
    }

    return _cityaArray;
}
-(NSMutableString *)str{
    
    if (_str == nil) {
        _str = [[NSMutableString alloc]init];
    }
    
    return  _str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.cityaArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"citycell" forIndexPath:indexPath];
    cell.textLabel.text = self.cityaArray[indexPath.row][@"city"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    companyTableViewController *company = [[companyTableViewController alloc]init];
    
    NSLog(@"qqq:%@",self.str);
  

    company.str = [NSMutableString stringWithFormat:@"%@ %@",self.str,self.cityaArray[indexPath.row][@"city"]];
    company.strid = [NSMutableString stringWithFormat:@"%@,%@",self.strid,self.cityaArray[indexPath.row][@"ciid"]];
    
    for (NSDictionary *dict in self.cityaArray[indexPath.row][@"le_arr"]) {

        
        [company.companyArray addObject:dict];
    }
        
   [self.navigationController pushViewController:company animated:YES];
    
    
}


@end
