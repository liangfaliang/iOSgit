//
//  ServiceAlipay_Order.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/9/14.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ServiceAlipay_Order.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation ServiceAlipay_Order
SYNTHESIZE_SINGLETON_FOR_CLASS(ServiceAlipay_Order);
- (void)generate
{
    if (!self.orderStr) {
        Order * order = [[Order alloc] init];
        //    order.partner = Partnera;
        //    order.seller = Sellera;
        order.partner = _partnera;
        order.seller = _sellera;
        
        order.tradeNO = _tradeNO; //订单ID（由商家?自?行制定）
        order.productName = _productName; //商品标题
        order.productDescription = _desc; //商品描述
        order.amount = _price; //商品价格
        
        order.notifyURL = _appliaynotify_url; //回调URL 支付宝订单结束后 会通过这个地址告知我们的后台服务器
        
        //下面是使用支付服务对应的信息 固定写法
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"utf-8";
        order.itBPay = @"30m";
        
        //将商品信息拼接成字符串
        NSString *orderSpec = [order description];
        
        //用私钥签验订单
        
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(_privatea);
        
        NSString *signedString = [signer signString:orderSpec];
        if (signedString != nil) {
            //最终的订单信息
            self.orderStr = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderSpec, signedString, @"RSA"];
            
        }
        
    }
    
    
    //调起支付宝支付
    [[AlipaySDK defaultService] payOrder:self.orderStr fromScheme:AppScheme callback:^(NSDictionary *resultDic) {
        //支付结束 返回结果
        NSString *strMsg = [NSString string];
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            NSLog(@"支付成功");
            if (_PayResults) {
                _PayResults(0);
            }
            strMsg = @"支付成功";
            //                [self presentMessageTips:@"支付成功"];
            //                [self notifySucceed];
        }else if ([resultDic[@"resultStatus"] isEqualToString:@"8000"]){
            if (_PayResults) {
                _PayResults(1);
            }
            strMsg = @"正在处理中";
            //                [self notifyWaiting];
            //                [self presentFailureTips:@"正在处理中"];
            
        }else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]){
            if (_PayResults) {
                _PayResults(1);
            }
            strMsg = @"订单支付失败";
            //                [self notifyFailed];
            //                [self presentFailureTips:@"订单支付失败"];
        }else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]){
            if (_PayResults) {
                _PayResults(1);
            }
            strMsg = @"您已取消支付";
            //                [self notifyFailed];
            //                [self presentFailureTips:@"您已取消支付"];
            
        }else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]){
            if (_PayResults) {
                _PayResults(1);
            }
            strMsg = @"网络连接出错";
            //                [self notifyFailed];
            //                [self presentFailureTips:@"网络连接出错"];
            
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
    
    
    
    
}

-(void)setPayResults:(BeeServiceBlock)PayResults{
    
    _PayResults = PayResults;
}
@end
