//
//  CollectioncellTableViewCell.m
//  TsApartment
//
//  Created by admin on 2018/6/15.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#import "CollectioncellTableViewCell.h"
#import "ImageLabelCollectionViewCell.h"
#import "MedicalHomeCollectionViewCell.h"
#import "HealthShopCollectionViewCell.h"
#import "ImageCollectionViewCell.h"
#import "ImLbModel.h"
#import "NSString+YTString.h"
@interface CollectioncellTableViewCell ()
@end
@implementation CollectioncellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _layout.minimumLineSpacing = 0.001;
    _layout.minimumInteritemSpacing = 0.001;
    _collectionView.delegate = self;
    self.collectionviewWidth.constant = screenW;
//    _collectionView.scrollEnabled = NO;
    _collectionView.dataSource = self;
    _collectionView.collectionViewLayout = _layout;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerNib:[UINib nibWithNibName:@"ImageLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageLabelCollectionViewCell"];
    
}
-(void)setIdentifier:(NSString *)Identifier{
    _Identifier = Identifier;
    [_collectionView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellWithReuseIdentifier:Identifier];
}
-(void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    [_collectionView reloadData];
}
-(void)setLayout:(UICollectionViewFlowLayout *)layout{
    [_collectionView setCollectionViewLayout:layout];
    [_collectionView reloadData];
}
#pragma mark - collectionView
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemSize.height > 0) {
        return self.itemSize;
    }
    return CGSizeMake(screenW / 4.5, screenW/4);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _titleArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (_titleArr.count > indexPath.row) {
        if (self.Identifier && [self.Identifier isEqualToString:@"MedicalHomeCollectionViewCell"]) {
            MedicalHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.Identifier forIndexPath:indexPath];
            cell.nameLb.text = @"李冰|29岁|孕7周+2天";
            cell.descLb.text = @"建档日期：2018-06-07\n家庭医生：张华庭";
            return cell;
        }
        if (self.Identifier && [self.Identifier isEqualToString:@"ImageLabelCollectionViewCell"]) {
            ImageLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.Identifier forIndexPath:indexPath];
            if ([_titleArr[indexPath.row] isKindOfClass:[ImLbModel class]]) {
                cell.model = _titleArr[indexPath.row];
            }
            return cell;
        }
        if (self.Identifier && [self.Identifier isEqualToString:@"HealthShopCollectionViewCell"]) {
            HealthShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.Identifier forIndexPath:indexPath];
            if ([_titleArr[indexPath.row] isKindOfClass:[MeGoodModel class]]) {
                cell.model = _titleArr[indexPath.row];
            }
            return cell;
        }
        if (self.Identifier && [self.Identifier isEqualToString:@"ImageCollectionViewCell"]) {
            ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.Identifier forIndexPath:indexPath];
            if ([_titleArr[indexPath.row] isKindOfClass:[ImLbModel class]]) {
                 ImLbModel * model = _titleArr[indexPath.row];
                if (model.imgurl && ![model.imgurl isValidUrl]) {
                    cell.imageV.image = [UIImage imageNamed:model.imgurl];
                }else{
                    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                }
            }
            return cell;
        }
    }

    ImageLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageLabelCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ClickBlock) {
        self.ClickBlock(indexPath);
    }
}
@end
