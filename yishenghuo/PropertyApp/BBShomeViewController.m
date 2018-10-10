//
//  BBShomeViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/8/11.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "BBShomeViewController.h"
#import "JWCycleScrollView.h"
#import "D0BBsTableViewCell.h"
#import "D0BBBSmodel.h"
#import "AppFMDBManager.h"
#import "MenuModel.h"
#import "CustomButton.h"
#import "CustomLabel.h"
#import "OneCellView.h"
#import "STPhotoBroswer.h"
#import "ListBBsViewController.h"
#import "DetailsViewController.h"
#import "UserInfoViewController.h"
#import "PostViewController.h"
#import "SearchViewController.h"
#import "STConfig.h"
#import "GovernmentPostTableViewCell.h"
#import "HomeWorkViewController.h"
#import "AttestViewController.h"
#import "LoginViewController.h"
#import "PushMessageViewController.h"
#import "AlertsButton.h"
#define headerHt SCREEN.size.width * 12/25
@interface BBShomeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,JWCycleScrollImageDelegate,UISearchBarDelegate,BBSPostDetailDelegate,GovernmentPostDelegate,UITabBarControllerDelegate,UITabBarControllerDelegate>
{
    long a ;
    float cellHight ;
    float keyboardY;
}
@property (nonatomic,strong)baseTableview * tableView;
@property (nonatomic,strong)UICollectionView *collectionview;
@property (nonatomic, strong) JWCycleScrollView * jwView;
//分类下面的背景图片
@property (nonatomic,strong)UIImageView *image;
//点击回复，输入框背景视图
@property (nonatomic,strong)UIView *bottomView;
//放大展示图片数组
@property (nonatomic,strong)NSMutableArray *imgListArray;
//蒙版
@property (nonatomic,strong)UIButton *mattebtn;
//模拟数据
@property (nonatomic,strong)NSMutableArray *array;

@property (nonatomic,strong)NSMutableArray *pictureArr;
//输入框
@property (nonatomic,strong)UITextView *tfview;
//请求数据数组
@property (strong,nonatomic)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *appArray;
//小图展示数组
@property (nonatomic,strong)NSMutableArray *imageArray;

//本地数据源
@property (nonatomic,strong)NSMutableArray *listArray;

@property (nonatomic,strong)NSMutableArray *iamgeArr2;
@property (nonatomic,strong)NSMutableArray *titleArr;
@property (nonatomic,strong)NSMutableArray *contentArr;
@property (nonatomic,strong)NSMutableArray *menuArray;

@property (nonatomic,assign)NSInteger page;

//
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UIButton *buttonBack;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat titleviewalph;
@property(nonatomic,assign)BOOL isAppear;
@property(nonatomic,strong)AlertsButton *alertbtn;//推送提醒
@property(nonatomic,strong)UISearchBar *searchbar;//搜索
@property(nonatomic,strong)NSString *more;
@property (nonatomic,strong)UIButton *sendBtn;//发帖按钮
@end

@implementation BBShomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tabBarController.delegate = self;
    // Do any additional setup after loading the view.
    //    self.navigationItem.titleView = self.titleView;
    self.tabBarController.delegate = self;
//    self.navigationAlpha = 0;
    self.page = 1;
    self.more = @"1";
    [self createSearch];
    [self createUI];
    [self requestData:self.page];
    [self upDataforMenu];
    [self wheelrequestData];
    [self createbarItem];
}
-(NSMutableArray *)iamgeArr2{
    
    
    if (_iamgeArr2 == nil) {
        _iamgeArr2 = [[NSMutableArray alloc]init];
    }
    
    return _iamgeArr2;
    
}
-(NSMutableArray *)titleArr{
    
    
    if (_titleArr == nil) {
        _titleArr = [[NSMutableArray alloc]init];
    }
    
    return _titleArr;
    
}
-(NSMutableArray *)contentArr{
    
    
    if (_contentArr == nil) {
        _contentArr = [[NSMutableArray alloc]init];
    }
    
    return _contentArr;
    
}
-(NSMutableArray *)menuArray{
    
    
    if (_menuArray == nil) {
        _menuArray = [[NSMutableArray alloc]init];
    }
    
    return _menuArray;
    
}

-(NSMutableArray *)listArray{
    
    
    if (_listArray == nil) {
        _listArray = [[NSMutableArray alloc]init];
    }
    
    return _listArray;
    
}
-(NSMutableArray *)pictureArr{
    
    
    if (_pictureArr == nil) {
        _pictureArr = [[NSMutableArray alloc]init];
    }
    
    return _pictureArr;
    
}
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
- (NSMutableArray *)appArray
{
    if (!_appArray) {
        _appArray = [[NSMutableArray alloc]init];
    }
    return _appArray;
}
- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}
- (NSMutableArray *)imgListArray
{
    if (!_imgListArray) {
        _imgListArray = [[NSMutableArray alloc]init];
    }
    return _imgListArray;
}
-(void)createbarItem{
    UIImage *btnim = [UIImage imageNamed:@"luntanhudong"];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnim.size.width, btnim.size.height)];
    [btn setImage:btnim forState:UIControlStateNormal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.alertbtn = [[AlertsButton alloc]init];
    UIImage *im =[UIImage imageNamed:@"tuisongxiaoxi"];
    self.alertbtn.frame =CGRectMake(0, 0, im.size.width, im.size.height);
    [self.alertbtn setImage:im forState:UIControlStateNormal];
    [self.alertbtn addTarget:self action:@selector(rightPushClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.alertbtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
-(void)rightPushClick:(AlertsButton *)btn{
    PushMessageViewController *push = [[PushMessageViewController alloc]init];
    [self.navigationController pushViewController:push animated:YES];
}
-(void)createSearch{
    
    self.searchbar = nil;
    self.searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width - 120, 40)];
    self.searchbar.layer.cornerRadius = 5;
    self.searchbar.layer.masksToBounds = YES;
    self.searchbar.placeholder = @"  输入关键词";
    UITextField *searchField = [self.searchbar valueForKey:@"_searchField"];
    if (searchField) {
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    }
    [self.searchbar setImage:[UIImage imageNamed:@"sousuoshangcheng"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.searchbar.delegate = self;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    [_searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"sousuokuangshangcheng"] forState:UIControlStateNormal];
    UIView *seachview = [[UIView alloc]initWithFrame:CGRectMake(60, 20, SCREEN.size.width - 120, 40)];
    [seachview addSubview:_searchbar];
    if (iOS11) {
        self.navigationItem.titleView = seachview;
    }else{
        self.navigationItem.titleView = _searchbar;
    }
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)]];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    
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
-(void)createUI{
    
//    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tianjiafatie"] style:UIBarButtonItemStyleDone target:self action:@selector(searchBtnClick:)];
//    searchBtn.tintColor = [UIColor whiteColor];
//    UIBarButtonItem *infoBtn =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"linlihudongtu1"] style:UIBarButtonItemStylePlain target:self action:@selector(infoBtnClick:)];;
//    infoBtn.tintColor = [UIColor whiteColor];
//    
//    NSArray *items = @[infoBtn,searchBtn];
//    self.navigationItem.rightBarButtonItem = infoBtn;
//    self.navigationItem.leftBarButtonItem = searchBtn;
    self.page = 1;
    [self creatBGImage];
    if (![userDefaults objectForKey:NetworkReachability]) {
        
        
        
        self.menuArray = (NSMutableArray *)[self MeunFMdbData:@"menu"];
        self.appArray = (NSMutableArray *)[self MeunFMdbData:@"listBBS"];
        
        [self createcorllviewBtn];
        
    }else{
        
        [self upDataforMenu];
    }
    
    [self creatTableview];
    
    
    [self ceratCycleScrollView];
    // 上拉下拉刷新控件
    [self setupRefresh];
    //注册监听者,接收键盘位置将要发生改变是的通知.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBottomViewAndTableViewFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
}
//searchbar的协议方法、、
//进入编辑状态时
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    if ( NO == [UserModel online] )
    {
        
        [self showLogin:^(id response) {
            
        }];
        return NO;
    }
    SearchViewController*search = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
    return NO;
}
-(void)searchBtnClick:(UIBarButtonItem *)btn{
    
    if ( NO == [UserModel online] )
    {
        
        [self showLogin:^(id response) {
        }];
        return;
    }
    PostViewController *postView = [[PostViewController alloc]init];
    [self.navigationController pushViewController:postView animated:YES];
    
    
}

-(void)infoBtnClick:(UIBarButtonItem *)btn{
    LFLog(@"infoBtnClick");
    UserInfoViewController * user = [[UserInfoViewController alloc]init];
    [self.navigationController pushViewController:user animated:YES];
    
    
}
//从数据库获取数据
-(NSArray *)MeunFMdbData:(NSString *)type{
    
    
    NSArray *modelarr = [[AppFMDBManager sharedAppFMDBManager] cachedDataWithDataType:type];
    
    return modelarr;
    
}

- (void)creatTableview
{
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:self.image.bounds];
    [tableHeaderView addSubview:self.image];
    //    CGFloat tableY = (kDevice_Is_iPhoneX ? -84 :-64);
    //    CGFloat tableH = ScreenHeight - tableY;
    self.tableView = [[baseTableview alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    if (iOS11) {
        self.tableView.height = SCREEN.size.height - 50;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableHeaderView  = self.image;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView registerNib:[UINib nibWithNibName:@"GovernmentPostTableViewCell" bundle:nil] forCellReuseIdentifier:@"D0BBsTableViewCell"];
    [self.view addSubview:self.tableView];
}

- (void)creatBGImage
{
    self.image = [[UIImageView alloc]init];
    self.image.frame = CGRectMake(0, 0, SCREEN.size.width, headerHt + 100);
    self.image.userInteractionEnabled = YES;
    //    self.image.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:self.image];
}
#pragma mark - --- delegate 视图委托 ---
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentInset.top + scrollView.contentOffset.y;
//    CGFloat progress = offsetY / (self.headerHeight - 20);
    CGFloat progressChange = offsetY / (self.headerHeight - 64 - 44);
    //    NSLog(@"%s, %f, %f, %f", __FUNCTION__ ,progressChange, progress, offsetY);
//    if (self.isAppear) {
//        if (progressChange >= 1) {
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//            [self.navigationController setNavigationAlpha:(progressChange - 1) animated:YES];
//            self.titleView.alpha = (progressChange - 1);
//        }else {
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//            self.titleView.alpha = 0;
//            [self.navigationController setNavigationAlpha:0 animated:YES];
//            
//        }
//    }
    
}
#pragma mark - --- getters and setters 属性 ---



- (UIButton *)buttonBack
{
    if (!_buttonBack) {
        CGFloat viewX = 0;
        CGFloat viewY = 0;
        CGFloat viewW = 13;
        CGFloat viewH = 21;
        _buttonBack = [[UIButton alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
    }
    return _buttonBack;
}

- (UILabel *)titleView
{
    if (!_titleView) {
        CGFloat viewX = 0;
        CGFloat viewY = 0;
        CGFloat viewW = 0;
        CGFloat viewH = 44;
        _titleView = [[UILabel alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        _titleView.text = @"员工互动";
        _titleView.textColor = [UIColor whiteColor];
        [_titleView sizeToFit];
    }
    return _titleView;
}

- (CGFloat)headerHeight
{
    return SCREEN.size.width * 28/75 + 100;
}

//图片轮播
- (void)ceratCycleScrollView
{
    //采用网络图片实现
    [_jwView removeAllSubviews];
    [_jwView removeFromSuperview];
    _jwView = nil;
    _jwView=[[JWCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerHt)];
    //    self.headerView.frame = CGRectMake(0, 0, SCREEN.size.width, _jwView.frame.size.height + 30);
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    
    if (self.pictureArr.count == 0) {
        imagesURLStrings = [NSMutableArray arrayWithObjects:@"banner",@"banner",nil];
        _jwView.localImageArray = imagesURLStrings;
    }else{
        for (NSDictionary *dt in self.pictureArr) {
            [imagesURLStrings addObject:dt[@"imgurl"]];
        }
        
        _jwView.imageURLArray=imagesURLStrings;
    }    // 图片配文字
    
    _jwView.placeHolderColor=[UIColor grayColor];
    _jwView.autoScrollTimeInterval=3.0f;
    _jwView.showPageControl=YES;
    _jwView.delegate=self;
    _jwView.pageControlAlignmentType=pageControlAlignmentTypeRight;
    _jwView.jwCycleScrollDirection=JWCycleScrollDirectionHorizontal; //横向
//    UIImageView *GradientImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"daohangtiaoyinying"]];
//    [_jwView addSubview:GradientImage];
//    [GradientImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(0);
//        make.left.offset(0);
//        make.right.offset(0);
//    }];
    [_jwView startAutoCarousel];
    
    [self.image addSubview:self.jwView];
    
    
}

-(void)cycleScrollView:(JWCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    if (cycleScrollView==_jwView)
    {
        //        NSLog(@"22222222=自动滚动到%ld页",(long)index);
    }
}


-(void)cycleScrollView:(JWCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index
{
    if (cycleScrollView==_jwView)
    {
        if (![userDefaults objectForKey:NetworkReachability]) {
            [self presentLoadingTips:@"网络貌似掉了~~"];
        }else{
            if ([self.pictureArr[index][@"ios"] isKindOfClass:[NSDictionary class]]) {
                UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:self.pictureArr[index][@"ios"] controller:self];
                if (board == nil) {
                    [self presentLoadingTips:@"信息读取失败！"];
                }
                return;
            }
            ListBBsViewController *list = [[ListBBsViewController alloc]init];
            list.titlestr = self.pictureArr[index][@"name"];
//            NSString *parent_id = self.pictureArr[index][@"parent_id"];
//            NSString *link = self.pictureArr[index][@"link"];
//            if ([parent_id isEqualToString:@"0"]) {
//                list.parentid = link;
//            }else{
//                list.parentid = parent_id;
//                list.link = link;
//            }
            list.parentid = [NSString stringWithFormat:@"%@",self.pictureArr[index][@"id"]];
            LFLog( @"%@",list.parentid);
            [self.navigationController pushViewController:list animated:YES];
        }
        
    }else {
        
        
    }
}

-(void)createcorllviewBtn{
    
    
    for (MenuModel *model in self.menuArray) {
        [self.iamgeArr2 addObject:model.id];
        [self.titleArr addObject:model.name];
        [self.contentArr addObject:model.detail];
    }
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake((SCREEN.size.width)/4.85, 100);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (self.collectionview == nil) {
        self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(1, headerHt , SCREEN.size.width,100) collectionViewLayout:flowLayout];
    }
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview setBackgroundColor:[UIColor clearColor]];
    _collectionview.backgroundColor = JHColor(232, 241, 245);
    //注册Cell，必须要有
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.image addSubview:self.collectionview];
    
}
#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.menuArray.count;
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    [cell.contentView removeAllSubviews];
    MenuModel *model = self.menuArray[indexPath.row];
    
    UIButton *bt  = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, SCREEN.size.width/4.5, 100)];
    
    bt.tag = indexPath.item + 800;
    [bt addTarget:self action:@selector(fenleibuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    bt.userInteractionEnabled = YES;
    [cell.contentView addSubview:bt];
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.layer.cornerRadius = 3;
    imageview.layer.masksToBounds = YES;
    [imageview sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:nil];
    [bt addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.equalTo(imageview.mas_width).multipliedBy(1);
        
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = _titleArr[indexPath.row];
    label.textColor = JHColor(102, 102, 102);
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [bt addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bt.mas_centerX);
        make.top.equalTo(imageview.mas_bottom);
        make.bottom.offset(0);
        
    }];
    
    
    
    
    
    return cell;
}


// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}

#pragma mark   回复textfield
//- (void)creatTextfieldView
//{
//    self.bottomView = [[UIView alloc]init];
//    [_bottomView setBackgroundImage:[UIImage imageNamed:@"base"]];
//    _bottomView.frame = CGRectMake(0, SCREEN.size.height, 0, 0);
//    [self.view addSubview:_bottomView];
//    //回复输入框
//    self.tfview = [[UITextView alloc]initWithFrame:CGRectMake(20, 5, SCREEN.size.width-80, 28)];
//    self.tfview.layer.borderColor = [[UIColor colorWithRed:235/256.0 green:236/256.0 blue:237/256.0 alpha:1.0]CGColor];
//    self.tfview.layer.borderWidth = 1;
//    self.tfview.layer.cornerRadius = 5;
//    self.tfview.font = [UIFont systemFontOfSize:14];
//    self.tfview.textColor = [UIColor grayColor];
//    self.tfview.delegate = self;
//    [self.bottomView addSubview:self.tfview];
//    //发送按钮
//    self.sendBtn = [CustomButton btnBgImg:nil title:@"发送" titleColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14.0] backGroundColor:[UIColor clearColor] cornerRadius:1.0 textAlignment:NSTextAlignmentCenter];
//    self.sendBtn.frame = CGRectMake(SCREEN.size.width-50, 5, 40, 30);
//    [self.sendBtn addTarget:self action:@selector(sendClick1) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomView addSubview:self.sendBtn];
//    
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appArray.count ;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

#pragma mark从第二个cell开始加载帖子数据
    
    static NSString *CellIdentifier = @"D0BBsTableViewCell";
    GovernmentPostTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.hotIm.hidden = YES;
    cell.delegate = self;
    cell.GovernmentModel = self.appArray[indexPath.row];
    cell.contentLbLeft.constant = 60;
    CGSize h = [cell.GovernmentModel.content selfadap:14 weith:50];
    CGFloat HH = h.height + 10;
    if (HH > 105) {
        HH = 105;
    }
    cell.contentLbHeight.constant = HH;
    __weak typeof(cell) weakcell = cell;
    [cell setLikeblock:^(UIButton *sender) {
        [self upDataforpraise:weakcell.GovernmentModel.id index:indexPath.row cell:weakcell];
    }];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    return cell;

    
}
#pragma mark  点击cell,进入帖子详情页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    LFLog(@"帖子详情页面");
    DetailsViewController *de = [[DetailsViewController alloc]init];
    GovernmentModel *model = self.appArray[indexPath.row];
    de.detailID = model.id;
    de.delegate = self;
    [self.navigationController pushViewController:de animated:YES];
}
#pragma mark  帖子详情代理
- (void)BBSDeletePost:(GovernmentModel *)model isDelete:(BOOL)isDelete{
    
    NSArray *tempArr = [self.appArray mutableCopy];
    int i = 0;
    for (GovernmentModel *gomodel in tempArr) {
        if ([gomodel.id isEqualToString:model.id]) {
            if (isDelete) {
                [self.appArray removeObject:gomodel];
            }else{
                [self.appArray replaceObjectAtIndex:i withObject:model];
            }
        }
        i ++;
    }
    
    [self.tableView reloadData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GovernmentModel *mo = self.appArray[indexPath.row];
    CGSize h = [mo.content selfadap:14 weith:20];
    CGFloat HH = h.height + 10;
    if (HH > 105) {
        HH = 105;
    }
    if (mo.imgurl.count) {
        CGFloat imgWidth = (SCREEN.size.width - 90)/3 + 10;
        if (mo.imgurl.count == 1) {
            imgWidth = (SCREEN.size.width - 90)/3 * 2;
        }else if (mo.imgurl.count == 4){
            imgWidth += imgWidth;
        }else{
            imgWidth = imgWidth * (((mo.imgurl.count - 1)/3 +1) < 4? (mo.imgurl.count - 1)/3 +1:3);
        }
        
        return HH + 110 + imgWidth;
    }else{
        return HH + 110;
        
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header =[[UIView alloc]init];
    header.backgroundColor = JHbgColor;
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setImage:[UIImage imageNamed:@"rementiezi"] forState:UIControlStateNormal];
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [header addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.right.offset(0);
        make.bottom.offset(-1);
    }];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 45;
    }
    return 0.001;
}

#pragma mark  跳转到分类
- (void)fenleibuttonClick:(UIButton *)btn
{
    ListBBsViewController *list = [[ListBBsViewController alloc]init];
    list.titlestr = self.titleArr[btn.tag - 800];
    list.parentid = [NSString stringWithFormat:@"%@",self.iamgeArr2[btn.tag - 800]];
    LFLog( @"%@",list.parentid);
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark  发帖按钮
- (void)postMessageClick:(UIButton *)btn
{
    if ( NO == [UserModel online] )
    {
        
        [self showLogin:^(id response) {
        }];
        return;
    }
    PostViewController *postView = [[PostViewController alloc]init];
    [postView setBlock:^{
        self.page = 1;
        self.more = @"1";
        [self requestData:self.page];
    }];
    [self.navigationController pushViewController:postView animated:YES];
}
#pragma mark   点击用户头像
- (void)choseTerm:(UIButton *)button
{
    if ( NO == [UserModel online] )
    {
        
        [self showLogin:^(id response) {
        }];
        return;
    }
    LFLog(@"%ld",(long)button.tag);
    UserInfoViewController*userInfo = [[UserInfoViewController alloc]init];
    [self.navigationController pushViewController:userInfo animated:YES];
}
#pragma mark  回复按钮
- (void)replay:(UIButton *)button
{
    self.mattebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mattebtn.frame = CGRectMake(0,0, 500, 800);
    [self.mattebtn addTarget:self action:@selector(hideKboard) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.mattebtn];
    [self.tfview becomeFirstResponder];
}
#pragma mark   回复消息发送按钮
- (void)sendClick1
{
    if ([self.tfview.text isEqualToString:@""] == YES)
    {
        return;
    }
    LFLog(@"%@",self.tfview.text);
    [self hideKboard];
}

#pragma mark - 接收到键盘位置将要发生改变时的通知
- (void)changeBottomViewAndTableViewFrame:(NSNotification *)notifi
{
    NSDictionary *dict = [notifi userInfo];
    CGRect keyboardRect = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:7];
    keyboardY = keyboardRect.origin.y-100;
    _bottomView.frame  = CGRectMake(0, keyboardRect.origin.y-100, SCREEN.size.width, 40);
    [UIView commitAnimations];
}
- (void)hideKboard
{
    self.tfview.text = nil;
    [self.mattebtn removeFromSuperview];
    [self.tfview resignFirstResponder];
}


- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size = [textView.text sizeWithAttributes:@{NSFontAttributeName:textView.font}];
    int length = size.height;
    int colomNumber = textView.contentSize.height/length;
    self.bottomView.frame = CGRectMake(0, keyboardY - (colomNumber - 2)*16, SCREEN.size.width, 40 + (colomNumber - 2)*16);
    self.tfview.frame =CGRectMake (20, 5, SCREEN.size.width-80, 28+(colomNumber - 2)*16);
}


#pragma mark 菜单数据请求
-(void)upDataforMenu{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    LFLog(@"菜单数据dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSMenuListUrl) params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        LFLog(@"菜单数据:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.menuArray removeAllObjects];
            for (NSDictionary *subDic in response[@"data"]) {

                MenuModel *model = [[MenuModel alloc]initWithDictionary:subDic error:nil];
                
                [self.menuArray addObject:model];
            }
            
            [self createcorllviewBtn];
            //gcd,把任务放到全局队列中，异步执行；gcd帮我们开辟线程，执行任务
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                AppFMDBManager *af =  [AppFMDBManager sharedAppFMDBManager];
                [af saveDataArray:self.menuArray dataType:@"menu"];
            });
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            NSArray *meunFBarr = [self MeunFMdbData:@"menu"];
            
            
            for (MenuModel *model in meunFBarr) {
                LFLog(@"%@",model.name);
                [self.iamgeArr2 addObject:model.id];
                [self.titleArr addObject:model.name];
                [self.contentArr addObject:model.detail];

            }
            LFLog(@"%@",meunFBarr);
            //            [self creatCategoryBtn];
            [self createcorllviewBtn];
            
            
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark 点赞数据请求
-(void)upDataforpraise:(NSString *)articleid index:(NSInteger)index cell:(GovernmentPostTableViewCell *)cell{
    
    if ( NO == [UserModel online] )
    {
        
        [self showLogin:^(id response) {
        }];
        return;
    }
      NSDictionary * session =[userDefaults objectForKey:@"session"];
        if (session == nil) {
            session = @{};
        }
        NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session",articleid,@"id", nil];
        LFLog(@"点赞dt：%@",dt);
        [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSLikeUrl) params:dt success:^(id response) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
            if ([str isEqualToString:@"1"]) {

                GovernmentModel *model = self.appArray[index];
                NSInteger praise = [model.agree_count integerValue];
                if ([model.is_agree isEqualToString:@"0"]) {
                    [self presentLoadingTips:@"点赞成功~~"];
                    model.is_agree = @"1";
                    praise ++;
                }else{
                    [self presentLoadingTips:@"取消点赞~~"];
                    model.is_agree = @"0";
                    praise --;
                    
                }
                model.agree_count = [NSString stringWithFormat:@"%d",(int)praise];
                [self.appArray replaceObjectAtIndex:index withObject:model];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

            }else{
                [self presentLoadingTips:response[@"status"][@"error_desc"]];
                
            }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark 请求数据
- (void)requestData:(NSInteger )pagenum{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"获取成功dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSHomeListUrl) params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            LFLog(@"获取成功:%@",response);
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            if (pagenum == 1) {
                [self.appArray removeAllObjects];
            }
            for (NSDictionary *dt in response[@"data"]) {
                
                GovernmentModel *model=[[GovernmentModel alloc]initWithDictionary:dt error:nil];
                [self.appArray addObject:model];
                
            }
            [self.tableView reloadData];
            
            if (self.appArray.count > 0) {
                //gcd,把任务放到全局队列中，异步执行；gcd帮我们开辟线程，执行任务
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    AppFMDBManager *af =  [AppFMDBManager sharedAppFMDBManager];
                    NSDate *datenow = [NSDate date];
                    CGFloat nowtime = [datenow timeIntervalSince1970];

                    CGFloat oldtime =  [[af timeDataWithDataType:@"listBBS"] doubleValue];
                    if ((nowtime - oldtime) > 86400) {
                        [af saveDataArray:self.appArray dataType:@"listBBS"];
                    }
                    [af saveDataArray:self.appArray dataType:@"listBBS"];



                });
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    self.page = 1;
                    self.more = @"1";
                    [self requestData:self.page];
                    [self upDataforMenu];
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark 轮播图请求数据
-(void)wheelrequestData{    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    LFLog(@"轮播图dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSbannerListUrl) params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        LFLog(@"轮播图:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.pictureArr removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                [self.pictureArr addObject:dt];
            }
            [_jwView removeFromSuperview];
            [self ceratCycleScrollView];
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - *************用户信息*************
-(void)refushUserInfo{
    [UserModel UploadDataUserInfo:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (response[@"data"][@"not_read"]) {
                if (self.alertbtn) {
                    self.alertbtn.alertLabel.textnum = [NSString stringWithFormat:@"%@",response[@"data"][@"not_read"]];
                }
                
            }
        }else{
            //            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            //            if ([error_code isEqualToString:@"100"]) {
            //
            //                [self showLogin:^(id response) {
            //                    if ([response isEqualToString:@"1"]) {
            //                        [self refushUserInfo];;
            //                    }
            //
            //                }];
            //            }
            //            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } error:^(NSError *error) {
        
    }];
    
}
#pragma mark tabbar点击



#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self requestData:self.page];
        [self upDataforMenu];
        [self wheelrequestData];
    }];
//    _tableView.mj_footer = [MJRefreshBackFooter]
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多帖子了"];
            [self.tableView.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self requestData:self.page];
        }
    
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showTabbar];
    [self createSendBtn];
    if (@available(iOS 11.0, *)) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(0.2, dispatch_get_main_queue(), ^{
            [weakSelf scrollViewDidScroll:weakSelf.tableView];
        });
    } else {
        [self scrollViewDidScroll:self.tableView];
    }
    [self refushUserInfo];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self hideTabbar];
    [self.navigationController setNavigationAlpha:1.0 animated:YES];
    [self.sendBtn removeFromSuperview];
    self.sendBtn = nil;
    //    [self.navigationController.navigationBar st_reset];
    //    self.titleviewalph = self.titleView.alpha;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //    self.titleView.alpha = self.titleviewalph;
//    [self.navigationController setNavigationColor:JHMaincolor animated:NO];
    self.isAppear = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationColor:self.navigationColor animated:NO];
    [self.navigationController setNavigationAlpha:1.0 animated:YES];
    //    [self.navigationController.navigationBar st_reset];
    self.isAppear = NO;
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
    [[SDWebImageManager sharedManager] cancelAll];
    
    [[SDImageCache sharedImageCache] clearDisk];
    
}
-(void)createSendBtn{
    
    if (self.sendBtn == nil) {
        self.sendBtn = [[UIButton alloc]init];
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        [self.sendBtn setImage:[UIImage imageNamed:@"fabutiezi"] forState:UIControlStateNormal];
        [self.sendBtn addTarget:self action:@selector(postMessageClick:) forControlEvents:UIControlEventTouchUpInside];
        [win addSubview:self.sendBtn];
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.bottom.offset((kDevice_Is_iPhoneX ? -94 :-60));
        }];
    }
}

@end
