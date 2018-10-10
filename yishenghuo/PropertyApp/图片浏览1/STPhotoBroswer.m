//
//  PayViewController.h
//  shop
//
//  Created by FGH on 16/4/13.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//
#import "STPhotoBroswer.h"
#import "STImageVIew.h"
#import "TBCycleView.h"
//1
#import "UIImageView+WebCache.h"

//2
#import "UIImage+GIF.h"
#import "SDImageCache.h"

#define MAIN_BOUNDS   [UIScreen mainScreen].bounds
#define Screen_Width  [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
//图片距离左右 间距
#define SpaceWidth    10
@interface STPhotoBroswer ()<STImageViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NSArray * imageArray;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) TBCycleView * cycleView;
@end
@implementation STPhotoBroswer
- (instancetype)initWithImageArray:(NSArray *)imageArray currentIndex:(NSInteger)index{
    if (self == [super init]) {
        self.imageArray = imageArray;
        if (self.imageArray.count) {
            self.index = index;
            [self setUpView];
        }

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollviewClick)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)scrollviewClick{

    [self dismiss];
}

//--getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
        //这里
        _scrollView.contentSize = CGSizeMake((Screen_Width + 2*SpaceWidth) * (self.imageArray.count), Screen_Height);
      _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        [self numberLabel];
    }
     _scrollView.contentOffset = CGPointMake((Screen_Width + 2*SpaceWidth) * self.index, 0);
    return _scrollView;
}
- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, Screen_Width, 40)];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.index +1,(unsigned long)self.imageArray.count];
        [self addSubview:_numberLabel];
    }
    return _numberLabel;
}
- (void)setUpView{
   // int index = 0;
    for (int i = 0; i < self.imageArray.count; i++) {
        STImageVIew * imageView = [[STImageVIew alloc]init];
        imageView.delegate = self;
       
//        imageView.image = [UIImage imageNamed:self.imageArray[i]];
       // imageView.image = [UIImage imageWithData:self.imageArray[i]];

        if ([self.imageArray[i] isKindOfClass:[UIImage class]]) {
            imageView.image = self.imageArray[i];
        }else{
//            TBCycleView *cycleView = [[TBCycleView alloc]initWithFrame:CGRectMake(SCREEN.size.width/2-50, SCREEN.size.height/2 -50, 100, 100)];
//            cycleView.backgroundColor = [UIColor redColor];
////            cycleView.center = self.center;
//            [imageView addSubview:cycleView];
//            [imageView bringSubviewToFront:cycleView];
//            [imageView sendSubviewToBack:cycleView];
//            [cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(imageView.mas_centerX);
//                make.centerY.equalTo(imageView.mas_centerY);
//            }];
//            [self insertSubview:cycleView aboveSubview:self.scrollView];
            imageView.cycleView.label.text = [NSString stringWithFormat:@"0.00%%"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[i]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            LFLog(@"%ld----%.2f",(long)receivedSize,(double)receivedSize/expectedSize);
                imageView.cycleView.label.text = [NSString stringWithFormat:@"%.2f%%", (double)receivedSize/expectedSize*100];
                [imageView.cycleView drawProgress:(double)receivedSize/expectedSize];
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [cycleView removeFromSuperview];
            if (error ) {
                imageView.cycleView.label.text = [NSString stringWithFormat:@"加载失败~~"];
            }else{
                imageView.cycleView.hidden = YES;
            }
            [imageView setScaleImgV];
            LFLog(@"error：%@",error);
        }];
        }
   [self.scrollView addSubview:imageView];
        
        
    
       // imageView.tag = index;
        
    }
//    for (UIImage * image in self.imageArray) {
//        STImageVIew * imageView = [[STImageVIew alloc]init];
//        imageView.delegate = self;
//        imageView.image = image;
//        imageView.tag = index;
//        [self.scrollView addSubview:imageView];
//        index ++;
//    }
}
#pragma mark ---UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/Screen_Width;
    self.index = index;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass(obj.class) isEqualToString:@"STImageVIew"]) {
            STImageVIew * imageView = (STImageVIew *) obj;
            [imageView resetView];
        }
                }];
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.index+1,(unsigned long)self.imageArray.count];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //主要为了设置每个图片的间距，并且使 图片铺满整个屏幕，实际上就是scrollview每一页的宽度是 屏幕宽度+2*Space  居中。图片左边从每一页的 Space开始，达到间距且居中效果。
    _scrollView.bounds = CGRectMake(0, 0, Screen_Width + 2 * SpaceWidth,Screen_Height);
    _scrollView.center = self.center;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(SpaceWidth + (Screen_Width+20) * idx, 0,Screen_Width,Screen_Height);
    }];
}
- (void)show{
    if (self.imageArray.count) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        [window addSubview:self];
        self.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:.5 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }

}
- (void)dismiss{
     self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:.2 animations:^{
//        [self removeFromSuperview];
        self.transform = CGAffineTransformMakeScale(0.0000000001, 0.00000001);
    }completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
   
}
#pragma mark ---STImageViewDelegate
- (void)stImageVIewSingleClick:(STImageVIew *)imageView{
    [self dismiss];
}
@end
