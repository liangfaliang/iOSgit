//
//  ProductDescBoard_iPhoneViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/18.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ProductDescBoard_iPhoneViewController.h"

@interface ProductDescBoard_iPhoneViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UIWebView *webview;
@end

@implementation ProductDescBoard_iPhoneViewController

-(instancetype)init{
    if (self = [super init]) {
//        [self UploadDatagoods];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{


    if (self = [super initWithFrame:frame]) {
//        [self UploadDatagoods];
    }
    return self;
}

-(void)setGoods_id:(NSString *)goods_id{
    _goods_id = goods_id;
    [self UploadDatagoods];

}
#pragma mark - *************商品描述请求*************
-(void)UploadDatagoods{
    NSDictionary *dt = @{@"goods_id":self.goods_id};
    LFLog(@"goods_id:%@",self.goods_id);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,@"goods/desc") params:dt success:^(id response) {

        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            self.webview = [[UIWebView alloc]initWithFrame:self.frame];
            NSString *HtmlData = response[@"data"];
            [self.webview loadHTMLString:HtmlData baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
            [self addSubview:self.webview];
        }else{

            
        }
    } failure:^(NSError *error) {

    }];
    
    
}


@end
