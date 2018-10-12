//
//  MineMenuTableViewCell.m
//  PropertyApp
//
//  Created by admin on 2018/10/11.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MineMenuTableViewCell.h"
#import "ImageLabelCollectionViewCell.h"

#import "ImLbModel.h"
@implementation MineMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _layout.minimumLineSpacing = 0.001;
    _layout.minimumInteritemSpacing = 0.001;
    _collectionView.delegate = self;
    //    _collectionView.scrollEnabled = NO;
    _collectionView.dataSource = self;
    _collectionView.collectionViewLayout = _layout;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerNib:[UINib nibWithNibName:@"ImageLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageLabelCollectionViewCell"];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.shadowColor = JHmiddleColor.CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(0, 2);
    self.backView.layer.shadowOpacity = 0.3;
    self.backView.layer.shadowRadius = 3;
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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titleArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_titleArr.count > indexPath.row) {
        if (self.Identifier && [self.Identifier isEqualToString:@"ImageLabelCollectionViewCell"]) {
            ImageLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.Identifier forIndexPath:indexPath];
            if ([_titleArr[indexPath.row] isKindOfClass:[ImLbModel class]]) {
                cell.model = _titleArr[indexPath.row];
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
