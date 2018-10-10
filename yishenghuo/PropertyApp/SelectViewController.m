//
//  SelectViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/5/13.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "SelectViewController.h"

@interface SelectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableview;

@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"请选择";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height)];
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"citycell"];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
}


-(void)handleSwipes:(UIGestureRecognizer *)sender{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
    
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}




#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"citycell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = JHmiddleColor;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(SelectViewControllerDelegate:tyId:)]) {
        [self.delegate SelectViewControllerDelegate:[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]] tyId:self.dataArray[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
