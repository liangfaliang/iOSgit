//
//  ZBLookImagesView.m
//  XZBTest
//
//  Created by 肖志斌 on 16/4/20.
//  Copyright © 2016年 xzb. All rights reserved.
//

#import "ZBLookImagesView.h"
#import "Masonry.h"
#import <objc/runtime.h>

@interface ZBLookImagesView () <UIScrollViewDelegate, UIAlertViewDelegate>

/**
 *  指向传入的img数组
 */
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIPageControl *mainPage;
@property (nonatomic, strong) UILabel *tipLab;

/**
 *  设置contenSize
 */
@property (nonatomic, strong) UIImageView *contensizeMaxImgView;

@end

@implementation ZBLookImagesView

#pragma mark - def登陆
- (instancetype)initWithSupView:(UIView *)supView
{
    self = [super init];
    if (self)
    {
        if (supView) [supView addSubview:self];
        
        self.backgroundColor = [UIColor blackColor];
        self.tipLab.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
+ (instancetype)initWithSupView:(UIView *)supView
{
    return [[[self class] alloc] initWithSupView:supView];
}
#pragma mark - override重写
- (void)layoutSubviews
{
    if (self.mainScrollView.contentSize.width != CGRectGetMaxX(self.contensizeMaxImgView.frame))
    {
        self.mainScrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.contensizeMaxImgView.frame), 0);
        [self uploadContentOffSet];
    }
}
#pragma mark - api
- (void)sShow:(NSInteger )page
{
    self.mainPage.currentPage = page;
    UIView *supView = self.superview;
    if (supView)
    {
        [supView bringSubviewToFront:self];
        [UIView transitionWithView:supView duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.hidden = NO;
        } completion:nil];
    }
    
    [self uploadContentOffSet];
}
- (void)sHiden
{
    UIView *supView = self.superview;
    if (supView)
    {
        [supView bringSubviewToFront:self];
        [UIView transitionWithView:supView duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            self.hidden = YES;
        } completion:nil];
    }
}
- (void)sImageArray:(NSMutableArray *)dataArray
{
    if ([dataArray count] > 0)
    {
        if ([self isImageArray:dataArray])
        {
        
            for (id obj in self.mainScrollView.subviews)
            {
                if ([obj isKindOfClass:[UIImageView class]])
                {
                    [(UIImageView *) obj removeFromSuperview];
                }
            }
            
            self.imgArray = dataArray;
            
            __block UIImageView *lastImgView = nil;
            //__weak typeof(self) weakSelf = self;
            [self.imgArray enumerateObjectsUsingBlock:^(UIImage *img, NSUInteger idx, BOOL *_Nonnull stop) {
            
                @autoreleasepool {
                    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
                    imgView.userInteractionEnabled = YES;
                    imgView.contentMode = UIViewContentModeScaleAspectFit;
                    [self.mainScrollView addSubview:imgView];
                    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(self.mainScrollView.mas_width);
                        make.height.equalTo(self.mainScrollView.mas_height).offset(-20);
                        make.top.offset(0);
                        if (lastImgView)
                        {
                            make.left.equalTo(lastImgView.mas_right);
                        }
                        else
                        {
                            make.left.offset(0);
                            
                        }
                    }];
                    
                    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imgPinchGesture:)];
                    pinchGesture.scale = 2;
                    [imgView addGestureRecognizer:pinchGesture];
                    
                    UITapGestureRecognizer *tapGestur = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapGestur:)];
                    [imgView addGestureRecognizer:tapGestur];
                    lastImgView = imgView;
                    
                }
            }];
            
            self.mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * [dataArray count], 0);
            self.contensizeMaxImgView = lastImgView;
            self.mainPage.numberOfPages = [dataArray count];
            
        }
    }
}

#pragma mark - model event
#pragma mark - view event
- (void)imgPinchGesture:(UIPinchGestureRecognizer *)sender
{
    UIImageView *senderView = (UIImageView *) sender.view;
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        senderView.transform = CGAffineTransformMakeScale(sender.scale, sender.scale);
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.5 animations:^{
        
            senderView.transform = CGAffineTransformIdentity;//取消一切形变
        }];
    }
}
- (void)imgTapGestur:(UITapGestureRecognizer *)sender
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除当前图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
//    [alert show];
    [self sHiden];
}
- (void)mainScrollViewSwipeGesture:(UISwipeGestureRecognizer *)sender
{
    //[self sHiden];
}
#pragma mark - private私有
/**
 *  确定都是image
 */
- (BOOL)isImageArray:(NSArray *)arr
{
    for (id obj in arr)
    {
        if (![obj isKindOfClass:[UIImage class]])
        {
            return NO;
        }
    }
    return YES;
}
/**
 *  pageValueChange
 */
- (void)onPageClick:(UIPageControl *)page

{
    NSInteger pg = page.currentPage;
    self.mainScrollView.contentOffset = CGPointMake(pg * CGRectGetWidth(self.frame), 0);
}
/**
 *  更新contenPoint
 */
- (void)uploadContentOffSet
{
    self.mainScrollView.contentOffset = CGPointMake(self.mainPage.currentPage * CGRectGetWidth(self.frame), 0);
}

#pragma mark - getter / setter
- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView)
    {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.backgroundColor = [UIColor blackColor];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
        [self addSubview:_mainScrollView];
        [_mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.offset(64+44);
            make.bottom.offset(0);
        }];
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(mainScrollViewSwipeGesture:)];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
        [_mainScrollView addGestureRecognizer:swipeGesture];
    }
    return _mainScrollView;
}
- (UIPageControl *)mainPage
{
    if (!_mainPage)
    {
        _mainPage = [[UIPageControl alloc] init];
        [self addSubview:_mainPage];
        [_mainPage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(44);
            make.bottom.offset(-44);
        }];
        [_mainPage addTarget:self action:@selector(onPageClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _mainPage;
}
- (UILabel *)tipLab
{
    if (!_tipLab)
    {
        _tipLab = [[UILabel alloc] init];
        _tipLab.text = @"点击图片返回";
        _tipLab.textColor = [UIColor yellowColor];
        _tipLab.backgroundColor = [UIColor blackColor];
        [self addSubview:_tipLab];
        [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.offset(64);
            make.height.offset(44.0);
        }];
    }
    return _tipLab;
}
#pragma mark -  delegete
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int pg = scrollView.contentOffset.x / CGRectGetWidth(self.frame);
    self.mainPage.currentPage = pg;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.imgArray removeObjectAtIndex:self.mainPage.currentPage];
        [self sImageArray:self.imgArray];
    }
}
@end

