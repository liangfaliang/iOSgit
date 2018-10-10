//
//  VaccinationPlanTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/23.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "VaccinationPlanCollectionViewCell.h"

@implementation VaccinationPlanCollectionViewCell

-(instancetype)init{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

-(void)initialization{
    self.layer.cornerRadius = 5;
    self.layer.shouldRasterize = YES;
    self.layer.masksToBounds = YES;
//    self.tabview = [[UITableView alloc]init];
//    [self.contentView addSubview:self.tabview];
//    [self.tabview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(0);
//        make.right.offset(0);
//        make.top.offset(0);
//        make.bottom.offset(0);
//    }];
}
-(void)setTabview:(UITableView *)tabview{
    if (_tabview) {
        [_tabview removeFromSuperview];
    }
    _tabview = tabview;
    [self headerView];
    [self reserveView];
    [self.contentView addSubview:_tabview];
    [_tabview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.equalTo(self.headerView.mas_bottom).offset(0);
        make.bottom.equalTo(self.reserveView.mas_top).offset(0);
    }];
}
-(UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]init];
        [self.contentView addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.top.offset(0);
            make.height.offset(40);
        }];
        
        [_headerView addSubview:self.headerLb];
        [_headerLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerView.mas_centerX);
            make.top.offset(10);
            make.height.offset(20);
        }];
    }
    return _headerView;
}
-(UILabel *)headerLb{
    if (_headerLb == nil) {
        _headerLb = [[UILabel alloc]init];
        _headerLb.textAlignment = NSTextAlignmentCenter;
        _headerLb.font  = [UIFont systemFontOfSize:11];
        _headerLb.textColor = JHMedicalColor;
        _headerLb.layer.borderColor= [JHMedicalColor CGColor];
        _headerLb.layer.borderWidth = 1;
        _headerLb.layer.cornerRadius = 5;
        _headerLb.layer.masksToBounds = YES;
    }
    return _headerLb;
}
-(UIView *)reserveView{
    if (_reserveView == nil) {
        _reserveView = [[UIView alloc]init];
        UIButton *reBtn = [[UIButton alloc]init];
//        [reBtn setImage:[UIImage imageNamed:@"yuyuebutton_yiliao"] forState:UIControlStateNormal];
        [_reserveView addSubview:reBtn];
        reBtn.layer.cornerRadius = 15;
        reBtn.layer.masksToBounds = YES;
        reBtn.backgroundColor = JHMedicalColor;
        [reBtn setTitle:@"预约" forState:UIControlStateNormal];
        [reBtn addTarget:self action:@selector(reBtnClick) forControlEvents:UIControlEventTouchUpInside];
        reBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [reBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_reserveView.mas_centerX).offset(0);
            make.centerY.equalTo(_reserveView.mas_centerY).offset(-10);
            make.width.mas_equalTo(_reserveView).multipliedBy(0.75);
            make.height.offset(30);
        }];
        [self.contentView addSubview:_reserveView];
        [_reserveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.height.offset(100);
            make.bottom.offset(0);
        }];

        [_reserveView addSubview:self.footerLb];
        [_footerLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(-10);
        }];
    }
    return _reserveView;
}
-(void)reBtnClick{
    if (_block) {
        _block();
    }
}
-(void)setBlock:(void (^)())block{
    _block = block;
}
-(UILabel *)footerLb{
    if (_footerLb == nil) {
        _footerLb = [[UILabel alloc]init];
        _footerLb.textAlignment = NSTextAlignmentCenter;
        _footerLb.font  = [UIFont systemFontOfSize:11];
        _footerLb.textColor = JHsimpleColor;
    }
    return _footerLb;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

@end
