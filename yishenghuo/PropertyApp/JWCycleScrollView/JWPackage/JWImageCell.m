//
//  JWImageCell.m
//  ImageScrollView
//
//  Created by 黄金卫 on 16/4/6.
//  Copyright © 2016年 黄金卫. All rights reserved.
//

#import "JWImageCell.h"
#import "JWCycleScrollView.h"
#import  <objc/runtime.h>


@implementation JWImageCell


#pragma mark- setter_相关

-(void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    //实现异步加载图片，本地缓存，网络下载，设置占位图片

    SEL sel= [self getMethod];
    if (sel)
    {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored"-Warc-performSelector-leaks"
   [_imageView performSelector:sel withObject:imageURL];
    }
    else
    {
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        NSLog(@">>>>  请导入三方库SDWebImage  >>>>");
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    }
}
-(SEL)getMethod
{
    unsigned int methodCount =0;

    //获取方法列表
    Method * methodList =class_copyMethodList(NSClassFromString(@"UIImageView"), &methodCount);
    //遍历数组，提取每个方法的信息
    SEL sel=nil;
    for (int i = 0 ; i <methodCount; i++)
    {
        Method method=methodList[i];
        //获取方法名
        const char * name =sel_getName(method_getName(method));
        NSString * nameStr=[NSString stringWithUTF8String:name];
        if ([nameStr isEqualToString:@"sd_setImageWithURL:"])
        {
           sel= method_getName(method);
        }
    }
    return sel;
}


-(void)setImageName:(NSString *)imageName
{
    _imageName = imageName;

    _imageView.image = [UIImage imageNamed:_imageName];
}

-(void)setPlaceHolderImageName:(NSString *)placeHolderImageName
{
    _placeHolderImageName = placeHolderImageName;
}


#pragma mark- 重写

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createSubViews];
    }
    return self;
}


-(void)createSubViews
{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height )];
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-self.frame.size.width - 10, 10, self.frame.size.width + 20, self.frame.size.height - 20)];
    _leftImageView.hidden = YES;
    _RightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 10, 0, 0, self.frame.size.height)];
    
    _leftImageView.layer.masksToBounds = YES;
    _RightImageView.contentMode = UIViewContentModeLeft;
    if (self.imageMode) {
        _imageView.contentMode = self.imageMode;
        _leftImageView.contentMode = self.imageMode;
    }
    [self.contentView addSubview:_imageView];
//    [self.contentView addSubview:_leftImageView];
//    [self.contentView addSubview:_RightImageView];
//    if (self.contentType == contentNewTypeImage) {
//
//    }
    _imageView.layer.masksToBounds = YES;
    _label=[[UILabel alloc]initWithFrame:CGRectMake(20, self.frame.size.height-30-30, self.frame.size.width-40, 30)];
    _label.textColor=[UIColor whiteColor];
    [self.contentView addSubview:self.label];
}




@end
