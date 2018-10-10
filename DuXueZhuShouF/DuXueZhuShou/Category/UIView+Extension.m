//
//  UIView+Extension.m
//  Weibo
//
//  Created by lanou3g on 15/5/13.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
@dynamic backgroundImage;
-(void)setBackgroundImage:(UIImage *)backgroundImage{
    
    self.layer.contents = (id) backgroundImage.CGImage;
    
}
-(void)setViewBorderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth;
}
CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect,CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x - CGRectGetMidX(rect);
    newrect.origin.y = center.y - CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}



- (CGPoint)topCenter
{
    CGFloat x = self.frame.origin.x + self.frame.size.width/2;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x,y);
}

- (CGPoint)bottomCenter
{
    CGFloat x = self.frame.origin.x + self.frame.size.width/2;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x , y);
}

- (CGPoint)leftCenter
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height/2;
    return CGPointMake(x, y);
}

- (CGPoint)rightCenter
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height/2;
    return CGPointMake(x , y);
}

- (CGPoint) origin_i
{
    return self.frame.origin;
}

- (void) setOrigin_i:(CGPoint)origin_i
{
    CGRect newframe = self.frame;
    newframe.origin = origin_i;
    self.frame = newframe;
}

- (CGSize) size_i
{
    return self.frame.size;
}

- (void) setSize_i:(CGSize)size_i
{
    CGRect newframe = self.frame;
    newframe.size = size_i;
    self.frame = newframe;
}

- (CGPoint) bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

- (CGFloat)height_i
{
    return self.frame.size.height;
}

- (void)setHeight_i:(CGFloat)height_i
{
    CGRect newframe = self.frame;
    newframe.size.height = height_i;
    self.frame = newframe;
    
}

- (CGFloat)width_i
{
    return self.frame.size.width;
}

- (void)setWidth_i:(CGFloat)width_i
{
    CGRect newframe = self.frame;
    newframe.size.width = width_i;
    self.frame = newframe;
}

- (CGFloat)top_i
{
    return self.frame.origin.y;
}

- (void)setTop_i:(CGFloat)top_i
{
    CGRect newframe = self.frame;
    newframe.origin.y = top_i;
    self.frame = newframe;
}

- (CGFloat)left_i
{
    return self.frame.origin.x;
}

- (void)setLeft_i:(CGFloat)left_i
{
    CGRect newframe = self.frame;
    newframe.origin.x = left_i;
    self.frame = newframe;
}

- (CGFloat)right_i
{
    return self.frame.origin.x + self.frame.size.width;
};

- (void)setRight_i:(CGFloat)right_i
{
    CGFloat delta = right_i-(self.frame.origin.x+self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta;
    self.frame = newframe;
}

- (CGFloat)bottom_i
{
    return self.frame.origin.y+self.frame.size.height;
}

- (void)setBottom_i:(CGFloat)bottom_i
{
    CGRect newframe = self.frame;
    newframe.origin.y = bottom_i - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)center_X
{
    return self.center.x;
}

- (void)setCenter_X:(CGFloat)center_X
{
    CGPoint pt = self.center;
    pt.x = center_X;
    self.center = pt;
}

- (CGFloat)center_Y
{
    return self.center.y;
}

- (void)setCenter_Y:(CGFloat)center_Y
{
    CGPoint pt = self.center;
    pt.y = center_Y;
    self.center = pt;
}

- (void)moveBy:(CGPoint)delta
{
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

- (void) scaleBy:(CGFloat)scaleFactor
{
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}


- (void)fitInsize:(CGSize)aSize
{
    CGFloat scale;
    CGRect newframe = self.frame;
    
    if (newframe.size.height && (newframe.size.height > aSize.height))
    {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize.width))
    {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    self.frame = newframe;
}

- (void)setX_i:(CGFloat)x_i
{
    CGRect frame = self.frame;
    frame.origin.x = x_i;
    self.frame = frame;
}
- (CGFloat)x_i
{
    return  self.frame.origin.x;
}

- (void)setY_i:(CGFloat)y_i
{
    CGRect frame = self.frame;
    frame.origin.y = y_i;
    self.frame = frame;
}
- (CGFloat)y_i
{
    return self.frame.origin.y;
}
#pragma mark - 手势
#pragma mark 点击手势
- (UITapGestureRecognizer *)ddy_AddTapTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    return tap;
}

#pragma mark 点击手势 + 代理
- (UITapGestureRecognizer *)ddy_AddTapTarget:(id)target action:(SEL)action delegate:(id)delegate {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tap.delegate = delegate;
    [self addGestureRecognizer:tap];
    return tap;
}

#pragma mark 点击手势 + 点击数
- (UITapGestureRecognizer *)ddy_AddTapTarget:(id)target action:(SEL)action number:(NSInteger)number {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tap.numberOfTapsRequired = number;
    [self addGestureRecognizer:tap];
    return tap;
}

#pragma mark 点击手势 + 点击数 + 代理
- (UITapGestureRecognizer *)ddy_AddTapTarget:(id)target action:(SEL)action number:(NSInteger)number  delegate:(id)delegate {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tap.numberOfTapsRequired = number;
    tap.delegate = delegate;
    [self addGestureRecognizer:tap];
    return tap;
}

#pragma mark 长按手势
- (UILongPressGestureRecognizer *)ddy_AddLongGestureTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:longGes];
    return longGes;
}

#pragma mark 长按手势 + 长按最短时间
- (UILongPressGestureRecognizer *)ddy_AddLongGestureTarget:(id)target action:(SEL)action minDuration:(CFTimeInterval)minDuration {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:target action:action];
    longGes.minimumPressDuration = minDuration;
    [self addGestureRecognizer:longGes];
    return longGes;
}

#pragma mark 拖动手势
- (UIPanGestureRecognizer *)ddy_AddPanGestureTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:panGes];
    return panGes;
}

#pragma mark 拖动手势 + 代理
- (UIPanGestureRecognizer *)ddy_AddPanGestureTarget:(id)target action:(SEL)action delegate:(id)delegate {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    panGesture.delegate = delegate;
    [self addGestureRecognizer:panGesture];
    return panGesture;
}

#pragma mark - 截屏
#pragma mark 截屏生成图片
- (UIImage *)ddy_SnapshotImage {
    UIGraphicsBeginImageContext(self.bounds.size);
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    } else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    image = [UIImage imageWithData:imageData];
    return image;
}

#pragma mark 截屏生成PDF
- (NSData *)ddy_SnapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData* data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

#pragma mark 整个截屏
+ (UIImage *)ddy_ScreenshotInPNGFormat {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize imageSize = UIInterfaceOrientationIsPortrait(orientation) ? [UIScreen mainScreen].bounds.size : CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in UIApplication.sharedApplication.windows) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIImage imageWithData:UIImagePNGRepresentation(image)];
}

#pragma mark - UI
#pragma mark 阴影
- (void)ddy_LayerShadow:(UIColor *)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

#pragma mark 部分圆角 UIRectCornerBottomLeft | UIRectCornerBottomRight
- (void)ddy_RoundCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)].CGPath;
    self.layer.mask = maskLayer;
}

@end

