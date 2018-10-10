//
//  GovernmentSendPostViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/12.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "GovernmentSendPostViewController.h"
#import "HPGrowingTextView.h"
#import "ZBLookImagesView.h"
#import "TZImagePickerController.h"
@interface GovernmentSendPostViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIGestureRecognizerDelegate,TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong)HPGrowingTextView *tfview;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)UICollectionView  *collectionview;
@property(nonatomic,strong)UIImage  *picture;
@end

@implementation GovernmentSendPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"发帖";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    
    rightItem.tintColor = JHAssistColor;
    self.navigationItem.rightBarButtonItem = rightItem;
    self.picture = [UIImage imageNamed:@"shaitu"];
    [self.imageArray addObject:self.picture];
    [self createUI];
    
}
-(void)rightItemClick:(UIBarButtonItem *)btn{
    
    if (self.tfview.text.length) {
        [self UploadDatagoodsEvaluation];
    }else{
        [self presentLoadingTips:@"请输入内容~"];
    }
}
-(void)createUI{
    self.tfview = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(10, 74, SCREEN.size.width - 20, 150)];
    self.tfview.placeholder = @"亲，来说点什么吧~";
    self.tfview.font = [UIFont systemFontOfSize:15];
    self.tfview.minHeight = 150;
//    self.tfview.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.tfview];

    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake((SCREEN.size.width-40)/3, (SCREEN.size.width-40)/3);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 244, SCREEN.size.width, SCREEN.size.height - 244) collectionViewLayout:flowLayout];
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview setBackgroundColor:[UIColor clearColor]];
    
    //注册Cell，必须要有
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:self.collectionview];
    


}

-(NSMutableArray *)imageArray{

    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.userInteractionEnabled = YES;
    imageview.image = self.imageArray[indexPath.row];
    UIButton *btn = [[UIButton alloc]init];
    
    [btn setImage:[UIImage imageNamed:@"icon_shanchu"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageclick:)];
//    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//    tap.cancelsTouchesInView = NO;
//    tap.delegate = self;
//    imageview.tag = indexPath.row + 55;
    
    //    if (!(indexPath.row == self.imageArray.count - 1)) {
    //
    //    }
    btn.tag = indexPath.row + 22;
    [cell.contentView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
    }];
    if (![imageview.image isEqual:self.picture]) {
        [imageview addSubview:btn];
//        [imageview addGestureRecognizer:tap];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.width.offset(30);
            make.height.offset(30);
            make.right.offset(0);
        }];
    }
    
    
    return cell;
    
}

-(void)buttonclick:(UIButton *)button{
    

    [self.imageArray removeObjectAtIndex:button.tag - 22];
    //    [self.imagedata removeObjectAtIndex:button.tag - 22];

    if (![self.imageArray.lastObject isEqual:self.picture]) {
        if (self.imageArray.count < 9) {
            [self.imageArray addObject:self.picture];
        }
    }
    
    
    
    [self.collectionview reloadData];
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return YES;
    
}


-(void)imageclick:(UITapGestureRecognizer *)tap{
    
    
    
    
    
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"collectioncell:");
    NSLog(@"imageArray:%@",self.imageArray);
    UIImage *image = self.imageArray[indexPath.row];
    if ([image isEqual:self.picture]) {
        
        if (self.imageArray.count <= 9) {
            [self choseImage];
        }else{
            
            [self alertController:@"提示" prompt:@"最多上传9张图片" sure:@"确定" cancel:nil success:^{
                
            } failure:^{
                
            }];
            
        }
        
        
        
    }else{
        NSMutableArray *marr = [self.imageArray mutableCopy];
        [marr removeObject:self.picture];
        STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:marr currentIndex:indexPath.row];
        [broser show];
    }
    
    
    
}

//选择tu
-(void)choseImage{
    [self.view endEditing:YES];
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"图库", nil];
    [sheet showInView:self.view];
    
    
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 2)return;
    
    UIImagePickerController *pic = [[UIImagePickerController alloc]init];
    pic.delegate = self;
    
    //允许编辑图片
    pic.allowsEditing = NO;
    
    
    if (buttonIndex == 0) {
        
        pic.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else{
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        imagePickerVc.maxImagesCount = 10 - self.imageArray.count;
        //        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.allowPickingVideo = NO;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
    //显示控制器
    [self presentViewController:pic animated:YES completion:nil];
}
#pragma mark  图片选择成功的方法
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    for (NSDictionary *info in infos) {
        
        NSString *file = [NSString stringWithFormat:@"%@",[info objectForKey:@"PHImageFileURLKey"]];
        LFLog(@"file:%@",file);
        file = [file stringByReplacingOccurrencesOfString:@"file:///" withString:@"/"];
        
        NSFileManager* manager = [NSFileManager defaultManager];
        
        if ([manager fileExistsAtPath:file]){
            
            LFLog(@"%f",[[manager attributesOfItemAtPath:file error:nil] fileSize]/(1024.0*1024.0)) ;
        }
    }
    [self.imageArray removeObject:self.picture];
    for (UIImage *im in photos) {
        [self.imageArray addObject:im];
    }
    LFLog(@"self.imageArray.count:%lu",(unsigned long)self.imageArray.count);
    if (self.imageArray.count < 9) {
        [self.imageArray addObject:self.picture];
    }
    
//    if (self.imageArray.count >3) {
//        self.collectionview.frame = CGRectMake(0, 284, SCREEN.size.width , ((SCREEN.size.width-40)/3) * 2 + 10) ;
//        
//    }
    
    [self.collectionview reloadData];
    //        ALAssetsLibrary* alLibrary = [[ALAssetsLibrary alloc] init];
    //        __block float fileMB  = 0.0;
    //
    //        [alLibrary assetForURL:[info objectForKey:@"PHImageFileURLKey"] resultBlock:^(ALAsset *asset)
    //         {
    //             ALAssetRepresentation *representation = [asset defaultRepresentation];
    //             fileMB = (float)([representation size]/(1024 * 1024));
    //             [self.imagedata addObject:[NSNumber numberWithFloat:fileMB]];
    //             NSLog(@"size of asset in bytes: %0.2f", fileMB);
    //
    //         }
    //                  failureBlock:^(NSError *error)
    //         {
    //
    //         }];
    
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    UIImage *editimage = info[UIImagePickerControllerOriginalImage];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
//    if ([mediaType isEqualToString:@"public.image"]) {  //判断是否为图片
//        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            UIImageWriteToSavedPhotosAlbum(editimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        }
//    }
    
    //    ALAssetsLibrary* alLibrary = [[ALAssetsLibrary alloc] init];
    //    __block float fileMB  = 0.0;
    //
    //    [alLibrary assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset)
    //     {
    //         ALAssetRepresentation *representation = [asset defaultRepresentation];
    //         fileMB = (float)([representation size]/(1024 * 1024));
    //         [self.imagedata addObject:[NSNumber numberWithFloat:fileMB]];
    //         NSLog(@"size of asset in bytes: %0.2f", fileMB);
    //
    //     }
    //              failureBlock:^(NSError *error)
    //     {
    //
    //     }];
    editimage = [editimage fixOrientation];
    
    [self.imageArray removeObject:self.picture];
    [self.imageArray addObject:editimage];
    if (self.imageArray.count < 9) {
        [self.imageArray addObject:self.picture];
    }
    
//    if (self.imageArray.count >3) {
//        self.collectionview.frame = CGRectMake(0, 284, SCREEN.size.width , ((SCREEN.size.width-40)/3) * 2 + 10) ;
//    }
    
    [self.collectionview reloadData];
    
    
    //移除图片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
//此方法就在UIImageWriteToSavedPhotosAlbum的上方
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"已保存");
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - *************评价提交
-(void)UploadDatagoodsEvaluation{
    [self presentLoadingTips];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session",self.cat_id,@"cat_id", nil];
    if (self.tfview.text.length) {
        [dt setObject:self.tfview.text forKey:@"content"];
    }
    LFLog(@"评论列表dt:%@",dt);
    [self.imageArray removeObject:self.picture];
    LFLog(@"countdt:%lu",(unsigned long)self.imageArray.count);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,GovernmentSendPostUrl) params:dt body:self.imageArray success:^(id response) {
        [self dismissTips];
        LFLog(@"评价：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSString class]]) {
                [self presentLoadingTips:response[@"data"]];
            }else{
                [self presentLoadingTips:@"发送成功!"];
            }
            
            if (_block) {
                _block();
            }
            [self performSelector:@selector(popviewcontroller) withObject:nil afterDelay:2.0];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
        
    } failure:^(NSError *error) {
        [self presentLoadingTips:@"发送失败~"];
        [self dismissTips];
        LFLog(@"评价error：%@",error);
    }];

    
    
}
-(void)popviewcontroller{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)setBlock:(SuccessblockClick)block{
    _block = block;
}
@end
