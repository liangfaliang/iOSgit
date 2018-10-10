//
//  PayViewController.h
//  shop
//
//  Created by FGH on 16/4/13.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//
#import "STImageVIew.h"
#import "UIView+Extension.h"
#import "TBCycleView.h"
@interface STImageVIew()<UIGestureRecognizerDelegate,UIActionSheetDelegate>{
    CGFloat _lastScale;//记录最后一次的图片放大倍数
}
/**手机屏幕高度不够用的时候 用于显示完整图片*/
@property (nonatomic, strong) UIScrollView * scrollView;
/**完整图片*/
@property (nonatomic, strong) UIImageView * scrollImgV;
/**用于放大 缩小 图片的scrollview*/
@property (nonatomic, strong) UIScrollView * scaleScrollView;
/**用于显示 放大缩小的 图片*/
@property (nonatomic, strong) UIImageView * scaleImgV;
@property (nonatomic, assign) BOOL doubleAction;
@property (nonatomic,strong)UILongPressGestureRecognizer * longTap;


@end
@implementation STImageVIew
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UIPinchGestureRecognizer * ges = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaleImageViewAction:)];
        ges.delegate = self;
        _lastScale = 1.f;
        [self addGestureRecognizer:ges];
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleClick:)];
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClick:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        
       self.longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longClick:)];
        
        [self addGestureRecognizer:self.longTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];

    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
      
    }
    return self;
}
-(TBCycleView *)cycleView{
    if (_cycleView == nil) {
        _cycleView =  [[TBCycleView alloc]initWithFrame:CGRectMake(SCREEN.size.width/2 - 50, SCREEN.size.height/2 - 50, 100, 100)];
        _cycleView.backgroundColor = [UIColor clearColor];
        [self addSubview:_cycleView];
    }
    return _cycleView;
}
-(void)instend{

}
//getter
//- (UIScrollView *)scrollView{
//    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
//        [self addSubview:_scrollView];
//    }
//    return _scrollView;
//}
//- (UIImageView *)scrollImgV{
//    if (!_scrollImgV) {
//        _scrollImgV = [[UIImageView alloc]init];
//        _scrollImgV.image = self.image;
//        [self.scrollView addSubview:_scrollImgV];
//    }
//    return _scrollImgV;
//}
-(void)setScaleImgV{
    _scaleImgV.image = self.image;
}
- (UIScrollView *)scaleScrollView{
    if (!_scaleScrollView) {
        _scaleScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _scaleScrollView.bounces = NO;
        _scaleScrollView.backgroundColor = [UIColor blackColor];
        _scaleScrollView.contentSize =  self.bounds.size;
        [self addSubview:_scaleScrollView];
        [self addSubview:self.cycleView];
    }
    return _scaleScrollView;
}
- (UIImageView *)scaleImgV{
    if (!_scaleImgV) {
        _scaleImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _scaleImgV.center = self.scaleScrollView.center;
//        _scaleImgV.bounds = CGRectMake(0, 0, 60, 60);
        _scaleImgV.image = self.image;
        [self.scaleScrollView addSubview:_scaleImgV];
    }
    return _scaleImgV;
}
- (void)layoutSubviews{
    [super layoutSubviews];
  //  CGSize imageSize = self.image.size;
//    //图片高度大于屏幕高度
//    if (self.width * (imageSize.height / imageSize.width) > self.height) {
//        [self scrollView];
//        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.width * (imageSize.height / imageSize.width));
//        self.scrollImgV.center = self.scrollView.center;
//        self.scrollImgV.bounds = CGRectMake(0, 0, imageSize.width, self.width * (imageSize.height / imageSize.width));
//    }else{
   // NSLog(@"--------%lf",self.image.size.width);
        self.scaleImgV.center = self.scaleScrollView.center;
    if (self.image.size.width > SCREEN.size.width || self.image.size.height > SCREEN.size.height)
    {
        if (self.image.size.width > SCREEN.size.width)
        {
            self.scaleImgV.bounds = CGRectMake(0, 0, SCREEN.size.width, self.image.size.height*(SCREEN.size.width/self.image.size.width));
            if (self.image.size.height*(SCREEN.size.width/self.image.size.width) > SCREEN.size.height)
            {
                self.scaleImgV.bounds = CGRectMake(0, 0,self.image.size.width*( SCREEN.size.height/self.image.size.height), SCREEN.size.height);
            }
        }else if (self.image.size.height > SCREEN.size.height)
        {
            self.scaleImgV.bounds = CGRectMake(0, 0, self.image.size.width*( SCREEN.size.height/self.image.size.height), SCREEN.size.height);
            if (self.image.size.width > SCREEN.size.width)
            {
                self.scaleImgV.bounds = CGRectMake(0, 0, SCREEN.size.width, self.image.size.height*(SCREEN.size.width/self.image.size.width));
                
            }
            
        }
    }else{
        self.scaleImgV.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
}
        //if (_scrollView)[_scrollView removeFromSuperview];
//    }
    
}
#pragma mark ---action
-(void)scaleImageViewAction:(UIPinchGestureRecognizer*)sender {
    
    CGFloat scale = sender.scale;//得到的是当前手势放大倍数
    NSLog(@"--------%f",scale);
    CGFloat shouldScale = _lastScale + (scale - 1);//我们需要知道的是当前手势相收缩率对于刚才手势的相对收缩 scale - 1，然后加上最后一次收缩率，为当前要展示的收缩率
    [self setScaleImageWithScale:shouldScale];
    sender.scale = 1.0;//图片大小改变后设置手势scale为1
}
- (void)setScaleImageWithScale:(CGFloat)scale{
    //最大2倍最小.5
    if (scale >=2) {
        scale = 2;
    }else if(scale <=.5){
        scale = .5;
    }

    _lastScale = scale;
    self.scaleImgV.transform = CGAffineTransformMakeScale(scale, scale);
    if (scale > 1) {
        CGFloat imageWidth = self.scaleImgV.width;
        CGFloat imageHeight =  MAX(self.scaleImgV.height, self.frame.size.height);
        [self bringSubviewToFront:self.scaleScrollView];
        self.scaleImgV.center = CGPointMake(imageWidth * 0.5, imageHeight * 0.5);
        self.scaleScrollView.contentSize = CGSizeMake(imageWidth, imageHeight);
        CGPoint offset = self.scaleScrollView.contentOffset;
        offset.x = (imageWidth - self.width)/2.0;
        offset.y = (imageHeight - self.height)/2.0;
        self.scaleScrollView.contentOffset = offset;
        
    }else{
        self.scaleImgV.center = self.scaleScrollView.center;
        self.scaleScrollView.contentSize = CGSizeZero;
    }
   
    
}
- (void)singleClick:(UITapGestureRecognizer *)tap{
    if (_delegate &&[_delegate respondsToSelector:@selector(stImageVIewSingleClick:)]) {
        [_delegate stImageVIewSingleClick:self];
    }
}

- (void)doubleClick:(UITapGestureRecognizer *)tap{
    if (_lastScale > 1) {
        _lastScale = 1;
        
    }else{
        _lastScale = 2;
    }
    
    
    [UIView animateWithDuration:.5 animations:^{
         [self setScaleImageWithScale:_lastScale];
        
    }completion:^(BOOL finished) {
        if (_lastScale == 1) {
            [self resetView];
        }
    }];
   
}
- (void)longClick:(UITapGestureRecognizer *)tap{
    if (self.longTap.state == UIGestureRecognizerStateBegan) {

        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:nil, nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self];

    }else {
        
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    switch (buttonIndex) {
        case 0:
            NSLog(@"点击了确定");
            UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
            NSLog(@"single click %@",self.image);
            break;
            
        case 1:
            NSLog(@"点击了取消");
            break;
            
        default:
            break;
    }
    
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];

    if(error != NULL){
        hud.labelText = NSLocalizedString(@"图片保存失败", @"HUD loading title");

//        [self presentFailureTips:@"图片保存失败"];

    }else{
        hud.labelText = NSLocalizedString(@"图片保存成功", @"HUD loading title");
//        [self presentSuccessTips:@"图片保存成功"];
        
    }
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [hud hide:YES];
    });
        
}
//当达到原图大小 清除 放大的图片 和scrollview
- (void)resetView{
    if (!self.scaleScrollView) {
        return;
    }
    self.scaleScrollView.hidden = YES;
    [self.scaleScrollView removeFromSuperview];
    self.scaleScrollView = nil;
    self.scaleImgV = nil;
}
-(void)dealloc{
    [_cycleView removeFromSuperview];
    _cycleView = nil;

}
@end
