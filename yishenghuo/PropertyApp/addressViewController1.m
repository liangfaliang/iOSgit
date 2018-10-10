//
//  addressViewController1.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/5.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "addressViewController1.h"
#import "addressViewController2.h"
@interface addressViewController1 ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableview;



@end

@implementation addressViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height )];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    
    return _dataArray;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    
    cell.textLabel.text = self.dataArray[indexPath.row][@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    addressViewController2 *ciyt = [[addressViewController2 alloc]init];

    ciyt.parent_id = self.dataArray[indexPath.row][@"id"];
    
    ciyt.region = self.dataArray[indexPath.row][@"name"];
    ciyt.regionid = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:ciyt animated:YES];
    
    
}



@end
