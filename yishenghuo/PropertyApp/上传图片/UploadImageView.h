//
//  UploadImageView.h
//  PropertyApp
//
//  Created by 梁法亮 on 2017/6/18.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZImagePickerController.h"
typedef void(^clickBlock) ( NSString *str);
typedef void(^deleteClickBlock) (NSArray *imarr);
@interface UploadImageView : UIView <UINavigationControllerDelegate,UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate>{
    UILabel *nameLb;
    UIButton *clickBtn;
}

@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,copy)clickBlock block;
@property(nonatomic,copy)deleteClickBlock deleteBlock;
@property(nonatomic,assign)BOOL isDisplay;//是否显示label 默认yes
@property(nonatomic,assign)BOOL isClick;//是否可以点击
-(void)setBlock:(clickBlock)block;
-(void)setDeleteBlock:(deleteClickBlock)deleteBlock;
-(void)setImagearrayForcollectionview:(NSArray *)imArr;
@end
