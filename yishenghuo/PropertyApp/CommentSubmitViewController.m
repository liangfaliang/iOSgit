//
//  CommentSubmitViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/11/22.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CommentSubmitViewController.h"
#import "starView.h"
#import "STPhotoBroswer.h"
#import "HPGrowingTextView.h"
#import "ZBLookImagesView.h"
#import "TZImagePickerController.h"
@interface CommentSubmitViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIGestureRecognizerDelegate,TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>{
    HPGrowingTextView *textview;
    starView *sta;
    UITextField *tf;
}

@property(nonatomic,strong)UICollectionView  *collectionview;
@property(nonatomic,strong)NSMutableArray  *imageArray;
@property(nonatomic,strong)UIImage  *picture;
@property (nonatomic, strong) ZBLookImagesView *lookImagesView;

@end

@implementation CommentSubmitViewController
-(instancetype)init{
    if (self = [super init]) {
        self.isPerpher = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitle = @"发表评论";
    [self createUI];
    self.picture = [UIImage imageNamed:@"shangchuanzhaopian_zbsy"];
    [self.imageArray addObject:self.picture];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
    rightBtn.tintColor = JHMaincolor;
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(NSMutableArray *)imageArray{
    
    if (_imageArray == nil) {
        _imageArray  = [[NSMutableArray alloc]init];
    }
    
    
    return _imageArray;
}
-(void)rightBtnClick:(UIBarButtonItem *)btn{
    LFLog(@"evnet:%ld",(long)sta.count);
    if (textview.text.length == 0) {
        [self presentLoadingTips:@"请您输入评论内容"];
        return;
    }
    [self presentLoadingStr:@"请稍后"];
    if (self.isPerpher) {
        [self UploadDatagoodsEvaluation];
        return;
    }
    [self requestDataEvaluation];

}

-(void)BtnClick:(UIButton *)btn event:(id)evnet{
    LFLog(@"evnet:%@",evnet);
    
}

-(void)createUI{
    
//    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 74, 80, 80)];
//    imageview.backgroundColor =[UIColor grayColor];
//    [imageview sd_setImageWithURL:[NSURL URLWithString:self.imageurl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
//    [self.view addSubview:imageview];
    
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(10, 64, 80, 55)];
    lb.font = [UIFont systemFontOfSize:15];
    lb.textColor = JHdeepColor;
    lb.text = @"请您评分";
    [self.view addSubview:lb];
    sta = [[starView alloc] initWithFrame:CGRectMake(100, 64, 150, 55)];
    sta.isShowLb = NO;
    sta.backgroundColor = [UIColor whiteColor];
    sta.count = 5;
    [self.view addSubview:sta];
    [self tz_addPopGestureToView:sta];
    UILabel *countlb = [[UILabel alloc]initWithFrame:CGRectMake(260, 64, 80, 55)];
    countlb.font = [UIFont systemFontOfSize:17];
    countlb.textColor = JHAssistRedColor;
    
    [self.view addSubview:countlb];
    __weak typeof(self) weakSelf = self;
    sta.clickBlock = ^(NSInteger count) {
        LFLog(@"评价count:%ld",(long)count);
        if (weakSelf.isPerpher) {
            countlb.text =[NSString stringWithFormat:@"%.1f",(float)count];
        }
    };
    textview = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(10, 55 + 64, SCREEN.size.width-20, 100)];
    textview.placeholder = @"您的评价...";
//    textview.backgroundColor = JHColor(238, 238, 238);
    [self.view addSubview:textview];
    if (self.isPerpher) {
        countlb.text = @"5.0";
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = CGSizeMake((SCREEN.size.width-50)/4, (SCREEN.size.width-50)/4);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 20, 10);
        [flowLayout setFooterReferenceSize:CGSizeMake(SCREEN.size.width, 55)];
        self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 160 + 64, SCREEN.size.width, (SCREEN.size.width-50)/4 + 90) collectionViewLayout:flowLayout];
        self.collectionview.dataSource=self;
        self.collectionview.delegate=self;
        [self.collectionview setBackgroundColor:[UIColor clearColor]];
        [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"writeCell"];
        [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footReuse"];
        [self.view addSubview:self.collectionview];
    }
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageArray.count;
}
//头视图尺寸
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN.size.width, 55);
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    NSLog(@"kind = %@", kind);
    if (kind == UICollectionElementKindSectionFooter){
        
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footReuse" forIndexPath:indexPath];
    }
    [reusableview removeAllSubviews];
    reusableview.backgroundColor = JHbgColor;
    UIView *Vf = [self.view viewWithTag:15];
    if (Vf == nil) {
        Vf = [[UIView alloc]init];
        Vf.tag = 15;
    }
    Vf.backgroundColor = [UIColor whiteColor];
    [reusableview addSubview:Vf];
    [Vf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.top.offset(10);
    }];
    if (tf == nil) {
        tf = [[UITextField alloc]init];
        tf.keyboardType = UIKeyboardTypeNumberPad;
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80 , 40)];
        lb.text = @"人均消费：";
        lb.font = [UIFont systemFontOfSize:15];
        lb.textColor = JHdeepColor;
        tf.leftViewMode = UITextFieldViewModeAlways;
        tf.leftView = lb;
        tf.font = [UIFont systemFontOfSize:15];
        tf.textColor = JHAssistColor;
        tf.placeholder = @"点击输入";
    }
    [Vf addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.bottom.offset(0);
        make.top.offset(0);
    }];
    return reusableview;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"writeCell" forIndexPath:indexPath];
    [cell.contentView removeAllSubviews];
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.userInteractionEnabled = YES;
    imageview.image = self.imageArray[indexPath.row];
    UIButton *btn = [[UIButton alloc]init];
    
    [btn setImage:[UIImage imageNamed:@"icon_shanchu"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageclick:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    imageview.tag = indexPath.row + 55;
    
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
        [imageview addGestureRecognizer:tap];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.width.offset(25);
            make.height.offset(25);
            make.right.offset(0);
        }];
    }
    
    
    return cell;
    
}

-(void)buttonclick:(UIButton *)button{
    
    [self.imageArray removeObjectAtIndex:button.tag - 22];

    if (![self.imageArray.lastObject isEqual:self.picture]) {
        [self.imageArray addObject:self.picture];
    }
    if (self.imageArray.count >3) {
        self.collectionview.height = ((SCREEN.size.width-50)/4) * 2 + 100;
    }else{
        self.collectionview.height = (SCREEN.size.width-50)/4 + 90;
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
    NSMutableArray *mimageArr = [self.imageArray mutableCopy];
    if ([mimageArr.lastObject isEqual:self.picture]) {
        [mimageArr removeObject:self.picture];
    }
    STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:mimageArr currentIndex:tap.view.tag - 55];
    [broser show];
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
        
        if (self.imageArray.count <= 8) {
            [self choseImage];
        }else{
            
            [self alertController:@"提示" prompt:@"最多上传8张图片" sure:@"确定" cancel:nil success:^{
                
            } failure:^{
                
            }];
            
        }
        
        
        
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
        imagePickerVc.maxImagesCount = 9 - self.imageArray.count;
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
    for (UIImage *image in self.imageArray) {
        if ([image isEqual:self.picture]) {
            [self.imageArray removeObject:image];
            
        }
    }
    for (UIImage *im in photos) {
        [self.imageArray addObject:im];
    }
    if (self.imageArray.count < 8) {
        [self.imageArray addObject:self.picture];
    }
    
    if (self.imageArray.count >3) {
        self.collectionview.height = ((SCREEN.size.width-50)/4) * 2 + 100;
    }else{
        self.collectionview.height = (SCREEN.size.width-50)/4 + 90;
    }
    [self.collectionview reloadData];

}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    UIImage *editimage = info[UIImagePickerControllerOriginalImage];
    editimage = [editimage fixOrientation];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
//    if ([mediaType isEqualToString:@"public.image"]) {  //判断是否为图片
//        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            UIImageWriteToSavedPhotosAlbum(editimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        }
//    }
    editimage = [editimage fixOrientation];
    
    for (UIImage *image in self.imageArray) {
        if ([image isEqual:self.picture]) {
            [self.imageArray removeObject:image];
            
        }
    }
    [self.imageArray addObject:editimage];
    if (self.imageArray.count < 8) {
        [self.imageArray addObject:self.picture];
    }
    if (self.imageArray.count >3) {
        self.collectionview.height = ((SCREEN.size.width-50)/4) * 2 + 100;
    }else{
        self.collectionview.height = (SCREEN.size.width-50)/4 + 90;
    }
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

#pragma mark - *************维修工单评价*************
-(void)requestDataEvaluation{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.orid) {
        [dt setObject:self.orid forKey:@"orid"];
    }
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) {
        coid = @"";
    }
    [dt setObject:textview.text forKey:@"sIDea"];
    [dt setObject:coid forKey:@"coid"];
//    if (sta.count < 2) {
//        [dt setObject:@"不满意" forKey:@"sQui"];
//    }else if (sta.count <4){
//        [dt setObject:@"满意" forKey:@"sQui"];
//    }else{
//        [dt setObject:@"基本满意" forKey:@"sQui"];
//    }
    [dt setObject:[NSString stringWithFormat:@"%ld",(long)sta.count] forKey:@"sea_Branch"];
    LFLog(@"维修工单评价dt:%@",dt);
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"bxhuifang") params:dt success:^(id response) {
        LFLog(@"维修工单评价:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        if ([str isEqualToString:@"0"]) {
            [self presentLoadingTips:@"您已评价成功"];
            [self performSelector:@selector(popviewcontroller) withObject:nil afterDelay:2.0];
        }else{
            [self presentLoadingTips:response[@"date"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"服务器繁忙！"];

    }];
    
}

#pragma mark - *************周边商业评价提交
-(void)UploadDatagoodsEvaluation{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSString *count = [NSString stringWithFormat:@"%d",(int)sta.count];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    [dt setObject:textview.text forKey:@"content"];
    [dt setObject:count forKey:@"comment_rank"];
    if (self.detailid) {
        [dt setObject:self.detailid forKey:@"id"];
    }
    [dt setObject:@"192.168.1.55" forKey:@"ip_address"];
    if (tf.text.length) {
        [dt setObject:tf.text forKey:@"price"];
    }
    NSMutableArray *imstr = [NSMutableArray array];
    for (int i = 0;i < self.imageArray.count ; i ++) {
        UIImage *image = self.imageArray[i];
        if (![image isEqual:self.picture]) {
            
            [imstr addObject:image];
            
        }
    }
    NSString *url = PBusyCommentAddUrl;
    if (self.isCarnival) {
        url = CarnivalCommentAddUrl;
    }
    LFLog(@"提交dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt body:imstr success:^(id response) {
        [self dismissTips];
        LFLog(@"评价：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"您已评价成功"];
            [self performSelector:@selector(popviewcontroller) withObject:nil afterDelay:2.0];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self UploadDatagoodsEvaluation];
                    }
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
        
    } failure:^(NSError *error) {
        LFLog(@"评价error：%@",error);
    }];

}
-(void)popviewcontroller{
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
