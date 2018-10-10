//
//  SelectTableViewController.m
//  shop
//
//  Created by 梁法亮 on 16/4/8.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "SelectTableViewController.h"
#import "cityTableViewController.h"

@interface SelectTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation SelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationBarTitle = @"";
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 64)];

    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)selectArray{
    if (_selectArray == nil) {
        _selectArray = [[NSMutableArray alloc]init];
    }
    return _selectArray;
}

-(NSMutableArray *)dataArray{

    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }


    return _dataArray;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"%lu",(unsigned long)self.selectArray.count);
    return self.selectArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = self.selectArray[indexPath.row][@"Province"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    cityTableViewController *ciyt = [[cityTableViewController alloc]init];
    for (NSArray *arr in self.selectArray[indexPath.row][@"note"]) {
       
           [ciyt.cityaArray addObject:arr];
    }
    ciyt.strid = [NSMutableString stringWithFormat:@"%@",self.selectArray[indexPath.row][@"prid"]];
    ciyt.str = [NSMutableString stringWithFormat:@"%@",self.selectArray[indexPath.row][@"Province"]];
    [self.navigationController pushViewController:ciyt animated:YES];


}


@end
