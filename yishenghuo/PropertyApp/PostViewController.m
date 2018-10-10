//
//  PostViewController.m
//  shop
//
//  Created by 梁法亮 on 16/5/10.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "PostViewController.h"
#import "ZBLookImagesView.h"
#import "MenuListViewController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "HPGrowingTextView.h"
#define SCREEN [[UIScreen mainScreen] bounds]

@interface PostViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIGestureRecognizerDelegate,TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong)HPGrowingTextView *tfview;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *SortArray;
@property(nonatomic,strong)UICollectionView  *collectionview;
@property(nonatomic,strong)UIImage  *picture;
@property(nonatomic,strong)NSDictionary  *sortDt;
@end

@implementation PostViewController

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
    [self upDataforMenu];
    
}
-(void)rightItemClick:(UIBarButtonItem *)btn{
 
    if (self.tfview.text.length == 0) {
        [self presentLoadingTips:@"请输入内容~"];
    }else if (!self.sortDt){
        [self presentLoadingTips:@"请选择帖子分类~"];
    }else{
        [self UploadDatagoodsEvaluation];
        
    }
}
-(void)createUI{

    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake((SCREEN.size.width-40)/3, (SCREEN.size.width-40)/3 + 10);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height ) collectionViewLayout:flowLayout];
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview setBackgroundColor:[UIColor clearColor]];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"BBSpostFootReuse"];//底视图
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BBSpostHeaderReuse"];//头视图
    //注册Cell，必须要有
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:self.collectionview];
    
    
    
}
-(NSMutableArray *)SortArray{
    
    if (_SortArray == nil) {
        _SortArray = [[NSMutableArray alloc]init];
    }
    return _SortArray;
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
        make.bottom.offset(-10);
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
    return 0.00001;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//头视图尺寸

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    

    return CGSizeMake(SCREEN.size.width, 170);
    
}
//底视图尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (self.SortArray.count) {
        CGFloat wieth = 0;
        CGFloat heigth = 50;
        CGFloat _font = 15;
        CGFloat totalwieth = 10;
        CGFloat _sortH = 44;
        int count = 0;
        for (int i = 0; i < _SortArray.count; i++) {
            NSString *str =_SortArray[i][@"name"];
            CGSize size = [str selfadap:_font weith:20];
            NSString *str1 = [[NSString alloc]init];
            
            if (i < _SortArray.count-1) {
                
                str1 = _SortArray[i + 1][@"name"];
            }
            CGSize size1 = [str1 selfadap:_font weith:20];
            if (totalwieth + size1.width +  (size1.width > 0 ? +15:0) + 20  + size.width + 15< SCREEN.size.width -20 ) {
                wieth  += size.width + 15;
                count ++;
            }else{
                
                heigth += _sortH;
                totalwieth = 10;
                wieth = 0;
                count = 0;
            }
      
            totalwieth =  count* 10 + wieth;
        }
        return CGSizeMake(SCREEN.size.width, heigth + _sortH);
    }
    return CGSizeMake(SCREEN.size.width, 0.0001);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        UIView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BBSpostHeaderReuse" forIndexPath:indexPath];
        
        reusableview = (UICollectionReusableView *)headerV;
        reusableview.backgroundColor = [UIColor whiteColor];
        if (self.tfview == nil) {
            self.tfview = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(10, 10, SCREEN.size.width - 20, 150)];
            self.tfview.placeholder = @"亲，来说点什么吧~";
//            self.tfview.maxHeight = 150;
            self.tfview.minHeight = 150;
            self.tfview.font = [UIFont systemFontOfSize:15];
            //    self.tfview.backgroundColor = [UIColor redColor];
            [reusableview addSubview:self.tfview];
        }

        
    }
    if (kind == UICollectionElementKindSectionFooter){
        
        UIView *footV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"BBSpostFootReuse" forIndexPath:indexPath];
        
        reusableview = (UICollectionReusableView *)footV;
        reusableview.backgroundColor = JHbgColor;
        if (self.SortArray.count) {
            [reusableview removeAllSubviews];
            UILabel *nameLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN.size.width - 20, 30)];
            nameLb.font = [UIFont systemFontOfSize:16];
            nameLb.textColor = JHdeepColor;
            nameLb.text = @"#为您的帖子加上标签吧#";
            [reusableview addSubview:nameLb];
            CGFloat wieth = 0;
            CGFloat heigth = 50;
            CGFloat _font = 15;
            CGFloat totalwieth = 10;
            CGFloat _sortH = 44;
            int count = 0;
            for (int i = 0; i < _SortArray.count; i++) {
                
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
                NSString *str =_SortArray[i][@"name"];
                
                [button setTitle:str forState:UIControlStateNormal];
                CGSize size = [str selfadap:_font weith:20];
                button.titleLabel.font = [UIFont systemFontOfSize:_font];
                button.frame = CGRectMake(10 + count* 10 + wieth, heigth, size.width + 15, 34);
                NSString *str1 = [[NSString alloc]init];
                
                if (i < _SortArray.count-1) {
                    
                    str1 = _SortArray[i + 1][@"name"];
                }
                
                CGSize size1 = [str1 selfadap:_font weith:20];
                if (totalwieth + size1.width +  (size1.width > 0 ? +15:0) + 20  + size.width + 15< SCREEN.size.width -20 ) {
                    wieth  += size.width + 15;
                    count ++;
                }else{

                    heigth += _sortH;
                    totalwieth = 10;
                    wieth = 0;
                    count = 0;
                }
//                if (_index == i) {
//                    button.selected = YES;
//                    button.layer.borderColor = [JHAssistColor CGColor];
//                }else{
                    button.selected = NO;
                    button.layer.borderColor = [JHBorderColor CGColor];
//                }
                
                button.layer.borderWidth = 1;
                button.backgroundColor = [UIColor whiteColor];
                button.layer.cornerRadius = 17;
                [button addTarget:self action:@selector(SortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitleColor:JHmiddleColor forState:UIControlStateNormal];
                [reusableview addSubview:button];
                totalwieth =  count* 10 + wieth;
            }
        }
        
        
        
    }
    return reusableview;
}
#pragma mark 点击标签
-(void)SortBtnClick:(UIButton *)btn{
    UICollectionReusableView *reusableview = (UICollectionReusableView *)btn.superview;
    for (UIView *subview in reusableview.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subview;
            if (subBtn != btn) {
                subBtn.selected = NO;
                subBtn.layer.borderColor = [JHBorderColor CGColor];
                [subBtn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
            }
        }
    }
    btn.selected = YES;
    [btn setTitleColor:JHAssistColor forState:UIControlStateNormal];
    btn.layer.borderColor = [JHAssistColor CGColor];
    [self.SortArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dt = (NSDictionary *)obj;
        if ([btn.titleLabel.text isEqualToString:dt[@"name"]]) {
            self.sortDt = dt;
        }
    }];
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
        NSMutableArray *marr = [NSMutableArray array];
        for (UIImage *im in self.imageArray) {
            if (im != self.picture) {
                [marr addObject:im];
            }
        }
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
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    if (self.tfview.text.length) {
        [dt setObject:self.tfview.text forKey:@"content"];
    }
    if (self.sortDt) {
        [dt setObject:self.sortDt[@"id"] forKey:@"category"];
    }
    LFLog(@"评论列表dt:%@",dt);
    NSMutableArray *imarr = [self.imageArray mutableCopy];
    [imarr removeObject:self.picture];
    LFLog(@"countdt:%lu",(unsigned long)self.imageArray.count);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSSendPostUrl) params:dt body:imarr success:^(id response) {
        [self dismissTips];
        LFLog(@"评价：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"发送成功"];
            if (_block) {
                _block();
            }
            [self performSelector:@selector(popviewcontroller) withObject:nil afterDelay:2.0];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDatagoodsEvaluation];
                    }
                    
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

#pragma mark 菜单数据请求
-(void)upDataforMenu{


    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSMenuListUrl) params:nil body:self.imageArray success:^(id response) {
        [self dismissTips];
        LFLog(@"评价：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self.SortArray removeAllObjects];
            
            for (NSDictionary *dt in response[@"data"]) {
                [self.SortArray addObject:dt];
            }
            [self.collectionview reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self upDataforMenu];
                    }
                    
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






@end
