//
//  GNRGoodsListCell.m
//  外卖
//
//  Created by LvYuan on 2017/5/2.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import "GNRGoodsListCell.h"
#import "AlertView.h"
@implementation GNRGoodsListCell

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, ([UIColor colorWithWhite:0.8 alpha:0.8]).CGColor);
    CGContextStrokeRect(context, CGRectMake(16, rect.size.height, rect.size.width, 0.4));
}

- (GNRCountStepper *)stepper{
    if (!_stepper) {
        _stepper = [[GNRCountStepper alloc]initWithFrame:CGRectZero];
    }
    return _stepper;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.stepperSuperView addSubview:self.stepper];
    [self.stepper countChangedBlock:^(NSInteger count ,UIButton *btn) {
        if (_goods) {
//            _goods.goods_number = [NSString stringWithFormat:@"%ld",(long)count];
            [self UploadDataCartListUpdate:_goods.goods_id new_number:[NSString stringWithFormat:@"%ld",(long)count] addSender:btn isAdd:_goods.goods_number.integerValue < count ? YES : NO];
//            if ([_delegate respondsToSelector:@selector(stepper:valueChangedForCount:goods:)]) {
//                [_delegate stepper:_stepper valueChangedForCount:count goods:_goods];
//            }
        }
    }];
    __weak typeof(self) wself = self;
    [wself.stepper addActionBlock:^(UIButton * btn) {
        if (_goods) {
//                    if ([wself.delegate respondsToSelector:@selector(stepper:addSender:cell:)]) {
//                        [wself.delegate stepper:wself.stepper addSender:btn cell:wself];
//                    }
        }

    }];
    [wself.stepper subActionBlock:^(UIButton * btn) {
//        if ([wself.delegate respondsToSelector:@selector(stepper:subSender:cell:)]) {
//            [wself.delegate stepper:wself.stepper subSender:btn cell:wself];
//        }
    }];
}
#pragma mark - *************购物车更新请求*************
-(void)UploadDataCartListUpdate:(NSString *)rec_id new_number:(NSString *)new_number addSender:(UIButton *)btn isAdd:(BOOL)isAdd {
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:rec_id,@"goods_id",new_number,@"goods_number", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.shop_id) {
        [dt setObject:self.shop_id forKey:@"shop_id"];
    }
    [AlertView showProgress];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BusinessCartUpdateUrl) params:dt success:^(id response) {
        [AlertView dismiss];
        LFLog(@"购物车更新：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            _goods.goods_number = new_number;
            self.stepper.count = new_number.integerValue;
            if ([_delegate respondsToSelector:@selector(stepper:valueChangedForCount:goods:)]) {
                [_delegate stepper:_stepper valueChangedForCount:new_number.integerValue goods:_goods];
            }
            if (isAdd) {
                if ([self.delegate respondsToSelector:@selector(stepper:addSender:cell:)]) {
                    [self.delegate stepper:self.stepper addSender:btn cell:self];
                }
            }else{
                if ([_delegate respondsToSelector:@selector(stepper:valueChangedForCount:goods:)]) {
                    [_delegate stepper:_stepper valueChangedForCount:new_number.integerValue goods:_goods];
                }
            }
        }else{
            
            [AlertView showMsg:response[@"status"][@"error_desc"]];
        }
        
    } failure:^(NSError *error) {
        [AlertView dismiss];
    }];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGoods:(GNRGoodsModel *)goods{
    _goods = goods;
    [self refreshUI];
}

- (void)layoutSubviews{
    self.stepper.center = CGPointMake(_stepperSuperView.bounds.size.width/2.0, _stepperSuperView.bounds.size.height/2.0);
}

- (void)refreshUI{
    if (!_goods) {
        return;
    }
    _nameL.text = _goods.goods_name;
    _priceL.text = [NSString stringWithFormat:@"￥%@",_goods.goods_price];
    _stepper.count = _goods.goods_number.integerValue;
    [_goodsImageV sd_setImageWithURL:[NSURL URLWithString:_goods.imgurl ? _goods.imgurl :@""] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}

@end
