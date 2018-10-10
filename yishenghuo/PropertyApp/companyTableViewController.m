//
//  companyTableViewController.m
//  shop
//
//  Created by 梁法亮 on 16/4/8.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "companyTableViewController.h"
#import "projectTableViewController.h"
#import "Person.h"
#import "YXTableViewIndexView.h"
#import "AttestViewController.h"
#import "registerViewController.h"
@interface companyTableViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *indexArray;
@property (strong,nonatomic) NSMutableArray * headerArr;
@property(nonatomic,strong)UISearchBar *searchbar;//搜索
@property (strong,nonatomic) YXTableViewIndexView * tableViewIndexView;
@property (assign,nonatomic) NSInteger  inx;
@end

@implementation companyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height )];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"companycell"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cartfirmCell"];//修改索引颜色
    if (self.is_Sort) {
        self.tableview.sectionIndexBackgroundColor = [UIColor clearColor];//修改右边索引的背景色
        self.tableview.sectionIndexColor = JHdeepColor;//修改右边索引字体的颜色
//        self.tableview.sectionIndexTrackingBackgroundColor = JHMaincolor;//修改右边索引点击时候的背景色
        [self SortingSourcedata:self.companyArray];
        //添加自定义索引视图
        [self.tableview.superview addSubview:self.tableViewIndexView];
        //搜索框
        self.searchbar = nil;
        self.searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width - 120, 40)];
        self.searchbar.layer.cornerRadius = 5;
        self.searchbar.layer.masksToBounds = YES;
        self.searchbar.placeholder = @"搜索";
        self.searchbar.delegate = self;
        self.searchbar.returnKeyType = UIReturnKeySearch;
        [_searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"sousuokuangshangcheng"] forState:UIControlStateNormal];
        //    _searchbar.translatesAutoresizingMaskIntoConstraints = YES;
        self.searchbar.backgroundColor = [UIColor clearColor];
        UIView *seachview = [[UIView alloc]initWithFrame:CGRectMake(60, 20, SCREEN.size.width - 120, 40)];
        [seachview addSubview:_searchbar];
        if (iOS11) {
            self.navigationItem.titleView = seachview;
        }else{
            self.navigationItem.titleView = _searchbar;
        }
    }


}
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
    
}

#pragma mark - UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dt in self.companyArray) {
        if (searchBar.text.length || searchText.length) {
            NSMutableString *tempStr = [NSMutableString stringWithFormat:@"%@",dt[@"le_name"]];
            LFLog(@"tempStr:%@\nsearchText:%@",tempStr,searchText);
            NSRange titleResult=[tempStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [tempArr addObject:dt];
            }
        }else{
            [tempArr addObject:dt];
        }
        
    }
    [self SortingSourcedata:tempArr];
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    LFLog(@"searchBar.text:%lu",searchBar.text.length);
    NSMutableArray *tempArr = [NSMutableArray array];
    if (searchBar.text.length == 0) {
        for (NSDictionary *dt in self.companyArray) {
            [tempArr addObject:dt];
        }
        [self SortingSourcedata:tempArr];
    }

}
-(NSMutableArray *)headerArr{
    if(nil == _headerArr){
        _headerArr = [[NSMutableArray alloc] init];
    }
    return _headerArr;
}
-(NSMutableArray *)indexArray{
    
    if (_indexArray == nil) {
        _indexArray = [[NSMutableArray alloc]init];
    }
    
    return _indexArray;
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}
-(NSMutableArray *)companyArray{
    
    if (_companyArray == nil) {
        _companyArray = [[NSMutableArray alloc]init];
    }
    
    return _companyArray;
}

-(NSMutableString *)str{
    
    if (_str == nil) {
        _str = [[NSMutableString alloc]init];
    }
    
    return  _str;
}
-(YXTableViewIndexView *)tableViewIndexView{
    if(nil == _tableViewIndexView){
        _tableViewIndexView = [YXTableViewIndexView loadFromXib];
        //索引视图设置
        _tableViewIndexView.tableView = self.tableview;
        CGRect frame = _tableViewIndexView.frame;
        frame.origin.x = self.tableview.frame.size.width - _tableViewIndexView.frame.size.width;
        frame.origin.y = self.tableview.frame.origin.y + self.tableview.contentInset.top;
        _tableViewIndexView.frame = frame;
        _tableViewIndexView.isShowTipView = YES;
        _tableViewIndexView.tipViewTitleFont = [UIFont systemFontOfSize:24];
        _tableViewIndexView.tipViewBackgroundImage = [UIImage imageNamed:@"fangdakuang"];
        _tableViewIndexView.tipViewBackgroundColor = [UIColor clearColor];
        _tableViewIndexView.tipViewTitleColor = [UIColor whiteColor];
        self.inx = 0;
        [_tableViewIndexView refashSelectLb:self.inx];
    }
    return _tableViewIndexView;
}
//排序
-(void)SortingSourcedata:(NSMutableArray *)noteArr{
    
    [self.dataArray removeAllObjects];
    [self.indexArray removeAllObjects];
    NSMutableArray *personArr = [NSMutableArray arrayWithCapacity:noteArr.count];
    for (NSDictionary *str in noteArr) {
        Person *person = [[Person alloc] initWithName:str];
        [personArr addObject:person];
    }
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSLog(@"%@", collation.sectionTitles);
    
    //1.获取获取section标题
    NSArray *titles = collation.sectionTitles;
    
    //2.构建每个section数组
    NSMutableArray *secionArray = [NSMutableArray arrayWithCapacity:titles.count];
    for (int i = 0; i < titles.count; i++) {
        NSMutableArray *subArr = [NSMutableArray array];
        [secionArray addObject:subArr];
    }
    //3.排序
    //3.1 按照将需要排序的对象放入到对应分区数组
    for (Person *person in personArr) {
        NSInteger section = [collation sectionForObject:person collationStringSelector:@selector(le_name)];
        NSMutableArray *subArr = secionArray[section];
        [subArr addObject:person];
    }
    
    //3.2 分别对分区进行排序
    for (NSMutableArray *subArr in secionArray) {
        NSArray *sortArr = [collation sortedArrayFromArray:subArr collationStringSelector:@selector(le_name)];
        [subArr removeAllObjects];
        [subArr addObjectsFromArray:sortArr];
        
    }
    
    for (int i = 0; i < titles.count; i++) {
        if ([secionArray[i] count]) {
            [self.indexArray addObject:titles[i]];
            [self.dataArray addObject:secionArray[i]];
            [self.headerArr addObject:[[UIView alloc]init]];
        }
    }
    [self.tableview reloadData];
}
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.is_Sort) {
        return self.dataArray.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.is_Sort) {
        return [self.dataArray[section] count];
    }
    return self.companyArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.is_Sort) {
        return 30;
    }
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"companycell"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (self.is_Sort) {
        Person *per = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = per.le_name;
    }else{
        if (self.tag == 101) {
            cell.textLabel.text = self.companyArray[indexPath.row];
        }else if (self.tag == 102) {
            cell.textLabel.text = self.companyArray[indexPath.row];
        }else if(self.tag == 1021){
            cell.textLabel.text = self.companyArray[indexPath.row][@"as_class"];
        }else if(self.tag == 1041){
            cell.textLabel.text = self.companyArray[indexPath.row][@"ki_name"];
        }else{
            cell.textLabel.text = self.companyArray[indexPath.row][@"company"];
        }
    }
    return cell;
}
//右侧索引
#pragma mark - UITableViewDataSource

#pragma mark SectionTitles
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.is_Sort) {
        if ([self.dataArray[section] count]) {
//            return [[UILocalizedIndexedCollation currentCollation].sectionTitles objectAtIndex:section];
            return [self.indexArray objectAtIndex:section];
        }
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.is_Sort) {
//        return self.indexArray;
        [self.tableViewIndexView setIndexTitlesArray:self.indexArray];
//        [self.tableViewIndexView setIndexTitlesArray:[UILocalizedIndexedCollation currentCollation].sectionTitles];
//        return [UILocalizedIndexedCollation currentCollation].sectionTitles;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.is_Sort) {
        NSInteger count = 0;
        for(NSString *character in self.indexArray)
        {
            if([character isEqualToString:title])
            {
                return count;
            }
            count ++;
        }
    }

    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

     NSString*sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    UILabel*label=[[UILabel alloc]init];

    label.frame=CGRectMake(13,0, 300, 31);

    label.backgroundColor=[UIColor clearColor];

    label.textColor= JHsimpleColor;

    label.text=sectionTitle;
    // Createheader view and add label as a subview
    UIView*sectionView = self.headerArr[section];
    [sectionView removeAllSubviews];
    sectionView=[[UIView alloc] initWithFrame:CGRectMake(0,0, tableView.bounds.size.width,22)];
    [sectionView setBackgroundColor:JHbgColor];
    [sectionView addSubview:label];
    return sectionView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.is_Sort) {
        Person *per = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
        NSMutableString * str = [NSMutableString stringWithFormat:@"%@ %@ %@ %@",per.province,per.city,per.company,per.le_name];
        NSLog(@"%@",str);
        NSArray *vcArr = self.navigationController.viewControllers;
        for (UIViewController *vc in vcArr) {
            if ([vc isKindOfClass:[AttestViewController class]]) {
                AttestViewController *att = (AttestViewController *)vc;
                att.str = [NSMutableString stringWithFormat:@"%@ %@ %@ %@",per.province,per.city,per.company,per.le_name];
                att.strID = [NSMutableString stringWithFormat:@"%@,%@,%@,%@",per.prid,per.ciid,per.coid,per.leid];
                att.isSenbox = @"projectTableViewController";
                [att.proButton setTitle:str forState:UIControlStateNormal];
                [self.navigationController popToViewController:att animated:YES];
            }else if ([vc isKindOfClass:[registerViewController class]]){
                
                registerViewController *regis = (registerViewController *)vc;
                regis.str = [NSMutableString stringWithFormat:@"%@ %@ %@ %@",per.province,per.city,per.company,per.le_name];
                regis.strID = [NSMutableString stringWithFormat:@"%@,%@,%@,%@",per.prid,per.ciid,per.coid,per.leid];
                [regis.sumbtn setTitle:str forState:UIControlStateNormal];
                [regis.sumbtn setTitleColor:JHdeepColor forState:UIControlStateNormal];
                regis.rightImage.hidden = YES;
                [self.navigationController popToViewController:regis animated:YES];
                
            }
        }
        return;
    }
    if (self.tag == 101) {
        projectTableViewController *project = [[projectTableViewController alloc]init];
        NSInteger count = [[UserDefault objectForKey:@"PropertyCount"] integerValue];
        for (int i = 0; i < count; i ++) {
            [project.projectArray addObject:[UserDefault objectForKey:[NSString stringWithFormat:@"po_name_%d",i]]];
            
        }
        //            NSUserDefaults *defuat = [NSUserDefaults standardUserDefaults];
        //            [project.projectArray addObject:[defuat objectForKey:@"po_name"]];
        project.tag = 102;
        
        project.str = [NSMutableString stringWithFormat:@"%@",self.companyArray[indexPath.row]];
        [self.navigationController pushViewController:project animated:YES];
        
    }else if (self.tag == 102) {
        projectTableViewController *project = [[projectTableViewController alloc]init];
        NSInteger count = [[UserDefault objectForKey:@"PropertyCount"] integerValue];
        for (int i = 0; i < count; i ++) {
            [project.projectArray addObject:[UserDefault objectForKey:[NSString stringWithFormat:@"po_name_%d",i]]];
            
        }
//            NSUserDefaults *defuat = [NSUserDefaults standardUserDefaults];
//            [project.projectArray addObject:[defuat objectForKey:@"po_name"]];
        project.tag = 102;
     
        project.str = [NSMutableString stringWithFormat:@"%@",self.companyArray[indexPath.row]];
        [self.navigationController pushViewController:project animated:YES];
        
    }else if(self.tag == 1021){
        projectTableViewController *project = [[projectTableViewController alloc]init];
        project.tag = 1021;
        
        for (NSArray *arr in self.companyArray[indexPath.row][@"note"]) {
            
            [project.projectArray addObject:arr];
        }
        project.str = [NSMutableString stringWithFormat:@"%@",self.companyArray[indexPath.row][@"as_class"]];
        [self.navigationController pushViewController:project animated:YES];
        
    }else if(self.tag == 1041){
        projectTableViewController *project = [[projectTableViewController alloc]init];
        project.tag = 1041;
        
        for (NSArray *arr in self.companyArray[indexPath.row][@"note"]) {
            
            [project.projectArray addObject:arr];
        }
        project.str = [NSMutableString stringWithFormat:@"%@",self.companyArray[indexPath.row][@"ki_name"]];
        
        
        [self.navigationController pushViewController:project animated:YES];
    
    }else{
        projectTableViewController *project = [[projectTableViewController alloc]init];
     
        for (NSArray *arr in self.companyArray[indexPath.row][@"note"]) {
            [project.projectArray addObject:arr];
        }
        project.str = [NSMutableString stringWithFormat:@"%@ %@",self.str,self.companyArray[indexPath.row][@"company"]];
        project.strid = [NSMutableString stringWithFormat:@"%@,%@",self.strid,self.companyArray[indexPath.row][@"coid"]];

        [self.navigationController pushViewController:project animated:YES];
    
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_tableViewIndexView) {
        CGFloat XX = 0;
        for (int i = 0; i < self.dataArray.count; i ++) {
            if (self.tableview.contentOffset.y > XX && self.tableview.contentOffset.y < XX + 30 ) {
                LFLog(@"section:%d",i);
                if (self.inx != i) {
                    [_tableViewIndexView refashSelectLb:i];
                    self.inx = i;
                    
                    break;
                }
            }
            XX += 30;
            XX += 44 *([self.dataArray[i] count]);
        }
    }

    
}

@end
