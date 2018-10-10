//
//  SetupPageViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/9.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "SetupPageViewController.h"
#import "ShopOtherTableViewCell.h"
#import "OfficialWebviewViewController.h"
#import "PersonalCenterViewController.h"
@interface SetupPageViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UIButton *btn;
}
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)NSArray *array1;
@property (nonatomic,strong)NSArray *array2;
@property (nonatomic,strong)NSMutableArray *officialArr;
@property (nonatomic,strong)NSString *isUpdate;
@property (nonatomic,strong)NSString *err_msg;
@end

@implementation SetupPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"设置";
    self.array1 = @[@" 账户管理:",@" 推送消息设置:",@" 清除本地缓存:"];
    self.array2 = @[@" 官方客服",@" 官方网站",@" 版本号"];
    self.isUpdate = @"0";//默认不更新
    [self createTableview];

    [self createFootview];
    [self complainUploaddata];
    
    [self officialData];
}
-(NSMutableArray *)officialArr{

    if (_officialArr == nil) {
        _officialArr = [[NSMutableArray alloc]init];
    }
    return _officialArr;
}

-(void)createFootview{
    UIView * footview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN.size.height - 100, SCREEN.size.width, 100)];
    [self.view addSubview:footview];

    btn =[[UIButton alloc]init];

       if ( YES == [UserModel online] )
       {
           btn.backgroundColor = [UIColor redColor];
           [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           [btn setTitle:@"注销" forState:UIControlStateNormal];
       }else{
           btn.backgroundColor = JHMaincolor;
           [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           [btn setTitle:@"登陆" forState:UIControlStateNormal];
       }
    
        btn.layer.cornerRadius = 25;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [footview addSubview:btn];
     [btn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerY.equalTo(footview.mas_centerY);
         make.height.offset(50);
         make.right.offset(-50);
         make.left.offset(50);
      }];
}

-(void)cancelClick:(UIButton *)btn{

    [[UserModel shareUserModel] removeAllUserInfo];
    [self showLogin:^(id response) {
    }];


}
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height  + 50 - 70)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"SetupPageViewController"];
    [self.view addSubview:self.tableview];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.array1.count;
    }
    if ([self.isUpdate isEqualToString:@"0"]) {
        return self.array2.count - 1;
    }
    return self.array2.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (inde) {
//        <#statements#>
//    }
    return 60;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]init];
    footer.backgroundColor = JHbgColor;
    return footer;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetupPageViewController"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.MustImHeight.constant = 0;

    if (indexPath.section == 0) {
        cell.rigthtIm.hidden = NO;
        cell.nameLabel.text = self.array1[indexPath.row];

        if (indexPath.row == 0) {

        }else if (indexPath.row == 1){
            
        }else if (indexPath.row == 2){
            NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
            LFLog(@"缓存大小：%.2fM",[ self folderSizeAtPath :cachPath]);
            NSString *company = [NSString stringWithFormat:@"%.2fM",[ self folderSizeAtPath :cachPath]];
            cell.contentLb.text = company;
        }
        
       
    }else if (indexPath.section == 1) {
        cell.rigthtIm.hidden = NO;
        cell.nameLabel.text = self.array2[indexPath.row];
        cell.contentLb.numberOfLines = 0;
        if (self.officialArr.count) {
            if (indexPath.row == 1) {
                cell.contentLb.text = self.officialArr[0][@"site_url"];
            }else if (indexPath.row == 0){
                cell.contentLb.text = self.officialArr[0][@"service_phone"];
            }else{
                NSDictionary *dict = [[NSBundle mainBundle]infoDictionary];
                cell.contentLb.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"CFBundleShortVersionString"]];
            }
        }
    }
    CGSize namesize = [cell.nameLabel.text selfadaption:15];
    cell.nameHeight.constant = namesize.width + 5;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (self.officialArr.count) {

          if (indexPath.row == 0) {
              NSString *recid =  self.officialArr[0][@"service_phone"];
              if (recid) {
                  if (recid.length) {
                      LFLog(@"recid:%@",recid);
                      recid = [recid stringByReplacingOccurrencesOfString:@"-" withString:@""];
                      NSString *tell = [NSString stringWithFormat:@"telprompt://%@",recid];
                      NSURL *url = [NSURL URLWithString:tell];
                      NSComparisonResult compare = [[UIDevice currentDevice].systemName compare:@"10.0"];
                      if (compare == NSOrderedDescending || compare == NSOrderedSame) {
                          [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                      }else{
                          [[UIApplication sharedApplication] openURL:url];
                      }
                  }
              }
          }else if (indexPath.row == 1){
              OfficialWebviewViewController *web = [[OfficialWebviewViewController alloc]init];
              web.urlstr = self.officialArr[0][@"site_url"];
              [self.navigationController pushViewController:web animated:YES];
        
          }else{
              [self AppStoreOfinfo:self.err_msg];
              
          }
            
        }
    }else{
        if (indexPath.row == 0) {
            if (![userDefaults objectForKey:NetworkReachability]) {
                [self presentLoadingTips:@"网络貌似掉了~~"];
                return;
            }
            
            if ( NO == [UserModel online] )
            {
                
                [self showLogin:^(id response) {
                }];
                
                return;
            }
            PersonalCenterViewController *per = [[PersonalCenterViewController alloc]init];
            [self.navigationController pushViewController:per animated:YES];
            

        }else if (indexPath.row == 1){
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }else if (indexPath.row == 2){
            [self presentLoadingStr:@"清除缓存"];
            [self clearFile];
        }

    }
}

#pragma mark - *************版本更新*************
-(void)complainUploaddata{
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"98") params:nil success:^(id response) {
        
        self.isUpdate = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        LFLog(@"版本更：%@",response);
        if (![self.isUpdate isEqualToString:@"0"]) {
            [self.tableview reloadData];
            self.err_msg = response[@"err_msg"];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - *************获取AppStore版本信息*************
- (void)AppStoreOfinfo:(NSString *)info
{
    [LFLHttpTool post:NSStringWithFormat(AppStoreUrl,@"1357016976") params:nil success:^(id response) {
        NSArray *arr = response[@"results"];
        if (arr.count) {
            LFLog(@"AppStore：%@",response[@"results"][0][@"version"]);
            NSDictionary *dict = [[NSBundle mainBundle]infoDictionary];
            NSString *currentVersion = [NSString stringWithFormat:@"%@",[dict objectForKey:@"CFBundleShortVersionString"]];
            LFLog(@"版本信息：%@",currentVersion);
            if (![currentVersion isEqualToString:[NSString stringWithFormat:@"%@",response[@"results"][0][@"version"]]] ) {

                [self alertController:@"怡生活有新的版本可以更新了" prompt:info sure:@"确定" cancel:@"取消" success:^{
                    NSURL *url = [NSURL URLWithString:response[@"results"][0][@"trackViewUrl"]];
                    [[UIApplication  sharedApplication]openURL:url];
                } failure:^{
                    
                }];
                    
            }else{
            
                [self alertController:@"提示" prompt:@"您的版本已经是最新的了" sure:@"确定" cancel:nil success:^{
                } failure:^{
                    
                }];
            }

            
        }
        
    } failure:^(NSError *error) {
    
    }];
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
    NSIndexPath *index=[NSIndexPath indexPathForRow:2 inSection:0];//刷新
    [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark 官方数据
-(void)officialData{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ConfigUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self.officialArr removeAllObjects];
            [self.officialArr addObject:response[@"data"]];
            LFLog(@"response:%@",self.officialArr);
            [self.tableview reloadData];
            
        }else{
      
//            [self presentLoadingTips:response[@"err_msg"]];
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableview reloadData];
    if ( YES == [UserModel online] )
    {
        btn.backgroundColor = [UIColor redColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"注销" forState:UIControlStateNormal];
    }else{
        btn.backgroundColor = JHMaincolor;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"登陆" forState:UIControlStateNormal];
    }
}

@end
