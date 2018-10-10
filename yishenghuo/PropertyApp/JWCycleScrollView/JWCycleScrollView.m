//
//  JWCycleScrollView.m
//  ImageScrollView
//
//  Created by 黄金卫 on 16/4/6.
//  Copyright © 2016年 黄金卫. All rights reserved.
//

#import "JWCycleScrollView.h"
#import "JWCacheManager.h"
#import "JWImageCell.h"
#import "JWTextCell.h"
#import "CustomFlowLayout.h"
#import "JWattributedCell.h"
@interface JWCycleScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>{
    JWImageCell *currentCell;
}

@property (nonatomic, retain) UICollectionView * cycleCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
@property (nonatomic, strong) CustomFlowLayout * Customlayout;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) BOOL isTimeUp;

@property (nonatomic, assign) NSInteger lastOffSet;

@end


@implementation JWCycleScrollView

#pragma mark- 对外开放的方法

-(BOOL)isAutoCarouseling
{
    if (self.cycleCollectionView)
    {
        if ([self imageCount]<2)
        {
            return NO;
        }
        else
        {
            if (self.timer)
            {
                return YES;
            }
            else
            {
                
                return NO;
            }
        }
    }
    else
    {
        return NO;
    }
}

-(void)startAutoCarousel
{
    if (_infiniteLoop)
    {
        if ([self imageCount] >= 2)
        {
            [self startTimer];
        }
    }
    else
    {
        [self stopTimer];
    }
}

-(void)stopAutoCarousel
{
    [self stopTimer];
}


-(NSMutableArray *)lablearr1{
    
    if (_lablearr1 == nil) {
        _lablearr1 = [[NSMutableArray alloc]init];
    }
    
    return _lablearr1;
}

-(NSMutableArray *)lablearr2{
    
    if (_lablearr2 == nil) {
        _lablearr2 = [[NSMutableArray alloc]init];
    }
    
    return _lablearr2;
}
#pragma mark- SET方法

-(void)setLocalImageArray:(NSArray *)localImageArray
{
    _localImageArray=localImageArray;
    
    if (self.pageControl &&[self imageCount]>=2&&(self.contentType==contentTypeImage || self.contentType==contentNewTypeImage))
    {
        self.pageControl.numberOfPages=[self imageCount];
    }
    
    [self resetViewStateAndStartAutoCarousel];
}

-(void)setImageURLArray:(NSArray *)imageURLArray
{
    _imageURLArray =imageURLArray;
    
    if (self.pageControl && [self imageCount]>=2&&(self.contentType==contentTypeImage || self.contentType==contentNewTypeImage))
    {
        self.pageControl.numberOfPages=[self imageCount];
    }
    if (self.placeHolderImageName == nil) {
        self.placeHolderImageName = @"placeholderImage";
    }
}

-(void)setJwTextArray:(NSArray *)jwTextArray
{
    _jwTextArray=jwTextArray;
    if (self.pageControl&&jwTextArray.count>=2&&self.contentType==contentTypeText)
    {
        self.pageControl.numberOfPages=jwTextArray.count;
    }
}

-(void)setJwtextFont:(UIFont *)jwtextFont
{
    _jwtextFont=jwtextFont;
}

-(void)setJwCycleScrollDirection:(JWCycleScrollDirection)jwCycleScrollDirection
{
    _jwCycleScrollDirection=jwCycleScrollDirection;
    
    if (jwCycleScrollDirection==JWCycleScrollDirectionVertical)
    {
        _layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    }else
    {
        _layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    }
}

-(void)setPageControlAlignmentType:(PageControlAlignmentType)pageControlAlignmentType
{
    _pageControlAlignmentType=pageControlAlignmentType;
    
}

-(void)setContentType:(ContentType)contentType
{
    _contentType=contentType;
    if (self.contentType == contentNewTypeImage) {
        _Customlayout =[[CustomFlowLayout alloc] init];
        _Customlayout.itemSize=CGSizeMake(self.frame.size.width - 40, self.frame.size.width);
        _Customlayout.minimumInteritemSpacing = 10;
        _Customlayout.minimumLineSpacing = 10;
        [_cycleCollectionView setCollectionViewLayout:_Customlayout];
//        _cycleCollectionView=[[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_Customlayout];
    }else{
        self.showPageControl = NO;
    }
    [self registerClassForCell];
}


-(void)setDelegate:(id<JWCycleScrollImageDelegate>)delegate
{
    _delegate=delegate;
    if (_delegate)
    {
        [self configureArray];
    }
}



#pragma mark- 重写



-(void)layoutSubviews
{
    [super layoutSubviews];
    _layout.itemSize=self.frame.size;
    LFLog(@"itemSize:%@",NSStringFromCGSize(_layout.itemSize));
    _cycleCollectionView.frame=self.bounds;
    CGFloat width=20.0f*[self imageCount];
    //设定分页位置
    _pageControl.frame=CGRectMake(self.frame.size.width-width, CGRectGetMaxY(_cycleCollectionView.frame)-30, width, 30);
    _pageControl.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - 15);
    
    if (self.pageControlAlignmentType==pageControlAlignmentTypeCenter)
    {
        //        _pageControl.frame=CGRectMake(_cycleCollectionView.frame.size.width/2-30, CGRectGetMaxY(_cycleCollectionView.frame)-30, width, 30);
        _pageControl.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - 30);
    }else if (self.pageControlAlignmentType==pageControlAlignmentTypeLeft)
    {
        _pageControl.frame=CGRectMake(20, CGRectGetMaxY(_cycleCollectionView.frame)-30, width, 30);
    }
    //设置偏移量
    NSInteger num=[self imageCount]*50;
    
    if (self.imageCount == 0) {
        _cycleCollectionView.backgroundColor = [UIColor whiteColor];
    }
    if (self.jwCycleScrollDirection==JWCycleScrollDirectionVertical)
    {
//        _cycleCollectionView.contentOffset=CGPointMake(0, _cycleCollectionView.frame.size.height*1.5);
    }else
    {
        _cycleCollectionView.contentOffset=CGPointMake(_cycleCollectionView.frame.size.width*num, 0);
    }
    
    
    _pageControl.hidden=!_showPageControl;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self initAttribute];
        //添加子视图
        [self createCycleView];
        [self createPageControl];
    }
    return self;
}



#pragma mark- 其他

-(void)resetViewStateAndStartAutoCarousel
{
    if (self.cycleCollectionView)
    {
        [_cycleCollectionView reloadData];
        [self startAutoCarousel];
    }
    
    if (self.pageControl && [self imageCount] > 1)
    {
        [self.pageControl setHidden:!_showPageControl];
    }
    
    if ([self imageCount] <=1 )
    {
        [self.pageControl setHidden:YES];
    }
}

//统计数组元素个数
-(NSInteger)imageCount
{
    if (_localImageArray)
    {
        return [_localImageArray count];
    }
    else if (_imageURLArray)
    {
        return [_imageURLArray count];
    }else if (_jwTextArray&&self.contentType==contentTypeText)
    {
        return _jwTextArray.count;
    }else if (_lablearr1&&self.contentType==contentattriTypeText)
    {
        return _lablearr1.count;
    }else
        return 0;
}



//协议获取数组
-(void)configureArray;
{
    //协议
    if (self.delegate&&[self.delegate respondsToSelector:@selector(imageArrayInCycleScrollView:)])
    {
        self.localImageArray=[self.delegate imageArrayInCycleScrollView:self];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(imageURLArrayInCycleScrollView:)])
    {
        self.imageURLArray=[self.delegate imageURLArrayInCycleScrollView:self];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textArrayInCycleScrollView:)])
    {
        self.jwTextArray=[self.delegate textArrayInCycleScrollView:self];
    }
}


//初始化属性
-(void)initAttribute
{
    self.showPageControl =YES;
    self.infiniteLoop =YES;
    self.autoScrollTimeInterval = 3.0f;
    self.pageControlAlignmentType = pageControlAlignmentTypeRight;
    self.jwCycleScrollDirection=JWCycleScrollDirectionHorizontal;
    
    _jwtextFont=[UIFont systemFontOfSize:17];
    _contentType=contentTypeImage;
    
    _currentIndex = 0;
    _lastOffSet=0;
}

//创建CollectionView
-(void)createCycleView
{
    if (_layout)
    {
        _layout=nil;
        _cycleCollectionView=nil;
    }
    _layout=[[UICollectionViewFlowLayout alloc]init];
    _layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
//    _layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    _cycleCollectionView=[[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_layout];
    _cycleCollectionView.delegate=self;
    _cycleCollectionView.dataSource=self;
    _cycleCollectionView.pagingEnabled=YES;
    _cycleCollectionView.showsHorizontalScrollIndicator=NO;
    _cycleCollectionView.userInteractionEnabled=YES;
    _cycleCollectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:_cycleCollectionView];
    //停靠模式，宽高自由
    _cycleCollectionView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self registerClassForCell];
}

//注册cell
-(void)registerClassForCell
{
    if (self.contentType==contentTypeImage || self.contentType==contentNewTypeImage)
    {
        [_cycleCollectionView registerClass:[JWImageCell class] forCellWithReuseIdentifier:@"CycleImageCell"];
    }else if(self.contentType == contentTypeText)
    {
        [_cycleCollectionView registerClass:[JWTextCell class] forCellWithReuseIdentifier:@"CycleTextCell"];
    }else{
        [_cycleCollectionView registerNib:[UINib nibWithNibName:@"JWattributedCell" bundle:nil] forCellWithReuseIdentifier:@"JWattributedCell"];
    }
    [_cycleCollectionView registerNib:[UINib nibWithNibName:@"JWattributedCell" bundle:nil] forCellWithReuseIdentifier:@"JWattributedCell"];
}

//创建pageControl
-(void)createPageControl
{
    if (_pageControl)
    {
        [_pageControl removeFromSuperview];
    }
    _pageControl=[[UIPageControl alloc]init];
    _pageControl.userInteractionEnabled=YES;
    _pageControl.currentPageIndicatorTintColor =[UIColor whiteColor];//当前页码颜色
    _pageControl.pageIndicatorTintColor=[UIColor darkGrayColor];   //普通页码颜色
    
    [self addSubview:_pageControl];
}
//偏移量转换
-(NSInteger)indexWithOffset:(NSInteger)offset
{
    if (_localImageArray)
    {
        return (offset % [_localImageArray count]);
    }
    else if (_imageURLArray)
    {
        return (offset % [_imageURLArray count]);
    }else if (_jwTextArray )
    {
        return (offset % [_jwTextArray count]);
    }else if (_lablearr1 )
    {
        return (offset % [_lablearr1 count]);
    }
    else
    {
        return 0;
    }
}


#pragma mark- 启动定时器

-(void)startTimer
{
    if (_timer) {
        
        return;
    }
    _isTimeUp=YES;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(roll) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)stopTimer
{
    if (_timer == nil)
    {
        return;
    }
    
    [_timer invalidate];
    _timer = nil;
}

// 定时器 响应方法

-(void)roll
{
    if (_cycleCollectionView)
    {
        //取出当前显示的cell
        NSIndexPath * indexPath=[_cycleCollectionView indexPathsForVisibleItems].lastObject;
//        LFLog(@"indexPath.item:%ld",(long)indexPath.item);
        if (indexPath)
        {
            //显示下一张
            [_cycleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:0]
                                         atScrollPosition:0
                                                 animated:YES];
//            NSIndexPath *nextindexpath = [NSIndexPath indexPathForRow:indexPath.item+1 inSection:0];
//            JWImageCell*cell1 = (JWImageCell*)[_cycleCollectionView cellForItemAtIndexPath:nextindexpath];
//            [cell1.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.offset(20);
//                make.right.offset(-20);
//            }];

            
        }
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollViewDidScroll:_cycleCollectionView];
            [self scrollViewDidEndDecelerating:_cycleCollectionView];
        });
    }
}


#pragma mark-   UICollectionView   协议方法

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self imageCount] >=2)
    {
        return INT16_MAX;
    }
    return [self imageCount];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index =[self indexWithOffset:indexPath.item];

    //
    if (self.contentType==contentTypeImage || self.contentType==contentNewTypeImage)
    {
        JWImageCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CycleImageCell" forIndexPath:indexPath];
        cell.placeHolderImageName = _placeHolderImageName;
        cell.leftImageView.hidden = YES;
        cell.backgroundColor=_placeHolderColor;
        if (self.imageMode) {
            cell.imageMode = self.imageMode;
        }
        cell.label.text=_labelTextArray[index];
        if (_imageURLArray)
        {
            cell.imageURL=_imageURLArray[index];
            
        }else if (_localImageArray)
        {
            cell.imageName=_localImageArray[index];
        }
        if (self.contentType == contentNewTypeImage) {
            NSInteger next = index +1;
            
//            if (_imageURLArray)
//            {
//                if (next > _imageURLArray.count) {
//                    next = 0;
//                }
//                if (index > 0) {
//                    [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray[index - 1]] placeholderImage:[UIImage imageNamed:_placeHolderImageName]];
//                }else{
//                    [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray.lastObject] placeholderImage:[UIImage imageNamed:_placeHolderImageName]];
//                }
//                [cell.RightImageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray[next]] placeholderImage:[UIImage imageNamed:_placeHolderImageName]];
//            }else if (_localImageArray)
//            {
//                if (next > _localImageArray.count) {
//                    next = 0;
//                }
//                if (index > 0) {
//                   cell.leftImageView.image = _localImageArray[index-1];
//                }

//                cell.RightImageView.image =_localImageArray[next];
//            }
            
//            if (cell == currentCell) {
//                cell.imageView.x = 20;
//                cell.imageView.width = cell.frame.size.width - 40;
//            }else{
//                cell.imageView.x = -10;
//                cell.imageView.width = cell.frame.size.width + 20;
//                currentCell.imageView.height = cell.height - 20 ;
//                cell.imageView.y = 10;
//            }
//            [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.offset(0);
//                make.bottom.offset(-30);
//                make.left.offset(-10);
//                make.right.offset(10);
//
//            }];

        }
        return cell;
        
    }else if(self.contentType == contentTypeText){
        JWTextCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CycleTextCell" forIndexPath:indexPath];
        
        if (_lablearr1.count || _lablearr2.count) {
            if ([_lablearr1[index] isKindOfClass:[NSMutableAttributedString class]]) {
                cell.labelView.attributedText = _lablearr1[index];
            }else{
                NSString *str1 = [NSString string];
                NSString *str2 = [NSString string];
                if (index + 1 <= _lablearr1.count) {
                    str1 = [NSString stringWithFormat:@"%@",_lablearr1[index]];
                }
                if (index + 1 <= _lablearr2.count) {
                    str2 = [NSString stringWithFormat:@"%@",_lablearr2[index]];
                }
                NSString *textStr =[NSString string];
                CGFloat textHH = 0;
                if (str2.length) {
                    textHH = _textH;
                    textStr = [NSString stringWithFormat:@"%@\n%@",str1,str2];
                }else{
                    textStr = [NSString stringWithFormat:@"%@",str1];
                }
                NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:textStr];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:textHH];
                [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];
                cell.labelView.attributedText = text;
            }
            
            
        }else{
            if ([self.jwTextArray[index] isKindOfClass:[NSAttributedString class]]) {
                cell.labelView.attributedText = self.jwTextArray[index];
            }else if ([self.jwTextArray[index] isKindOfClass:[NSString class]]){
            
                cell.labelView.text=self.jwTextArray[index];
            }
        }
        if (self.numberOfLines) {
            cell.labelView.numberOfLines = self.numberOfLines;
        }
        if (self.jwtextFont) {
            cell.labelView.font = self.jwtextFont;
        }
        if (self.textAlignment) {
            cell.labelView.textAlignment = self.textAlignment;
        }
        if (self.jwtextcolor) {
            cell.labelView.textColor = self.jwtextcolor;
        }
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else{
        JWattributedCell *cell001 = [collectionView dequeueReusableCellWithReuseIdentifier:@"JWattributedCell" forIndexPath:indexPath];
        NSDictionary * dt = nil;
        if (_lablearr1.count  > index) {
            dt = _lablearr1[index];
            cell001.lflb0.text = dt[@"tag"];
            cell001.rightlb0.text = dt[@"title"];
            cell001.lf0width.constant = [cell001.lflb0.text selfadap:12 weith:20].width + 5;
        }
        if (_lablearr2.count  > index) {
            dt = _lablearr2[index];
            cell001.lflb1.text = dt[@"tag"];
            cell001.rightlb1.text = dt[@"title"];
            cell001.lf1width.constant = [cell001.lflb1.text selfadap:12 weith:20].width + 5;
            cell001.lflb1.hidden = NO;
            cell001.rightlb1.hidden = NO;
        }else{
            cell001.lflb1.hidden = YES;
            cell001.rightlb1.hidden = YES;
        }
        
        return cell001;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(cycleScrollView:didSelectIndex:)])
    {
        [self.delegate cycleScrollView:self didSelectIndex:[self indexWithOffset:indexPath.item]];
    }
}



#pragma mark- UIScrollView  协议方法

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.jwCycleScrollDirection==JWCycleScrollDirectionHorizontal)
    {
        
        NSInteger offset = (scrollView.contentOffset.x+scrollView.frame.size.width*0.5) /scrollView.frame.size.width;
        if ([self indexWithOffset:offset] != _currentIndex) {
            if (self.contentType == contentNewTypeImage) {

                currentCell = (JWImageCell*)[_cycleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:offset inSection:0]];
                CGFloat num = (int)scrollView.contentOffset.x % (int)scrollView.frame.size.width;
                currentCell.imageView.x = 20 ;
                currentCell.imageView.y = 0 ;
                currentCell.imageView.height = scrollView.frame.size.height ;
                currentCell.imageView.width = scrollView.frame.size.width - 40;
                JWImageCell*cell3 = (JWImageCell*)[_cycleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:offset + 1 inSection:0]];
                cell3.imageView.x = -10;
                cell3.imageView.width = scrollView.frame.size.width + 20;
                if (offset > 0) {
//                    [_cycleCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:offset -1 inSection:0]]];
                    //                    JWImageCell*cell1 = (JWImageCell*)[_cycleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:offset -1 inSection:0]];
                    //                    cell1.imageView.x = -10;
                    //                    cell1.imageView.width = scrollView.frame.size.width + 40;
                }
                
            }
            currentCell.leftImageView.hidden = YES;
            _currentIndex = [self indexWithOffset:offset];
            _pageControl.currentPage=_currentIndex;
        }

    }else
    {
        NSInteger offset=(scrollView.contentOffset.y+scrollView.frame.size.height*0.5)/scrollView.frame.size.height;
        
        _currentIndex =[self indexWithOffset:offset];
        _pageControl.currentPage=_currentIndex;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger offset = (scrollView.contentOffset.x+scrollView.frame.size.width*0.5) /scrollView.frame.size.width;
    currentCell.leftImageView.hidden = NO;
    [self callbackScrollToIndex];
}

// 将要开始拖拽，停止自动轮播
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopAutoCarousel];
}

// 已经结束拖拽，启动自动轮播
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startAutoCarousel];
}


- (void)callbackScrollToIndex
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:_currentIndex];
    }
}



#pragma mark- 缓存清理

+(CGFloat)getCacheSizeAtPath:(NSString *)path
{
    return [JWCacheManager getCacheSizeAtPath:path];
}

+(BOOL)clearCacheAtPath:(NSString *)path
{
    return [JWCacheManager clearCacheAtPath:path];
}

+(CGFloat)getCacheSize
{
    NSString *path = [NSString stringWithFormat:@"%@/Library",NSHomeDirectory()];
    return [JWCacheManager getCacheSizeAtPath:path];
}

+(BOOL)clearCache
{
    NSString *path = [NSString stringWithFormat:@"%@/Library",NSHomeDirectory()];
    return [JWCacheManager clearCacheAtPath:path];
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
