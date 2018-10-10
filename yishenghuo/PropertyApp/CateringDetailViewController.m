//
//  CateringDetailViewController.m
//  shop
//
//  Created by 梁法亮 on 16/10/20.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "CateringDetailViewController.h"
#import "NSString+selfSize.h"
#import "UIImage+GIF.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "STPhotoBroswer.h"
@interface CateringDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)UIView *footview;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong) STPhotoBroswer * brose;
//数据请求对象
@property(nonatomic,assign)NSInteger imageIndex;


@end

@implementation CateringDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarTitle = @"餐厅详情";
    [self createTableview];
    [self setupRefresh];
    [self requestdetailhouser];
    
}


-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}

-(void)createfootview{
    
    if (_footview == nil) {
        _footview = [[UIView alloc]init];
    }
    if (self.dataArray.count > 0) {
        NSArray *dt = self.dataArray[0][@"food"];
        for (int i = 0; i < dt.count; i ++ ) {
            UIImageView *picture = [self.view viewWithTag:300 + i];
            
            if (picture == nil) {
                picture = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15 + i * ((SCREEN.size.width - 20)* 0.7 + 50), SCREEN.size.width - 20, (SCREEN.size.width - 20)* 0.7)];
                picture.tag = 300 + i;
                [_footview addSubview:picture];
                UIButton *tap = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, picture.width, picture.height)];
                tap.backgroundColor = [UIColor clearColor];
                tap.tag = 300 + i;
                [tap addTarget:self action:@selector(imageviewtap:) forControlEvents:UIControlEventTouchUpInside];
                [picture addSubview:tap];
                picture.userInteractionEnabled = YES;
                //                    [picture setContentScaleFactor:[[UIScreen mainScreen] scale]];
                picture.contentMode =  UIViewContentModeScaleAspectFit;
                //                    picture.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                picture.clipsToBounds  = YES;
            }
            
            [picture sd_setImageWithURL:[NSURL URLWithString:dt[i][@"food_image"]] placeholderImage:[UIImage imageNamed:@""]];
            UIView *imagefoot = [[UIView alloc]init];
            imagefoot.backgroundColor = JHColor(209, 211, 212);
            [_footview addSubview:imagefoot];
            [imagefoot mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(0);
                make.left.offset(0);
                make.top.equalTo(picture.mas_bottom);
                make.height.offset(30);
                
            }];
            UILabel *namelabel = [[UILabel alloc]init];
            namelabel.text = dt[i][@"food_name"];
            namelabel.font = [UIFont systemFontOfSize:13];
            namelabel.textColor = JHColor(51, 51, 51);
            [imagefoot addSubview:namelabel];
            [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-SCREEN.size.width/2);
                make.centerY.equalTo(imagefoot.mas_centerY);
                
            }];
            UILabel *pricelabel = [[UILabel alloc]init];
            pricelabel.text = [NSString stringWithFormat:@"   ￥%@/%@ ",dt[i][@"food_price"],dt[i][@"food_unit"]];
            pricelabel.font = [UIFont systemFontOfSize:13];
            pricelabel.textColor = [UIColor redColor];
            [imagefoot addSubview:pricelabel];
            [pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(SCREEN.size.width/2);
                make.centerY.equalTo(imagefoot.mas_centerY);
                
            }];
            
        }
        
        _footview.frame = CGRectMake(0, 0, SCREEN.size.width, 15 + dt.count * ((SCREEN.size.width - 20)* 0.7 + 50));
        
        self.tableview.tableFooterView = self.footview;
    }
    
}

-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 65;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (self.dataArray.count > 0) {
        
        NSDictionary *dt = self.dataArray[0];
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titlelabel = [self.view viewWithTag:11];
            if (titlelabel == nil) {
                titlelabel = [[UILabel alloc]init];
                titlelabel.tag = 11;
                titlelabel.textColor = JHColor(51, 51, 51);
                titlelabel.font = [UIFont systemFontOfSize:15];
                
            }
            titlelabel.text = dt[@"cate_name"];
            [cell.contentView addSubview:titlelabel];
            [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.top.offset(10);
                make.height.offset(21);
            }];
            
            UILabel *timelabel = [self.view viewWithTag:12];
            if (timelabel == nil) {
                timelabel = [[UILabel alloc]init];
                timelabel.tag = 12;
                timelabel.textColor = JHColor(151, 151, 151);
                timelabel.font = [UIFont systemFontOfSize:12];
                
            }
            timelabel.text = [NSString stringWithFormat:@"阅读 %@",dt[@"cate_read"]];
            [cell.contentView addSubview:timelabel];
            [timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.top.equalTo(titlelabel.mas_bottom).offset(5);
                make.height.offset(21);
            }];
            
            UILabel *locationlabel = [self.view viewWithTag:13];
            if (locationlabel == nil) {
                locationlabel = [[UILabel alloc]init];
                locationlabel.tag = 13;
                locationlabel.textColor = JHColor(151, 151, 151);
                locationlabel.font = [UIFont systemFontOfSize:12];
                locationlabel.textAlignment = NSTextAlignmentRight;
                
            }
            locationlabel.text = [NSString stringWithFormat:@"%@",dt[@"cate_address"]];
            [cell.contentView addSubview:locationlabel];
            [locationlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(timelabel.mas_right).offset(10);
                make.right.offset(-10);
                make.top.equalTo(titlelabel.mas_bottom).offset(5);
                make.height.offset(21);
            }];
            
            
            
        }else if(indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"telephone"];
            cell.textLabel.text = [NSString stringWithFormat:@"订餐电话：%@",dt[@"cate_mobile"]];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = JHColor(51, 51, 51);
            
        }else{
            cell.imageView.image = [UIImage imageNamed:@"telephone"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",dt[@"cate_discount"]];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = JHColor(255, 79, 0);
            
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        NSString *phone = self.dataArray[0][@"mobile"];
        NSLog(@"打电话");
        if (phone != nil)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phone]]];
        }
    }
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
    
}
//图片点击事件
-(void)imageviewtap:(UIButton *)tap{
    NSArray *dt = self.dataArray[0][@"food"];
    LFLog(@"点击图片：%@",dt[tap.tag - 300][@"food_image"]);
   self.brose = [[STPhotoBroswer alloc]initWithImageArray:@[dt[tap.tag - 300][@"food_image"]] currentIndex:0];
    [_brose show];
    
}

#pragma mark - *************详情请求*************
-(void)requestdetailhouser{

    NSDictionary *dt = @{@"cate_id":self.detailid};
    [LFLHttpTool get:@"http://www.shequyun.cc/xingfuhui/mobile/index.php?c=catering&a=catering" params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        
        if ([str isEqualToString:@"0"]) {
            [self.dataArray removeAllObjects];
            
            [self.dataArray addObject:response[@"data"]];
            [self createfootview];
            [self.tableview reloadData];
    
        }else{

            
        }
        
    } failure:^(NSError *error) {
        [self presentLoadingTips:@"暂无数据"];
        [_tableview.mj_header endRefreshing];
    }];
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestdetailhouser];
    }];
}


@end
