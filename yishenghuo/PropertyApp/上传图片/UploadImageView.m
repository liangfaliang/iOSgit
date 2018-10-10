//
//  UploadImageView.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/6/18.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "UploadImageView.h"
#import "STPhotoBroswer.h"
#import "IndexBtn.h"
@interface UploadImageView ()


@end
@implementation UploadImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    if (self = [super init]) {
        [self initialization];
    }
    return self;

}
-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}
-(NSMutableArray *)imageArray{
    
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    
    return _imageArray;
    
}
-(void)setImagearrayForcollectionview:(NSArray *)imArr{

    [self.imageArray removeAllObjects];
    [self.imageArray addObjectsFromArray:imArr];
    [self.collectionView reloadData];
}

-(void)initialization{
    self.isClick = YES;//默认可以点击
    self.isDisplay = YES;
    nameLb = [[UILabel alloc]init];
    nameLb.text = @"上传图片:";
    nameLb.font = [UIFont systemFontOfSize:15];
    nameLb.textColor = JHmiddleColor;
    clickBtn = [[UIButton alloc]init];
    [clickBtn setImage:[UIImage imageNamed:@"shangchuanzhaopian"] forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(choseImage:) forControlEvents:UIControlEventTouchUpInside];

    if (self.collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.itemSize = CGSizeMake((SCREEN.size.width-60)/4, (SCREEN.size.width-60)/4);
        self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, 0) collectionViewLayout:flowLayout];
        self.collectionView.dataSource=self;
        self.collectionView.delegate=self;
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        //注册Cell，必须要有
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];

    }
}
-(void)layoutSubviews{

    if (self.isDisplay) {
        [self addSubview:nameLb];
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(0);
            make.height.offset(30);
        }];
        [self addSubview:clickBtn];
        [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.centerY.equalTo(nameLb.mas_centerY);
        }];
    }

    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.left.offset(10);
        make.bottom.offset(0);
        if (self.isDisplay) {
            make.top.equalTo(nameLb.mas_bottom).offset(0);
        }else{
            make.top.offset(0);
        }
        
    }];
    [self.collectionView reloadData];
}
-(void)choseImage:(UIButton *)btn{
    if (self.isClick) {
        if (_block) {
            _block(@"");
        }
    }

}
-(void)setBlock:(clickBlock)block{
    _block = block;
}
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.imageArray.count;
}
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//
//    if (self.imageArray.count <= 3) {
//        return 1;
//    }else{
//    return 2;
//
//    }
//
//}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.userInteractionEnabled = YES;
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.layer.masksToBounds = YES;
    if ([self.imageArray[indexPath.row] isKindOfClass:[UIImage class]]) {
        imageview.image = self.imageArray[indexPath.row];
    }else{
        [imageview sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
    IndexBtn *btn = [[IndexBtn alloc]init];
    //btn.backgroundColor = [UIColor blueColor];
    [btn setImage:[UIImage imageNamed:@"shanchu_baoxiutupian"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [cell.contentView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.left.offset(5);
        make.right.offset(5);
        make.bottom.offset(5);
    }];
    
    //    if (!(indexPath.row == self.imageArray.count - 1)) {
    if (self.isDisplay) {
        if (self.isClick) {
            [cell.contentView addSubview:btn];
            //        [imageview addGestureRecognizer:tap];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.left.offset(0);
                make.width.offset(25);
                make.height.offset(25);
            }];
        }

    }

    //    }
    
    
    
    
    btn.index = indexPath.row ;
    return cell;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return YES;
    
}


-(void)buttonclick:(IndexBtn *)button{
    if (self.isClick) {
        [self.imageArray removeObjectAtIndex:button.index];
        [self.collectionView reloadData];
        if (_deleteBlock) {
            _deleteBlock(self.imageArray);
        }
    }
}
-(void)setDeleteBlock:(deleteClickBlock)deleteBlock{
    _deleteBlock = deleteBlock;
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isDisplay && self.height > 10) {
        return CGSizeMake(self.height-10, self.height - 10);
    }else{
        return CGSizeMake((SCREEN.size.width-60)/4, (SCREEN.size.width-60)/4);
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableArray * muarr = [self.imageArray copy];
    STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:muarr currentIndex:indexPath.row];
    [broser show];
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



@end
