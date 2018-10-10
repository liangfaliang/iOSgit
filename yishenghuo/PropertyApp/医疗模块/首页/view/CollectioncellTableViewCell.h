//
//  CollectioncellTableViewCell.h
//  TsApartment
//
//  Created by admin on 2018/6/15.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectioncellTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionviewWidth;
@property (copy, nonatomic) NSArray *titleArr;
@property (assign, nonatomic) CGSize itemSize;
@property (strong, nonatomic)UICollectionViewFlowLayout *layout;
@property (copy, nonatomic)NSString * Identifier;
@property(copy,nonatomic) void (^ClickBlock) (NSIndexPath *indexpath);
@end
