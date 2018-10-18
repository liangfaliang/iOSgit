//
//  AskQuestionTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AskQuestionTableViewCell.h"
#import "UITextView+Placeholder.h"
@implementation AskQuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tfBackview.layer.borderColor = JHBorderColor.CGColor;
    self.tfBackview.layer.borderWidth = 1;
    [self.textTf addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    self.textView.delegate = self;
    self.picture = [UIImage imageNamed:@"add"];
    [self.imageArray addObject:self.picture];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake((screenW - 50)/3 -1, (screenW - 60)/3);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [self.collectionview setCollectionViewLayout:flowLayout];
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionviewHeight.constant = (screenW - 60)/3 + 10;
}
-(NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray  = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}
-(void)textField1TextChange:(UITextField *)textField{
    self.model.title = textField.text;
}
#pragma mark TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    CGFloat length = textView.text.length;
    if (length > 200) {//3行了  两行52 三行70
        while (length > 200) {
            textView.text = [textView.text substringToIndex:[textView.text length]-1];
            length = textView.text.length;
        }
    }
    if (self.model) self.model.content = textView.text;
    if (self.lmodel) self.lmodel.content = textView.text;
    self.numLb.text = [NSString stringWithFormat:@"%d/200",200 - (int)length];
}
#pragma mark collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.tag = 1000;
    imageview.image = self.imageArray[indexPath.row];
    [cell.contentView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(-10);
    }];
    if (![imageview.image isEqual:self.picture]) {
        ImTopBtn *btn = [[ImTopBtn alloc]init];
        //btn.backgroundColor = [UIColor blueColor];
        [btn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [cell.contentView addSubview:btn];
        //        [imageview addGestureRecognizer:tap];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.right.offset(0);
            make.width.offset(25);
            make.height.offset(25);
        }];
        btn.index = indexPath.row ;
    }

    return cell;
}

-(void)buttonclick:(ImTopBtn *)button{
    [self.imageArray removeObjectAtIndex:button.index];
    if (![self.imageArray.lastObject isEqual:self.picture]) {
        [self.imageArray addObject:self.picture];
    }
    self.collectionviewHeight.constant = ((screenW - 60)/3 + 10) * (self.imageArray.count/3 + (self.imageArray.count%3 ? 1 : 0));
    [self.collectionview reloadData];
    if (self.collectionHeightRefsh) {
        self.collectionHeightRefsh(self.imageArray.count);
    }
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *image = self.imageArray[indexPath.row];
    if ([image isEqual:self.picture]) {
        if (self.imageArray.count > 5) {
            [AlertView showMsg:@"最多选择5张图片!"];
            return;
        }
        [self selectPicture];
    }else{
        NSMutableArray *marr = [NSMutableArray arrayWithArray:self.imageArray];
        if ([marr containsObject:self.picture]) {
            [marr removeObject:self.picture];
        }
        NSMutableArray *tempArr = [NSMutableArray array];
        [self.imageArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqual:self.picture]) {
                YBImageBrowserModel *model = [YBImageBrowserModel new];
                model.image = (UIImage *)obj;
                model.sourceImageView = [self getImageViewOfCellByIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                [tempArr addObject:model];
            }
        }];
        
        //创建图片浏览器（注意：更多功能请看 YBImageBrowser.h 文件或者 github readme）
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataArray = tempArr;
        browser.currentIndex = indexPath.row;
        //展示
        [browser show];
        
    }
}
- (UIImageView *)getImageViewOfCellByIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionview cellForItemAtIndexPath:indexPath];
    if (!cell) return nil;
    return [cell.contentView viewWithTag:1000];
}
//选择tu
// 选择头像
-(void)selectPicture{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        BasicViewController *vc = (BasicViewController *)[self viewController];
        [vc alertController:@"提示" prompt:@"此应用没有权限访问您的照片或视频，您可以在”隐私设置“中启用访问" sure:@"确定" cancel:@"取消" success:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } failure:^{
        }];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pic = [[UIImagePickerController alloc]init];
        pic.delegate = self;
        //允许编辑图片
        pic.allowsEditing = YES;
        pic.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[self viewController] presentViewController:pic animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
        imagePickerVc.maxImagesCount = 6 - self.imageArray.count ;
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowCrop = YES;
        imagePickerVc.cropRect = CGRectMake(0, (screenH-screenW)/2, screenW, screenW);
        [[self viewController] presentViewController:imagePickerVc animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [[self viewController] presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark  图片选择成功的方法
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    [self.imageArray removeObject:self.picture];
    for (UIImage *im in photos) {
        [self.imageArray addObject:im];
    }
    if (self.imageArray.count < 6) {
        [self.imageArray addObject:self.picture];
    }
    self.collectionviewHeight.constant = ((screenW - 60)/3 + 10) * (self.imageArray.count/3 + (self.imageArray.count%3 ? 1 : 0));
    [self.collectionview reloadData];
    if (self.collectionHeightRefsh) {
        self.collectionHeightRefsh(self.imageArray.count);
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *editimage = info[UIImagePickerControllerOriginalImage];
    editimage = [editimage fixOrientation];
    for (UIImage *image in self.imageArray) {
        if ([image isEqual:self.picture]) {
            [self.imageArray removeObject:image];
        }
    }
    if (self.imageArray.count < 6) {
        [self.imageArray addObject:self.picture];
    }
    self.collectionviewHeight.constant = ((screenW - 60)/3 + 10) * (self.imageArray.count/3 + (self.imageArray.count%3 ? 1 : 0));
    [self.collectionview reloadData];
    
    //移除图片选择器
    [[self viewController] dismissViewControllerAnimated:YES completion:nil];
    if (self.collectionHeightRefsh) {
        self.collectionHeightRefsh(self.imageArray.count);
    }
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [[self viewController] dismissViewControllerAnimated:YES completion:nil];
}
@end
