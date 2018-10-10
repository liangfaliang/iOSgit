//
//  AdressListView.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/31.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AdressListView.h"
#import "AdressListTableViewCell.h"
@implementation AdressListView

- (instancetype)initWithImageArray:(NSArray *)dataArray{
    if (self == [super init]) {
        if (dataArray.count) {
            [self.dataArray addObjectsFromArray:dataArray];
        }
        [self addSubview:self.tableview];
    }
    return self;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

-(UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW * 0.6, 0) style:UITableViewStylePlain];
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.estimatedRowHeight = 50;
        _tableview.rowHeight = -1;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"attendcell"];
        [_tableview registerNib:[UINib nibWithNibName:@"AdressListTableViewCell" bundle:nil] forCellReuseIdentifier:@"AdressListTableViewCell"];
        
    }
    return _tableview;
}


#pragma mark tableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AdressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdressListTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellClick) {
        self.cellClick(self.dataArray[indexPath.row]);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.tableview.frame = self.bounds;
}


@end

