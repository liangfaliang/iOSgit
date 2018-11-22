//
//  BasicViewController.m
//  37℃Apartment
//
//  Created by SandClock on 2018/5/23.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#import "BasicViewController.h"
#import "MBProgressHUD.h"
#import "UserUtils.h"
#import "LoginViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface BasicViewController (){
    MBProgressHUD *_hud;
}
@property (nonatomic, strong) NSMutableArray<NSURLSessionDataTask *> *sessionDataTaskMArr;
@end

@implementation BasicViewController
-(void)dealloc{
    LFLog(@"dealloc:%@",[self class]);
}
-(instancetype)init{
    if (self = [super init]) {
        _isLoadEnd = @0;
        _isEmptyDelegate = YES;
        _isCancelNetwork = YES;

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JHbgColor;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
//    [self UpData];
    [self initBasic];
    
}
LazyLoadArray(sessionDataTaskMArr)
//检测是否登录
-(void)CheckIsLogin{
    if ([UserUtils getUserRole] == UserStyleNone) {
        LoginViewController *login = [LoginViewController sharedLoginViewController];
        if (!self.presentedViewController && !self.isPresent && ![self isKindOfClass:[LoginViewController class]] && [self isCurrentViewControllerVisible] && !login.isPresent) {
            self.isPresent = YES;
            login.isPresent = YES;
            [self presentViewController:login animated:YES completion:^{
            }];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setNavigationBarWhite];
}
-(void)UpData{self.isLoadEnd = @0;};

- (void)initBasic{
    
    if (!_backItemHidden) {
        [self initBackItem];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self dismissTips];
    [AlertView dismiss];
}
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
    [self CheckIsLogin];
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
#pragma mark - 初始化返回按钮
- (void)initBackItem{
    
        //        let leftItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        //        leftItem.width = -15
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        leftItem.width = -20;
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        _backButton.contentMode = UIViewContentModeLeft;
        [_backButton setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backItemAction) forControlEvents:UIControlEventTouchUpInside];
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
        self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backItemAction{
    if (self.presentingViewController) {
        UIViewController *vc =self.presentingViewController;
        while (vc.presentingViewController) {
            vc = vc.presentingViewController;
        }
        [vc dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)setNavigationBarWhite {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
}

- (void)setNavigationBarShadowHidden{
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[self imageWithColor:[UIColor clearColor]]];
}

- (void)showLoginAlert{
    [self showLoginAlert:nil];
}

- (void)showLoginAlert:(void (^)(NSInteger code))resultBlock{
    
    LoginViewController *login = [LoginViewController sharedLoginViewController];
    login.loginResultBlock =  resultBlock;
    if (!self.presentedViewController && !self.isPresent && ![self isKindOfClass:[LoginViewController class]]) {
        self.isPresent = YES;
        [self presentViewController:login animated:YES completion:^{
        }];
    }
}
//提示框
-(void)alertController:(NSString *)name prompt:(NSString *)prompt sure:(NSString *)sure cancel:(NSString *)cancel success:(void (^)(void))success failure:(void (^)(void))failure{
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
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)navigationBackItemClicked{
    [self.navigationController popViewControllerAnimated:true];
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
#pragma mark - Examples

- (void)presentLoadingTips:(NSString *)str {
    if (![str isKindOfClass:[NSString class]]) {
        str = @"暂无提示信息";
    }
    UIView *view = self.navigationController.view;
    if (view == nil) {
        view = self.view;
    }
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *im = [[UIImage imageNamed:@"MBlogo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:im];
    hud.customView = imageview;
    hud.removeFromSuperViewOnHide = YES;
    [_hud hideAnimated:YES];
    _hud = hud;
    hud.bezelView.backgroundColor = JHColoralpha(0, 0, 0, 0.5);
    hud.detailsLabel.text = NSLocalizedString(str, @"HUD loading title");
    hud.detailsLabel.font = [UIFont systemFontOfSize:13];
    hud.detailsLabel.textAlignment = NSTextAlignmentCenter;
    hud.detailsLabel.numberOfLines = 0;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    [self performSelector:@selector(dismissTips) withObject:nil afterDelay:2.0];
}
- (void)presentPromptStr:(NSString *)str{
    
    if (![str isKindOfClass:[NSString class]]) {
        str = @"暂无提示信息";
    }
    UIView *view = self.navigationController.view;
    if (view == nil) {
        view = self.view;
    }
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [_hud hideAnimated:YES];
    _hud = hud;
    hud.bezelView.backgroundColor = JHColoralpha(0, 0, 0, 0.5);
    hud.detailsLabel.text = NSLocalizedString(str, @"HUD loading title");
    hud.detailsLabel.font = [UIFont systemFontOfSize:13];
    hud.detailsLabel.textAlignment = NSTextAlignmentCenter;
    hud.detailsLabel.numberOfLines = 0;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    [self performSelector:@selector(dismissTips) withObject:nil afterDelay:2.0];
    
    
}
- (void)presentLoadingTips{
    
    UIView *view = self.navigationController.view;
    if (view == nil) {
        view = self.view;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.bezelView.backgroundColor = JHColoralpha(0, 0, 0, 0.5);
    hud.removeFromSuperViewOnHide = YES;
    [_hud hideAnimated:YES];
    _hud = hud;
    
}

- (void)presentTextStr:(NSString *)str{
    if (![str isKindOfClass:[NSString class]]) {
        str = @"暂无提示信息";
    }
    UIView *view = self.navigationController.view;
    if (view == nil) {
        view = self.view;
    }
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [_hud hideAnimated:YES];
    _hud = hud;
    hud.bezelView.backgroundColor = JHColoralpha(0, 0, 0, 0.5);
    hud.detailsLabel.text = NSLocalizedString(str, @"HUD loading title");
    hud.detailsLabel.font = [UIFont systemFontOfSize:13];
    hud.detailsLabel.textAlignment = NSTextAlignmentCenter;
    hud.detailsLabel.numberOfLines = 0;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    
}

-(void)dismissTips{
    [_hud hideAnimated:YES];
}

/** 将需要在退出VC取消的请求，记录。
 *  在记录的时候，清理已经请求完成的task
 */
- (void)addSessionDataTask:(NSURLSessionDataTask *)task
{
    if (nil == task) {
        return;
    }
    [self.sessionDataTaskMArr addObject:task];
}
- (void)addSessionDataTasks:(NSArray *)taskArr
{
    if (!taskArr.count) {
        return;
    }
    [self.sessionDataTaskMArr addObjectsFromArray:taskArr];
}

/** 移除已经请求成功的请求 */
- (void)removeSessionDataTask:(NSURLSessionDataTask *)task
{
    [self.sessionDataTaskMArr removeObject:task];
}

/** 取消所有的请求 */
- (void)cancelAllSessionDataTask
{
    if (0 >= [self.sessionDataTaskMArr count]) {
        return;
    }
    
    for (NSURLSessionTask *dataTask in self.sessionDataTaskMArr) {
        if (NSURLSessionTaskStateRunning == dataTask.state
            || NSURLSessionTaskStateSuspended == dataTask.state) {
            [dataTask cancel];
        }
    }
    
    [self.sessionDataTaskMArr removeAllObjects];
    
}
//- (NSMutableArray *)sessionDataTaskMArr
//{
//    if (nil == _sessionDataTaskMArr) {
//        _sessionDataTaskMArr = [[NSMutableArray alloc] initWithCapacity:5];
//    }
//
//    return _sessionDataTaskMArr;
//}
#pragma mark - Override Methods
- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0)
{
    if (self.isCancelNetwork) {
        [self cancelAllSessionDataTask];
    }
    [super dismissViewControllerAnimated:flag completion:completion];
}

#pragma mark - 当前控制器是否正在显示
-(BOOL)isCurrentViewControllerVisible
{
    return (self.isViewLoaded && self.view.window);
}
@end
