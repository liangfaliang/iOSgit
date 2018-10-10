
//
//  VolunteerActivityDetailViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/6.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "VolunteerActivityDetailViewController.h"
#import "STPhotoBroswer.h"
#import "NSString+selfSize.h"
#import "UIImage+GIF.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "NSString+YTString.h"
@interface VolunteerActivityDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UITableView *applytableview;
@property(nonatomic,strong)NSArray *imagearr;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong) STPhotoBroswer * brose;

@property(nonatomic,strong)UIView *applyView;//活动报名

@property(nonatomic,strong)UIView *applylist;//报名列表

@property(nonatomic,strong)UILabel * contentLabel;

@property(nonatomic,strong)NSMutableArray *applyArray;

//是否可以报名
@property(nonatomic,assign)BOOL isApply;

//活动是否结束
@property(nonatomic,assign)BOOL isend;


//数据请求对象
@property(nonatomic,strong)NSMutableArray *requestArr;

//底视图的高度
@property(nonatomic,assign) CGFloat h;


@end

@implementation VolunteerActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarTitle = @"活动详情";
    self.isApply = YES;
    self.isend = NO;
    [self createTableview];
    [self requestdetail];
//    [self performSelector:@selector(requestuserList) withObject:nil afterDelay:1.0];//防止两个tableview刷新失败
    [self setupRefresh];
    //添加键盘通知
    [Notification addObserver:self selector:@selector(activikbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [Notification addObserver:self selector:@selector(activikbWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 键盘将显示
-(void)activikbWillShow:(NSNotification *)noti{
    
    LFLog(@"contentSize:%f",self.tableview.contentSize.height);
    LFLog(@"scrollRectToVisible:%f",_h);
    [self.tableview scrollRectToVisible:CGRectMake(0, _h + 180, 1,1) animated:NO];
}

-(void)activikbWillHide:(NSNotification *)noti
{
    
    //    [self.tableview scrollRectToVisible:CGRectMake(0, 0, 1,1) animated:NO];
}
- (NSMutableArray *)requestArr
{
    if (_requestArr == nil) {
        _requestArr = [[NSMutableArray alloc]init];
    }
    return _requestArr;
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}

-(NSMutableArray *)applyArray{
    
    if (_applyArray == nil) {
        _applyArray = [[NSMutableArray alloc]init];
    }
    
    return _applyArray;
    
}

-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    
    self.tableview.delegate = self;
    self.tableview.dataSource =self;
    [self.view addSubview:self.tableview];
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"detailcell"];
    
    self.imagearr = [NSArray arrayWithObjects:@"shijian",@"didian",@"renyuan", nil];
    
    self.applytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width-20, 220) style:UITableViewStylePlain];
    
    self.applytableview.delegate = self;
    self.applytableview.dataSource =self;
    
    //    [self.applytableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"applycell"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableview) {
        return 3;
    }else{
        
        
        return self.applyArray.count;
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableview) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailcell"];
        cell.imageView.image = [UIImage imageNamed:self.imagearr[indexPath.row]];

        if (self.dataArray.count > 0) {
            NSDictionary *dt = self.dataArray[0];
            
            
            cell.textLabel.font =[UIFont systemFontOfSize:14];
            cell.textLabel.textColor = JHColor(102, 102, 102);
            if (indexPath.row  == 0) {
                cell.textLabel.text = dt[@"ac_time"];
            }else if (indexPath.row == 1){
                
                cell.textLabel.text = dt[@"ac_address"];
                
            }else if (indexPath.row == 2){
                
                cell.textLabel.text = [NSString stringWithFormat:@"已有%@参加 限%@人",dt[@"count"],dt[@"ac_number"]];
                
            }
        }
        
        return cell;
        
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"applycell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"applycell"];
        }
        
        
        if (indexPath.row %2 == 0) {
            cell.backgroundImage = [UIImage imageNamed:@"yibaoming1"];
        }else{
            cell.backgroundImage = [UIImage imageNamed:@"yibaoming2"];
            
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = JHColor(51, 51, 51);
        cell.textLabel.text = self.applyArray[indexPath.row][@"user_name"];
        cell.detailTextLabel.text = self.applyArray[indexPath.row][@"add_time"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        LFLog(@"%@",self.applyArray[indexPath.row][@"add_time"]);
        return cell;
        
        
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *headerview = [[UIView alloc]init];
    if (tableView == self.tableview) {
        UILabel *warnlabel = [self.view viewWithTag:20];
        if (_isend) {
            
            if (warnlabel == nil) {
                warnlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 30)];
                warnlabel.tag = 20;
                [headerview addSubview:warnlabel];
            }
            warnlabel.font = [UIFont systemFontOfSize:14];
            
            warnlabel.textColor = [UIColor whiteColor];
            warnlabel.textAlignment = NSTextAlignmentCenter;
            warnlabel.backgroundColor = JHAssistColor;
            
        }
        UILabel *titlelabel = [self.view viewWithTag:21];
        titlelabel.tag = 21;
        if (titlelabel  == nil) {
            titlelabel = [[UILabel alloc]init];
            [headerview addSubview:titlelabel];
            titlelabel.numberOfLines = 0;
        }
        

        
        titlelabel.textColor = JHColor(51, 51, 51);
        titlelabel.font = [UIFont systemFontOfSize:15];
        UILabel *tlabel = [self.view viewWithTag:77];
        if (tlabel == nil) {
            tlabel = [[UILabel alloc]init];
            tlabel.textColor = JHColor(153, 153, 153);
            tlabel.font = [UIFont systemFontOfSize:12];
            
        }
        UILabel *redlabel = [self.view viewWithTag:78];
        if (redlabel == nil) {
            redlabel = [[UILabel alloc]init];
            redlabel.textColor = JHColor(153, 153, 153);
            redlabel.font = [UIFont systemFontOfSize:12];
            
        }
        if (self.dataArray.count > 0) {
            redlabel.text = [NSString stringWithFormat:@"阅读 %@",self.dataArray[0][@"ac_read_number"]];
            tlabel.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"add_time"]];
            titlelabel.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"ac_name"]];
            NSInteger begiantime = [self.dataArray[0][@"ac_enroll_start"] integerValue];
            NSInteger endtime = [self.dataArray[0][@"ac_enroll_end"] integerValue];
            NSInteger interval = [[NSDate date] timeIntervalSince1970];
            if (interval < begiantime) {
                warnlabel.text = @"温馨提示：此活动未到报名时间";
            }else if (interval > endtime){
            
            warnlabel.text = @"温馨提示：此活动已停止报名";
            }
        }
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (warnlabel == nil) {
                make.top.offset(5);
            }else{
                make.top.equalTo(warnlabel.mas_bottom).offset(5);
                
            }
            make.right.offset(-10);
            make.left.offset(10);
            make.height.offset([titlelabel.text selfadap:17 weith:20].height );
            
        }];
        [headerview addSubview:tlabel];
        [tlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.offset(-10);
            make.top.equalTo(titlelabel.mas_bottom).offset(3);
        }];
        [headerview addSubview:redlabel];
        [redlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(10);
            make.top.equalTo(titlelabel.mas_bottom).offset(3);
        }];
        headerview.backgroundColor = [UIColor whiteColor];
        
    }else{
        
        
        UILabel *countlabel = [self.view viewWithTag:80];
        if (countlabel == nil) {
            countlabel = [[UILabel alloc]init];;
            countlabel.tag = 80;
            countlabel.textColor = [UIColor whiteColor];
            countlabel.font = [UIFont systemFontOfSize:14];
        }
        headerview.backgroundColor = JHMaincolor;
        [headerview addSubview:countlabel];
        [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.bottom.offset(0);
            make.left.offset(10);
        }];
        //
        if (self.dataArray.count > 0) {
            countlabel.text =[NSString stringWithFormat:@"%@人已报名成功",self.dataArray[0][@"count"]];
            
        }else{
            countlabel.text = @"报名成功人数";
            
        }
        
        
        
    }
    
    
    return headerview;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (tableView == self.tableview) {
        
        UIView *footview = [self.view viewWithTag:100];
        if (footview == nil) {
            footview = [[UIView alloc]init];
            footview.tag = 100;
        }
        LFLog(@"self.dataArray:%@",self.dataArray);
        
        if (self.dataArray.count > 0) {
            UIImageView *picture = [self.view viewWithTag:30];
            NSArray *arr = self.dataArray[0][@"images"];
            if (arr.count > 0) {
                
                
                if (picture == nil) {
                    picture = [[UIImageView alloc]init];
                    picture.tag = 30;
                    [footview addSubview:picture];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagetap:)];
                    [picture addGestureRecognizer:tap];
                    picture.userInteractionEnabled = YES;
                    [picture setContentScaleFactor:[[UIScreen mainScreen] scale]];
                    picture.contentMode =  UIViewContentModeScaleAspectFill;
                    picture.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                    picture.clipsToBounds  = YES;
                }
                
                [picture sd_setImageWithURL:[NSURL URLWithString:self.dataArray[0][@"images"][0]] placeholderImage:[UIImage imageNamed:@""]];
                self.brose = [[STPhotoBroswer alloc]initWithImageArray:self.dataArray[0][@"images"] currentIndex:0];
                [picture mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.offset(15);
                    make.left.offset(10);
                    make.right.offset(-10);
                    make.height.mas_equalTo(picture.mas_width).multipliedBy(0.5);
                    
                }];
                NSArray *count = self.dataArray[0][@"images"];
                UILabel *countlabel = [[UILabel alloc]init];
                countlabel.font = [UIFont systemFontOfSize:12];
                countlabel.text = [NSString stringWithFormat:@"共%d张",(int)count.count];
                [footview addSubview:countlabel];
                [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-15);
                    make.top.equalTo(picture.mas_bottom).offset(5);
                    make.height.offset(14);
                }];
                
                UILabel *clicklabel = [[UILabel alloc]init];
                clicklabel.font = [UIFont systemFontOfSize:12];
                clicklabel.text = [NSString stringWithFormat:@"点击查看更多"];
                [footview addSubview:clicklabel];
                [clicklabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(15);
                    make.top.equalTo(picture.mas_bottom).offset(-15);
                    make.height.offset(14);
                }];
                
            }
            if (self.contentLabel == nil) {
                _contentLabel = [[UILabel alloc]init];
                _contentLabel.numberOfLines = 0;
                
                _contentLabel.font = [UIFont systemFontOfSize:14];
                _contentLabel.textColor = JHColor(51, 51, 51);
                
            }
            
            _contentLabel.text = self.dataArray[0][@"ac_content"];
            
            CGSize contentsize = [_contentLabel.text selfadaption:15];
            [footview addSubview:_contentLabel];
            
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (picture) {
                    make.top.equalTo(picture.mas_bottom).offset(20);
                }else{
                    make.top.offset(20);
                    
                }
                make.left.offset(15);
                make.right.offset(-15 );
                
                make.height.offset(contentsize.height);
                
            }];
            
            if (_isApply) {
                
                if (self.applyView == nil) {
                    self.applyView = [[UIView alloc]init];
                    
                    _applyView.layer.cornerRadius = 5;
                    _applyView.layer.masksToBounds = YES;
                    _applyView.layer.borderWidth = 1;
                    _applyView.layer.borderColor = [JHColor(229, 229, 229)CGColor];
                }
                [footview addSubview:self.applyView];
                _applyView.backgroundImage = [UIImage imageNamed:@"huodongbaoming"];
                [_applyView mas_makeConstraints:^(MASConstraintMaker *make){
                    
                    make.top.equalTo(_contentLabel.mas_bottom).offset(20);
                    make.left.offset(10);
                    make.right.offset(-10);
                    make.height.offset(225);
                    
                }];
                [self.applyView removeAllSubviews];
                UILabel *applylabel = [self.view viewWithTag:40];
                if (applylabel == nil) {
                    applylabel = [[UILabel alloc]init];
                    applylabel.tag = 40;
                    applylabel.text = @"活动报名";
                    applylabel.textColor = JHMaincolor;
                    applylabel.textAlignment = NSTextAlignmentCenter;
                    applylabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
                    
                }
                [_applyView addSubview:applylabel];
                [applylabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(0);
                    make.right.offset(0);
                    make.top.offset(0);
                    make.height.offset(45);
                    
                }];
                
                
                UIView *blueview = [[UIView alloc]init];
                
                [_applyView addSubview:blueview];
                blueview.backgroundColor = JHMaincolor;
                [blueview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(10);
                    make.right.offset(-10);
                    make.height.offset(1);
                    make.top.equalTo(applylabel.mas_bottom).offset(5);
                }];
                
                NSArray *namearr = [NSArray arrayWithObjects:@"联系人：",@"联系电话：",@"参加人数：", nil];
                for (int i = 0; i < 2; i ++) {
                    UIView *tfview = [self.view viewWithTag:50 + i];
                    if (tfview == nil) {
                        tfview = [[UIView alloc]initWithFrame:CGRectMake(10, 60 + i *55, SCREEN.size.width - 40, 40)];
                        [_applyView addSubview:tfview];
                        tfview.tag = 50 + i;
                        
                        tfview.backgroundColor = [UIColor whiteColor];
                        tfview.layer.borderWidth = 1;
                        tfview.layer.borderColor = [JHColor(229,229, 229)CGColor];
                    }
                    
                    UILabel *tlabel = [self.view viewWithTag:70 + i];
                    
                    if (tlabel == nil) {
                        tlabel = [[UILabel alloc]init];
                        [tfview addSubview:tlabel];
                        tlabel.tag = 70 + i;
                    }
                    tlabel.text = namearr[i];
                    tlabel.textColor = JHColor(51, 51, 51);
                    tlabel.font = [UIFont systemFontOfSize:13];
                    [tlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.left.offset(3);
                        make.top.offset(0);
                        make.bottom.offset(0);
                        make.width.offset(70);
                    }];
                    
                    UITextField *tf = [self.view viewWithTag:60 + i];
                    
                    if (tf == nil) {
                        
                        tf = [[UITextField alloc]init];
                        tf.font = [UIFont systemFontOfSize:13];
                        tf.textColor = JHColor(102, 102, 102);
                        tf.tag = 60+ i;
                        [tfview addSubview:tf];
                        if (i > 0) {
                            tf.keyboardType = UIKeyboardTypeNumberPad;
                        }
                    }
                    
                    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.left.equalTo(tlabel.mas_right).offset(3);
                        make.top.offset(0);
                        make.bottom.offset(0);
                        make.right.offset(0);
                    }];
                    
                    
                    
                }
                
                UIButton *applybutton = [self.view viewWithTag:86];
                if (applybutton == nil) {
                    applybutton = [[UIButton alloc]init];
                    applybutton.tag = 86;
                    [_applyView addSubview:applybutton];
                    [applybutton setImage:[UIImage imageNamed:@"tijiao"] forState:UIControlStateNormal];
                    [applybutton addTarget:self action:@selector(applybuttonclick:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                [applybutton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(_applyView.mas_bottom).offset(-10);
                    make.centerX.equalTo(_applyView.mas_centerX);
                    
                }];
                
            }
            CGFloat h = self.applyArray.count *44 + 44;
            if (h > 220) {
                h = 220;
            }
            if (self.applylist == nil) {
                self.applylist = [[UIView alloc]init];
                
                _applylist.layer.cornerRadius = 5;
                _applylist.layer.masksToBounds = YES;
                _applylist.layer.borderWidth = 1;
                _applylist.layer.borderColor = [JHMaincolor CGColor];
                
            }
            [footview addSubview:self.applylist];
            [_applylist mas_makeConstraints:^(MASConstraintMaker *make){
                
                make.left.offset(10);
                make.right.offset(-10);
                make.height.offset(h);
                
            }];
            if (_isApply) {
                
                [_applylist mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(_applyView.mas_bottom).offset(30);
                    
                    make.left.offset(10);
                    make.right.offset(-10);
                    make.height.offset(h);
                }];
            }else{
                
                [_applylist mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    
                    make.top.equalTo(_contentLabel.mas_bottom).offset(30);
                    
                    make.left.offset(10);
                    make.right.offset(-10);
                    make.height.offset(h);
                }];
            }
            
            
            
            [_applylist addSubview:self.applytableview];
            
        }
        
        
        
        return footview;
        
    }else{
        return nil;
    }
    
}
//图片点击
-(void)imagetap:(UITapGestureRecognizer *)tap{
    
    [_brose show];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.tableview) {
        if (self.dataArray.count) {
            CGSize size = [self.dataArray[0][@"ac_name"] selfadap:17 weith:20];
            if (_isend) {
                return size.height + 60;
            }else{
                
                return size.height + 30;
            }
        }
        return 0.001;
        
    }else{
        
        return 44;
        
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView == self.tableview) {
        NSString *str = [NSString string];
        if (self.dataArray.count > 0) {
            str = self.dataArray[0][@"content"];
        }
        CGSize size = [str selfadaption:15];
        CGFloat cell = self.applyArray.count *44 ;
        if (cell > 220) {
            cell = 220;
        }
        _h = size.height + 225 + 44  + 150;
        if (self.dataArray.count) {
            NSArray *arr = self.dataArray[0][@"images"];
            if (arr.count > 0) {
                _h += SCREEN.size.width/2;
        }
     }
        if (_isApply) {
            _h += 200;
        }
        LFLog(@"%f",_h);
        return _h;
    }else{
        
        return 0.01;
        
    }
}


#pragma mark - *************提交按钮*************
-(void)applybuttonclick:(UIButton *)btn{
    
    
    [self.view endEditing:YES];
    UITextField *tf1 = [self.view viewWithTag:60];
    UITextField *tf2 = [self.view viewWithTag:61];
    UITextField *tf3 = [self.view viewWithTag:62];
    LFLog(@"%@==%@===%@",tf1.text,tf2.text,tf3.text);
    if (tf1.text.length  == 0) {
        [self presentLoadingTips:@"请您输入联系人姓名~~"];
    }else if (tf2.text.length == 0){
        
        [self presentLoadingTips:@"请您输入联系人电话~~"];
        
    }else if (![tf2.text isValidateMobile]){
        [self presentLoadingTips:@"请您输入正确的联系人电话~~"];
        
    }else{
        [self requestapplyUp:tf1.text mobile:tf2.text number:tf3.text];
    }
    
    
}


//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    for (int i = 0; i < 3; i ++) {
        UITextField *tf = [self.view viewWithTag:60 + i];
        if ([tf isFirstResponder]) {
            [self.view endEditing:YES];
        }
    }
    
}

#pragma mark - *************详情请求*************
-(void)requestdetail{
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.detailid,@"id", nil];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }else{
        [self showLogin:^(id response) {
        }];
    }

    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,volunteersActivityDatilUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        LFLog(@"------%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObject:response[@"data"]];
            

//            LFLog(@"%ld %ld",(long)interval,(long)endtime);
            if ([response[@"data"][@"is_join"] isEqualToString:@"0"]) {
                self.isApply = YES;
            }else{
            self.isApply = NO;
            }
            NSInteger begiantime = [response[@"data"][@"ac_enroll_start"] integerValue];
            NSInteger endtime = [response[@"data"][@"ac_enroll_end"] integerValue];
            NSInteger interval = [[NSDate date] timeIntervalSince1970];
            if (interval < endtime && interval >begiantime) {
//                [self requestchickApply];
                self.isend = NO;
                
            }else{
                
                self.isend = YES;
                
                [_applyView removeFromSuperview];
                _applyView = nil;
                
                [self delayMethod];
                
            }
            [self.tableview reloadData];
            [self.applyArray removeAllObjects];
            NSArray *arr = response[@"data"][@"join_list"] ;
            for (NSDictionary *dt in arr) {
                [self.applyArray addObject:dt];
            }
//            for (int i = 0; i < arr.count; i ++) {
//                [self.applyArray addObject:arr[i]];
//            }
//            
            [self.applytableview reloadData];
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self requestdetail];
                    }
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
            
            
        }
        
    } failure:^(NSError *error) {
        [_tableview.mj_header endRefreshing];
    }];
    
}

#pragma mark - *************报名提交*************
- (void)requestapplyUp:(NSString *)name mobile:(NSString *)mobile number:(NSString *)number{
    
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.detailid,@"id",name,@"user_name",mobile,@"user_mobile", nil];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }else{
        [self showLogin:^(id response) {
        }];
    }
    LFLog(@"活动报名dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,volunteersActivityJionUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        LFLog(@"活动报名：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"您已报名成功"];
            
            [self requestdetail];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        LFLog(@"活动报名error：%@",error);
        [_tableview.mj_header endRefreshing];
    }];
    
}

#pragma mark - *************用户列表*************
//- (void)requestuserList{
//    
//    NSString *uid = [UserDefault objectForKey:@"useruid"];
//    if (uid == nil) {
//        uid = @"";
//    }
//    NSDictionary *dt = @{@"id":self.detailid};
//    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"27") params:dt success:^(id response) {
//        [_tableview.mj_header endRefreshing];
//        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
//        if ([str isEqualToString:@"0"]) {
//            
//            [self.applyArray removeAllObjects];
//            NSArray *arr = response[@"note"];
//            for (int i = 0; i < arr.count; i ++) {
//                [self.applyArray addObject:arr[i]];
//            }
//            
//            [self.applytableview reloadData];
//            [self delayMethod];
//        }else{
//            
//            [self presentLoadingTips:response[@"err_msg"]];
//            
//            
//            
//        }
//        
//    } failure:^(NSError *error) {
//        [_tableview.mj_header endRefreshing];
//    }];
//    
//}


#pragma mark - *************检测用户是否可以报名*************
//- (void)requestchickApply{
//    
//    NSString *uid = [UserDefault objectForKey:@"useruid"];
//    if (uid == nil) {
//        uid = @"";
//    }
//    NSDictionary *dt = @{@"id":self.detailid,@"userid":uid};
//    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"25") params:dt success:^(id response) {
//        [_tableview.mj_header endRefreshing];
//        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
//        if ([str isEqualToString:@"0"]) {
//            
//            self.isApply = YES;
//            
//            
//        }else{
//            
//            self.isApply = NO;
//            
//        }
//        
//        [self delayMethod];
//        
//    } failure:^(NSError *error) {
//        [_tableview.mj_header endRefreshing];
//    }];
//    
//}

-(void)delayMethod{
    
    self.contentLabel = nil;
    [self.contentLabel removeFromSuperview];
    [_applyView removeFromSuperview];
    _applyView = nil;
    [_applylist removeFromSuperview];
    _applylist = nil;
    [_tableview.mj_header endRefreshing];
    [self.tableview reloadData];
    
}


#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestdetail];
//        [self requestuserList];
    }];
    
}




@end
