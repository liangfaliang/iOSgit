//
//  MaintenanceFundViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/8/18.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "MaintenanceFundViewController.h"
#import "TZImagePickerController.h"
#import "AVCaptureViewController.h"
#import "JXTAlertManagerHeader.h"
@interface MaintenanceFundViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    IndexBtn *deedbtn;
}
@property (nonatomic,strong)UITableView * tableView;
@property (strong,nonatomic)NSMutableArray *subViewArray;
@property (strong,nonatomic)NSMutableArray *IdcardArray;//身份证
@property (strong,nonatomic)UIImage *deedImage;//房产证
@property (strong,nonatomic)UIImage *backImage;//
@property (strong,nonatomic)UIImage *picture;//
@property (strong,nonatomic)NSArray *nameArray;
@property (strong,nonatomic)NSArray *placeholderArr;
@property (strong,nonatomic)NSArray *titleArray;
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation MaintenanceFundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.picture = [UIImage imageNamed:@"shenfenzhengrenxiangmian"];
    [self.IdcardArray addObject:self.picture];
    self.deedImage = [UIImage imageNamed:@"fangchanzhengzhaopian"];
    self.backImage = [UIImage imageNamed:@"shenfenzhengkuang"];
    self.navigationBarTitle = @"维修基金查询";
    self.titleArray = @[@"房主信息",@"上传身份证照片（如房主多人，请依次上传）",@"房产证照片"];
    self.nameArray = @[@"房主姓名：",@"房产证编号：",@"身份证号："];
    self.placeholderArr = @[@"如房主为多人，请用逗号隔开填写",@"请输入",@"如房主为多人，请按顺序用逗号隔开填写"];
    [self createUI];
    
}

-(NSMutableArray *)IdcardArray{
    if (_IdcardArray == nil) {
        _IdcardArray = [[NSMutableArray alloc]init];;
    }
    return _IdcardArray;
}
-(NSMutableArray *)subViewArray{
    if (_subViewArray == nil) {
        _subViewArray = [[NSMutableArray alloc]init];;
    }
    return _subViewArray;
}

-(void)createUI{
    
    for (int i = 0; i < self.nameArray.count; i ++) {
        UITextField *tf = [[UITextField alloc]init];
        tf.placeholder = self.placeholderArr[i];
        tf.textAlignment = NSTextAlignmentRight;
        tf.font = [UIFont systemFontOfSize:12];
        tf.textColor = JHmiddleColor;
        if (i > 2) {
            tf.enabled = NO;
        }
        if (i == 1) {
            tf.keyboardType = UIKeyboardTypeNumberPad;
        }
        [self.subViewArray addObject:tf];
    }
    LFLog(@"self.subViewArray:%@",self.subViewArray);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = JHColor(222, 222, 222);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    
    
    UIView * foootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 300)];
    
    UIButton * submitBtn = [[UIButton alloc]init];
    [submitBtn setImage:[UIImage imageNamed:@"tijiaobuttun"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(employsubmitClick) forControlEvents:UIControlEventTouchUpInside];
    [foootview addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(70);
        make.centerX.equalTo(foootview.mas_centerX);
    }];
    
    
    
    self.tableView.tableFooterView = foootview;
    
    
    
}
-(void)createCollectionview{
    
    if (self.collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = CGSizeMake((SCREEN.size.width-30)/2, self.backImage.size.height);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 1;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.backImage.size.height + 20) collectionViewLayout:flowLayout];
        self.collectionView.dataSource=self;
        self.collectionView.delegate=self;
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self tz_addPopGestureToView:self.collectionView];
        //注册Cell，必须要有
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"maintenanCollectionViewCell"];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.nameArray.count;
    }
    if (section == 1) {
        return 1;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *Header = [[UIView alloc]init];
    Header.backgroundColor = JHColor(234, 244, 249);
    UILabel *lb = [[UILabel alloc]init];
    lb.font = [UIFont systemFontOfSize:15];
    if (section == 1) {
        lb.attributedText = [self.titleArray[section] AttributedString:@"如房主多人，请依次上传" backColor:nil uicolor:nil uifont:[UIFont systemFontOfSize:12]];
    }else{
        lb.text = self.titleArray[section];
    }
    lb.textColor = JHmiddleColor;
    [Header addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.centerY.equalTo(Header.mas_centerY);
    }];
    

    return Header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //        NSString *CellIdentifier = @"iscell";
    //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"maintenancell%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            UILabel *label = [[UILabel alloc]init];
            label.textColor = JHColor(53, 53, 53);
            label.font = [UIFont systemFontOfSize:15];
            label.text = self.nameArray[indexPath.row];
            CGSize lbsize = [label.text selfadaption:15];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.offset(10);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.width.offset(lbsize.width + 5);
                
            }];
            UITextField *tf = self.subViewArray[indexPath.row];
            
            [cell.contentView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.offset(-30);
                make.left.equalTo(label.mas_right).offset(10);
                
            }];

        }

    }
    if (indexPath.section == 1) {
        [self createCollectionview];
        [cell.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.top.offset(10);
            make.bottom.offset(0);
        }];
    }else if (indexPath.section == 2){
        
        if (deedbtn == nil) {
            deedbtn = [[IndexBtn alloc]initWithFrame:CGRectMake(10 , 10, (SCREEN.size.width - 20)/2, self.backImage.size.height)];
            deedbtn.layer.masksToBounds = YES;
            deedbtn.imageView.contentMode = UIViewContentModeCenter;
//            [deedbtn setBackgroundImage:[UIImage imageNamed:@"shenfenzhengkuang"] forState:UIControlStateNormal];
            [deedbtn setImage:self.deedImage forState:UIControlStateNormal];
            [deedbtn addTarget:self action:@selector(deedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell.contentView addSubview:deedbtn];
        
    }
    
    return cell;
    
    
}
-(void)deedBtnClick:(IndexBtn *)btn{
    [self jxt_showActionSheetWithTitle:@"请选择" message:@"" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.
        addActionCancelTitle(@"取消");
        alertMaker.
        addActionDefaultTitle(@"拍照");
        alertMaker.
        addActionDefaultTitle(@"相册");
        
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        
        if ([action.title isEqualToString:@"取消"]) {
            NSLog(@"取消");
        }else if ([action.title isEqualToString:@"拍照"]) {
            UIImagePickerController *pic = [[UIImagePickerController alloc]init];
            pic.delegate = self;
            //允许编辑图片
            pic.allowsEditing = NO;
            pic.sourceType = UIImagePickerControllerSourceTypeCamera;
                //显示控制器
            [self presentViewController:pic animated:YES completion:nil];

        }else if ([action.title isEqualToString:@"相册"]) {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
            imagePickerVc.maxImagesCount = 1;
            imagePickerVc.allowPickingOriginalPhoto = NO;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                NSLog(@"选择图片");
                if (photos.count) {
                    [deedbtn setImage:photos[0] forState:UIControlStateNormal];
                    self.deedImage = photos[0];
                }
            }];
            
            [self presentViewController:imagePickerVc animated:YES completion:nil];

        }
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return self.IdcardArray.count/2 * (self.backImage.size.height + 10) + self.IdcardArray.count%2 * (self.backImage.size.height + 10) + 10;
    }else if (indexPath.section == 2){
        return self.backImage.size.height + 30;
    }
    return 50;
}
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.IdcardArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"maintenanCollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.contentView removeAllSubviews];
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.userInteractionEnabled = YES;
    
    if ([self.IdcardArray[indexPath.row] isKindOfClass:[UIImage class]]) {
        imageview.image = self.IdcardArray[indexPath.row];
    }else{
        [imageview sd_setImageWithURL:[NSURL URLWithString:self.IdcardArray[indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
    [cell.contentView addSubview:imageview];
    cell.contentView.backgroundImage = [UIImage imageNamed:@"shenfenzhengkuang"];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    
    if (!(indexPath.row == self.IdcardArray.count - 1)) {
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        IndexBtn *btn = [[IndexBtn alloc]init];
        btn.index = indexPath.row;
        //btn.backgroundColor = [UIColor blueColor];
        [btn setImage:[UIImage imageNamed:@"shanchu_baoxiutupian"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [cell.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.right.offset(0);
            make.width.offset(25);
            make.height.offset(25);
        }];
    }else{
        imageview.contentMode = UIViewContentModeCenter;
    }
    
    return cell;
}



-(void)clearbuttonclick:(IndexBtn *)button{
    [self.IdcardArray removeObjectAtIndex:button.index];
    [self.tableView reloadData];
    [self.collectionView reloadData];
    
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
    if (indexPath.row < self.IdcardArray.count - 1) {
        NSMutableArray * muarr = [self.IdcardArray mutableCopy];
        [muarr removeObject:self.picture];
        STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:muarr currentIndex:indexPath.row];
        [broser show];
    }else{
        NSString *temp = nil;
        NSString *name = nil;
        NSString *idcard = nil;
        for (int i = 0 ; i < self.subViewArray.count; i ++ ) {
            UITextField *tf = self.subViewArray[i];
            if (i == 0) {
                if (tf.text.length == 0) {
                    temp = @"请先输入房主姓名";
                }else{
                    name = tf.text;
                }
                
            }else if (i == 2){
                if (tf.text.length == 0) {
                    if (temp == nil) {
                        temp = @"请先输入身份证号码";
                    }
                    
                }else{
                    idcard = tf.text;
                }
                
            }
        }
        if (temp == nil) {
            AVCaptureViewController *AVCaptureVC = [[AVCaptureViewController alloc] init];
            [AVCaptureVC StartTesting:YES];
            [AVCaptureVC successfulGetIdCodeInfo:^(IDInfo *Info, UIImage *image) {
                LFLog(@"Info:%@",Info.num);
                BOOL isOk = NO;
                NSString *temp = nil;
                NSString *name = nil;
                NSString *idcard = nil;
                for (int i = 0 ; i < self.subViewArray.count; i ++ ) {
                    UITextField *tf = self.subViewArray[i];
                    
                    if (i == 0) {
                        name = tf.text;
                        
                    }else if (i == 2){
                        name = tf.text;
                        
                    }
                }
                if (temp == nil) {
                    name = [name stringByReplacingOccurrencesOfString:@"，" withString:@","];
                    idcard = [name stringByReplacingOccurrencesOfString:@"，" withString:@","];
                    NSArray *nameArr = [name componentsSeparatedByString:@","];
                    NSArray *idcardArr = [name componentsSeparatedByString:@","];
                    for (NSString *str1 in nameArr) {
                        if ([str1 isEqualToString:Info.name]) {
                            isOk = YES;
                        }
                    }
                    if (!isOk) {
                        temp = @"扫描身份证信息和您输入的身份证姓名不一致，请重新拍摄!";
                    }
                    
                    for (NSString *str2 in idcardArr) {
                        if ([str2 isEqualToString:Info.num]) {
                            isOk = YES;
                        }
                    }
                    if (!isOk) {
                        if (temp == nil) {
                            temp = @"扫描身份证信息和您输入的身份证号码信息不一致，请重新拍摄!";
                        }
                        
                    }
                }

                if (isOk) {
                    [self.IdcardArray removeObject:self.picture];
                    [self.IdcardArray addObject:image];
                    [self.IdcardArray addObject:self.picture];
                    [self.tableView reloadData];
                    [self.collectionView reloadData];
                }else{
                    [self alertController:@"提示" prompt:@"扫描身份证信息和您输入的身份证号码信息不一致，请重新拍摄!" sure:@"确定" cancel:nil success:^{
                        
                    } failure:^{
                        
                    }];
                }
                
            }];
            
            [self.navigationController pushViewController:AVCaptureVC animated:YES];
        }else{
        
            [self presentLoadingTips:temp];
        }
        
    }
    
    
    
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //    LFLog(@"info%@",info);
    
    UIImage *editimage = info[UIImagePickerControllerOriginalImage];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
//    if ([mediaType isEqualToString:@"public.image"]) {  //判断是否为图片
//        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            UIImageWriteToSavedPhotosAlbum(editimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        }
//    }
    editimage = [editimage fixOrientation];
    if (editimage) {
        [deedbtn setImage:editimage forState:UIControlStateNormal];
        self.deedImage = editimage;
    }
    //移除图片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

//此方法就在UIImageWriteToSavedPhotosAlbum的上方
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"已保存");
}
#pragma mark - 提交按钮
-(void)employsubmitClick{
    NSArray *tipArr = @[@"请输入房主姓名",@"请输入房产编号",@"请输入身份证号",@"",@""];
    NSString *name = nil;
    NSString *idcard = nil;
    for (int i = 0 ; i < self.subViewArray.count; i ++ ) {
        UITextField *tf = self.subViewArray[i];
        if (tf.text.length == 0) {
            [self presentLoadingTips:tipArr[i]];
            return;
        }else{
            if (i == 0) {
                name = tf.text;
            }else if (i == 2){
                idcard = tf.text;
            }
        
        }
    }
    name = [name stringByReplacingOccurrencesOfString:@"，" withString:@","];
    idcard = [name stringByReplacingOccurrencesOfString:@"，" withString:@","];
    NSArray *nameArr = [name componentsSeparatedByString:@","];
    NSArray *idcardArr = [name componentsSeparatedByString:@","];
    if (nameArr.count != idcardArr.count) {
        [self presentLoadingTips:@"您输入的房主姓名个数和身份证号码个数不一致，请核对！"];
        return;
    }
    if (self.IdcardArray.count - 1 < nameArr.count) {
        [self presentLoadingTips:@"请上传身份证照片!"];
        return;
    }
    
    if (self.IdcardArray.count < 2) {
        [self presentLoadingTips:@"请上传身份证照片!"];
        return;
    }
    if (self.deedImage == [UIImage imageNamed:@"fangchanzhengzhaopian"]) {
        [self presentLoadingTips:@"请上传房产证照片!"];
        return;
    }
//    [self upDateInfo];
    
}
#pragma mark 提交
-(void)upDateInfo{
    [self presentLoadingTips];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSArray *parameterArr = @[@"user_name",@"house",@"cardid"];
    for (int i = 0 ; i < parameterArr.count; i ++ ) {
        UITextField *tf = self.subViewArray[i];
        [dt setObject:tf.text forKey:parameterArr[i]];
    }
    LFLog(@"维修基金查询提交dt：%@",dt);
    NSMutableArray *mImagearr = [[NSMutableArray alloc]init];
    int i = 0;
    for (UIImage *im in self.IdcardArray) {
        if (im != self.picture) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:ImageKey,FliePathKey,[NSString stringWithFormat:@"imgurl1_%d",i],ImageNameKey,im,FlieImageKey, nil];//身份证照片
            [mImagearr addObject:dic];
        }
        i ++;
    }
    NSDictionary *deedDic = [NSDictionary dictionaryWithObjectsAndKeys:ImageKey,FliePathKey,@"imgurl2",ImageNameKey,self.deedImage,FlieImageKey, nil];//房产证照片
    [mImagearr addObject:deedDic];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,GovernmentMaintainSubmitUrl) params:dt body:self.IdcardArray success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"维修基金查询：%@",response);
        [self dismissTips];
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"查询成功，请稍后"];
            [self performSelector:@selector(gobackup) withObject:nil afterDelay:.2];

        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"提交失败，网络错误！"];
    }];
    
    
}

-(void)gobackup{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
