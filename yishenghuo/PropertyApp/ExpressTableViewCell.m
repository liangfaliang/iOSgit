//
//  ExpressTableViewCell.m
//  shop
//
//  Created by 梁法亮 on 16/8/24.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "ExpressTableViewCell.h"

@implementation ExpressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.pictureImage = [[UIImageView alloc]init];
        self.pictureImage.layer.cornerRadius = 3;
        self.pictureImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.pictureImage];
        
        self.typeLabel = [[UILabel alloc]init];
        self.typeLabel.textColor = JHColor(102, 102, 102);
        self.typeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.typeLabel];
        
        self.phoneLabel = [[UILabel alloc]init];
        self.phoneLabel.textColor = JHColor(102, 102, 102);
        self.phoneLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.phoneLabel];
        
        self.infoLabel = [[UILabel alloc]init];
        self.infoLabel.textColor = JHColor(102, 102, 102);
        self.infoLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.infoLabel];
        
        self.notiview = [[UIImageView alloc]init];
        [self.contentView addSubview:self.notiview];
        
        self.notiLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width-20, 30) rate:50.0f andFadeLength:10.0f];
        self.notiLabel.textColor = JHColor(208, 56, 84);
        self.notiLabel.font = [UIFont systemFontOfSize:14];
        self.notiLabel.numberOfLines = 1;
        self.notiLabel.shadowOffset = CGSizeMake(0.0, -1.0);
        self.notiLabel.textAlignment = NSTextAlignmentLeft;
        [self.notiview addSubview:self.notiLabel];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = JHColor(14, 110, 213);
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = JHColor(14, 110, 213);
        self.timeLabel.font = [UIFont systemFontOfSize:14];

        [self.contentView addSubview:self.timeLabel];
        
        self.subBtn = [[UIButton alloc]init];
        [self.contentView addSubview:self.subBtn];

    }
    
    return self;

}


-(void)setModel:(Expressmodel *)model{

    _model = model;
    
    UIImage *im = [UIImage imageNamed:@"tupian_kuaiditongzhi-"];

    [_pictureImage sd_setImageWithURL:[NSURL URLWithString:model.express_img] placeholderImage:im];
    [_pictureImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(10);
        make.left.offset(10);
        make.height.offset(im.size.height);
        make.width.offset(im.size.width);
        
    }];
    //运单号
    _typeLabel.text = [NSString stringWithFormat:@"%@:%@",model.express_company,model.express_number];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_pictureImage.mas_right).offset(10);
        make.right.offset(-10);
        make.top.equalTo(_pictureImage.mas_top);
        make.height.offset(im.size.height/3);
        
    }];

    //手机号
    _phoneLabel.text = [NSString stringWithFormat:@"收件人电话：%@",model.owner_mobile];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_pictureImage.mas_right).offset(10);
        make.right.offset(-10);
        make.top.equalTo(_typeLabel.mas_bottom).offset(0);
        make.height.offset(im.size.height/3);
        
    }];
    
    //业主信息
    _infoLabel.text = [NSString stringWithFormat:@"%@ %@",model.owner_name,model.owner_address];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_pictureImage.mas_right).offset(10);
        make.right.offset(-10);
        make.top.equalTo(_phoneLabel.mas_bottom).offset(0);
        make.height.offset(im.size.height/3);
     
    }];
    UIImage *imview = [UIImage imageNamed:@"-lingqutishikuang"];
    _notiview.image = imview;
    [_notiview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.width.offset(SCREEN.size.width - 20);
        make.top.equalTo(_pictureImage.mas_bottom).offset(25);
        make.height.offset(40);
        
    }];
    //消息通知
    _notiLabel.text = [NSString stringWithFormat:@"请 %@ %@ 在 %@领取快递",model.owner_name,model.worker_time,model.worker_address];
    [_notiLabel restartLabel];
    [_notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(1);
        make.height.offset(30);
        
    }];
    UIImage *btnimview = [UIImage imageNamed:@"querenlingqu"];
    [_subBtn setImage:btnimview forState:UIControlStateNormal];
 
    [_subBtn addTarget:self action:@selector(subBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        

        make.right.offset(-10);
        make.top.equalTo(_notiview.mas_bottom).offset(20);
        make.width.offset(btnimview.size.width);
        
    }];
    _nameLabel.text = model.worker_mobile;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(10);
        make.right.equalTo(_subBtn.mas_left).offset(10);
        make.top.equalTo(_notiview.mas_bottom).offset(10);
        make.height.offset(20);
        
    }];
    _timeLabel.text = model.add_time;
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(10);
        make.right.equalTo(_subBtn.mas_left).offset(10);
        make.top.equalTo(_nameLabel.mas_bottom).offset(5);
        make.height.offset(20);
        
    }];

}

-(void)setFinishmodel:(finishModel *)finishmodel{


    _finishmodel = finishmodel;
    
    UIImage *im = [UIImage imageNamed:@"tupian_kuaiditongzhi-"];
    [_pictureImage sd_setImageWithURL:[NSURL URLWithString:finishmodel.express_img] placeholderImage:im];
    [_pictureImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(10);
        make.left.offset(10);
        make.height.offset(im.size.height);
        make.width.offset(im.size.width);
        
    }];
    
    //运单号
    _typeLabel.text = [NSString stringWithFormat:@"%@:%@",finishmodel.express_company,finishmodel.express_number];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_pictureImage.mas_right).offset(10);
        make.right.offset(-10);
        make.top.equalTo(_pictureImage.mas_top);
        make.height.offset(im.size.height/3);
        
    }];
    
    //手机号
    _phoneLabel.text = [NSString stringWithFormat:@"收件人电话：%@",finishmodel.owner_mobile];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_pictureImage.mas_right).offset(10);
        make.right.offset(-10);
        make.top.equalTo(_typeLabel.mas_bottom).offset(0);
        make.height.offset(im.size.height/3);
        
    }];
    
    //业主信息
    _infoLabel.text = [NSString stringWithFormat:@"%@ %@",finishmodel.owner_name,finishmodel.owner_address];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_pictureImage.mas_right).offset(10);
        make.right.offset(-10);
        make.top.equalTo(_phoneLabel.mas_bottom).offset(0);
        make.height.offset(im.size.height/3);
        
    }];

    UIImage *btnimview = [UIImage imageNamed:@"yishouhuobuttun"];
    [_subBtn setImage:btnimview forState:UIControlStateNormal];
    
    [_subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.right.offset(-10);
        make.top.equalTo(_pictureImage.mas_bottom).offset(20);
        make.width.offset(btnimview.size.width);
        
    }];
    _nameLabel.text = finishmodel.confirm_time;
    _nameLabel.textColor = JHColor(102, 102, 102);
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(10);
        make.right.equalTo(_subBtn.mas_left).offset(10);
        make.centerY.equalTo(_subBtn.mas_centerY);
        make.height.offset(20);
        
    }];
    



}

//确认领取
-(void)subBtnClick:(UIButton *)btn{


    if (_Block) {
        _Block(_model.id);
    }
}

-(void)setBlock:(BtnBlock)Block{

    
    _Block = Block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
