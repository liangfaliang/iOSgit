//
//  MineMenuTableViewCell.h
//  PropertyApp
//
//  Created by admin on 2018/10/11.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BasicTableViewCell.h"

@interface MineMenuTableViewCell : BasicTableViewCell<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (copy, nonatomic) NSArray *titleArr;
@property (assign, nonatomic) CGSize itemSize;
@property (strong, nonatomic)UICollectionViewFlowLayout *layout;
@property (copy, nonatomic)NSString * Identifier;
@property(copy,nonatomic) void (^ClickBlock) (NSIndexPath *idxpath);
@end
