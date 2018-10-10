//
//  ItemViewController.m
//  shop
//
//  Created by wwzs on 16/4/12.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//


#import "ItemViewController.h"
#import "RepairsViewController.h"

@interface ItemViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ItemViewController

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
    static NSString *ItemCellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ItemCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ItemCellIdentifier] ;
    }
    cell.textLabel.text = self.itemArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //代理调用协议方法
    
    if ([self.delegate respondsToSelector:@selector(itemString:)] == YES)
    {
        [self.delegate itemString:self.itemArr[indexPath.row]];
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

@end
