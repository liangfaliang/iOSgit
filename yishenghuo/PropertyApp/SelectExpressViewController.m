//
//  SelectExpressViewController.m
//  shop
//
//  Created by 梁法亮 on 16/8/25.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "SelectExpressViewController.h"
#import "SendExpressViewController.h"
@interface SelectExpressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;

@end

@implementation SelectExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 64)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"project"];
    [self.view addSubview:self.tableview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSMutableArray *)projectArray{
    
    if (_projectArray == nil) {
        _projectArray = [[NSMutableArray alloc]init];
    }
    
    return _projectArray;
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.projectArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"project";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    cell.textLabel.text = self.projectArray[indexPath.row][@"content"];

            return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.tag == 500) {
        
 
        NSArray *vcArr = self.navigationController.viewControllers;
        for (UIViewController *vc in vcArr) {
            if ([vc isKindOfClass:[SendExpressViewController class]]) {
                
                SendExpressViewController *Rep= (SendExpressViewController *)vc;
                Rep.timelb.text = self.projectArray[indexPath.row][@"content"];

                [self.navigationController popToViewController:Rep animated:YES];
            }
        }
        
    }else if(self.tag == 501){

        
        NSArray *vcArr = self.navigationController.viewControllers;
        for (UIViewController *vc in vcArr) {
          if ([vc isKindOfClass:[SendExpressViewController class]]) {
            
            SendExpressViewController *Rep= (SendExpressViewController *)vc;
            Rep.placeLb.text = self.projectArray[indexPath.row][@"content"];
            
            [self.navigationController popToViewController:Rep animated:YES];
        }
    }
        
    }
}


@end
