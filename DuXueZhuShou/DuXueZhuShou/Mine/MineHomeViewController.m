//
//  MineHomeViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/9.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MineHomeViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "MineHeaderView.h"
#import "ChangePasswordViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "MyClassViewController.h"//我的班级
#import "WKViewViewController.h"
@interface MineHomeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)MineHeaderView *headerView;
@end

@implementation MineHomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UserUtils postGetUserInfo:self success:^(id response) {
        [self RefreshHeaderdata];
    } failure:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"我的";
    [self.view addSubview:self.tableView];
    [self UpData];
}
-(void)UpData{

}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
        NSString *cache = [NSString stringWithFormat:@"%.2fM",[ self folderSizeAtPath :cachPath]];
        NSArray *array = @[];
        if ([UserUtils getUserRole] == UserStyleStudent) {
            array = @[@{@"name":@"   修改密码",@"leftim":@"password",@"rightim":@"1"},
                               @{@"name":@"   关于我们",@"leftim":@"about",@"rightim":@"1"},
                               @{@"name":@"   清除缓存",@"text":cache,@"leftim":@"clear"}];
        }else if ([UserUtils getUserRole] == UserStyleInstructor){
            array = @[@{@"name":@"   我的班级",@"leftim":@"password",@"rightim":@"1"},
                      @{@"name":@"   修改密码",@"leftim":@"about",@"rightim":@"1"},
                      @{@"name":@"   清除缓存",@"text":cache,@"leftim":@"clear"}];
        }else if ([UserUtils getUserRole] == UserStyleTeacher){
            array = @[@{@"name":@"   修改密码",@"leftim":@"about",@"rightim":@"1"},
                      @{@"name":@"   清除缓存",@"text":cache,@"leftim":@"clear"}];
        }

        for (NSDictionary *dt in array) {
            TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:dt];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

-(MineHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [MineHeaderView view];
        _headerView.height_i = 150;
    }
    return _headerView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 60;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        _tableView.tableHeaderView = self.headerView;
        UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 170)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 60, screenW - 30, 50)];
        [footer addSubview:btn];
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
        [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.backgroundColor = JHbgColor;
        [btn setViewBorderColor:JHBorderColor borderWidth:1];
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(OutPutClick) forControlEvents:UIControlEventTouchUpInside];
        _tableView.tableFooterView = footer;
//        WEAKSELF;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            weakSelf.page = 1;
//            self.more = 1;
//            [self getDataList:weakSelf.page];
//        }];

    }
    return _tableView;
}
-(void)RefreshHeaderdata{
//    @property (weak, nonatomic) IBOutlet UIImageView *iconIm;
//    @property (weak, nonatomic) IBOutlet UILabel *addressLb;
//    @property (weak, nonatomic) IBOutlet UILabel *nameLb;
//    @property (weak, nonatomic) IBOutlet UILabel *gardeLb;
    UserModel *mo = [UserUtils getUserInfo];
    if (mo) {
        self.headerView.nameLb.text = mo.name;
        [self.headerView.iconIm sd_setImageWithURL:[NSURL URLWithString:mo.avatar] placeholderImage:PlaceholderImage];
        if ([UserUtils getUserRole] == UserStyleStudent) {
            self.headerView.gardeLb.hidden = NO;
            self.headerView.addressLb.text = [NSString stringWithFormat:@"%@%@%@",mo.schoolName,mo.campusName,mo.className];
            self.headerView.gardeLb.text = [NSString stringWithFormat:@"   %@   ",mo.rank];
        }else{
            self.headerView.addressLb.text = [UserUtils getUserRole] == UserStyleInstructor ? @"学管员" : @"老师";
            self.headerView.gardeLb.hidden = YES;
        }
        
    }
}
#pragma mark - 退出登录
-(void)OutPutClick{
    [UserUtils RemoveUserInfo];
    [self CheckIsLogin];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextFiledLableTableViewCell class]) forIndexPath:indexPath];
    cell.nameBtn.userInteractionEnabled = NO;
    cell.model = self.dataArray[indexPath.row];
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    return cell;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return -1;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.headerView;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UserUtils getUserRole] == UserStyleStudent) {
        if (indexPath.row == 0) {//修改密码
            [self.navigationController pushViewController:[[ChangePasswordViewController alloc]init] animated:YES];
        }else if (indexPath.row == 1) {//关于我们
            WKViewViewController *bord = [[WKViewViewController alloc]init];
            bord.titleStr = @"关于我们";
            bord.urlStr = NSStringWithFormat(SERVER_IP,NSStringWithFormat(HtmlDetailUrl, @"1"));
            [self.navigationController pushViewController:bord animated:YES];
        }else if (indexPath.row == 2) {//清除缓存
            [self clearFile];
        }
    }else if ([UserUtils getUserRole] == UserStyleInstructor){
        if (indexPath.row == 0) {//我的班级
            [self.navigationController pushViewController:[[MyClassViewController alloc]init] animated:YES];
        }else if (indexPath.row == 1) {//修改密码
            [self.navigationController pushViewController:[[ChangePasswordViewController alloc]init] animated:YES];
        }else if (indexPath.row == 2) {//清除缓存
            [self clearFile];
        }
    }else if ([UserUtils getUserRole] == UserStyleTeacher){
        if (indexPath.row == 0) {//修改密码
            [self.navigationController pushViewController:[[ChangePasswordViewController alloc]init] animated:YES];
        }else if (indexPath.row == 1) {//清除缓存
            [self clearFile];
        }
    }

}
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0 ;
}
//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
    
}
// 清理缓存

- (void)clearFile
{
//    NSString *html = @" {margin: 0.0px 0.0px 0.0px 0.0px; font: 16.0px 'Heiti SC'; color: #000000}p.p2 {margin: 0.0px 0.0px 0.0px 0.0px; font: 12.0px Helvetica}p.p3 {margin: 0.0px 0.0px 0.0px 0.0px; font: 25.0px 'Heiti SC'; color: #000000}span.s1 {font-family: 'STHeitiSC-Light'; font-weight: normal; font-style: normal; font-size: 16.00pt}span.s2 {font-family: 'Helvetica'; font-weight: normal; font-style: normal; font-size: 12.00pt}span.s3 {font-family: 'STHeitiSC-Light'; font-weight: normal; font-style: normal; font-size: 25.00pt}</style></head><body>";
//    NSScanner *sc = [NSScanner scannerWithString:html];
//    NSString *tt = nil;
//    while ([sc isAtEnd] == NO) {
//        [sc scanUpToString:@"font:" intoString:nil];
//        [sc scanUpToString:@"x" intoString:&tt];
//        NSString *tem = [NSString stringWithString:tt];
//        NSScanner *scanner = [NSScanner scannerWithString:tt];
//        [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
//        int number;
//        [scanner scanInt:&number];
//        NSLog(@"number : %d", number);
//        tem = [tem stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%d",number] withString:[NSString stringWithFormat:@"%d",number-2]];
//        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",tt] withString:tem];
//    }
//    LFLog(@"html:%@",html);
//    return;
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    NSLog ( @"cachpath = %@" , cachPath);
    for ( NSString * p in files) {
        //如有需要，加入条件，过滤掉不想删除的文件
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
}
-(void)clearCachSuccess
{

    [self dismissTips];
    [self presentLoadingTips:@"清除成功"];
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    LFLog(@"缓存大小：%f",[ self folderSizeAtPath :cachPath]);
    TextFiledModel *model = self.dataArray[[UserUtils getUserRole] == UserStyleTeacher ? 1 : 2];
    model.text = [NSString stringWithFormat:@"%.2fM",[ self folderSizeAtPath :cachPath]];
    [self.tableView reloadData];
}


@end
