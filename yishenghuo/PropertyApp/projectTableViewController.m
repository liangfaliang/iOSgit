//
//  projectTableViewController.m
//  shop
//
//  Created by 梁法亮 on 16/4/8.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "projectTableViewController.h"
#import "AttestViewController.h"
#import "RepairsViewController.h"
#import "EmployeeCertificationViewController.h"
#import "registerViewController.h"
@interface projectTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@end

@implementation projectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle = @"";
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
-(NSMutableString *)str{
    
    if (_str == nil) {
        _str = [[NSMutableString alloc]init];
    }
    
    return  _str;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.projectArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"project";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (self.tag == 102) {
        cell.textLabel.text = self.projectArray[indexPath.row];
        return cell;
    }else if(self.tag == 1021){
        cell.textLabel.text = self.projectArray[indexPath.row][@"as_types"];
        
        return cell;
        
        
    }else if(self.tag == 1041){
        cell.textLabel.text = self.projectArray[indexPath.row][@"kiname"];
        
        return cell;
        
        
    }else{
        cell.textLabel.text = self.projectArray[indexPath.row][@"le_name"];
        
        return cell;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.tag == 102) {
     
       
        NSMutableString * str = [NSMutableString stringWithFormat:@"%@ %@",self.str,self.projectArray[indexPath.row]];
        
        NSArray *vcArr = self.navigationController.viewControllers;
        for (UIViewController *vc in vcArr) {
            if ([vc isKindOfClass:[RepairsViewController class]]) {
                
                RepairsViewController *Rep= (RepairsViewController *)vc;
                Rep.isPop = @"project";
                Rep.poid = [UserDefault objectForKey:[NSString stringWithFormat:@"poid_%ld",(long)indexPath.row]];
//                [Rep.itembtn setTitle:str forState:UIControlStateNormal];
                [Rep itemString:str];
                [self.navigationController popToViewController:Rep animated:YES];
            }
        }
        
    }else if(self.tag == 1021){
        NSMutableString * str = [NSMutableString stringWithFormat:@"%@ %@",self.str,self.projectArray[indexPath.row][@"as_types"]];
        
        NSArray *vcArr = self.navigationController.viewControllers;
        for (UIViewController *vc in vcArr) {
            if ([vc isKindOfClass:[RepairsViewController class]]) {
                
                RepairsViewController *Rep= (RepairsViewController *)vc;
                Rep.isPop = @"project";
                [Rep positionString:str index:indexPath.row];
//                [Rep.positionbtn setTitle:str forState:UIControlStateNormal];
                [self.navigationController popToViewController:Rep animated:YES];
            }
        }
        
    }else if(self.tag == 1041){
        NSMutableString * str = [NSMutableString stringWithFormat:@"%@ %@",self.str,self.projectArray[indexPath.row][@"kiname"]];
        
        NSArray *vcArr = self.navigationController.viewControllers;
        for (UIViewController *vc in vcArr) {
            if ([vc isKindOfClass:[RepairsViewController class]]) {
                
                RepairsViewController *Rep= (RepairsViewController *)vc;
                Rep.isPop = @"project";
                [Rep positionString:str];
//                [Rep.positionbtn setTitle:str forState:UIControlStateNormal];
                [self.navigationController popToViewController:Rep animated:YES];
            }
        }
        
    }else{
    
    NSMutableString * str = [NSMutableString stringWithFormat:@"%@ %@",self.str,self.projectArray[indexPath.row][@"le_name"]];
    NSLog(@"%@",str);
    
    NSArray *vcArr = self.navigationController.viewControllers;
    for (UIViewController *vc in vcArr) {
        if ([vc isKindOfClass:[AttestViewController class]]) {
            AttestViewController *att = (AttestViewController *)vc;
            att.str = [NSMutableString stringWithFormat:@"%@ %@",self.str,self.projectArray[indexPath.row][@"le_name"]];
            att.strID = [NSMutableString stringWithFormat:@"%@,%@",self.strid,self.projectArray[indexPath.row][@"leid"]];
            att.isSenbox = @"projectTableViewController";
            [att.proButton setTitle:str forState:UIControlStateNormal];
            [self.navigationController popToViewController:att animated:YES];
        }else if ([vc isKindOfClass:[EmployeeCertificationViewController class]]){
        
            EmployeeCertificationViewController *employ = (EmployeeCertificationViewController *)vc;
            employ.str = [NSMutableString stringWithFormat:@"%@ %@",self.str,self.projectArray[indexPath.row][@"le_name"]];
            
            employ.strid = [NSMutableString stringWithFormat:@"%@,%@",self.strid,self.projectArray[indexPath.row][@"leid"]];
        
            [self.navigationController popToViewController:employ animated:YES];
        
        }else if ([vc isKindOfClass:[registerViewController class]]){
            
            registerViewController *regis = (registerViewController *)vc;
            regis.str = [NSMutableString stringWithFormat:@"%@ %@",self.str,self.projectArray[indexPath.row][@"le_name"]];
            
            regis.strID = [NSMutableString stringWithFormat:@"%@,%@",self.strid,self.projectArray[indexPath.row][@"leid"]];
            
            [regis.sumbtn setTitle:str forState:UIControlStateNormal];
            [regis.sumbtn setTitleColor:JHdeepColor forState:UIControlStateNormal];

            
            [self.navigationController popToViewController:regis animated:YES];
            
        }
        
    }
    
 }
}



@end
