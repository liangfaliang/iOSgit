//
//  AskQuestionTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZImagePickerController.h"
#import "AnswerModel.h"
#import "LeaveSubModel.h"
@interface AskQuestionTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfTop;
@property (weak, nonatomic) IBOutlet UITextField *textTf;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vlineHeight;
@property (weak, nonatomic) IBOutlet UIView *vline;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numLb;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic,strong)NSMutableArray  *imageArray;
@property(nonatomic,strong)UIImage  *picture;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionviewHeight;
@property (weak, nonatomic) IBOutlet UIView *tfBackview;
@property(nonatomic,copy)void (^collectionHeightRefsh)(NSInteger count);
@property(nonatomic,retain)LeaveSubModel  *lmodel;
@property(nonatomic,retain)AnswerModel  *model;
@end
