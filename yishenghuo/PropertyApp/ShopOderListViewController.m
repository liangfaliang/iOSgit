//
//  ShopOderListViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/5/16.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "ShopOderListViewController.h"
#import "ShopCartTableViewCell.h"
@interface ShopOderListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView * tableview;

@end

@implementation ShopOderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTableview];
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height -50)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopCartTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopOderListCell"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cartfirmCell"];
    [self.view addSubview:self.tableview];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray.count) {
        return self.dataArray.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count) {
        return 120;
    }
    return SCREEN.size.height - 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataArray.count) {
        ShopCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopOderListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ShopCartModel *model = self.dataArray[indexPath.row];
        __weak typeof(cell) weakcell = cell;


        cell.countView.countLabel.delegate =self;
        cell.countView.countLabel.enabled = NO;
        cell.nameLabel.text = model.goods_name;
        NSMutableString *mstr = [NSMutableString string];
        //        if (model.goods_attr.count) {
        //            for (int i = 0; i < model.goods_attr.count; i ++) {
        //                [mstr appendFormat:@"%@ ", model.goods_attr[i][@"value"]];
        //            }
        //        }
        cell.styleLabel.text = mstr;
        cell.priceLabel.text = model.subtotal;
        cell.countView.countLabel.text = model.goods_number;
        [cell.pictureIm sd_setImageWithURL:[NSURL URLWithString:model.img[@"thumb"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartfirmCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView removeAllSubviews];
        UIImageView *plImview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuneirong"]];
        [cell.contentView addSubview:plImview];
        [plImview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20);
            make.centerX.equalTo(cell.contentView.mas_centerX);
        }];
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    //    ShopCartModel *model = self.dataArray[indexPath.row];
    //
    //    DoodsDetailsViewController *goods =[[DoodsDetailsViewController alloc]init];
    //    goods.goods_id = model.goods_id;
    //    [self.navigationController pushViewController:goods animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return   UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count) {
        return YES;
    }else{
        return NO;
    }
}



@end
