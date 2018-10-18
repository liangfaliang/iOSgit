//
//  LearnHomeViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/7/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LearnHomeViewController.h"
#import "SDCycleScrollView.h"
#import "ImageLabelCollectionViewCell.h"
#import "StuNewsViewController.h"
#import "PunchOperationListViewController.h"
#import "SignInMapViewController.h"
#import "AttendanceListViewController.h"
#import "TestScoreViewController.h"
#import "MyAnswerListViewController.h"
#import "LeaveListViewController.h"
#import "PostOperationViewController.h"
#import "StudentGroupViewController.h"
#import "ReleaseGradeViewController.h"
#import "SupplyFractionViewController.h"
#import "AFNetworking.h"
#import "SoapUtil.h"
#import "WKViewViewController.h"
#define headerHt SCREEN.size.width * 12/25
@interface LearnHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)NSMutableArray * bookArr;
@property (nonatomic,strong)NSMutableArray * pictureArr;
@property (nonatomic,strong)UICollectionView * collectionview;
@property (nonatomic, strong)SDCycleScrollView *sdCySV;

@end

@implementation LearnHomeViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getReadMessage];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"督学小助手";
    [self.view addSubview:self.sdCySV];
    [self.view addSubview:self.collectionview];
    [self updata];

}

-(void)updata{
    [self getData];
}

-(NSMutableArray *)pictureArr{
    if (_pictureArr == nil) {
        _pictureArr = [NSMutableArray array];
    }
    return _pictureArr;
}

- (NSMutableArray *)bookArr
{
    if (!_bookArr) {
        _bookArr = [[NSMutableArray alloc]init];
        NSArray *arr = @[];
        if ([UserUtils getUserRole] == UserStyleStudent) {
            arr = @[@{@"name":@"消息",@"imgurl":@"xiaoxi"},
                    @{@"name":@"打卡作业",@"imgurl":@"daka"},
                    @{@"name":@"考勤签到",@"imgurl":@"qiandao"},
                    @{@"name":@"测试成绩",@"imgurl":@"cjfb"},
                    @{@"name":@"一对一答疑",@"imgurl":@"qjsp" },
                    @{@"name":@"请假审批",@"imgurl":@"bfsp"}];
        }else if ([UserUtils getUserRole] == UserStyleInstructor){
            arr = @[@{@"name":@"消息",@"imgurl":@"xiaoxi"},
                    @{@"name":@"布置作业",@"imgurl":@"daka"},
                    @{@"name":@"考勤设定",@"imgurl":@"qiandao"},
                    @{@"name":@"成绩发布",@"imgurl":@"cjfb"},
                    @{@"name":@"请假审批",@"imgurl":@"qjsp" },
                    @{@"name":@"补分审批",@"imgurl":@"bfsp"}];
        }
        
        for (NSDictionary *dt in arr) {
            ImLbModel *mo = [ImLbModel mj_objectWithKeyValues:dt];
            
            [_bookArr addObject:mo];
        }
//        [_bookArr addObjectsFromArray:@[@"",@"",@"",@"",@"",@""]];
    }
    return _bookArr;
}

- (SDCycleScrollView *)sdCySV {
    if(!_sdCySV){
        _sdCySV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT, screenW, headerHt) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        _sdCySV.currentPageDotColor = [UIColor whiteColor];
    }
    
    return _sdCySV;
}

-(UICollectionView *)collectionview{
    if (!_collectionview) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((screenW - 51) /3, 100);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT + headerHt, screenW,screenH - SAFE_NAV_HEIGHT - headerHt) collectionViewLayout:flowLayout];
        _collectionview.dataSource=self;
        _collectionview.delegate=self;
        _collectionview.backgroundColor = [UIColor whiteColor];
        [_collectionview registerNib:[UINib nibWithNibName:@"ImageLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageLabelCollectionViewCell"];
        //        [_AcCollectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ActivityHomeCollectionViewCell"];
        WEAKSELF;
        _collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf updata];
        }];
    }
    return _collectionview;
}

- (void)soapv13Request
{
    NSString *soapStr = [NSString stringWithFormat:
                         @"&lt?xml version=\"1.0\" encoding=\"utf-8\"?&gt\n"
                         "&ltsoap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"&gt\n"
                         "&ltsoap:Body&gt\n"
                         "&lt%@ xmlns=\"%@\"&gt\n"
                         "&lt/%@&gt\n"
                         "&lt/soap:Body&gt\n"
                         "&lt/soap:Envelope&gt\n",@"GetCurrentSysTime",@"http://tempuri.org/",@"GetCurrentSysTime"];
    
  SoapUtil *soap =  [[SoapUtil alloc]initWithNameSpace:@"http://tempuri.org/" andEndpoint:@"http://117.107.252.22:8086/AppService.asmx"];
    NSData *data = [soap requestMethod:@"GetCurrentSysTime" withDate:@[@{@"GetCurrentSysTime":soapStr}]];
    LFLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding])
}
- (void)soapv12Request
{
    NSURL *url = [NSURL URLWithString:@"http://117.107.252.22:8086/AppService.asmx?wsdl"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    req.HTTPMethod = @"POST";
    //    [req setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    NSString *soapMsg = [NSString stringWithFormat:
                         @"&lt?xml version=\"1.0\" encoding=\"utf-8\"?&gt\n"
                         "&ltsoap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"&gt\n"
                         "&ltsoap:Body&gt\n"
                         "&lt%@ xmlns=\"%@\"&gt\n"
                         "&lt/%@&gt\n"
                         "&lt/soap:Body&gt\n"
                         "&lt/soap:Envelope&gt\n",@"GetCurrentSysTime",@"http://tempuri.org/",@"GetCurrentSysTime"];

    NSData *reqData = [soapMsg dataUsingEncoding:NSUTF8StringEncoding];
    req.HTTPBody = reqData;

    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            NSLog(@"Error:%@",connectionError);
        }
        else
        {
            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        }


    }];
    
    
    NSString *soapStr = [NSString stringWithFormat:
                         @"&lt?xml version=\"1.0\" encoding=\"utf-8\"?&gt\n"
                         "&ltsoap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"&gt\n"
                         "&ltsoap:Body&gt\n"
                         "&lt%@ xmlns=\"%@\"&gt\n"
                         "&lt/%@&gt\n"
                         "&lt/soap:Body&gt\n"
                         "&lt/soap:Envelope&gt\n",@"GetCurrentSysTime",@"http://tempuri.org/",@"GetCurrentSysTime"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 60;
    // 返回NSData
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置请求头，也可以不设置
//    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%zd", soapStr.length] forHTTPHeaderField:@"Content-Length"];
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error)
     {
         return soapStr;
     }];
    [manager POST:@"http://117.107.252.22:8086/AppService.asmx?wsdl" parameters:soapStr success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:responseObject                            encoding:NSUTF8StringEncoding];
        NSLog(@"%@",result);
        //使用自己写的请求方法resultWithDiction进行解析
//        NSDictionary * dic = [self resultWithDiction:result];
        //通过Block传回数据
//        success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
            NSLog(@"%@",error);
//            failure(error);
//        }
    }];
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    WKViewViewController *bord = [[WKViewViewController alloc]init];
    bord.titleStr = @"详情";
    bord.urlStr = NSStringWithFormat(SERVER_IP,NSStringWithFormat(HtmlDetailUrl, self.pictureArr[index][@"id"]));
    [self.navigationController pushViewController:bord animated:YES];
}
#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bookArr.count;
    
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ImageLabelCollectionViewCell";
    ImageLabelCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.model = self.bookArr[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    [self soapv13Request];
//    return;

    if (indexPath.row == 0) {//消息
        [self.navigationController pushViewController:[[StuNewsViewController alloc]init] animated:YES];
    }else if (indexPath.row == 1){//作业 布置作业
        [self.navigationController pushViewController:[[PunchOperationListViewController alloc]init] animated:YES];
//        if ([UserUtils getUserRole] == UserStyleStudent) {
//            [self.navigationController pushViewController:[[PunchOperationListViewController alloc]init] animated:YES];
//        }else if ([UserUtils getUserRole] == UserStyleInstructor){
//            [self.navigationController pushViewController:[[PostOperationViewController alloc]init] animated:YES];
//        }
        
    }else if (indexPath.row == 2){//考勤签到 考勤设定
        if ([UserUtils getUserRole] == UserStyleStudent) {
            [self.navigationController pushViewController:[[AttendanceListViewController alloc]init] animated:YES];
        }else if ([UserUtils getUserRole] == UserStyleInstructor){//考勤设定
            StudentGroupViewController *vc = [[StudentGroupViewController alloc]init];
            vc.isSignSet = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.row == 3){//测试成绩 成绩发布
        if ([UserUtils getUserRole] == UserStyleStudent) {
            [self.navigationController pushViewController:[[TestScoreViewController alloc]init] animated:YES];
        }else if ([UserUtils getUserRole] == UserStyleInstructor){//考勤设定
            [self.navigationController pushViewController:[[ReleaseGradeViewController alloc]init] animated:YES];
        }
        
    }else if (indexPath.row == 4){//一对一答疑 请假审批
        if ([UserUtils getUserRole] == UserStyleStudent) {//一对一答疑
            [self.navigationController pushViewController:[[MyAnswerListViewController alloc]init] animated:YES];
        }else if ([UserUtils getUserRole] == UserStyleInstructor){//请假审批
            [self.navigationController pushViewController:[[LeaveListViewController alloc]init] animated:YES];
        }
        
    }else if (indexPath.row == 5){//请假审批 补分审批
        if ([UserUtils getUserRole] == UserStyleStudent) {//一对一答疑
            [self.navigationController pushViewController:[[LeaveListViewController alloc]init] animated:YES];
        }else if ([UserUtils getUserRole] == UserStyleInstructor){//补分审批
            [self.navigationController pushViewController:[[SupplyFractionViewController alloc]init] animated:YES];
        }
        
    }else if (indexPath.row == 2){
        [self.navigationController pushViewController:[[SignInMapViewController alloc]init] animated:YES];
    }
    
}
#pragma mark banner
-(void)getData{
    NSMutableDictionary *dt = [NSMutableDictionary dictionary];
    if ([UserUtils getUserRole] == UserStyleStudent) {
        [dt setObject:@"1" forKey:@"id"];
    }else if ([UserUtils getUserRole] == UserStyleInstructor){
        [dt setObject:@"2" forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,HomeBannerUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        
        [_collectionview.mj_footer endRefreshing];
        [_collectionview.mj_header endRefreshing];
        LFLog(@"5e推荐:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"]) {
            [self.pictureArr removeAllObjects];
            NSMutableArray *imageurl = [NSMutableArray array];
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in response[@"data"]) {
                    [self.pictureArr addObject:dict];
                    [imageurl addObject:dict[@"thumbnail"]];
                }
            }
            self.sdCySV.imageURLStringsGroup = imageurl;
        }else{
            [self presentLoadingTips:response[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self presentLoadingTips:@"请求失败！"];

    }];
    
}

#pragma mark 是否有未读消息
-(void)getReadMessage{
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,NoReadMessageUrl) params:nil viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"是否有未读消息:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"]) {
            ImLbModel *mo = self.bookArr[0];
            if (response[@"data"][@"has_not_read"] && [response[@"data"][@"has_not_read"] integerValue] == 1) {
                mo.bage = @"●";
            }else{
                mo.bage = nil;
            }
        }else{
//            [self presentLoadingTips:response[@"msg"]];
        }
        [self.collectionview reloadData];
    } failure:^(NSError *error) {
        [self presentLoadingTips:@"请求失败！"];
        
    }];
    
}

@end
