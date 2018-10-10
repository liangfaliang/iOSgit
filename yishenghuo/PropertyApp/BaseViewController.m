//
//  BaseViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/12.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "LFLNavigationController.h"
#import "HPGrowingTextView.h"
#import "UMMobClick/MobClick.h"//友盟统计
#import "HomeWorkViewController.h"
#import "AttestViewController.h"
#define TAB_HEIGHT	49.0f
@interface BaseViewController ()<MBProgressHUDDelegate,LFLNavigationControllerDelegate,UITabBarControllerDelegate,UITabBarControllerDelegate>{
    MBProgressHUD *_hud;
    CGFloat _tabbarOriginY;
    
}
@property (nonatomic, copy) void (^backBlock)(UIViewController *viewController);
@property (nonatomic, copy) void (^rightBarBlock)(UIBarButtonItem *sender);
@property (strong, nonatomic) NSDate *lastDate;//记录最后一次tabbar点击时间
@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _navigationHidden = NO;
        _navigationAlpha = navBarAlpha;
        _navigationHeight = navBarHeight;
        _navigationColor = navBarColor;
        _isLoadEnd = @0;
        _isEmptyDelegate = YES;
    }
    
    return self;
}

static UIImage *nav_back;

+ (void)initialize
{
    nav_back = [UIImage imageNamed:@"nav_back_1"]; // 默认返回按钮图片
}

// 状态栏白色样式 子类样式改变重写即可
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self dismissTips];

}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    [self dismissTips];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [self.navigationController setNavigationBarHidden:self.navigationHidden animated:YES];
    [self.navigationController setNavigationAlpha:self.navigationAlpha animated:NO];
    [self.navigationController setNavigationColor:self.navigationColor animated:NO];
//    self.navigationController.navigationBar.topItem.title = @"返回";
}
-(void)UpData{self.isLoadEnd = @0;};
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isEmptyDelegate) {
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass:[UITableView class]]) {
                UITableView *tab = ((UITableView *)subview);
                tab.emptyDataSetDelegate = self;
                tab.emptyDataSetSource = self;
                [tab reloadEmptyDataSet];
            }
            if ([subview isKindOfClass:[UICollectionView class]]) {
                UICollectionView *tab = ((UICollectionView *)subview);
                tab.emptyDataSetDelegate = self;
                tab.emptyDataSetSource = self;
                [tab reloadEmptyDataSet];
            }
        }
    }
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.isLoadEnd && self.isLoadEnd.integerValue != 0) {
        NSString *buttonTitle = @"加载失败！点击重新加载";
        if ( self.isLoadEnd.integerValue == 1) {
            buttonTitle = @"加载完成，暂无数据！";
        }
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f]
                                     };
        return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
    }
    return nil;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    if (self.isLoadEnd && self.isLoadEnd.integerValue == 2) {
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass:[UITableView class]]) {
                [((UITableView *)subview).mj_header beginRefreshing];
            }else if ([subview isKindOfClass:[UICollectionView class]]) {
                [((UICollectionView *)subview).mj_header beginRefreshing];
            }
        }
        [self UpData];
    }
    LFLog(@"按钮点击");
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    //    [UIView animateWithDuration:0.5 animations:^{
    UIEdgeInsets edg = scrollView.contentInset;
    edg.bottom = 0;
    scrollView.contentInset = edg;
    //    }];
}
-(void)setIsLoadEnd:(NSNumber *)isLoadEnd{
    _isLoadEnd = isLoadEnd;
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UITableView class]]) {
            [((UITableView *)subview) reloadEmptyDataSet];
        }else if ([subview isKindOfClass:[UICollectionView class]]) {
            [((UICollectionView *)subview) reloadEmptyDataSet];
        }
    }
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isLoadEnd && self.isLoadEnd.integerValue != 0) {
        return nil;
    }
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    return activityView;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
-(BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return YES;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBarController.delegate = self;
    [[UITableView appearance]setTableFooterView:[UIView new]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;//关闭透明度
    self.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    LFLNavigationController *na = (LFLNavigationController *)self.navigationController;
    na.gobackdelegate = self;

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [Notification addObserver:self selector:@selector(keyboardHandle:) name:UIKeyboardWillShowNotification object:nil];
    [Notification addObserver:self selector:@selector(keyboardHandle:) name:UIKeyboardWillHideNotification object:nil];
    self.isShowASR = YES;
}
//键盘通知
- (void)keyboardHandle:(NSNotification *)notify
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    //    NSLog(@"firstResponder:%@",[firstResponder class]);
    //    NSLog(@"notify.userInfo:%@",notify.userInfo);
    //    NSLog(@"name:%@",notify.name);
    if( [firstResponder isKindOfClass:[UITextField class] ]|| [firstResponder isKindOfClass:[UITextView class] ] || [firstResponder isKindOfClass:[HPGrowingTextView class] ])
    {
        
        
        //获取文本输入框中心点坐标
        //        CGPoint center =self.textView.center;
        //        CGPoint center = self.TVCenter;
        //取出键盘的尺寸值
        NSValue *rectValue = notify.userInfo[UIKeyboardFrameEndUserInfoKey];
        //官方提供了直接从NSValue转化为CGRect的函数
        CGRect rect = rectValue.CGRectValue;
        //获取键盘的高度
        CGFloat height = rect.size.height;
        //获取通知的名字
        NSString *nameStr = notify.name;
        //判断是哪个通知，做出相应的处理
        //键盘弹出
        CGRect frm =   self.view.frame;
        if ([nameStr isEqualToString:UIKeyboardWillShowNotification])
        {
            [firstResponder layoutIfNeeded];
            UIWindow * window= [[[UIApplication sharedApplication] delegate] window];
            CGRect rect = [firstResponder convertRect: firstResponder.bounds toView:window];//获取在屏幕的尺寸
            NSLog(@"rect:%@",NSStringFromCGRect(rect));
            if( ([UIScreen mainScreen].bounds.size.height - height) < rect.origin.y + rect.size.height)//判断是否挡住了
            {
                if (rect.origin.y +  ([UIScreen mainScreen].bounds.size.height - height)-(rect.origin.y + rect.size.height) > 64) {//判断上移后是否会遮挡输入框 遮挡就不上移
                    frm.origin.y = ([UIScreen mainScreen].bounds.size.height - height)-(rect.origin.y + rect.size.height);//挡住就整体上移
                }
                
            }
            
            
        }
        else
        {//键盘退出
            frm.origin.y = 0;
            
        }
        self.view.frame = frm;
    }
}

-(id)navigationBarTitle{
    
    return self.navigationItem.titleView;
}
-(void)setNavigationBarTitle:(id)navigationBarTitle{
    
    if ( navigationBarTitle )
    {
        if ( [navigationBarTitle isKindOfClass:[NSString class]] )
        {
            
            
            CGSize size = [navigationBarTitle selfadaption:20];
            
            UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
            [customLab setTextColor:JHdeepColor];
            [customLab setText:navigationBarTitle];
            customLab.textAlignment = NSTextAlignmentCenter;
            customLab.font = [UIFont boldSystemFontOfSize:17];
            self.navigationItem.titleView = customLab;
            
            self.navigationItem.titleView = customLab;
            
            
            
        }
        else if ( [navigationBarTitle isKindOfClass:[UIImage class]] )
        {
            UIImageView * imageView = [[UIImageView alloc] initWithImage:navigationBarTitle];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            
            self.navigationItem.titleView = imageView;
        }
        else if ( [navigationBarTitle isKindOfClass:[UIView class]] )
        {
            self.navigationItem.titleView = navigationBarTitle;
        }
        else if ( [navigationBarTitle isKindOfClass:[UIViewController class]] )
        {
            self.navigationItem.titleView = ((UIViewController *)navigationBarTitle).view;
        }
    }
    
}
-(id)navigationBarRightItem{
    
    return self.navigationItem.rightBarButtonItem;
}
-(void)setNavigationBarRightItem:(id)navigationBarRightItem{
  
    if ( navigationBarRightItem )
    {
        if ( [navigationBarRightItem isKindOfClass:[NSString class]] )
        {
            NSString *name = (NSString *)navigationBarRightItem;
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [name selfadap:15 weith:20].width + 5, 44)];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitle:name forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(rightBaritemBtn:) forControlEvents:UIControlEventTouchUpInside];
            //            UIBarButtonItem * barbtn = [[UIBarButtonItem alloc] initWithImage:navigationBarRightItem style:UIBarButtonItemStylePlain target:self action:@selector(rightBaritemBtn:)];
            //            barbtn.tintColor = JHdeepColor;
            UIBarButtonItem * barbtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.rightBarButtonItem = barbtn;
            
            
        }
        else if ( [navigationBarRightItem isKindOfClass:[UIImage class]] )
        {
            UIImage *im = (UIImage *)navigationBarRightItem;
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, im.size.width, im.size.height)];
            [btn setImage:im forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(rightBaritemBtn:) forControlEvents:UIControlEventTouchUpInside];
//            UIBarButtonItem * barbtn = [[UIBarButtonItem alloc] initWithImage:navigationBarRightItem style:UIBarButtonItemStylePlain target:self action:@selector(rightBaritemBtn:)];
//            barbtn.tintColor = JHdeepColor;
             UIBarButtonItem * barbtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.rightBarButtonItem = barbtn;
        }
        else if ( [navigationBarRightItem isKindOfClass:[UIView class]] )
        {
//            navigationBarRightItem.u
            UIBarButtonItem * barbtn = [[UIBarButtonItem alloc] initWithCustomView:navigationBarRightItem];
//            barbtn.tintColor = JHdeepColor;
            [barbtn setTarget:self];
            [barbtn setAction:@selector(rightBaritemBtn:)];
            self.navigationItem.rightBarButtonItem = barbtn;
//            self.navigationItem.rightBarButtonItem = navigationBarRightItem;
        }
        else if ( [navigationBarRightItem isKindOfClass:[NSArray class]] )
        {
            self.navigationItem.rightBarButtonItems = navigationBarRightItem;
        }
    }
    
}
-(void)rightBaritemBtn:(UIBarButtonItem *)sender{
    if (self.rightBarBlock) {
        self.rightBarBlock(sender);
//        self.rightBarBlock = nil;
    }

}
//跳转登陆页面
//-(void)showLogin{
//    
//    [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
//    //    [self presentViewController:[[LoginViewController alloc]init] animated:YES completion:nil];
//    
//}
-(void)showLogin:(void (^)(id response))resultBlock{
//    UIViewController *vc = self.navigationController.viewControllers.lastObject;
//    LFLog(@"vc:%@",vc);
//    if (vc && [vc isKindOfClass:[LoginViewController class]]) {
//        return;
//    }
    LoginViewController *login = [LoginViewController sharedLoginViewController];
    [login refresh];
    login.loginResultBlock = resultBlock;
    [self.navigationController pushViewController:login animated:YES];
    //    [self presentViewController:[[LoginViewController alloc]init] animated:YES completion:nil];
}
- (void)hidesBottomBarWhenPushed:(void(^)())exec
{
    [self setHidesBottomBarWhenPushed:YES];
    exec();
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark -
- (void)goBack:(UIButton *)btn
{
    if (self.backBlock) {
        self.backBlock(self);
        self.backBlock = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)navigationShouldPopOnBackButton{
    
    return [self goBackPreviousPage];
}
//-(BOOL)fd_interactivePopDisabled{
//
//    return [self goBackPreviousPage];
//}

-(BOOL)goBackPreviousPage{
    return NO;
}
- (void)dealloc
{
    [self dismissTips];
    [Notification removeObserver:self];
    // 测试是否循环引用
    NSLog(@"%@ dealloc", self.class);
}

//创建底视图
-(void)createFootview{
//    _basefootview = [[UIImageView alloc]init];
//    _basefootview.image = [UIImage imageNamed:@"appfootview"];
//    [self.view addSubview:_basefootview];
//    [_basefootview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.offset(0);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.width.offset(SCREEN.size.width);
//    }];
    
}
//提示框
-(void)alertController:(NSString *)name prompt:(NSString *)prompt sure:(NSString *)sure cancel:(NSString *)cancel success:(void (^)())success failure:(void (^)())failure{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:name message:prompt preferredStyle:UIAlertControllerStyleAlert];
    if (sure.length > 0) {
        [alertController addAction:[UIAlertAction actionWithTitle:sure style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (success) {
                success();
            }
            
            
        }]];
    }
    if (cancel.length > 0) {
        [alertController addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (failure) {
                failure();
            }
        }]];
    }

    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark - 获取当前最顶层的ViewController
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
#pragma mark tabbar双击
//-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    UINavigationController *na = (UINavigationController *)viewController;
//    LFLog(@"viewController:%@",[na.topViewController class]);
//    if ([na.topViewController isKindOfClass:[HomeWorkViewController class]]) {
//        if ( NO == [UserModel online] )
//        {
//            [self showLogin:nil];
//            return NO;
//        }
//        if (![UserModel Certification]) {
//            AttestViewController *att = [[AttestViewController alloc]init];
//            [self.navigationController pushViewController:att animated:YES];
//            return NO;
//        }
//    }
//    return YES;
//}
//-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    UINavigationController *na = (UINavigationController *)viewController;
//    LFLog(@"viewController:%@",[na.topViewController class]);
//    UIViewController *vc =((UINavigationController *)tabBarController.selectedViewController).topViewController;
//    LFLog(@"selectedViewController:%@",[vc class]);
//    if ([na.topViewController isKindOfClass:[HomeWorkViewController class]]) {
//        if ( NO == [UserModel online] )
//        {
//            LoginViewController *login = [[LoginViewController alloc]init];
//            [vc.navigationController pushViewController:login animated:YES];
//            return NO;
//        }
//        if (![UserModel Certification]) {
//            AttestViewController *att = [[AttestViewController alloc]init];
//            [vc.navigationController pushViewController:att animated:YES];
//            return NO;
//        }
//    }
//    return YES;
//}
-(void)tabbarDoubleClick:(BOOL)isDouble{

}

#pragma mark - Examples

- (void)presentLoadingTips:(NSString *)str {
    if (str == nil || [str isKindOfClass:[NSNull class]]) {
        str = @"暂无提示信息";
    }
    UIView *view = self.navigationController.view;
    if (view == nil) {
        view = self.view;
    }
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *im = [[UIImage imageNamed:@"MBlogo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:im];
    hud.customView = imageview;
    //    hud.tintColor = [UIColor whiteColor];
    //    hud.color = [UIColor grayColor];
    hud.opacity = 0.5;
    hud.removeFromSuperViewOnHide = YES;
    [_hud hide:YES];
    _hud = hud;
    hud.detailsLabelText = NSLocalizedString(str, @"HUD loading title");
    [self performSelector:@selector(dismissTips) withObject:nil afterDelay:2.0];
}
- (void)presentPromptStr:(NSString *)str{

    if (str == nil || [str isKindOfClass:[NSNull class]]) {
        str = @"暂无提示信息";
    }
    UIView *view = self.navigationController.view;
    if (view == nil) {
        view = self.view;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.opacity = 0.5;
    hud.removeFromSuperViewOnHide = YES;
    [_hud hide:YES];
    _hud = hud;
    hud.yOffset = SCREEN.size.height * 0.118;
    hud.detailsLabelFont =  [UIFont fontWithName:@"Helvetica-Bold" size:15];
    hud.detailsLabelText = NSLocalizedString(str, @"HUD loading title");
    [self performSelector:@selector(dismissTips) withObject:nil afterDelay:2.0];


}
- (void)presentLoadingTips{
    
    UIView *view = self.navigationController.view;
    if (view == nil) {
        view = self.view;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    //    hud.mode = MBProgressHUDModeCustomView;
    //    UIImage *im = [[UIImage imageNamed:@"MBlogo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    UIImageView *imageview = [[UIImageView alloc]initWithImage:im];
    //    hud.customView = imageview;
    //    hud.tintColor = [UIColor whiteColor];
    //    hud.color = [UIColor grayColor];
    hud.opacity = 0.5;
    hud.removeFromSuperViewOnHide = YES;
    [_hud hide:YES];
    _hud = hud;
    
}
- (void)presentLoadingStr:(NSString *)str{
    if (str == nil || [str isKindOfClass:[NSNull class]]) {
        str = @"暂无提示信息";
    }
    UIView *view = self.navigationController.view;
    if (view == nil) {
        view = self.view;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *im = [[UIImage imageNamed:@"MBlogo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:im];
    hud.customView = imageview;
    //    hud.tintColor = [UIColor whiteColor];
    //    hud.color = [UIColor grayColor];
    hud.opacity = 0.5;
    hud.removeFromSuperViewOnHide = YES;
    [_hud hide:YES];
    _hud = hud;
    hud.detailsLabelText = NSLocalizedString(str, @"HUD loading title");
}

- (void)presentTextStr:(NSString *)str{
    if (str == nil || [str isKindOfClass:[NSNull class]]) {
        str = @"暂无提示信息";
    }
    UIView *view = self.navigationController.view;
    if (view == nil) {
        view = self.view;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.opacity = 0.5;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = NSLocalizedString(str, @"HUD loading title");
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    hud.detailsLabelColor = [UIColor whiteColor];
    [_hud hide:YES];
    _hud = hud;
    
}

//- (void)doSomeNetworkWorkWithProgress {
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
//    NSURL *URL = [NSURL URLWithString:@"https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1425/sample_iPod.m4v.zip"];
//    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:URL];
//    [task resume];
//}

- (void)cancelWork:(id)sender {
    //    self.canceled = YES;
}

-(void)dismissTips{
    
    
    [_hud hide:YES];
    
    
}
//获取ip地址
- (void)getDeviceIPIpAddresses:(void (^)(NSString *IP))Addresses

{
    [LFLHttpTool get:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip" params:nil success:^(id response) {

        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([code isEqualToString:@"0"]) {
            if (Addresses) {
                Addresses(response[@"data"][@"ip"]);
            }
        }
        LFLog(@"ip地址：%@",response);

    } failure:^(NSError *error) {
        if (Addresses) {
            Addresses(@"ipError");
        }
        LFLog(@"ip地址error：%@",error);
    }];
    
    //1.确定请求路径
//    NSURL *url = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
//    
//    //2.创建请求对象
//    //请求对象内部默认已经包含了请求头和请求方法（GET）
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    //3.获得会话对象
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    //4.根据会话对象创建一个Task(发送请求）
//    /*
//     第一个参数：请求对象
//     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
//     data：响应体信息（期望的数据）
//     response：响应头信息，主要是对服务器端的描述
//     error：错误信息，如果请求失败，则error有值
//     */
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        LFLog(@"ip地址：%@",response);
//        if (error == nil) {
//            //6.解析服务器返回的数据
//            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            
//            NSLog(@"%@",dict);
//        }
//    }];
//    
//    //5.执行任务
//    [dataTask resume];
    
}
#pragma mark - MBProgressHUDDelegate 隐藏后调用的方法
-(void)hudWasHidden:(MBProgressHUD *)hud{
    
}
#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // Do something with the data at location...
    
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        [_hud hide:YES];
        _hud = hud;
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"Completed", @"HUD completed title");
        //        [hud hideAnimated:YES afterDelay:3.f];
        [hud hide:YES afterDelay:3.f];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        [_hud hide:YES];
        _hud = hud;
        hud.mode = MBProgressHUDModeDeterminate;
        hud.progress = progress;
    });
}

#pragma mark -

- (void)showTabbar
{
    CGFloat tab_height = TAB_HEIGHT;
    if (kDevice_Is_iPhoneX) {
        tab_height = 83;
    }
    _tabbarOriginY = self.view.height - tab_height ;
    CGRect tabbarFrame = self.tabBarController.tabBar.frame;
    tabbarFrame.origin.y = _tabbarOriginY;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.tabBarController.tabBar.frame = tabbarFrame;
    
    [UIView commitAnimations];
}



- (void)hideTabbar
{
    _tabbarOriginY = self.view.height;
    
    CGRect tabbarFrame = self.tabBarController.tabBar.frame;
    tabbarFrame.origin.y = _tabbarOriginY;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.tabBarController.tabBar.frame = tabbarFrame;
    
    [UIView commitAnimations];
}


@end


@implementation UINavigationController (XPBaseViewController)

- (UIView *)navigationBarBackgroundView
{
    return [self.navigationBar valueForKey:@"_backgroundView"];
}

- (CGFloat)navigationAlpha
{
    return self.navigationBarBackgroundView.alpha;
}
- (void)setNavigationAlpha:(CGFloat)navigationAlpha
{
    self.navigationBarBackgroundView.alpha = navigationAlpha;
}
- (void)setNavigationAlpha:(CGFloat)navigationAlpha animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            [self setNavigationAlpha:navigationAlpha];
        }];
    } else {
        [self setNavigationAlpha:navigationAlpha];
    }
}



- (UIColor *)navigationColor
{
    return self.navigationBar.barTintColor;
}
- (void)setNavigationColor:(UIColor *)navigationColor
{
    [self.navigationBar setBarTintColor:navigationColor];
}
- (void)setNavigationColor:(UIColor *)navigationColor animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            [self setNavigationColor:navigationColor];
        }];
    } else {
        [self setNavigationColor:navigationColor];
    }
}

@end
