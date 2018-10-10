//
//  SignInMapViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/7/31.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SignInMapViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ErrorInfoUtility.h"
#import "AdressListView.h"
#import <CoreLocation/CLLocationManager.h>
@interface SignInMapViewController ()<AMapNearbySearchManagerDelegate, AMapSearchDelegate,MAMapViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapNearbySearchManager *nearbyManager;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AdressListView *adressView;
@property (nonatomic, strong) NSArray *circles;
@property (nonatomic, strong) UIImageView *centerIm;//居中图标
@property (nonatomic, strong) UITextField *searchFiled;//
@property (nonatomic, strong) NSString *city;//城市
@property (nonatomic, strong) placeModel *pmodel;//城市
@property (nonatomic, strong) UIView *alterView;//提示框
@end

@implementation SignInMapViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.mapView addOverlays:self.circles];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_nearbyManager stopAutoUploadNearbyInfo];
    _nearbyManager.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        //定位不能用
        [self alertController:@"允许\"定位\"提示" prompt:@"请在设置中打开定位" sure:@"打开定位" cancel:@"取消" success:^{
            NSURL *setUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:setUrl];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT, screenW, screenH - SAFE_NAV_HEIGHT)];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [_mapView setZoomLevel:16 animated:YES];
    //定位
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.navigationBarTitle = self.isSetAdress ? @"考勤地点" :@"签到";
    self.locationManager = [[AMapLocationManager alloc]init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    if (self.isSetAdress) {
        self.pmodel = [[placeModel alloc]init];
        _nearbyManager = [AMapNearbySearchManager sharedInstance];
        _nearbyManager.delegate = self;
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
        self.mapView.showsUserLocation = NO;
        [self createBaritem];
        [self.view addSubview:self.centerIm];
        [self.view addSubview:self.searchFiled];
    }else{
        self.mapView.showsUserLocation = YES;
        [self initCircles];
    }
    [self SingleLocation];
    
}
-(void)createBaritem{
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    rightBar.tintColor = JHMaincolor;
    self.navigationItem.rightBarButtonItem = rightBar;
    
}
-(UIImageView *)centerIm{
    if (_centerIm == nil) {
        _centerIm = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dingwei"]];
        _centerIm.center = CGPointMake(screenW/2, SAFE_NAV_HEIGHT/2 + screenH/2);
//        _centerIm.size_i = _centerIm.image.size;
    }
    return _centerIm;
}
-(UITextField *)searchFiled{
    if (_searchFiled == nil) {
        _searchFiled = [[UITextField alloc]initWithFrame:CGRectMake(20, SAFE_NAV_HEIGHT + 20, screenW - 40, 50)];
        _searchFiled.font = SYS_FONT(15);
        _searchFiled.placeholder = @"请输入考勤地点";
        _searchFiled.backgroundColor =[UIColor whiteColor];
        _searchFiled.layer.cornerRadius = 5;
        _searchFiled.clearButtonMode = UITextFieldViewModeAlways;
        _searchFiled.layer.masksToBounds = YES;
        _searchFiled.delegate = self;
        _searchFiled.returnKeyType = UIReturnKeySearch;
        UIImageView *leftview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, _searchFiled.height_i)];
        leftview.image = [UIImage imageNamed:@"dingwei"];
        leftview.contentMode = UIViewContentModeCenter;
        _searchFiled.leftViewMode = UITextFieldViewModeAlways;
        _searchFiled.leftView = leftview;
    }
    return _searchFiled;
}
-(AdressListView *)adressView{
    if (_adressView == nil) {
        _adressView = [[AdressListView alloc]initWithImageArray:nil];
        _adressView.frame = CGRectMake(0, screenH, screenW, screenH/2);
        WEAKSELF;
        _adressView.cellClick = ^(placeModel *pmodel) {
            weakSelf.pmodel = pmodel;
            weakSelf.searchFiled.text = pmodel.address;
            [weakSelf adressViewAnimation:YES];
            CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:pmodel.lat longitude:pmodel.lng];
            [weakSelf.mapView setCenterCoordinate:curLocation.coordinate animated:YES];
        };
        [self.view addSubview:_adressView];
    }
    return _adressView;
}
-(UIView *)alterView {
    if ( _alterView == nil) {
        _alterView = [[UIView alloc]initWithFrame:CGRectMake(40, screenH/2, screenW - 80, 80)];
        _alterView.backgroundColor = [UIColor whiteColor];
        _alterView.layer.cornerRadius = 5;
        _alterView.layer.masksToBounds  = YES;
        UILabel *lb = [UILabel initialization:CGRectZero font:SYS_FONT(15) textcolor:JHdeepColor numberOfLines:0 textAlignment:NSTextAlignmentCenter];
        [_alterView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(15);
            make.right.offset(-15);
        }];
        if (self.smodel.photoProof.integerValue == 1) {
            UIButton *btn = [[UIButton alloc]init];
            [btn setPropertys:@"拍照" font:SYS_FONT(15) textcolor:[UIColor whiteColor] image:nil state:UIControlStateNormal];
            btn.backgroundColor = JHMaincolor;
            btn.layer.cornerRadius = 3;
            btn.layer.masksToBounds = YES;
            [btn addTarget:self action:@selector(TakephotoClick) forControlEvents:UIControlEventTouchUpInside];
            [_alterView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.right.bottom.offset(-15);
                make.height.offset(40);
            }];
        }
    }
    return _alterView;
}
-(void)adressViewAnimation:(BOOL )isHiden{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.adressView.y_i = isHiden ? screenH : screenH/2;
    } completion:^(BOOL finished) {
        self.adressView.y_i = isHiden ? screenH : screenH/2;
    }];
}
#pragma mark  确定
-(void)rightClick{
    NSMutableArray *parr = [NSMutableArray array];
    if (self.model && self.model.place.count) [parr addObjectsFromArray:self.model.place];
    [parr addObject:self.pmodel];
    self.model.place = parr;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  TextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [self keywordSearch];
    return YES;
}
#pragma mark 计算两经纬度之间的距离
-(double)distanceBetweenOrderBy:(CLLocation * )location1 location2:(CLLocation * )location2{
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:39.996441 longitude:116.411146];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:40.096441 longitude:116.511146];
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    return  distance;
    
}
#pragma mark  经纬度转地址
- (void)setGegeo:(CLLocationCoordinate2D)coor {
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc]init];
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
    
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];
    
}
#pragma mark  关键字搜索
-(void)keywordSearch{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords            = self.searchFiled.text;
    request.city                = self.city;
//    request.types               = @"位置";
    request.requireExtension    = YES;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    [self.search AMapPOIKeywordsSearch:request];
}


#pragma mark - Initialization
- (void)initCircles {
    NSMutableArray *arr = [NSMutableArray array];
    if (self.smodel) {
        for (placeModel *pmo in self.smodel.place) {
            MACircle *circle1 = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(pmo.lat, pmo.lng) radius:300];
            [arr addObject:circle1];
//            circle1.hollowShapes = @[[MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.996441, 116.411146) radius:5000]];
        }
    }
    self.circles = [NSArray arrayWithArray:arr];
}
#pragma mark - 提示框
-(void)shoeAlertview:(NSString *)text{
    UILabel *lb = nil;
    for (UIView *sub in self.alterView.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            lb = (UILabel *)sub;
        }else if ([sub isKindOfClass:[UIButton class]]){
            sub.hidden = self.pmodel ? NO : YES;
        }
    }
    lb.text = text;
    [lb NSParagraphStyleAttributeName:10];
    CGFloat hh = [lb.attributedText selfadaption:110].height + 10 + 30;
    if (self.smodel.photoProof.integerValue == 1) {
        hh += self.pmodel ? 55 : 0;
    }
    self.alterView.height_i = hh;
    self.alterView.center_Y = screenH/2;
    [self.view addSubview:self.alterView];
}
#pragma mark - 拍照
-(void)TakephotoClick{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self alertController:@"提示" prompt:@"此应用没有权限访问您的照片或视频，您可以在”隐私设置“中启用访问" sure:@"确定" cancel:@"取消" success:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } failure:^{
            
        }];
        return;
    }
    UIImagePickerController *pic = [[UIImagePickerController alloc]init];
    pic.delegate = self;
    //允许编辑图片
    pic.allowsEditing = YES;
    pic.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pic animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *editimage = info[UIImagePickerControllerOriginalImage];
    editimage = [editimage fixOrientation];
    
    //移除图片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
    [self updatePicture:editimage];

}
-(void)updatePicture:(UIImage *)image{
    [self presentLoadingTips];
    [UploadManager uploadImagesWith:@[image] uploadFinish:^(NSArray *imFailArr){
        if (imFailArr.count) {
            [self dismissTips];
            [self alertController:@"提示" prompt:@"图片上传失败！是否重新上传" sure:@"是" cancel:@"否" success:^{
                [self updatePicture:image];
            } failure:^{
                
            }];
        }else{
            
            [self UpdateLoad];
        }
        
    } success:^(NSDictionary *imgDic, int idx) {
        NSInteger code = [imgDic[@"code"] integerValue];
        if (code == 1) {
            self.pmodel.photo = [imgDic[@"data"][@"url"] SeparatorStr:self.pmodel.photo];
        }else{
            [AlertView showMsg:imgDic[@"msg"]];
        }
    } failure:^(NSError *error, int idx) {
        
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 记录位置
-(void)RecordLocation:(CLLocation * )curLocation{
    if (self.smodel) {
        for (placeModel *pmo in self.smodel.place) {
            CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:pmo.lat longitude:pmo.lng];
            double  distance  = [curLocation distanceFromLocation:otherLocation];
            if (distance <= 300) {
                self.pmodel = pmo;
                self.pmodel.address = nil;
                self.pmodel.name = nil;
                self.pmodel.date = [UserUtils getShowDate:[NSDate date] dateFormat:@"yyyy-MM-dd"];
                if (self.smodel.photoProof.integerValue == 1) {
                    [self shoeAlertview:@"位置记录成功，请在5分钟内拍照周边环境并上传"];
                }else{
                    [self UpdateLoad];
                }
                
                return;
            }
        }
        [self shoeAlertview:@"您现在不在可签到区域，请行至可签到区域后进行签到"];
    }
}
#pragma mark - 定位
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (updatingLocation  && !self.pmodel)  {
        [self RecordLocation:userLocation.location];
    }
}
- (void)SingleLocation{
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error){
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed){
                [self presentLoadingTips:@"定位错误！"];
                return;
            }
        }
        if (regeocode){
            if (self.isSetAdress) {
                self.city = regeocode.city;
                if (!self.searchFiled.text.length) {
                    self.pmodel.name = regeocode.POIName;
                    self.pmodel.address = regeocode.formattedAddress;
                    self.pmodel.lat = location.coordinate.latitude;
                    self.pmodel.lng = location.coordinate.longitude;
                    self.searchFiled.text = regeocode.formattedAddress;
                }
            }else{
                if (!self.pmodel) [self RecordLocation:location];
            }

            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:(MACircle *)overlay];
        circleRenderer.lineWidth   = 4.f;
        circleRenderer.strokeColor = JHAssistRedColor;
        circleRenderer.fillColor   = [JHColor(244, 35, 29) colorWithAlphaComponent:0.3];
        NSInteger index = [self.circles indexOfObject:overlay];
        if(index == 0) {
            
        } else if(index == 1) {
            circleRenderer.fillColor   = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        } else if(index == 2) {
            circleRenderer.fillColor   = [[UIColor blueColor] colorWithAlphaComponent:0.3];
        } else {
            circleRenderer.fillColor   = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
        }
        return circleRenderer;
    }
    
    return nil;
}
/**
 * @brief 地图移动结束后调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    if (wasUserAction) {
        MACoordinateRegion region;
        CLLocationCoordinate2D centerCoordinate = mapView.region.center;
        region.center = centerCoordinate;
        [self setGegeo:centerCoordinate];
    }

}

/**
 * @brief 单击地图回调，返回经纬度
 * @param mapView 地图View
 * @param coordinate 经纬度
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self adressViewAnimation:YES];
}

#pragma mark - 搜索
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
}
/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        self.pmodel.name = response.regeocode.formattedAddress;
        self.pmodel.address = response.regeocode.formattedAddress;
        self.pmodel.lat = request.location.latitude;
        self.pmodel.lng = request.location.longitude;
        self.searchFiled.text = response.regeocode.formattedAddress;
        NSLog(@"nearby responst:%@", response.regeocode.formattedAddress);
    }
}
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    [self.adressView.dataArray removeAllObjects];
    for (AMapPOI *poi in response.pois) {
        LFLog(@"搜索结果：%@",poi.address);
        placeModel *mo = [[placeModel alloc]init];
        mo.name = poi.name;
        mo.address = poi.address;
        mo.lat = poi.location.latitude;
        mo.lng = poi.location.longitude;
        [self.adressView.dataArray addObject:mo];
    }
    
    [self.adressView.tableview reloadData];
    [self adressViewAnimation:NO];
    //解析response获取POI信息，具体解析见 Demo
}

#pragma mark 提交
-(void)UpdateLoad{
    [self presentLoadingTips];
    NSMutableDictionary *mdt = [self.pmodel mj_keyValues];
    [mdt removeObjectForKey:@"id"];
    [mdt setObject:self.pmodel.place forKey:@"place"];
    [mdt setObject:self.smodel.ID forKey:@"attendance_id"];
//    [mdt setObject:@"32" forKey:@"attendance_id"];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP, self.smodel.status == 5 ? AttendancSignInUrl : AttendancSignOutUrl) params:mdt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"tijaio:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            NSLog(@"注册成功");
            if (self.successBlock) {
                self.successBlock();
            }
            [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.];
        }
        [AlertView showMsg:response[@"msg"]];
        
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"error：%@",error);
    }];
}
-(void)dismissView{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
