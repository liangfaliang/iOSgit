//
//  ServiceAlipay_Order.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/9/14.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

typedef	void	(^BeeServiceBlock)( NSInteger state );
@interface ServiceAlipay_Order : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ServiceAlipay_Order);


@property (nonatomic, retain) NSString *	partnera;
@property (nonatomic, retain) NSString *	sellera;
@property (nonatomic, retain) NSString *	appliaynotify_url;
@property (nonatomic, retain) NSString *	privatea;
@property (nonatomic, retain) NSString *	tradeNO;
@property (nonatomic, retain) NSString *	productName;
@property (nonatomic, retain) NSString *	desc;
@property (nonatomic, retain) NSString *	price;
@property (nonatomic, retain) NSString *orderStr;//最终订单信息（包含签名）
@property (nonatomic, copy) BeeServiceBlock				PayResults;
- (void)generate;
-(void)setPayResults:(BeeServiceBlock)PayResults;
@end
