//
//  OperationHeaderView.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/10.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZImagePickerController.h"
#import "OperateSubmitModel.h"
@interface OperationHeaderView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UILabel *numLb;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic,strong)NSMutableArray  *imageArray;
@property(nonatomic,strong)UIImage *picture;
@property(nonatomic,copy)void (^imageCoumtRefrshBlock)(NSInteger count);
@property(nonatomic,strong)OperateSubmitModel *model;
@end
