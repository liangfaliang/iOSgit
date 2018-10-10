//
//  BusinessHomeTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/8/15.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BusinessHomeTableViewCell.h"
#import "UIButton+WebCache.h"
@implementation BusinessHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setViewHideen:(BOOL)ishiden{
    self.nameLb.hidden = ishiden;
    self.xx_image.hidden = ishiden;
    self.adressLb.hidden = ishiden;
    self.imagebackviewTop.constant = ishiden ? 10 : 25;
}
- (void)setBmodel:(businessModel *)bmodel{
    _bmodel = bmodel;
    self.nameLb.text = bmodel.shop_name;
    self.adressLb.text = bmodel.shop_address;
    self.xx_image.scale = [bmodel.rank doubleValue]/5.0;
    self.xx_image.selImage = [UIImage imageNamed:@"xingxing_chense"];
    [self setImageArr:bmodel.imgurl];

}

-(void)setImageArr:(NSArray *)imageArr{
    if (imageArr.count) {
        self.imageBackviewHeight.constant = (screenW - 60)/3;
    }else{
        self.imageBackviewHeight.constant = 0;
    }
    for (int i = 0; i < 3; i ++) {
        NSString *imName = [NSString stringWithFormat:@"image%d",i+ 1];
        UIButton * imageview = [self valueForKey:imName];
        if (imageArr.count > i) {
            [imageview sd_setBackgroundImageWithURL:[NSURL URLWithString:imageArr[i]] forState:UIControlStateNormal];
        }else{
            [imageview setImage:nil forState:UIControlStateNormal];
        }
    }
}
- (IBAction)imageClick:(UIButton *)sender {
    if (self.imageclickBlock) {
        self.imageclickBlock(sender.tag - 1);
    }
}


@end
