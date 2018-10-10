//
//  CastVoteViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/17.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CastVoteViewDetailController.h"
#import "STPhotoBroswer.h"
#import "NSString+selfSize.h"
#import "UIImage+GIF.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "CastVoteCollectionViewCell.h"
#import "CastVoteResutTableViewCell.h"
@interface CastVoteViewDetailController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UITableView *resultTab;
@property (nonatomic,strong)UICollectionView * collectionview;
@property(nonatomic,strong)NSArray *imagearr;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *option;
@property(nonatomic,strong) STPhotoBroswer * brose;

@property(nonatomic,strong)UIView *tabFootView;

@property(nonatomic,strong)UIView *applylist;

//@property(nonatomic,strong)UILabel * contentLabel;

@property(nonatomic,strong)NSMutableArray *applyArray;
//是否可以报名
@property(nonatomic,assign)BOOL isApply;

//活动是否结束
@property(nonatomic,assign)BOOL isend;
//投票是否有图片
@property(nonatomic,strong)NSString * is_img;

//数据请求对象
@property(nonatomic,strong)NSMutableArray *requestArr;

//底视图的高度
@property(nonatomic,assign) CGFloat h;
@end

@implementation CastVoteViewDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarTitle = @"投票表决";
    self.is_img = @"0";
    self.isApply = YES;
    self.isend = NO;
    [self createTableview];
    [self requestdetail];
//    [self performSelector:@selector(requestuserList) withObject:nil afterDelay:1.0];//防止两个tableview刷新失败
//    [self setupRefresh];
    //添加键盘通知
//    [Notification addObserver:self selector:@selector(activikbWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [Notification addObserver:self selector:@selector(activikbWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    self.navigationBarRightItem = [UIImage imageNamed:@"buttun_fenxiang"];
//    
//    __weak __typeof(&*self)weakSelf =self;
//    [self setRightBarBlock:^(UIBarButtonItem *sender) {
//        LFLog(@"分享");
//        if (weakSelf.dataArray.count) {
//            
//            [[ShareSingledelegate sharedShareSingledelegate] ShareContent:weakSelf.view content:weakSelf.dataArray[0][@"share"][@"title"] title:weakSelf.dataArray[0][@"share"][@"title"] url:weakSelf.dataArray[0][@"share"][@"url"] image:weakSelf.dataArray[0][@"share"][@"imgurl"]];
//        }
//        
//    }];

    
}
#pragma mark 键盘将显示
-(void)activikbWillShow:(NSNotification *)noti{
    
    
    [self.tableview scrollRectToVisible:CGRectMake(0, _h + 180, 1,1) animated:NO];
}

-(void)activikbWillHide:(NSNotification *)noti
{
    
    //    [self.tableview scrollRectToVisible:CGRectMake(0, 0, 1,1) animated:NO];
}
- (NSMutableArray *)option
{
    if (_option == nil) {
        _option = [[NSMutableArray alloc]init];
    }
    return _option;
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
    self.imagearr = [NSArray arrayWithObjects:@"shijian_huodong",@"didian",@"renyuan", nil];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    
    self.tableview.delegate = self;
    self.tableview.dataSource =self;
    [self.view addSubview:self.tableview];
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"detailcell"];
    
    
    
    //    [self.applytableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"applycell"];
    
}
-(void)createTableFootview{
    if (self.tabFootView == nil) {
        self.tabFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 150)];
        self.tabFootView.backgroundColor = [UIColor whiteColor];
        UIButton *suBmit = [[UIButton alloc]init];
        suBmit.tag = 5;
        [suBmit setImage:[UIImage imageNamed:@"woyaotoupiao"]forState:UIControlStateNormal];
        [suBmit addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabFootView addSubview:suBmit];
        [suBmit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(50);
            make.centerX.equalTo(self.tabFootView.mas_centerX);
        }];
        self.tableview.tableFooterView = self.tabFootView;
    }
    if (self.resultTab == nil) {
        self.resultTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, SCREEN.size.width, self.applyArray.count * 60) style:UITableViewStylePlain];
        
        self.resultTab.delegate = self;
        self.resultTab.dataSource =self;
        [self.resultTab registerNib:[UINib nibWithNibName:@"CastVoteResutTableViewCell" bundle:nil] forCellReuseIdentifier:@"CastVoteResutTableViewCell"];
//        CastVoteResutTableViewCell
        [self.tabFootView addSubview:self.resultTab];
    }else{
        [self.resultTab reloadData];
    }
     UIButton *suBmit = [self.tabFootView viewWithTag:5];
    if (self.isApply) {
        suBmit.hidden = NO;
        self.resultTab.frame = CGRectMake(0, 150, SCREEN.size.width, self.applyArray.count * 60);
        self.tabFootView.frame = CGRectMake(0, 0, SCREEN.size.width, self.resultTab.height + 200);
    }else{
       
        suBmit.hidden = YES;
        self.resultTab.frame = CGRectMake(0, 50, SCREEN.size.width, self.applyArray.count * 60);
        self.tabFootView.frame = CGRectMake(0, 0, SCREEN.size.width, self.resultTab.height + 50);
    }
    
    self.tableview.tableFooterView = self.tabFootView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableview) {
        return 4;
    }else{
        
        
        return self.applyArray.count;
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableview) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailcell"];
        if (self.dataArray.count > 0) {
         NSDictionary *dt = self.dataArray[0];
          if (indexPath.row == 2){
              NSString *CellIdentifier3 = @"threecell";
              UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
              if (cell == nil) {
                  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
              }
              cell.textLabel.numberOfLines = 0;
              cell.textLabel.font =[UIFont systemFontOfSize:14];
              cell.textLabel.textColor = JHmiddleColor;
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
              cell.textLabel.text = [NSString stringWithFormat:@"%@",dt[@"detail"]];
              [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.left.offset(10);
                  make.right.offset(-10);
                  make.top.offset(0);
                  make.bottom.offset(0);
              }];
              [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
              [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
            return cell;
              
          }else if (indexPath.row ==3){
              NSString *CellIdentifier = @"onecell";
              UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
              if (cell == nil) {
                  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
              }
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
              CGFloat num = 4;
//              if (self.menuArr.count > 0) {
//                  num = self.menuArr.count;
//                  LFLog(@"num:%f",num);
//              }
              
              
              
              if (self.collectionview == nil) {
                  UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
                  
                  flowLayout.itemSize = CGSizeMake((SCREEN.size.width-5)/num, 90);
                  flowLayout.minimumInteritemSpacing = 10;
                  flowLayout.minimumLineSpacing = 1;
                  flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
                  flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
                  self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, SCREEN.size.width,90) collectionViewLayout:flowLayout];
                  self.collectionview.dataSource=self;
                  self.collectionview.delegate=self;
                  [self.collectionview setBackgroundColor:[UIColor clearColor]];
                  [cell.contentView addSubview:_collectionview];
                  [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
                      make.top.offset(0);
                      make.left.offset(10);
                      make.bottom.offset(0);
                      make.right.offset(-10);
                  }];
                  self.collectionview.scrollEnabled = NO;
                  //注册Cell，必须要有
                  [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"VoteHeaderReuse"];//头视图
                  [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"VoteFootReuse"];//底视图
                  [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"VoteUICollectionViewCell"];
                  [self.collectionview registerNib:[UINib nibWithNibName:@"CastVoteCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CastVoteCollectionViewCell"];
                  
              }
              if ([self.is_img isEqualToString:@"0"]) {
                  self.collectionview.layer.borderColor = [JHAssistColor CGColor];
                  self.collectionview.layer.borderWidth = 1;
                  self.collectionview.backgroundColor  = JHBorderColor;
              }
              
              return cell;

          }else{
              
              cell.imageView.image = [UIImage imageNamed:self.imagearr[indexPath.row]];
              cell.textLabel.font =[UIFont systemFontOfSize:14];
              cell.textLabel.textColor = JHdeepColor;
              if (indexPath.row  == 0) {
                  cell.textLabel.text = [NSString stringWithFormat:@"投票时间：%@-%@",dt[@"start_time"],dt[@"end_time"]];
              }else if (indexPath.row == 1){
                  cell.textLabel.text = nil;
//                  cell.textLabel.text = [NSString stringWithFormat:@"投票人数：%@",dt[@"end_time"]];
                  
              }
              
        }
      }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        return cell;
        
    }else{
        
        CastVoteResutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CastVoteResutTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArray.count) {
            NSDictionary *resutDt = self.applyArray[indexPath.row];
            float com_count = [[NSString stringWithFormat:@"%@",self.dataArray[0][@"com_count"]] floatValue];
            float count = [[NSString stringWithFormat:@"%@",resutDt[@"count"]] floatValue];
            if (com_count <= 0) {
                com_count = 1;
                count = 1;
            }
            cell.selectviewWidth.constant = (SCREEN.size.width - 40) * (float)(count/com_count);
            cell.nameLb.text = resutDt[@"name"];
            cell.countLb.text = [NSString stringWithFormat:@"%@",resutDt[@"count"]];
            if (indexPath.row%3 == 0) {
                cell.selectView.backgroundColor = JHColor(168, 195, 236);
            }else if (indexPath.row%3 == 1){
                cell.selectView.backgroundColor = JHColor(254, 212, 135);
            }else if (indexPath.row%3 == 2){
                cell.selectView.backgroundColor = JHColor(193, 229, 233);
            }
        }
        

        return cell;
        
        
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *headerview = [[UIView alloc]init];
    if (tableView == self.tableview) {
        if (self.dataArray.count) {
            NSString *status = [NSString stringWithFormat:@"%@",self.dataArray[0][@"status"]];
            UILabel *warnlabel = [self.view viewWithTag:20];
            if ( ![status isEqualToString:@"1"]) {
                
                if (warnlabel == nil) {
                    warnlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 30)];
                    warnlabel.tag = 20;
                    [headerview addSubview:warnlabel];
                }
                warnlabel.font = [UIFont systemFontOfSize:14];
                if ( [status isEqualToString:@"2"]) {
                    warnlabel.text = @"温馨提示：此活动已结束";
                }else if ([status isEqualToString:@"0"]){
                    warnlabel.text = @"温馨提示：此活动尚未开始";
                }
                
                warnlabel.textColor = [UIColor whiteColor];
                warnlabel.textAlignment = NSTextAlignmentCenter;
                warnlabel.backgroundColor = JHAssistColor;
                
            }
            UILabel *titlelabel = [self.view viewWithTag:21];
            
            if (titlelabel  == nil) {
                titlelabel = [[UILabel alloc]init];
                titlelabel.tag = 21;
                [headerview addSubview:titlelabel];
                
            }
            

            
            titlelabel.textColor = JHColor(51, 51, 51);
            titlelabel.font = [UIFont systemFontOfSize:15];
            UILabel *tlabel = [self.view viewWithTag:77];
            if (tlabel == nil) {
                tlabel = [[UILabel alloc]init];
                tlabel.tag = 78;
                tlabel.textColor = JHColor(153, 153, 153);
                tlabel.font = [UIFont systemFontOfSize:12];
                
            }
            UILabel *timeLb = [self.view viewWithTag:78];
            if (timeLb == nil) {
                timeLb = [[UILabel alloc]init];
                timeLb.tag = 78;
                timeLb.textColor = JHColor(153, 153, 153);
                timeLb.font = [UIFont systemFontOfSize:12];
                timeLb.textAlignment= NSTextAlignmentRight;
            }
            if (self.dataArray.count > 0) {
                timeLb.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"add_time"]];
//                tlabel.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"add_time"]];
                titlelabel.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"title"]];
            }
            [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                if (warnlabel == nil) {
                    make.top.offset(5);
                }else{
                    make.top.equalTo(warnlabel.mas_bottom).offset(5);
                }
                make.right.offset(-10);
                make.left.offset(10);
                make.height.offset([titlelabel.text selfadap:15 weith:20].height + 5);
                
            }];
            [headerview addSubview:tlabel];
            [tlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.offset(10);
                make.top.equalTo(titlelabel.mas_bottom).offset(0);
                make.height.offset(25);
                make.width.offset([tlabel.text selfadap:12 weith:20].width + 10);
            }];
            [headerview addSubview:timeLb];
            [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(tlabel.mas_right).offset(0);
                make.top.equalTo(titlelabel.mas_bottom).offset(0);
                make.height.offset(25);
                make.right.offset(-10);
            }];
            headerview.backgroundColor = [UIColor whiteColor];
        }
        
        
    }else{
        
        
        return nil;
    }
    
    
    return headerview;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableview) {
        if (self.dataArray.count) {
            if (indexPath.row == 2) {
                NSString * textLabel = [NSString stringWithFormat:@"%@",self.dataArray[0][@"detail"]];
                return [textLabel selfadap:14 weith:20].height + 30;
                
                return 0.001;
            }else if (indexPath.row == 3){
                if (self.option.count) {
                    CGFloat HH = 44;
                    if ([self.is_img isEqualToString:@"1"]) {
                        HH += (self.option.count/2 + self.option.count%2) *250;
                    }else{
                        HH += self.option.count *50;
                    }
                    return HH;
                }
                
                
            }
        }
        if (indexPath.row == 1) {
            return 0.001;
        }
        return 50;
    }
    return 60;
}

////图片点击
//-(void)imagetap:(UITapGestureRecognizer *)tap{
//    
//    [_brose show];
//}
//
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.tableview) {
        if (self.dataArray.count) {
            NSString *status = [NSString stringWithFormat:@"%@",self.dataArray[0][@"status"]];
            NSString *titlelabel = [NSString stringWithFormat:@"%@",self.dataArray[0][@"title"]];
            if ( ![status isEqualToString:@"1"]) {
                return [titlelabel selfadap:15 weith:20].height + 30 +30;
            }else{
                return [titlelabel selfadap:15 weith:20].height + 30;
            }
        }
        return 0.0001;
    }else{
        
        return 0.001;
        
    }
    
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//    if (tableView == self.tableview) {
//        NSString *str = [NSString string];
//        //        if (self.dataArray.count > 0) {
//        //            str = self.dataArray[0][@"content"];
//        //        }
//        //        CGSize size = [str selfadaption:15];
//        CGFloat cell = self.applyArray.count *44 ;
//        if (cell > 220) {
//            cell = 220;
//        }
//        _h = self.wkviewHeight + 275 + 44  + 150 + cell;
//        if (self.dataArray.count > 0) {
//            NSArray *arr = self.dataArray[0][@"imgurl"];
//            if (arr.count > 0) {
//                _h +=  SCREEN.size.width/2;
//            }
//        }
//        if (_isApply) {
//            _h += 200;
//        }
//        return _h;
//    }else{
//        
//        return 0.01;
//        
//    }
//}
#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.option.count;
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *mdt = self.option[indexPath.row];
    if ([self.is_img isEqualToString:@"1"]) {
        CastVoteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CastVoteCollectionViewCell" forIndexPath:indexPath];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",mdt[@"imgurl"]]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:0];
        [cell.nameBtn setTitle:[NSString stringWithFormat:@"  %@",mdt[@"name"]] forState:UIControlStateNormal];
        if (self.isApply) {
            if ([mdt[@"isSelect"] isEqualToString:@"1"]) {
                [cell.nameBtn setImage:[UIImage imageNamed:@"xuanzhong_toupiaobiaojue"] forState:UIControlStateNormal];
            }else{
                [cell.nameBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
            }
        }else{
            [cell.nameBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }

        return cell;
    }else{
        static NSString * CellIdentifier = @"VoteUICollectionViewCell";
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        //
        UIImageView *imageveiw  = [[UIImageView alloc]init];
        imageveiw.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imageveiw];
        imageveiw.image = [UIImage imageNamed:@"toupiaobiaojue_tuoyuan"];
        [imageveiw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.offset(imageveiw.image.size.width);
        }];
        
        
        UILabel *lab  = [[UILabel alloc]init];
        
        lab.text = self.option[indexPath.row][@"name"];
        lab.font = [UIFont systemFontOfSize:13];
        lab.textAlignment = NSTextAlignmentLeft;
        [lab setTextColor:[UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1]];
        lab.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.offset(0);
            make.right.offset(-50);
            make.left.equalTo(imageveiw.mas_right).offset(10);
            make.bottom.offset(0);
            
        }];
        
        UIButton *selectBtn = [[UIButton alloc]init];
        selectBtn.userInteractionEnabled = NO;
        if (self.isApply) {
            if ([mdt[@"isSelect"] isEqualToString:@"1"]) {
                [selectBtn setImage:[UIImage imageNamed:@"xuanzhong_toupiaobiaojue"] forState:UIControlStateNormal];
            }else{
                [selectBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
            }
        }
        [cell.contentView addSubview:selectBtn];
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            
        }];
        
        return cell;

    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count) {
        
        if ([self.is_img isEqualToString:@"1"]) {
            return CGSizeMake((SCREEN.size.width-25)/2, 250);
        }
        return CGSizeMake(SCREEN.size.width-20, 49);
    }

    return CGSizeMake(0.001, 0.001);
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.is_img isEqualToString:@"1"]) {
        return 0.001;
    }
    return 1;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isApply) {
        NSMutableDictionary *mdt = self.option[indexPath.row];
        NSString *is_radio = [NSString stringWithFormat:@"%@",self.dataArray[0][@"is_radio"]];
        NSString *max_count = [NSString stringWithFormat:@"%@",self.dataArray[0][@"max_count"]];
        if ([is_radio isEqualToString:@"0"]) {
            if ([mdt[@"isSelect"] isEqualToString:@"1"]) {
                
                [mdt setObject:@"0" forKey:@"isSelect"];
            }else{
                CGFloat seleeCount = 0;
                for (NSMutableDictionary *opdt in self.option) {
                    if ([opdt[@"isSelect"] isEqualToString:@"1"]) {
                        seleeCount ++;
                    }
                }
                if (seleeCount < [max_count integerValue]) {
                    [mdt setObject:@"1" forKey:@"isSelect"];
                }else{
                    [self presentLoadingTips:[NSString stringWithFormat:@"最多选%@人",max_count]];
                    return;
                }
                
            }
            
            [self.collectionview reloadItemsAtIndexPaths:@[indexPath]];
        }else{
            if ([mdt[@"isSelect"] isEqualToString:@"1"]) {
                
                [mdt setObject:@"0" forKey:@"isSelect"];
            }else{
                
                
                [mdt setObject:@"1" forKey:@"isSelect"];
                
            }
            
            for (NSMutableDictionary *opdt in self.option) {
                if (![opdt[@"id"] isEqualToString:mdt[@"id"]]) {
                    [opdt setObject:@"0" forKey:@"isSelect"];
                }
            }
            [self.collectionview reloadData];
        }
        
        
        
        
    }
    
       
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
//头视图尺寸
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{

    return CGSizeMake(SCREEN.size.width, 45);
    
}
////底视图尺寸
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    return CGSizeMake(SCREEN.size.width, 150);
//}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UIView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"VoteHeaderReuse" forIndexPath:indexPath];
        
        reusableview = (UICollectionReusableView *)headerV;
        if (self.dataArray.count) {
            [reusableview removeAllSubviews];
            reusableview.backgroundColor = JHAssistColor;
            NSString *is_radio = [NSString stringWithFormat:@"%@",self.dataArray[0][@"is_radio"]];

            UILabel *nameLb = [[UILabel alloc]init];
            nameLb.textColor = [UIColor whiteColor];
            nameLb.font = [UIFont systemFontOfSize:13];
            if ([is_radio isEqualToString:@"0"]) {
                nameLb.text = [NSString stringWithFormat:@"匿名投票（多选，最多可选%@人）",self.dataArray[0][@"max_count"]];
            }else{
            nameLb.text = @"匿名投票（单选）";
            }
            [reusableview addSubview:nameLb];
            [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(5);
                make.top.offset(0);
                make.bottom.offset(0);
                make.width.offset([nameLb.text selfadap:13 weith:20].width + 10);
            }];
            
            UILabel *countLb = [[UILabel alloc]init];
            countLb.textColor = [UIColor whiteColor];
            countLb.font = [UIFont systemFontOfSize:13];
            countLb.textAlignment = NSTextAlignmentRight;
            countLb.text = [NSString stringWithFormat:@"%@人已投票",self.dataArray[0][@"com_count"]];
            [reusableview addSubview:countLb];
            [countLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-10);
                make.left.equalTo(nameLb.mas_right).offset(0);
                make.bottom.offset(0);
                make.top.offset(0);
            }];
    
            
            
        }
        
    }
//    if (kind == UICollectionElementKindSectionFooter){
//        
//        UIView *footV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeFootReuse" forIndexPath:indexPath];
//        
//        reusableview = (UICollectionReusableView *)footV;
//        [reusableview removeAllSubviews];
//        if (![UserModel Certification]) {
//            
//            UIButton *cerBtn = [[UIButton alloc]init];
//            [cerBtn addTarget:self action:@selector(cerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [cerBtn setImage:[UIImage imageNamed:@"qurenzheng"] forState:UIControlStateNormal];
//            [reusableview addSubview:cerBtn];
//            [cerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(reusableview.mas_centerX);
//                make.centerY.equalTo(reusableview.mas_centerY);
//            }];
//        }
//        
//        
//    }
    return reusableview;
}
//
//#pragma mark - *************提交按钮*************
//-(void)applybuttonclick:(UIButton *)btn{
//    
//    
//    [self.view endEditing:YES];
//    UITextField *tf1 = [self.view viewWithTag:60];
//    UITextField *tf2 = [self.view viewWithTag:61];
//    UITextField *tf3 = [self.view viewWithTag:62];
//    LFLog(@"%@==%@===%@",tf1.text,tf2.text,tf3.text);
//    if (tf1.text.length  == 0) {
//        [self presentLoadingTips:@"请您输入联系人姓名~~"];
//    }else if (tf2.text.length == 0){
//        
//        [self presentLoadingTips:@"请您输入联系人电话~~"];
//        
//    }else if (![tf2.text isValidateMobile]){
//        [self presentLoadingTips:@"请您输入正确的联系人电话~~"];
//        
//    }else if (tf3.text.length == 0){
//        
//        [self presentLoadingTips:@"请您输入参加的人数~~"];
//        
//    }else{
//        [self requestapplyUp:tf1.text mobile:tf2.text number:tf3.text];
//    }
//    
//    
//}
//
//
////开始拖拽视图
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
//{
//    for (int i = 0; i < 3; i ++) {
//        UITextField *tf = [self.view viewWithTag:60 + i];
//        if ([tf isFirstResponder]) {
//            [self.view endEditing:YES];
//        }
//    }
//    
//}
//
#pragma mark - *************投票按钮
-(void)submitClick:(UIButton *)btn{
    LFLog(@"option:%@",self.option);
    NSMutableArray *marr = [NSMutableArray array];
    for (NSMutableDictionary *mdt in self.option) {
        if ([mdt[@"isSelect"] isEqualToString:@"1"]) {
            [marr addObject:mdt];
        }
    }
    if (marr.count) {
        [self requestapplyUp:marr];
    }else{
        [self presentLoadingTips:@"请选择投票人"];
    }
}
#pragma mark - *************详情请求*************
-(void)requestdetail{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.detailid,@"id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,CastVoteDetailUrl) params:dt success:^(id response) {
        LFLog(@"投票详情：%@",response);
        [_tableview.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (![response[@"data"] isKindOfClass:[NSString class]]) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObject:response[@"data"]];
                [self.option  removeAllObjects];
                for (NSDictionary *opDt in response[@"data"][@"option"]) {
                    NSMutableDictionary *mdt = [NSMutableDictionary dictionaryWithDictionary:opDt];
                    [mdt setObject:@"0" forKey:@"isSelect"];
                    [self.option addObject:mdt];
                }
                [self.applyArray removeAllObjects];
                for (NSDictionary *appDt in response[@"data"][@"option_cal"]) {
                    [self.applyArray addObject:appDt];
                }
                if (![[NSString stringWithFormat:@"%@",response[@"data"][@"status"]] isEqualToString:@"1"]) {//投票结束或未开始
                    self.isApply = NO;
                }else{
                    if ([[NSString stringWithFormat:@"%@",response[@"data"][@"is_com"]] isEqualToString:@"1"]) {//已投票
                        self.isApply = NO;
                    }else{
                    self.isApply = YES;
                    }
                
                }
                self.detailid = [NSString stringWithFormat:@"%@",response[@"data"][@"id"]];
                self.is_img = [NSString stringWithFormat:@"%@",response[@"data"][@"is_img"]];
                [self.tableview reloadData];
                [self.collectionview reloadData];
                [self createTableFootview];
            }else{
                NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
                if ([error_code isEqualToString:@"100"]) {
                    [self showLogin:^(id response) {
                        if ([response isEqualToString:@"1"]) {
                            [self requestdetail];
                        }
                        
                    }];
                }
                [self presentLoadingTips:response[@"status"][@"error_desc"]];
            }
        }
        
    } failure:^(NSError *error) {
        [_tableview.mj_header endRefreshing];
    }];
    
}

#pragma mark - *************报名提交*************
- (void)requestapplyUp:(NSArray *)optonArr{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.detailid,@"vote_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSMutableString *option = [NSMutableString string];
    for (int i = 0; i < optonArr.count; i ++) {
         [option appendFormat:@"%@",optonArr[i][@"id"]];
        if (i < optonArr.count - 1) {
            [option appendString:@","];
        }
    }
    [dt setObject:option forKey:@"option"];
    LFLog(@"投票dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,CastVoteSubmitUrl) params:dt success:^(id response) {
        LFLog(@"投票：%@",response);
        [_tableview.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (![response[@"data"] isKindOfClass:[NSString class]]) {
                [self presentLoadingTips:@"投票成功~~"];
                [self requestdetail];
            }else{
                NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
                if ([error_code isEqualToString:@"100"]) {
                    [self showLogin:^(id response) {
                    }];
                }
                [self presentLoadingTips:response[@"status"][@"error_desc"]];
            }
        }
        
    } failure:^(NSError *error) {
        [_tableview.mj_header endRefreshing];
    }];
}
//
//#pragma mark - *************用户列表*************
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
//
//
//#pragma mark - *************检测用户是否可以报名*************
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
//            self.isApply = NO;
//        }
//        
//        [self delayMethod];
//        
//    } failure:^(NSError *error) {
//        [_tableview.mj_header endRefreshing];
//    }];
//    
//}
//
//-(void)delayMethod{
//    
//    self.wkview = nil;
//    [self.wkview removeFromSuperview];
//    [_applyView removeFromSuperview];
//    _applyView = nil;
//    [_applylist removeFromSuperview];
//    _applylist = nil;
//    [_tableview.mj_header endRefreshing];
//    self.isLoadWkview = YES;
//    [self.tableview reloadData];
//    
//}
//
//
//#pragma mark 集成刷新控件
//- (void)setupRefresh
//{
//    // 下拉刷新
//    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self requestdetail];
//        [self requestuserList];
//    }];
//    
//}


@end

