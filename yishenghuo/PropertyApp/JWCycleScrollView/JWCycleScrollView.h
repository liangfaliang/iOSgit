//
//  JWCycleScrollView.h
//  ImageScrollView
//
//  Created by 黄金卫 on 16/4/6.
//  Copyright © 2016年 黄金卫. All rights reserved.
//
//
// 简介：通用轮播控件
// * 1.内嵌一个PageControl，可以通过showPagecontrol这个属性设置是否需要显示PageControl，默认显示（图片张数大于1时）
// * 2.支持图片数组和图片地址数组，采用sdwebImage库做图片的下载与缓存；
// * 3.支持自动轮播的暂停和启动
// * 4.支持横向轮播和纵向轮播
// * 5.使用该控件要添加SDWebImage的引用
//
// 实现思路:
// * 轮播模式a:collectionView有无限个Item，每次Item显示的时候通过索引取相应的图片，滚动时复用item
// * 轮播模式b:collectionview的Item个数为实际图片的个数，
// *
// *
// 轮播的规则：
// * 右滑--当collectionview从item1 滚动到item2的位置后，这个时候做一个无动画滚动，让位置继续滚回到item1，
// * 然后下次右滑的时候依然按照这个流程走，这样就可以保证在从最后一张滑动到第一张的时候，滚动动画的正常。左滑同右滑，只是方向变换一下。
// * 1.当图片个数为1的时候，不能自动轮播
// * 2.当图片个数为2的时候，采用轮播模式a。
// * 3.当图片个数大于2张的时候，采用轮播模式b。
// */
//
///*********************************************************************///
///                                                                     ///
///    注意：当使用网路图片轮播时，只需将第三方  SDWebImage   导入工程中即可     ///
///                                                                     ///
///               如需其他显示内容请自定制cell                              ///
///             pageControl 最多可容纳18个分页符，                         ///
///*********************************************************************///

#import <UIKit/UIKit.h>


typedef enum {
    pageControlAlignmentTypeRight,    //默认
    pageControlAlignmentTypeCenter,
    pageControlAlignmentTypeLeft
}PageControlAlignmentType;

typedef enum {
    JWCycleScrollDirectionHorizontal, //默认
    JWCycleScrollDirectionVertical
}JWCycleScrollDirection;

typedef enum {
    contentTypeImage ,   //默认
    contentNewTypeImage ,   //新样式
    contentTypeText,
    contentattriTypeText
}ContentType;



@class JWCycleScrollView;

@protocol JWCycleScrollImageDelegate <NSObject>

@optional

/**
 *  返回本地图片数组
 */
- (NSArray<UIImage*>*)imageArrayInCycleScrollView:(JWCycleScrollView*)cycleScrollView;

/**
 *  返回网络图片的URLString数组
 */
- (NSArray<NSString *>*)imageURLArrayInCycleScrollView:(JWCycleScrollView*)cycleScrollView;

/**
 *  返回文字数组 （必须contentType==contentTypeText时有效）
 */
- (NSArray<NSString*>*) textArrayInCycleScrollView:(JWCycleScrollView*)cycleScrollView;

/**
 *  点击事件（选中index页）
 */
- (void)cycleScrollView:(JWCycleScrollView*)cycleScrollView didSelectIndex:(NSInteger)index;

/**
 * cycleScrollView 已经滚动到index页
 */
- (void)cycleScrollView:(JWCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;

@end



@interface JWCycleScrollView : UIView


@property (nonatomic, weak) id<JWCycleScrollImageDelegate> delegate;

//if contentType is contentImage
@property (nonatomic, strong) NSArray * labelTextArray;
@property (nonatomic, strong) NSArray * localImageArray;
@property (nonatomic, strong) NSArray * imageURLArray;
@property (nonatomic, strong) UIColor  * placeHolderColor;
@property (nonatomic, copy)   NSString * placeHolderImageName;


//两行文字
@property (nonatomic, strong) NSMutableArray * lablearr1;
@property (nonatomic, strong) NSMutableArray * lablearr2;
@property (nonatomic, assign) CGFloat  textH;//文字行间距
//if contentType is contentText
@property (nonatomic, strong) NSArray * jwTextArray;
@property (nonatomic, strong) UIFont * jwtextFont;
@property (nonatomic, strong) UIColor * jwtextcolor;
@property (nonatomic, assign) CGFloat numberOfLines;
@property (nonatomic, assign,getter=NSTextAlignmentLeft) NSTextAlignment   textAlignment;
@property (nonatomic, assign) BOOL showPageControl;           //显示分页_YES ( except_1 )
@property (nonatomic, assign) BOOL infiniteLoop;              //是否轮播_YES
@property (nonatomic, assign) CGFloat autoScrollTimeInterval; //轮播时间间隔_3.0f

@property (nonatomic, assign) PageControlAlignmentType pageControlAlignmentType;
@property (nonatomic, assign) JWCycleScrollDirection  jwCycleScrollDirection;  //轮播滚动方向（横向|纵向）
@property (nonatomic, assign) ContentType contentType;          //轮播内容样式

@property (nonatomic) UIViewContentMode imageMode;//图片显示样式

/**
 *   轮播相关接口
 */

-(BOOL)isAutoCarouseling;   //是否轮播
-(void)startAutoCarousel;   //开始轮播 【不写_不会启动】
-(void)stopAutoCarousel;    //停止轮播


/**
 *   清理缓存相关接口 ——单位:M
 */

//自建路径
+(CGFloat)getCacheSizeAtPath:(NSString *)path;
+(BOOL)clearCacheAtPath:(NSString *)path;

//默认路径（沙盒库）
+(CGFloat)getCacheSize;
+(BOOL)clearCache;

@end






