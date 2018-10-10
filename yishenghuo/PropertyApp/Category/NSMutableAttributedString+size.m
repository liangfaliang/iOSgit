//
//  NSMutableAttributedString+size.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/18.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "NSMutableAttributedString+size.h"

@implementation NSMutableAttributedString (size)
-(CGSize )selfadaption:(CGFloat )weith{
    return [self boundingRectWithSize:CGSizeMake(SCREEN.size.width - weith, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading context:nil].size;
}
@end
