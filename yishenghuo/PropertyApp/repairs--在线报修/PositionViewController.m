//
//  PositionViewController.m
//  shop
//
//  Created by wwzs on 16/4/12.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//



#import "PositionViewController.h"
#import "RepairsViewController.h"

@interface PositionViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(NSMutableArray *)itemArr{
    
    if (_itemArr == nil) {
        _itemArr = [[NSMutableArray alloc]init];
    }
    
    return _itemArr;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PositionCellIdentifier = @"PositionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PositionCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PositionCellIdentifier] ;
    }
    if ([self.itemArr[indexPath.row] isKindOfClass:[NSString class]]) {
        cell.textLabel.text = self.itemArr[indexPath.row];
    }else if ([self.itemArr[indexPath.row] isKindOfClass:[NSDictionary class]] && self.itemArr[indexPath.row][@"er_ProCategory"]){
        cell.textLabel.text = self.itemArr[indexPath.row][@"er_ProCategory"];//报修分类
    }else if ([self.itemArr[indexPath.row] isKindOfClass:[NSDictionary class]] && self.itemArr[indexPath.row][@"kiname"]){
        cell.textLabel.text = self.itemArr[indexPath.row][@"kiname"];//报修分类
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.itemArr[indexPath.row] isKindOfClass:[NSDictionary class]] && self.itemArr[indexPath.row][@"er_ProCategory"]){
        PositionViewController *positionVC = [[PositionViewController alloc]init];
        positionVC.delegate = self.delegate;
        NSArray *noteArr = self.itemArr[indexPath.row][@"note"];
        for (int i = 0; i < noteArr.count; i ++) {
            [positionVC.itemArr addObject:noteArr[i]];
        }
        positionVC.categoryDt = self.itemArr[indexPath.row];
        [self.navigationController pushViewController:positionVC animated:YES];
    }else{
        if ([self.delegate respondsToSelector:@selector(positionString:index:)] == YES)
        {
            if (self.categoryDt) {
                [self.delegate positionString:self.categoryDt index:indexPath.row];
            }else{
                [self.delegate positionString:self.itemArr[indexPath.row] index:indexPath.row];
            }
            
        }
        NSArray *vcArr = self.navigationController.viewControllers;
        for (UIViewController *vc in vcArr) {
            if ([vc isKindOfClass:[RepairsViewController class]]) {
                RepairsViewController *att = (RepairsViewController *)vc;
                att.isPop = @"project";
                [self.navigationController popToViewController:att animated:YES];
                
            }
        }
    }
    
    
    
    
    
}

@end


