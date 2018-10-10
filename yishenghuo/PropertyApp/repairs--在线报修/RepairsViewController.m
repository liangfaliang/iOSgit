//
//  RepairsViewController.m
//  shop
//
//  Created by wwzs on 16/4/11.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//



#define RGBACOLOR [UIColor colorWithRed: 4/255.0f green:146/255.0f blue:245/255.0f alpha:1.0]


#import "RepairsViewController.h"
#import "IndexBtn.h"
#import "LFLaccount.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "ZBLookImagesView.h"
#import "TZImagePickerController.h"
#import "companyTableViewController.h"
#import "STPhotoBroswer.h"
#import "RepairsMaintenanceRepairViewController.h"
#import "RepairsOrderDetailsViewController.h"
#import "CommentSubmitViewController.h"//评价
#import "HCScanQRViewController.h"
@interface RepairsViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,TZImagePickerControllerDelegate,MHSelectPickerViewDelegate,UITextViewDelegate>{
    UITextView *tfERP;//公区报修 报修位置
}

@property(nonatomic,strong)UIImage *picture;

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)NSMutableArray  *imagedata;
@property(nonatomic,strong)UIView *submitView;
@property(nonatomic,strong)NSMutableArray *categoryArray;//报修分类
@property(nonatomic,strong)NSDictionary *categoryDt;
//在线投诉
@property(nonatomic,strong)NSMutableArray *complainArray;

//特约服务
@property(nonatomic,strong)NSMutableArray *serveArray;

@property (strong,nonatomic)NSMutableArray *repairRecordArr;
@property (assign,nonatomic)CGFloat keyHeight;

@property (nonatomic, strong) ZBLookImagesView *lookImagesView;

@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)NSString *strtime;
@property(nonatomic,strong)NSArray *nameArr;
@property(nonatomic,strong)NSArray *keyArr;
@property(nonatomic,assign)CGFloat cell0;
@property(nonatomic,assign)CGFloat cell1;
//存储bool的值
@property(nonatomic,strong) NSMutableArray *boolArray;

@end


@implementation RepairsViewController
-(instancetype)init{
    if (self =[super init]) {
        self.selectIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeStr = @"请选择";
    self.picture = [UIImage imageNamed:@"icon_add"];
    //    [self.imageArray addObject:self.picture];
    _cell1 = 50;
    _cell0 = 50;
    self.poid = [UserDefault objectForKey:@"poid_0"];
    if (!self.poid) {
        self.poid = @"";
    }
    [self userInfo];
    [[UITableView appearance]setTableFooterView:[UIView new]];
    //设置导航
    //    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle = _titlename;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if (self.tag == 101) {
        self.nameArr = @[@"您创建了报修任务",@"报修已接单",@"报修开始处理",@"报修已处理",@"报修已评价"];
        self.keyArr = @[@"or_requestTime",@"se_recdate",@"ws_begintime",@"ws_completetime",@"sea_date"];
        if (self.publicRepair) {//公区报修
            self.segementArray = [[NSArray alloc]initWithObjects:@"公区报修",@"报修记录",nil];
        }else{
            self.segementArray = [[NSArray alloc]initWithObjects:@"物业报修",@"报修记录",nil];
        }
        self.titleArr = [NSArray arrayWithObjects:@"物业项目:",@"报修位置:",@"报修内容:",@"预约时间:",@"上传照片:", nil];
        [self UploadDataCategory:NO];
    }else if (self.tag == 102){
        self.segementArray = [[NSArray alloc]initWithObjects:@"在线投诉",@"投诉记录",nil];
        [self titleInfo:@"投诉位置:" str2:@"投诉类型:" str3:@"投诉内容:" ];
    }else if (self.tag == 104){
        self.segementArray = [[NSArray alloc]initWithObjects:@"在线投诉",@"投诉记录",nil];
        [self titleInfo:@"服务项目:" str2:@"服务种类:" str3:@"服务内容:" ];
    }
    //创建视图
    [self creatSegment];
    [self creatView];
    [self creatTableView];
    [self creatSubmitView];
}

- (NSMutableArray *)categoryArray
{
    if (_categoryArray == nil) {
        _categoryArray = [[NSMutableArray alloc]init];
    }
    return _categoryArray;
}
- (NSMutableArray *)boolArray
{
    if (_boolArray == nil) {
        _boolArray = [[NSMutableArray alloc]init];
    }
    return _boolArray;
}
-(NSMutableArray *)imagedata{
    
    if (_imagedata == nil) {
        _imagedata  = [[NSMutableArray alloc]init];
    }
    
    
    return _imagedata;
}
- (ZBLookImagesView *)lookImagesView
{
    if (!_lookImagesView)
    {
        _lookImagesView = [ZBLookImagesView initWithSupView:self.view];
        [_lookImagesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.offset(0);
            make.bottom.offset(0);
        }];
        [_lookImagesView sHiden];
    }
    return _lookImagesView;
}


//
//#pragma mark 键盘将显示
//-(void)kbWillShow:(NSNotification *)noti{
//
//    if (self.segment.selectedSegmentIndex == 0) {
//        NSDictionary *dict = [noti userInfo];
//        CGRect keyboardRect = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        self.tableView.frame = CGRectMake(0, 0, SCREEN.size.width, keyboardRect.origin.y-45>SCREEN.size.height-105?SCREEN.size.height-105:keyboardRect.origin.y-45);
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
//        [self.tableView  scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//
//    }
//
//}
//
//
//#pragma mark 键盘将隐藏
//-(void)kbWillHide:(NSNotification *)noti{
//    if (self.segment.selectedSegmentIndex == 0) {
//    self.tableView .frame =CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height-105);
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView  scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//
//
//    }
//
////    _btn.userInteractionEnabled = YES;
//}
//
//
//-(void)keyboardHide:(UITapGestureRecognizer*)tap{
//    if (self.segment.selectedSegmentIndex == 0) {
//       // [self.view endEditing:YES];
//
//        if ([self.txtView isFirstResponder]) {
////            _btn.userInteractionEnabled = NO;
//            [self.txtView resignFirstResponder];
//        };
//    }
//}

-(void)titleInfo:(NSString *)str1 str2:(NSString *)str2 str3:(NSString *)str3{
    
    self.titleArr = [NSArray arrayWithObjects:str1,str2,str3,@"预约时间:",@"上传照片:", nil];
    
    
}

-(void)userInfo{
    
    [self.contentArr removeAllObjects];
    NSUserDefaults *defuat = [NSUserDefaults standardUserDefaults];
    
    NSString *name = [NSString stringWithFormat:@"%@",[defuat objectForKey:@"name"]];
    NSString *phone = [NSString stringWithFormat:@"%@",[defuat objectForKey:@"mobile"]];
    NSString *company = [NSString stringWithFormat:@"%@",[defuat objectForKey:@"company"]];
    self.contentArr = [NSMutableArray arrayWithObjects:name,phone,company,nil];
    
    
}
//懒加载
-(NSMutableArray *)imageArray{
    
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    
    return _imageArray;
    
}

-(NSMutableArray *)complainArray{
    
    if (_complainArray == nil) {
        _complainArray = [[NSMutableArray alloc]init];
    }
    
    return _complainArray;
    
}

-(NSMutableArray *)serveArray{
    
    if (_serveArray == nil) {
        _serveArray = [[NSMutableArray alloc]init];
    }
    
    return _serveArray;
    
}

- (NSMutableArray *)repairRecordArr
{
    if (_repairRecordArr == nil) {
        _repairRecordArr = [[NSMutableArray alloc]init];
    }
    return _repairRecordArr;
}


-(void)createCollectionview{
    
    if (self.collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.itemSize = CGSizeMake((SCREEN.size.width-60)/4, (SCREEN.size.width-60)/4);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 1;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 60) collectionViewLayout:flowLayout];
        self.collectionView.dataSource=self;
        self.collectionView.delegate=self;
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self tz_addPopGestureToView:self.collectionView];
        //注册Cell，必须要有
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        
    }
    
    
}

- (void)creatSegment
{
    self.segment = [[UISegmentedControl alloc]initWithItems:self.segementArray ];
    self.segment.selectedSegmentIndex = self.selectIndex;
    self.segment.tintColor  = JHMaincolor;
    self.segment.bounds = CGRectMake(0, 0, SCREEN.size.width-40, 40);
    self.segment.center = CGPointMake(SCREEN.size.width/2, 25);
    [self.segment addTarget:self action:@selector(segmentclick:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark x选择按钮
-(void)segmentclick:(UISegmentedControl *)seg{
    
    NSInteger Index = seg.selectedSegmentIndex;
    if (Index == 0) {
        self.tableView.mj_header.hidden = YES;
        self.tableView .frame = CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height-40);
        [self.tableView reloadData];
        self.submitView.frame = CGRectMake(0, SCREEN.size.height-50, SCREEN.size.width, 40);
    }else{
        self.tableView.mj_header.hidden = NO;
        self.tableView .frame = CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height);
        [self.tableView reloadData];
        self.submitView.frame = CGRectMake(0, SCREEN.size.height+204, SCREEN.size.width, 40);
        
    }
    
}

- (void)creatView
{
    self.view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 50)];
    [self.view1 addSubview:self.segment];
    self.view1.backgroundColor = [UIColor whiteColor];
}


- (void)creatTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height-50) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource =self;
    self.tableView.emptyDataSetDelegate = self;
    //    [self.tableView registerNib:[UINib nibWithNibName:@"ImagePostTableViewCell" bundle:nil] forCellReuseIdentifier:@"imagecell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"imagecell"];
    self.tableView.tableHeaderView  = self.view1;
    self.tableView.tag = 500;
    [self.view addSubview:self.tableView];
    [self setupRefresh];
    self.tableView.mj_header.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.segment.selectedSegmentIndex == 0) {
        return self.titleArr.count;
    }
    return self.repairRecordArr.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.segment.selectedSegmentIndex == 0){
        if (self.tag == 101) {
            if (section == 1) {
                return 2;
            }
        }
        
        return 1;
        
    }
    BOOL ret = [self.boolArray[section] boolValue];
    if (ret) {
        
        return 1;
    }else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.segment.selectedSegmentIndex == 0) {
        
        UIImageView *rightimage = [[UIImageView alloc]init];
        rightimage.image = [UIImage imageNamed:@"gerenzhongxinjiantou"];
        
        if (indexPath.section == 0 ){
            //物业项目cell，点击可push
            static NSString *ThreeCellIdentifier = @"ThreeCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ThreeCellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ThreeCellIdentifier] ;
                UILabel *label = [[UILabel alloc]init];
                [cell.contentView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(10);
                    make.centerY.equalTo(cell.mas_centerY);
                    make.width.offset(80);
                }];
                label.text = self.titleArr[indexPath.section];
                label.font = [UIFont systemFontOfSize:14.0];
                UILabel *conlabel = [self.view viewWithTag:60 ];
                if (conlabel== nil) {
                    conlabel = [[UILabel alloc]init];
                    conlabel.font = [UIFont systemFontOfSize:12];
                    conlabel.textColor = JHColor(102, 102, 102);
                    conlabel.numberOfLines = 0;
                    conlabel.tag = 60 ;
                    if (self.tag == 101) {
                        conlabel.text = [NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"le_name"]];
                    }else if (self.tag == 102){
                        conlabel.text = [NSString stringWithFormat:@"%@ %@",[UserDefault objectForKey:@"le_name"],[UserDefault objectForKey:@"po_name_0"]];
                    }
                    
                }
                
                [cell.contentView addSubview:conlabel];
                [conlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.offset(0);
                    make.bottom.offset(0);
                    make.left.equalTo(label.mas_right).offset(8);
                    make.right.offset(-30);
                }];
                
                
            }
            [cell.contentView addSubview:rightimage];
            [rightimage mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.offset(-10);
                make.centerY.equalTo(cell.mas_centerY);
                
            }];
            //        self.itembtn = (UIButton *)[self.view viewWithTag:50];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if ( indexPath.section == 1){
            //物业位置cell，点击可push
            static NSString *FourCellIdentifier = @"FourCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FourCellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FourCellIdentifier];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView removeAllSubviews];
            UILabel *label = [[UILabel alloc]init];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                if (indexPath.row ==0 && self.publicRepair) {
                    make.top.offset(0);
                    make.height.offset(30);
                }else{
                    make.centerY.equalTo(cell.mas_centerY);
                }
                
                make.width.offset(80);
            }];
            label.text = self.titleArr[indexPath.section];
            label.font = [UIFont systemFontOfSize:14.0];
            if (indexPath.row == 0) {
                if (self.publicRepair) {
                    if (tfERP == nil) {
                        tfERP = [[UITextView alloc]init];
                        tfERP.backgroundColor = JHColor(245, 245, 245);
                        tfERP.layer.cornerRadius = 5;
                        tfERP.layer.borderColor = [JHColor(225, 225, 225) CGColor];
                        tfERP.layer.borderWidth = 1;
                        tfERP.font = [UIFont systemFontOfSize:14];
                    }
                    
                    [cell.contentView addSubview:tfERP];
                    [tfERP mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.left.offset(10);
                        make.top.equalTo(label.mas_bottom).offset(5);
                        make.bottom.offset(-10);
                        make.right.offset(-10);
                        
                    }];
                    
                    
                    UIButton *saoBtn = [cell viewWithTag:9];
                    if (saoBtn == nil) {
                        saoBtn = [[UIButton alloc]init];
                        saoBtn.tag = 9;
                        [saoBtn setImage:[UIImage imageNamed:@"saoyisaoshebeijiancha"] forState:UIControlStateNormal];
                        [saoBtn addTarget:self action:@selector(saoyisaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                    [cell.contentView addSubview:saoBtn];
                    [saoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.centerY.equalTo(label.mas_centerY);
                        make.right.offset(-10);
                    }];
                    return cell;
                }
                
            }
            UILabel *conlabel = [self.view viewWithTag:61 + indexPath.row];
            if (conlabel== nil) {
                conlabel = [[UILabel alloc]init];
                conlabel.font = [UIFont systemFontOfSize:12];
                conlabel.textColor = JHColor(102, 102, 102);
                conlabel.numberOfLines = 0;
                conlabel.tag = 61 + indexPath.row;
                if (self.tag == 101){
                    if (indexPath.row == 0) {
                        conlabel.text = [NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"po_name_0"]];
                    }
                }
            }
            if (indexPath.row == 0) {
                label.text = self.titleArr[indexPath.section];
            }else{
                if (self.tag == 101){
                    label.text = @"报修分类：";
                    if (self.categoryDt) {
                        conlabel.text = [NSString stringWithFormat:@"%@ %@",self.categoryDt[@"er_ProCategory"],self.categoryDt[@"kiname"]];
                        
                    }
                }
                
            }
            
            [cell.contentView addSubview:conlabel];
            [conlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.bottom.offset(0);
                make.left.equalTo(label.mas_right).offset(8);
                make.right.offset(-10);
            }];
            if (self.tag == 102) {
                if (self.positionbtn == nil) {
                    _positionbtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                    //                [_positionbtn setImage:[UIImage imageNamed:@"qingxuanze"] forState:UIControlStateNormal];
                    //            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    //            [btn setBackgroundImage:[UIImage imageNamed:@"icon_dropdown"] forState:UIControlStateNormal];
                    _positionbtn.tag = 51;
                    _positionbtn.titleLabel.font = [UIFont systemFontOfSize:12];
                    [_positionbtn setTitle:@"请选择" forState:UIControlStateNormal];
                    [_positionbtn addTarget:self action:@selector(positionBtnClick) forControlEvents:UIControlEventTouchUpInside];
                }
                [cell.contentView addSubview:_positionbtn];
                [_positionbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-10);
                    make.centerY.equalTo(cell.mas_centerY);
                    make.width.offset(60);
                }];
                
            }
            [cell.contentView addSubview:rightimage];
            [rightimage mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.offset(-10);
                make.centerY.equalTo(cell.mas_centerY);
                
            }];
            
            return cell;
            
        }else if (indexPath.section == 3){
            //预约时间cell
            
            static NSString *SixCellIdentifier = @"SixCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SixCellIdentifier];
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SixCellIdentifier] ;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 80, 30)];
            label.text = self.titleArr[indexPath.section];
            label.font = [UIFont systemFontOfSize:14.0];
            _btn = [UIButton buttonWithType:UIButtonTypeCustom];
            _btn.frame = CGRectMake(90, 7, SCREEN.size.width-90, 30);
            _btn.tag = indexPath.section;
            _btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_btn setTitle:self.timeStr forState:UIControlStateNormal];
            [_btn addTarget:self action:@selector(timeClick:) forControlEvents:UIControlEventTouchUpInside];
            [_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _btn.titleLabel.font = [UIFont systemFontOfSize:12];
            if (self.tag == 102) {
                
            }else{
                //                NSDateFormatter *format=[[NSDateFormatter alloc] init];
                //                [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                //                NSDate *fromdate=[format dateFromString:self.timeStr ];
                //                long time= (long)[fromdate timeIntervalSince1970];
                //                self.strtime = [NSString stringWithFormat:@"%ld",time];
                [cell.contentView addSubview:_btn];
                [cell.contentView addSubview:label];
            }
            
            
            
            self.timebtn = (UIButton *)[cell viewWithTag:indexPath.section];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.tag == 101) {
                [cell.contentView addSubview:rightimage];
                [rightimage mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.offset(-10);
                    make.centerY.equalTo(cell.mas_centerY);
                    
                }];
            }
            
            return cell;
            
        }else if (indexPath.section == 4) {
            //上传图片cell
            
            static NSString *SevenCellIdentifier = @"imagecell";
            //            ImagePostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SevenCellIdentifier];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SevenCellIdentifier];
            [cell.contentView removeAllSubviews];
            [self createCollectionview];
            if (self.imageArray.count) {
                self.collectionView.frame = CGRectMake(0, 40, SCREEN.size.width, (SCREEN.size.width-60)/4);
            }else{
                self.collectionView.frame = CGRectMake(0, 40, SCREEN.size.width, 0);
                
            }
            [cell.contentView addSubview:self.collectionView];
            //
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 70, 30)];
            titleLabel.text = self.titleArr[indexPath.section];
            titleLabel.font = [UIFont systemFontOfSize:14.0];
            [cell.contentView addSubview:titleLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *pickBtn = [[UIButton alloc]init];
            [pickBtn setImage:[UIImage imageNamed:@"shangchuanzhaopian"] forState:UIControlStateNormal];
            [pickBtn addTarget:self action:@selector(choseImage:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:pickBtn];
            [pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-10);
                make.centerY.equalTo(titleLabel.mas_centerY);
            }];
            return cell;
            
        }else{
            //报修内容cell
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
                self.txtView = [[HPGrowingTextView alloc] initWithFrame:CGRectZero];
                self.txtView.tag = indexPath.section;
                //                self.txtView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                //                self.txtView.layer.borderWidth =1.0;//显示外边框
                //                self.txtView.layer.cornerRadius = 6.0;//textView边角的弧度
                //                self.txtView.layer.masksToBounds = YES;
                self.txtView.delegate = self;
                self.txtView.placeholder = @"请输入内容";
                self.txtView.frame = CGRectMake(90, 0, SCREEN.size.width-100, 60);
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 30)];
                label.text = self.titleArr[indexPath.section];
                label.font = [UIFont systemFontOfSize:14.0];
                [cell.contentView addSubview:label];
                [cell.contentView addSubview:self.txtView];
                
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (self.segment.selectedSegmentIndex == 1){
        
        static NSString *OneCellIdentifier2 = @"OneCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OneCellIdentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OneCellIdentifier2] ;
        }
        [cell.contentView removeAllSubviews];
        self.str = [self comStr:(int)indexPath.section];
        CGSize labesize = [self.str selfadap:14 weith:20 Linespace:10];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN.size.width-20,labesize.height +10)];
        contentLabel.text = self.str;
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = JHdeepColor;
        [cell.contentView addSubview:contentLabel];
        [contentLabel NSParagraphStyleAttributeName:10];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(0);
            make.right.offset(-10);
            make.bottom.offset(0);
        }];
        //        if (self.tag == 101) {
        //            NSDictionary *dt = self.repairRecordArr[indexPath.section];
        //            if ([[NSString stringWithFormat:@"%@",dt[@"or_states"]] isEqualToString:@"6"] && ![[NSString stringWithFormat:@"%@",dt[@"pl_states"]] isEqualToString:@"1"]) {
        //                UIButton *btn = [[UIButton alloc]init];
        //                btn.titleLabel.font = [UIFont systemFontOfSize:15];
        //                [btn setTitle:@"点击评价" forState:UIControlStateNormal];
        //                btn.backgroundColor = JHColor(0, 148, 241);
        //                btn.layer.cornerRadius = 3;
        //                btn.layer.masksToBounds = YES;
        //                [btn addTarget:self action:@selector(EvaluationBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
        //                [cell.contentView addSubview:btn];
        //                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        //                    make.left.offset(20);
        //                    make.right.offset(-20);
        //                    make.height.offset(30);
        //                    make.top.equalTo(contentLabel.mas_bottom).offset(10);
        //                }];
        //            }
        //        }
        
        return cell;
        
    }return nil;
    
    
}
#pragma mark - 扫描二维码
-(void)saoyisaoBtnClick:(UIButton *)btn{
    HCScanQRViewController *scan = [[HCScanQRViewController alloc]init];
    //调用此方法来获取二维码信息
    [scan successfulGetQRCodeInfo:^(NSString *QRCodeInfo) {
        tfERP.text = QRCodeInfo;
        LFLog(@"二维码信息:%@",QRCodeInfo);
    }];
    [self.navigationController pushViewController:scan animated:YES];
    
}
-(void)EvaluationBtnClick:(UIButton *)btn event:(id)event{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    RepairsMaintenanceRepairViewController *main = [[RepairsMaintenanceRepairViewController alloc]init];
    main.gobackBlock = ^(){
        [self recordData:self.tag];
    };
    NSDictionary *dt = self.repairRecordArr[indexPath.section];
    [main.dataArray addObject:dt];
    main.tag = 111;
    main.namearr = @[@"报修人：",@"手机号：",@"位置 :",@"工程进度：",@"报修时间：",@"报修内容：",@"预约时间："];
    main.namekey = @[self.contentArr[0],self.contentArr[1],dt[@"or_location"],dt[@"sStates"],dt[@"or_requestTime"],dt[@"er_desc"],dt[@"or_servertime"]];
    
    [self.navigationController pushViewController:main animated:YES];
    
    
}
- (NSString *)comStr:(int)number
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (self.tag == 102) {
        NSArray *keyArr = [NSArray arrayWithObjects:@"po_name",@"accuse_class",@"complete",@"accuse_kind",@"analysis",@"visit", nil];
        for (int i = 0; i < keyArr.count; i ++) {
            NSString *str1 = [self.repairRecordArr[number] objectForKey:keyArr[i]];
            [arr addObject:str1];
        }
        
        self.str  = [NSString stringWithFormat:@"投诉人：%@\n手机号：%@\n投诉单元：%@\n投诉类型：%@\n处理结果：%@\n投诉级别：%@\n分析预防措施：%@\n回访情况：%@",self.contentArr[0],self.contentArr[1],arr[0],arr[1],arr[2],arr[3],arr[4],arr[5]];
    }else if (self.tag == 101){
        NSArray *keyArr = nil;
        if (self.publicRepair) {
            keyArr = [NSArray arrayWithObjects:@"orid",@"or_linkman",@"or_tel",@"le_name",@"or_location",@"sstates",@"or_requestTime",@"em_type",@"er_desc",nil];
        }else{
            keyArr = [NSArray arrayWithObjects:@"or_location",@"em_type",@"er_desc",@"or_servertime",nil];
        }
        for (int i = 0; i < keyArr.count; i ++) {
            NSString *str1 = [self.repairRecordArr[number] objectForKey:keyArr[i]];
            str1 = str1 ? str1:@"";
            [arr addObject:str1];
        }
        NSString *or_servertime = arr[3];
        if (![or_servertime isKindOfClass:[NSNull class]]) {
            if (or_servertime.length == 0) {
                or_servertime = @"无";
            }else{
                if ([or_servertime rangeOfString:@"1900"].location == NSNotFound && [or_servertime rangeOfString:@"1970"].location == NSNotFound ) {
                } else {
                    or_servertime = @"无";
                }
            }
        }else{
            or_servertime = @"无";
        }
        if (self.publicRepair) {
            self.str  = [NSString stringWithFormat:@"报修单号：%@\n报修人：%@\n手机号：%@\n物业项目：%@\n报修位置：%@\n工单进度：%@\n报修时间：%@\n报修分类：%@\n描述：%@",arr[0],arr[1],arr[2],arr[3],arr[4],arr[5],arr[6],arr[7],arr[8]];
        }else{
            self.str  = [NSString stringWithFormat:@"报修位置：%@\n报修分类：%@\n报修内容：%@\n预约日期：%@",arr[0],arr[1],arr[2],or_servertime ];
        }
        
    }else if (self.tag == 104){
        NSArray *keyArr = [NSArray arrayWithObjects:@"ki_name",@"kiname",@"sys_date",@"require",@"cu_state",nil];
        for (int i = 0; i < keyArr.count; i ++) {
            NSString *str1 = [self.repairRecordArr[number] objectForKey:keyArr[i]];
            [arr addObject:str1];
        }
        self.str  = [NSString stringWithFormat:@"申请人：%@\n手机号：%@\n服务总类：%@\n服务类型：%@\n申请时间：%@\n描述：%@\n状态：%@",self.contentArr[0],self.contentArr[1],arr[0],arr[1],arr[2],arr[3],arr[4]];
    }
    
    return _str;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"cell:::::%ld",(long)indexPath.row);
    if (self.segment.selectedSegmentIndex == 0) {
        if (indexPath.section == 0) {
            [self itemClick];
        }else if (indexPath.section == 1){
            if (indexPath.row == 0 && self.publicRepair) {
                return;
            }
            if (indexPath.row == 1 ) {
                if (!self.categoryArray.count) {
                    [self presentLoadingTips];
                    [self UploadDataCategory:YES];
                    return;
                }
            }
            [self positionClick:indexPath.row];
        }
    }else{
        if (self.tag == 101 && !self.publicRepair) {
            RepairsOrderDetailsViewController * detail = [[RepairsOrderDetailsViewController alloc]init];
            detail.orid = self.repairRecordArr[indexPath.section][@"orid"];
            [self.navigationController pushViewController:detail animated:YES];
            return;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    
    if (self.segment.selectedSegmentIndex == 1) {
        IndexBtn *header = [[IndexBtn alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 40)];
        header.backgroundColor = [UIColor whiteColor];
        header.index = section;
        if (self.tag == 101 && !self.publicRepair) {
            //cell上左侧的
            IndexBtn *btn1= [IndexBtn buttonWithType:UIButtonTypeCustom];
            btn1.index = section;
            btn1.frame = CGRectMake(10, 0, SCREEN.size.width-110, 39);
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:12];
            btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn1.userInteractionEnabled = NO;
            [btn1 setBackgroundColor:[UIColor whiteColor]];
            [header addSubview:btn1];
            //cell上右侧的
            IndexBtn *btn2= [IndexBtn buttonWithType:UIButtonTypeCustom];
            btn2.frame = CGRectMake(SCREEN.size.width-120, 0, 90, 39);
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn2.titleLabel.font = [UIFont systemFontOfSize:12];
            btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            btn2.userInteractionEnabled = NO;
            [btn2 setBackgroundColor:[UIColor whiteColor]];
            [header addSubview:btn2];
            btn2.titleLabel.font = [UIFont systemFontOfSize:14];
            btn2.titleLabel.textAlignment = NSTextAlignmentRight;
            btn1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
            [btn1 setTitleColor:JHMaincolor forState:UIControlStateNormal];
            [btn2 setTitleColor:JHsimpleColor forState:UIControlStateNormal];
            [btn2 setImage:[UIImage imageNamed:@"gerenzhongxinjiantou"] forState:UIControlStateNormal];
            int lastInter = 0;
            for (int i = 0 ; i < self.keyArr.count; i ++) {
                if (self.repairRecordArr[section] [self.keyArr[i]] && [self.repairRecordArr[section] [self.keyArr[i]] length]) {
                    lastInter = i;
                }
            }
            NSString *sstates = self.nameArr[lastInter];
            NSString *or_requestTime = [self.repairRecordArr[section] objectForKey:@"or_requestTime"];
            or_requestTime = or_requestTime ? or_requestTime:@"";
            [btn1 setTitle:sstates forState:UIControlStateNormal];
            [btn2 setTitle:[NSString stringWithFormat:@"%@",or_requestTime] forState:UIControlStateNormal];
            CGSize btn1size = [sstates selfadapUifont:[UIFont fontWithName:@"Helvetica-Bold" size:15] weith:20];
            //            CGSize btn2size = [or_requestTime selfadapUifont:[UIFont systemFontOfSize:14] weith:20];
            btn1.width = btn1size.width + 10;
            if (lastInter == 3) {
                btn1.userInteractionEnabled = YES;
                [btn1 setImage:[UIImage imageNamed:@"qupingjia_qd"] forState:UIControlStateNormal];
                btn1.width += btn1.imageView.image.size.width;
                [btn1 addTarget:self action:@selector(evaluateClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn1.imageView.image.size.width, 0, btn1.imageView.image.size.width )];
                [btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, btn1.titleLabel.bounds.size.width + 10, 0, -btn1.titleLabel.bounds.size.width-10)];
            }
            
            btn2.frame = CGRectMake(btn1.width + 10, 0, SCREEN.size.width - btn1.width - 25, 39);
            [btn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn2.imageView.image.size.width-10, 0, btn2.imageView.image.size.width + 10)];
            [btn2 setImageEdgeInsets:UIEdgeInsetsMake(0, btn2.titleLabel.bounds.size.width, 0, -btn2.titleLabel.bounds.size.width)];
        }else{
            IndexBtn *backBtn = [[IndexBtn alloc]init];
            backBtn.userInteractionEnabled = NO;
            header.backgroundColor = [UIColor whiteColor];
            BOOL ret = [self.boolArray[section] boolValue];
            if (ret) {
                [backBtn setBackgroundImage:[UIImage imageNamed:@"xiajiantoukuang"] forState:UIControlStateNormal];
            }else{
                [backBtn setBackgroundImage:[UIImage imageNamed:@"shangjiantoukuang"] forState:UIControlStateNormal];
            }
            [header addSubview:backBtn];
            [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.right.offset(-10);
                make.top.offset(10);
                make.bottom.offset(-10);
            }];
            NSArray *keyArr = nil;
            if (self.tag == 101) {
                keyArr = @[@"le_name",@"or_linkman",@"or_requestTime",@"sstates"];
            }else{
                keyArr = @[@"po_name",@"",@"pubdate",@"complete"];
            }
            CGFloat xx = 10;
            CGFloat ww = 0;
            CGFloat sww = (SCREEN.size.width - 20)*131/140.0;
            for (int i = 0; i < 4; i ++) {
                UILabel *lb = [[UILabel alloc]init];
                lb.textColor = JHdeepColor;
                NSString *text = self.repairRecordArr[section][keyArr[i]];
                if (i == 1) {
                    if (self.tag == 101) {
                        text = [NSString stringWithFormat:@"报修人：%@",text];
                    }else{
                        text = [NSString stringWithFormat:@"报修人：%@",[UserDefault objectForKey:@"name"]];
                    }
                    
                }
                lb.text = text;
                if (i < 2) {
                    lb.font = [UIFont systemFontOfSize:15];
                }else{
                    lb.font = [UIFont systemFontOfSize:13];
                }
                if (i%2 == 0) {
                    xx = 10;
                    
                    if (i == 0) {
                        NSString *next = nil;
                        if (self.tag == 101) {
                            next = [NSString stringWithFormat:@"报修人：%@",self.repairRecordArr[section][keyArr[i]]];
                        }else{
                            next = [NSString stringWithFormat:@"报修人：%@",[UserDefault objectForKey:@"name"]];
                        }
                        ww = sww- [next selfadapUifont:lb.font weith:20].width - 30;
                    }else{
                        ww = [text selfadapUifont:lb.font weith:20].width + 10;
                    }
                }else{
                    lb.textAlignment = NSTextAlignmentRight;
                    xx = ww + 10;
                    ww = sww - ww-20;
                }
                lb.frame = CGRectMake(xx, i < 2 ? 0: 30, ww, 30);
                [backBtn addSubview:lb];
            }
        }
        
        //#pragma 区头
        //        if (self.tag == 102){
        //            [btn1 setTitle:[self.repairRecordArr[section] objectForKey:@"pubdate"] forState:UIControlStateNormal];
        //            [btn2 setTitle:[self.repairRecordArr[section] objectForKey:@"complete"] forState:UIControlStateNormal];
        //        }else if (self.tag == 101) {
        //
        //
        //
        //            if (self.publicRepair) {
        //                btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        //                [btn1 setTitleColor:JHmiddleColor forState:UIControlStateNormal];
        //                [btn2 setTitleColor:JHmiddleColor forState:UIControlStateNormal];
        //                NSString *str1 = [self.repairRecordArr[section] objectForKey:@"or_linkman"];
        //                NSString *str2 = [self.repairRecordArr[section] objectForKey:@"or_requestTime"];
        //                NSString *str = [NSString stringWithFormat:@"%@  %@",str1,str2];
        //                [btn1 setTitle:str forState:UIControlStateNormal];
        //                [btn2 setTitle:[self.repairRecordArr[section] objectForKey:@"sstates"] forState:UIControlStateNormal];
        //                CGSize btn2Size = [btn2.titleLabel.text selfadap:14 weith:20];
        //                btn2.frame = CGRectMake(SCREEN.size.width-btn2Size.width - 20, 0, btn2Size.width+ 10, 39);
        //                btn1.frame = CGRectMake(10, 0, SCREEN.size.width-btn2Size.width - 30, 39);
        //            }else{
        //
        //            }
        //
        //            //            NSString *sstates = [self.repairRecordArr[section] objectForKey:@"sstates"] ;
        //            //            sstates = sstates ? sstates:@"";
        //
        //
        //        }else if (self.tag == 104) {
        //            NSString *str1 = [self.repairRecordArr[section] objectForKey:@"ki_name"];
        //            NSString *str2 = [self.repairRecordArr[section] objectForKey:@"sys_date"];
        //            NSString *str = [NSString stringWithFormat:@"%@%@",str1,str2];
        //            [btn1 setTitle:str forState:UIControlStateNormal];
        //            [btn2 setTitle:@"详细" forState:UIControlStateNormal];
        //        }
        [header addTarget:self action:@selector(sectionOpenAndCloseClick:) forControlEvents:UIControlEventTouchUpInside];
        return header;
    }
    return nil;
    
}
-(void)evaluateClick:(IndexBtn *)sender{
    CommentSubmitViewController *main = [[CommentSubmitViewController alloc]init];
    main.isPerpher = NO;
    main.orid = self.repairRecordArr[sender.index][@"orid"];
    [self.navigationController pushViewController:main animated:YES];
}

- (void)sectionOpenAndCloseClick:(IndexBtn *)sender
{
    if (self.tag == 101 && !self.publicRepair) {
        RepairsOrderDetailsViewController * detail = [[RepairsOrderDetailsViewController alloc]init];
        detail.orid = self.repairRecordArr[sender.index][@"orid"];
        [self.navigationController pushViewController:detail animated:YES];
        return;
    }
    BOOL ret = [self.boolArray[sender.index ] boolValue];
    if (ret) {
        [self.boolArray replaceObjectAtIndex:sender.index withObject:@NO];
    }else{
        [self.boolArray replaceObjectAtIndex:sender.index withObject:@YES];
        
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sender.index];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.segment.selectedSegmentIndex == 0) {
        return 0.000001;
    }
    if (self.tag == 101 && !self.publicRepair) {
        return 40;
    }else{
        return 80;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex == 0) {
        if (indexPath.section == 3 ){
            if (self.tag == 102) {
                return 0;
            }else{
                
                return 50;
            }
            
        }else if(indexPath.section == 0 ){
            return _cell0;
        }else if(indexPath.section == 1){
            if (indexPath.row == 0) {
                if (self.publicRepair) {
                    return 100;
                }
                return _cell1;
            }else{
                return 50;
            }
            
        }else if(indexPath.section == 2){
            return 60;
        }else if(indexPath.section == 4){
            if (self.imageArray.count) {
                return (SCREEN.size.width-60)/4 + 50;
            }else{
                return 40;
                
            }
        }else{
            
            return 100;
            
        }
        
    }
    self.str = [self comStr:(int)indexPath.section];
    CGSize labesize = [self.str selfadap:14 weith:20 Linespace:10];
    CGFloat HH = (labesize.height+20 <44) ? 44 :labesize.height+20 ;
    //    if (self.tag == 101) {
    //        NSDictionary *dt = self.repairRecordArr[indexPath.section];
    //        if ([[NSString stringWithFormat:@"%@",dt[@"or_states"]] isEqualToString:@"6"] && ![[NSString stringWithFormat:@"%@",dt[@"pl_states"]] isEqualToString:@"1"]) {
    //            HH += 50;
    //        }
    //    }
    return HH;
    
}


//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.imageArray.count;
}
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//
//    if (self.imageArray.count <= 3) {
//        return 1;
//    }else{
//    return 2;
//
//    }
//
//}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.userInteractionEnabled = YES;
    imageview.contentMode = UIViewContentModeScaleToFill;
    imageview.image = self.imageArray[indexPath.row];
    UIButton *btn = [[UIButton alloc]init];
    //btn.backgroundColor = [UIColor blueColor];
    [btn setImage:[UIImage imageNamed:@"shanchu_baoxiutupian"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageclick:)];
    //    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    //    tap.cancelsTouchesInView = NO;
    //    tap.delegate = self;
    //    imageview.tag = indexPath.row + 55;
    [cell.contentView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.left.offset(5);
        make.right.offset(5);
        make.bottom.offset(5);
    }];
    
    //    if (!(indexPath.row == self.imageArray.count - 1)) {
    [cell.contentView addSubview:btn];
    //        [imageview addGestureRecognizer:tap];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.width.offset(25);
        make.height.offset(25);
    }];
    //    }
    
    
    
    
    btn.tag = indexPath.row + 22;
    
    
    return cell;
}
-(void)imageclick:(UITapGestureRecognizer *)tap{
    
    NSMutableArray * muarr = self.imageArray;
    [muarr removeLastObject];
    STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:muarr currentIndex:tap.view.tag - 55];
    [broser show];
    
    
    //    if (self.lookImagesView.isHidden)
    //    {
    //        [self.lookImagesView sShow:tap.view.tag - 55];
    //    }
    //    else
    //    {
    //        [self.lookImagesView sHiden];
    //    }
    
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return YES;
    
}


-(void)buttonclick:(UIButton *)button{
    [self.imageArray removeObjectAtIndex:button.tag - 22];
    //    [self.imagedata removeObjectAtIndex:button.tag - 22];
    [self.tableView reloadData];
    [self.collectionView reloadData];
    
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"collectioncell:");
    STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:self.imageArray currentIndex: indexPath.row];
    [broser show];
    //    UIImage *image = self.imageArray[indexPath.row];
    //    if ([image isEqual:self.picture]) {
    //
    //
    //
    //
    //    }
    
    
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

//警告框
-(void)createAlertion:(NSString *)str1 str:(NSString *)str2{
    
    UIAlertController *alertcontro = [UIAlertController alertControllerWithTitle:str1 message:str2 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alertcontro addAction:okAction];
    
    [self presentViewController:alertcontro animated:YES completion:nil];
    
    
}

//选择tu
-(void)choseImage:(UIButton *)btn{
    if (self.imageArray.count <= 5) {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"图库", nil];
        [sheet showInView:self.view];
    }else{
        [self createAlertion:@"提示" str:@"最多上传五张图片"];
        
    }
    
    
    
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 2)return;
    
    UIImagePickerController *pic = [[UIImagePickerController alloc]init];
    pic.delegate = self;
    
    //允许编辑图片
    pic.allowsEditing = NO;
    
    
    if (buttonIndex == 0) {
        
        pic.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else{
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        imagePickerVc.maxImagesCount = 5 - self.imageArray.count;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        return;
    }
    
    //显示控制器
    [self presentViewController:pic animated:YES completion:nil];
}
#pragma mark  图片选择成功的方法
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    for (UIImage *im in photos) {
        [self.imageArray addObject:im];
    }
    [self.lookImagesView sImageArray:self.imageArray];
    //    [self.imageArray addObject:self.picture];
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //    LFLog(@"info%@",info);
    
    UIImage *editimage = info[UIImagePickerControllerOriginalImage];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    //    if ([mediaType isEqualToString:@"public.image"]) {  //判断是否为图片
    //        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
    //            UIImageWriteToSavedPhotosAlbum(editimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //        }
    //    }
    editimage = [editimage fixOrientation];
    ALAssetsLibrary* alLibrary = [[ALAssetsLibrary alloc] init];
    __block float fileMB  = 0.0;
    
    [alLibrary assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset)
     {
         ALAssetRepresentation *representation = [asset defaultRepresentation];
         fileMB = (float)([representation size]/(1024 * 1024));
         [self.imagedata addObject:[NSNumber numberWithFloat:fileMB]];
         
         
     }
              failureBlock:^(NSError *error)
     {
         
     }];
    
    [self.imageArray addObject:editimage];
    [self.lookImagesView sImageArray:self.imageArray];
    //    [self.imageArray addObject:self.picture];
    [self.tableView reloadData];
    [self.collectionView reloadData];
    //移除图片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

//此方法就在UIImageWriteToSavedPhotosAlbum的上方
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"已保存");
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    UIView *view = textView.superview;
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = [view superview];
    }
    
    UITableViewCell *cell = (UITableViewCell*)view;
    CGRect rect = [cell convertRect:cell.frame toView:self.view];
    if (rect.origin.y / 2 + rect.size.height>=SCREEN.size.height-216) {
        //        self.tableveiw.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    return YES;
}
- (void)creatSubmitView
{
    self.submitView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN.size.height-50, SCREEN.size.width, 50)];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitBtn.frame = CGRectMake(10, 0, SCREEN.size.width-20, 40);
    [submitBtn.layer setMasksToBounds:YES];
    [submitBtn.layer setCornerRadius:5.0];
    [submitBtn setBackgroundColor:JHMaincolor];
    [submitBtn setTitle:@"提  交" forState:UIControlStateNormal];
    [submitBtn setTintColor:[UIColor whiteColor]];
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.submitView addSubview:submitBtn];
    [self.view addSubview:self.submitView];
    if (self.selectIndex == 1) {
        self.submitView.y = SCREEN.size.height+204;
    }
    
}



#pragma mark - 物业项目点击选择
- (void)itemClick
{
    ItemViewController *itemVC = [[ItemViewController alloc]init];
    itemVC.delegate = self;
    NSUserDefaults *defuat = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:@"%@",[defuat objectForKey:@"le_name"]];
    NSLog(@"3232:%@",str);
    if ([str isEqualToString: @"(null)"]) {
        [self createAlertion:@"提示" str:@"请先进行业主认证"];
        
    }else{
        if (self.tag == 101) {
            [itemVC.itemArr addObject:str];
            
            [self.navigationController pushViewController:itemVC animated:YES];
        }else if (self.tag == 102){
            companyTableViewController *company = [[companyTableViewController alloc]init];
            company.tag = 102;
            [company.companyArray addObject:[defuat objectForKey:@"le_name"]];
            NSLog(@"comm:%@",company.companyArray);
            [self.navigationController pushViewController:company animated:YES];
            
        }else{
            
            
            companyTableViewController *company = [[companyTableViewController alloc]init];
            company.tag = 102;
            [company.companyArray addObject:[defuat objectForKey:@"le_name"]];
            NSLog(@"comm:%@",company.companyArray);
            [self.navigationController pushViewController:company animated:YES];
            
            
        }
        
        
    }
    
}
#pragma mark - 物业位置点击选择
-(void)positionBtnClick{
    [self positionClick:0];
}
- (void)positionClick:(NSInteger )index
{
    if ([self.itembtn.titleLabel.text isEqualToString:@"请选择"]) {
        [self presentLoadingTips:@"请先选择项目"];
        return;
    }
    PositionViewController *positionVC = [[PositionViewController alloc]init];
    positionVC.delegate = self;
    NSUserDefaults *defuat = [NSUserDefaults standardUserDefaults];
    NSString *str = [defuat objectForKey:@"po_name"];
    NSLog(@"3232:%@",str);
    if (!str) {
        [self createAlertion:@"提示" str:@"请先进行业主认证"];
    }else{
        
        if (self.tag == 101) {
            if (index == 0) {//报修位置
                NSInteger count = [[UserDefault objectForKey:@"PropertyCount"] integerValue];
                for (int i = 0; i < count; i ++) {
                    [positionVC.itemArr addObject:[UserDefault objectForKey:[NSString stringWithFormat:@"po_name_%d",i]]];
                }
            }else if (index ==1){//报修分类
                for (int i = 0; i < self.categoryArray.count; i ++) {
                    [positionVC.itemArr addObject:self.categoryArray[i]];
                }
            }
            
            
            [self.navigationController pushViewController:positionVC animated:YES];
        }else if (self.tag == 102){
            if (self.complainArray.count == 0) {
                [self presentLoadingTips:@"获取信息失败"];
                
            }else{
                
                companyTableViewController *company = [[companyTableViewController alloc]init];
                company.tag = 1021;
                for (NSArray *arr in self.complainArray) {
                    [company.companyArray addObject:arr];
                }
                company.companyArray = [NSMutableArray arrayWithArray:self.complainArray];
                [self.navigationController pushViewController:company animated:YES];
                
                
            }
            
            
        }else if(self.tag == 104){
            if (self.complainArray.count == 0) {
                [self presentLoadingTips:@"获取信息失败"];
            }else{
                
                companyTableViewController *company = [[companyTableViewController alloc]init];
                company.tag = 1041;
                NSLog(@"@%@",self.complainArray );
                for (NSDictionary *arr in self.complainArray) {
                    [company.companyArray addObject:arr];
                }
                
                [self.navigationController pushViewController:company animated:YES];
                //
                
            }
            
            
        }else{
            
            
            
        }
        
    }
    
    
}

#pragma mark - 物业项目回传值
- (void)itemString:(NSString *)string
{
    [self.itembtn setTitle:string forState:UIControlStateNormal];
    self.itembtn.hidden = YES;
    UILabel *lb = [self.view viewWithTag:60];
    lb.text = string;
    CGSize labesize = [string boundingRectWithSize:CGSizeMake(SCREEN.size.width- 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    if (labesize.height >44) {
        _cell0 = labesize.height;
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
    }
    if (self.tag == 102) {
        
    }
    NSLog(@"%@",string);
}

#pragma mark - 物业位置回传值 代理
- (void)positionString:(id)string index:(NSInteger )index
{
    
    if ([string isKindOfClass:[NSString class]]) {
        [self.positionbtn setTitle:string forState:UIControlStateNormal];
        self.positionbtn.hidden = YES;
        UILabel *lb = [self.view viewWithTag:61];
        lb.text = string;
        if (self.tag == 101) {
            self.poid = [UserDefault objectForKey:[NSString stringWithFormat:@"poid_%ld",(long)index]];
        }
        CGSize labesize = [string boundingRectWithSize:CGSizeMake(SCREEN.size.width- 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        if (labesize.height >44) {
            _cell1 = labesize.height;
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:NO];
        }
    }else if ([string isKindOfClass:[NSDictionary class]]){
        NSDictionary *temDt = (NSDictionary *)string;
        if ([temDt[@"note"] count] > index) {
            NSMutableDictionary *cDt = [NSMutableDictionary dictionaryWithDictionary:temDt[@"note"][index]];
            [cDt setObject:temDt[@"er_ProCategory"] forKey:@"er_ProCategory"];
            self.categoryDt = cDt;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    
    NSLog(@"%@",string);
}

#pragma mark - 选择时间点击事件
- (void)timeClick:(UIButton *)sender
{
    
    _selectTimePicker = [[MHDatePicker alloc] init];
    _selectTimePicker.Displaystr = @"yyyy-MM-dd HH:mm";
    _selectTimePicker.delegate = self;
}

#pragma mark - 时间回传值
- (void)timeString:(NSString *)timeString
{
    [self.timebtn setTitle:timeString forState:UIControlStateNormal];
    self.timeStr = timeString;
    [self.timebtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *fromdate=[format dateFromString:timeString];
    time= (long)[fromdate timeIntervalSince1970];
    NSNumber *longNumber = [NSNumber numberWithLong:time];
    self.strtime = [longNumber stringValue];
    NSLog(@"strtime:%@",self.strtime);
}



#pragma mark - 提交按钮点击
- (void)submitClick
{
    
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    
    if ([self.itembtn.titleLabel.text isEqualToString:@"请选择"]) {
        if (self.tag == 101) {
            [self presentLoadingTips:@"请选择项目"];
            
        }else if (self.tag == 102){
            [self presentLoadingTips:@"请选择投诉位置"];
        }else{
            [self presentLoadingTips:@"请选择服务位置"];
        }
        
    }else{
        if (self.tag == 101 && self.publicRepair && !tfERP.text.length) {
            [self presentLoadingTips:@"请填写报修位置"];
            return;
        }
        if ([self.positionbtn.titleLabel.text isEqualToString:@"请选择"]) {
            if (self.tag == 101) {
                
                [self presentLoadingTips:@"请选择报修位置"];
                
            }else if (self.tag == 102){
                [self presentLoadingTips:@"请选择投诉类型"];
            }else{
                [self presentLoadingTips:@"请选择服务类型"];
            }
        }else{
            if (self.tag == 101) {
                if (!self.categoryDt) {
                    [self presentLoadingTips:@"请选择报修分类"];
                    return;
                }
            }
            if (self.txtView.text.length == 0) {
                if (self.tag == 101) {
                    [self presentLoadingTips:@"请选择报修内容"];
                }else if (self.tag == 102){
                    [self presentLoadingTips:@"请选择投诉内容"];
                }else{
                    [self presentLoadingTips:@"请选择服务内容"];
                }
            }else{
                
                [self presentLoadingTips];
                //                [self uploadPicture];
                if (self.tag == 101) {
                    [self UploadDatarepair];
                }else if (self.tag == 102){
                    
                    [self UploadDatacomplain];
                    
                }else if (self.tag == 104){
                    
                    [self UploadDatasevire];
                    
                }else{
                    
                    
                }
                
                
            }
            
            
            
        }
    }
    
    NSLog(@"物业项目---%@",self.itembtn.titleLabel.text);
    NSLog(@"物业位置---%@",self.positionbtn.titleLabel.text);
    NSLog(@"报修内容---%@",self.txtView.text);
    
}



#pragma mark 页面将要显示
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    
    
    //    if ( NO == [UserModel online] )
    //    {
    //      bee.ui.appBoard.rep = self;
    //    [bee.ui.appBoard showLogin];
    //        return;
    //    }
    
    [self willappear];
    
}

-(void)willappear{
    
    NSUserDefaults *defuat = [NSUserDefaults standardUserDefaults];
    
    if ([self.isPop isEqualToString:@"pop"]) {
        NSString *str = [NSString stringWithFormat:@"%@",[defuat objectForKey:@"name"]];
        NSLog(@"6554:%@",str);
        if ([str isEqualToString: @"(null)"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            
            [self userInfo];
            [self.tableView reloadData];
            
        }
    }else if([self.isPop isEqualToString:@"project"]){
        
        
        
        
    }else {
        
        
        NSString *str = [NSString stringWithFormat:@"%@",[defuat objectForKey:@"name"]];
        NSLog(@"6554:%@",str);
        if ([str isEqualToString: @"(null)"]) {
            //            AttestViewController *att = [[AttestViewController alloc]init];
            //
            //            [self.navigationController pushViewController:att animated:YES];
        }else{
            if (self.tag == 101) {
                [self userInfo];
                [self recordData:self.tag];
                [self.tableView reloadData];
            }else if (self.tag == 102){
                [self recordData:self.tag];
                [self complainUploaddata];
            }else if (self.tag == 104){
                [self recordData:self.tag];
                [self sevireUploaddata];
                
            }
            
            
            
            
        }
        
    }
    
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.isPop = nil;
    
}

#pragma mark - 记录查询
- (void)recordData:(NSInteger)tagnumber{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSMutableDictionary *dt = [NSMutableDictionary dictionaryWithObjectsAndKeys:uid,@"userid", nil];
    NSString *urlstr = [NSString string];
    if (tagnumber == 101) {
        
        NSString *coid = [UserDefault objectForKey:@"coid"];
        if (coid == nil) {
            coid = @"";
        }
        NSString *mobile = [UserDefault objectForKey:@"mobile"];
        if (mobile == nil) {
            mobile = @"";
        }
        [dt setObject:coid forKey:@"coid"];
        [dt setObject:mobile forKey:@"mobile"];
        if (self.publicRepair) {//公区报修
            [dt removeObjectForKey:@"userid"];
            urlstr = NSStringWithFormat(ZJERPIDBaseUrl,@"106");
        }else{
            urlstr = NSStringWithFormat(ZJERPIDBaseUrl,@"132");
        }
    }else if (tagnumber == 102) {
        urlstr = NSStringWithFormat(ZJguokaihangBaseUrl,@"16");
    }else if (tagnumber == 104) {
        urlstr = NSStringWithFormat(ZJguokaihangBaseUrl,@"17");
    }
    [LFLHttpTool get:urlstr params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        LFLog(@"记录：%@",response);
        NSString *str = @"";
        if (self.tag == 101) {
            str = [NSString stringWithFormat:@"%@",response[@"error"]];
        }else{
            str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        }
        if ([str isEqualToString:@"0"]) {
            
            if ([[response objectForKey:@"note"] isKindOfClass:[NSArray class]]) {
                NSArray *reArr = [response objectForKey:@"note"];
                [self.repairRecordArr removeAllObjects];
                [self.boolArray removeAllObjects];
                for (NSDictionary *dic in reArr) {
                    [self.repairRecordArr addObject:dic];
                    if (self.tag == 101 && !self.publicRepair) {
                        [self.boolArray addObject:@YES];
                    }else{
                        [self.boolArray addObject:@NO];
                    }
                    
                }
            }
            
        }else{
            if (self.segment.selectedSegmentIndex == 1) {
                [self presentLoadingTips:response[@"date"]];
            }
            
        }
        [self.tableView reloadData];
        [self.tableView reloadEmptyDataSet];
    } failure:^(NSError *error) {
        if (self.segment.selectedSegmentIndex == 1) {
            [self presentLoadingTips:@"服务器繁忙！"];
        }
        [_tableView.mj_header endRefreshing];
    }];
    
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.repairRecordArr.count) {
        return nil;
    }else{
        return [UIImage imageNamed:@"wuneirong"];
    }
}


#pragma mark - 在线报修分类
-(void)UploadDataCategory:(BOOL)isPush{
    
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) {
        coid = @"";
    }
    //    coid =@"48";
    [dt setObject:coid forKey:@"coid"];
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"139") params:dt success:^(id response) {
        LFLog(@"在线报修分类:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        if ([str isEqualToString:@"0"]) {
            if ([response[@"arr"] isKindOfClass:[NSArray class]] && [response[@"arr"] count]) {
                [self.categoryArray removeAllObjects];
                for (NSDictionary *temDt in response[@"arr"]) {
                    [self.categoryArray addObject:temDt];
                }
                if (!isPush && self.categoryArray.count) {
                    //                    if ([self.categoryArray[0][@"note"] count]) {
                    //                        NSMutableDictionary *cDt = [NSMutableDictionary dictionaryWithDictionary:self.categoryArray[0][@"note"][0]];
                    //                        [cDt setObject:self.categoryArray[0][@"er_ProCategory"] forKey:@"er_ProCategory"];
                    //                        self.categoryDt = cDt;
                    //                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    //                    }
                    
                }else{
                    [self dismissTips];
                    PositionViewController *positionVC = [[PositionViewController alloc]init];
                    positionVC.delegate = self;
                    for (int i = 0; i < self.categoryArray.count; i ++) {
                        [positionVC.itemArr addObject:self.categoryArray[i]];
                    }
                    [self.navigationController pushViewController:positionVC animated:YES];
                }
            }else{
                if (isPush) {
                    if (response[@"date"]) {
                        [self presentLoadingTips:response[@"date"]];
                    }else{
                        [self presentLoadingTips:@"没有数据！"];
                    }
                    [self dismissTips];
                }
            }
        }else{
            if (isPush) {
                [self dismissTips];
                if (response[@"date"]) {
                    [self presentLoadingTips:response[@"date"]];
                }else{
                    [self presentLoadingTips:@"没有数据！"];
                }
                
            }
            
        }
    } failure:^(NSError *error) {
        if (isPush) {
            [self dismissTips];
            [self presentLoadingTips:@"请求失败！"];
        }
    }];
    
}
#pragma mark - 在线报修数据上传
-(void)UploadDatarepair{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    
    NSString *leid = [NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"leid"]];
    //    NSString *location = [NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"poid"]];
    NSString *mobile = [NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"mobile"]];
    NSMutableDictionary *dt = [NSMutableDictionary dictionaryWithObjectsAndKeys:uid,@"userid",leid,@"leid",mobile,@"mobile", nil];
    if (self.txtView.text.length) {
        [dt setObject:self.txtView.text forKey:@"desc"];
    }
    if (![self.timeStr isEqualToString:@"请选择"]) {
        [dt setObject:self.strtime forKey:@"servertime"];
    }
    if (self.categoryDt) {
        if ([self.categoryDt[@"emid"] isKindOfClass:[NSString class]]) {
            [dt setObject:self.categoryDt[@"emid"] forKey:@"emid"];
        }
        if ([self.categoryDt[@"er_ProCategory"] isKindOfClass:[NSString class]]) {
            [dt setObject:self.categoryDt[@"er_ProCategory"] forKey:@"er_ProCategory"];
        }
    }
    if (self.publicRepair) {//公区报修
        [dt setObject:tfERP.text forKey:@"location"];
        [dt setObject:@"2" forKey:@"sub_type"];
    }else{
        [dt setObject:self.poid forKey:@"location"];
    }
    NSLog(@"在线报修dt:%@",dt);
    [self.imageArray removeObject:self.picture];
    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"8") params:dt body:self.imageArray success:^(id response) {
        //    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"8") params:dt success:^(id response) {
        [self dismissTips];
        NSLog(@"在线报修:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            [self recordData:self.tag];
            self.segment.selectedSegmentIndex = 1;
            [self segmentclick:self.segment];
            [self presentLoadingTips:@"提交成功"];
        }else {
            NSLog(@"报修失败");
            [self presentLoadingTips:response[@"err_msg"]];
            
        }
    } failure:^(NSError *error) {
        [self dismissTips];
    }];
    
}


#pragma mark 在线投诉数据请求

-(void)complainUploaddata{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid};
    
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"14") params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            if ([response[@"note"] isKindOfClass:[NSString class]] ||[response[@"note"] isKindOfClass:[NSNull class]] || response[@"note"] == nil) {
                
                
            }else{
                [self.complainArray removeAllObjects];
                for (NSArray *arr in response[@"note"]) {
                    [self.complainArray addObject:arr];
                }
            }
            
        }else {
            NSLog(@"投诉失败");
            
            [self presentLoadingTips:response[@"err_msg"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)UploadDatacomplain{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    
    NSString *str2 = [NSString stringWithFormat:@"%@",self.positionbtn.titleLabel.text];
    NSArray * array2 = [str2 componentsSeparatedByString:@" "];
    NSString *leid = [NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"leid"]];
    //  NSString *cardid = [NSString stringWithFormat:@"%@",[defuat objectForKey:@"cardId"]];
    //    NSString *poid = [NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"poid"]];
    NSString *mobile = [NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"mobile"]];
    
    NSDictionary *dt = @{@"userid":uid,@"leid":leid,@"poid":self.poid,@"types":array2[0],@"class":array2[1],@"content":self.txtView.text,@"mobile":mobile};
    LFLog(@"在线投诉dt:%@",dt);
    [self.imageArray removeObject:self.picture];
    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"15") params:dt body:self.imageArray success:^(id response) {
        //    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"15") params:dt success:^(id response) {
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        NSLog(@"在线投诉数据提交:%@",response);
        if ([str isEqualToString:@"0"]) {
            
            [self recordData:self.tag];
            self.segment.selectedSegmentIndex = 1;
            [self segmentclick:self.segment];
            //            [self.tableView reloadData];
            [self presentLoadingTips:@"提交成功"];
            
        }else {
            NSLog(@"投诉失败");
            
            [self presentLoadingTips:response[@"err_msg"]];
            
        }
    } failure:^(NSError *error) {
        [self dismissTips];
    }];
    
}

#pragma mark 特约服务数据请求

-(void)sevireUploaddata{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid};
    
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"12") params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            
            if ([response[@"note"] isKindOfClass:[NSString class]] ||[response[@"note"] isKindOfClass:[NSNull class]] || response[@"note"] == nil) {
                
                
            }else{
                [self.complainArray removeAllObjects];
                for (NSDictionary *arr in response[@"note"]) {
                    [self.complainArray addObject:response[@"note"][arr]];
                }
            }
            
            
            
            
        }else {
            NSLog(@"预约服务失败");
            
            [self presentLoadingTips:response[@"err_msg"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)UploadDatasevire{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSString *str2 = [NSString stringWithFormat:@"%@",self.positionbtn.titleLabel.text];
    NSArray * array2 = [str2 componentsSeparatedByString:@" "];
    NSString *leid = [NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"leid"]];
    //    NSString *poid = [NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"poid"]];
    NSString *mobile = [NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"mobile"]];
    
    
    NSDictionary *dt = @{@"userid":uid,@"leid":leid,@"poid":self.poid,@"kiid":array2[0],@"seid":array2[1],@"content":self.txtView.text,@"mobile":mobile};
    [self.imageArray removeObject:self.picture];
    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"13") params:dt body:self.imageArray success:^(id response) {
        //    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"13") params:dt success:^(id response) {
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        NSLog(@"在线投诉数据提交:%@",response);
        if ([str isEqualToString:@"0"]) {
            [self recordData:self.tag];
            self.segment.selectedSegmentIndex = 1;
            
            [self presentLoadingTips:@"提交成功"];
        }else {
            NSLog(@"特约服务失败");
            
            [self presentLoadingTips:response[@"err_msg"]];
            
        }
    } failure:^(NSError *error) {
        [self dismissTips];
    }];
    
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self recordData:self.tag];
    }];
    
    
}




@end

