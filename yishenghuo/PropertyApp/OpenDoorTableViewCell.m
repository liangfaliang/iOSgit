//
//  OpenDoorTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/17.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "OpenDoorTableViewCell.h"

@implementation OpenDoorTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self Initialization];
    }
    return self;
}
-(instancetype)init{
    if (self = [super init]) {
//        [self Initialization];
    }
    return self;
}
//- (void)Initialization{
//    [super awakeFromNib];
//    // Initialization code
//    UIImage *im = [UIImage imageNamed:@"beijing_shoujikaimen"];
//    self.backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREEN.size.width - 20, im.size.height)];
//    self.backView.backgroundImage = im;
//    [self.contentView addSubview:self.backView];
//    UIImage *sliderim = [UIImage imageNamed:@"menyikai_buttun"];
//    self.dwslider = [[DWStepSlider alloc]initWithFrame:CGRectMake(self.backView.width - sliderim.size.width, (im.size.height -sliderim.size.height)/2, sliderim.size.width, sliderim.size.height) stepNodes:@[@"0",@"1"]];
////    self.dwslider = dwslider;
////    self.dwslider.thumbImage =[UIImage imageNamed:@"baidihongquan"];
//    self.dwslider.minTrackImage = sliderim;
//    self.dwslider.maxTrackImage = [UIImage imageNamed:@"huadong_buttun"];
//    self.dwslider.minTrackColor = [UIColor clearColor];
//    self.dwslider.maxTrackColor = [UIColor clearColor];
//    [self.dwslider addTarget:self action:@selector(dwsliderClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.backView addSubview:self.dwslider];
//    
//    self.nameLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.backView.width - sliderim.size.width - 20, im.size.height)];
//    self.nameLb.textColor = JHdeepColor;
//    self.nameLb.numberOfLines = 0;
//    self.nameLb.font =[UIFont systemFontOfSize:15];
//    [self.backView addSubview:self.nameLb];
//}
//- (void)dwsliderClick:(DWStepSlider *)sender {
//    sender.userInteractionEnabled = NO;
//    NSLog(@"currentNode:%@",sender.currentNode);
//    if ([sender.currentNode isEqualToString:@"1"]) {
//        
//        BaseViewController *vc = (BaseViewController *)[self viewController];
//        [vc presentLoadingStr:@"请稍后！"];
//        NSMutableDictionary *mdt = [self paramDt];
//        if (self.jsonDt[@"device_sn"]) {
//            [mdt setObject:self.jsonDt[@"device_sn"] forKey:@"device_sn"];//0039002D34365106
//        }else{
//            [vc presentLoadingTips:@"设备号为空！"];
//            return;
//        }
//        if (self.jsonDt[@"device_id"]) {
//            [mdt setObject:self.jsonDt[@"device_id"] forKey:@"device_id"];//0039002D34365106
//        }else{
//            [vc presentLoadingTips:@"设备ID为空！"];
//            return;
//        }
//        [mdt setObject:@"1" forKey:@"direction"];
//        [mdt setObject:@"1" forKey:@"hint"];
//        [UserModel AccessOpenDoor:mdt result:^(id response) {
//            [vc dismissTips];
//            LFLog(@"response:%@",response);
//            sender.userInteractionEnabled = YES;
//            NSString *str = [NSString stringWithFormat:@"%@",response[@"retcode"]];
//            if ([str isEqualToString:@"0"]) {
//                [vc presentLoadingTips:@"成功开门！"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
//                    // do something
//                    sender.value = 0;
//                });
//            }else{
//                [vc presentLoadingTips:response[@"retmsg"]];
//            }
//            
//            
//        } error:^(NSError *error) {
//            [vc dismissTips];
//            sender.userInteractionEnabled = YES;
//            sender.value = 0;
//            LFLog(@"error:%@",error);
//            if (error.localizedFailureReason && error.localizedFailureReason.length ) {
//                [vc presentLoadingTips:error.localizedFailureReason];
//            }else{
//                [vc presentLoadingTips:@"开门失败！"];
//            }
//            
//        }];
//    }else{
//        sender.userInteractionEnabled = YES;
//        sender.value = 0;
//    }
//    
//}
//-(NSMutableDictionary *)paramDt{
//
//    NSMutableDictionary *mdt = [NSMutableDictionary dictionary];
//    if (self.jsonDt[@"client_id"]) {
//        [mdt setObject:self.jsonDt[@"client_id"] forKey:@"client_id"];
//    }else{
//        [mdt setObject:@"c8057e82a151cdbb77900b4ae6c567f12c7714c82b964bbe3721ae4e3fd7ac6a" forKey:@"client_id"];
//    }
//    if (self.jsonDt[@"client_secret"]) {
//        [mdt setObject:self.jsonDt[@"client_secret"] forKey:@"client_secret"];
//    }else{
//        [mdt setObject:@"fdccf09451acdf5803327184798a725359e2ce2e22ac93a85790871200779c8e" forKey:@"client_secret"];
//    }
//    if (self.jsonDt[@"redirect_uri"]) {
//        [mdt setObject:self.jsonDt[@"redirect_uri"] forKey:@"redirect_uri"];
//    }else{
//        [mdt setObject:@"urn:ietf:wg:oauth:2.0:oob" forKey:@"redirect_uri"];
//    }
//    
//    return mdt;
//}
//-(void)setJsonDt:(NSDictionary *)jsonDt{
//    _jsonDt = jsonDt;
//    self.nameLb.text = jsonDt[@"name"];
//}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
