//
//  PunchSubmitViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "PunchSubmitViewController.h"
#import "UITextView+Placeholder.h"
#import "TZImagePickerController.h"
#import "UploadManager.h"
#import "LeaveSubModel.h"
@interface PunchSubmitViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *undoneBtn;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UILabel *numLb;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneBtnTop;
@property(nonatomic,strong)NSMutableArray  *imageArray;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property(nonatomic,strong)UIImage  *picture;
@property(nonatomic, strong)LeaveSubModel *lmodel;
@end

@implementation PunchSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textview.delegate = self;
    self.picture = [UIImage imageNamed:@"add"];
    self.isEmptyDelegate = NO;
    [self.imageArray addObject:self.picture];
    if ([UserUtils getUserRole] == UserStyleStudent) {
        if (self.isAmend) {
            self.navigationBarTitle = @"申请补分";
            [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            self.undoneBtn.hidden = YES;
            [self.doneBtn setImage:nil forState:UIControlStateNormal];
            [self.doneBtn setTitle:@"申请理由" forState:UIControlStateNormal];
            self.textview.placeholder = @"请详情描述理由和相关日期...";
        }else{
            self.navigationBarTitle = @"打卡";
            self.textview.placeholder = @"作业完成情况...";
            [self.submitBtn setTitle:@"确定" forState:UIControlStateNormal];
            [self.doneBtn setImage:[UIImage imageNamed:@"choosed"] forState:UIControlStateSelected];
            [self.undoneBtn setImage:[UIImage imageNamed:@"choosed"] forState:UIControlStateSelected];
            self.doneBtn.selected = YES;
        }
    }else if ([UserUtils getUserRole] == UserStyleInstructor){//考勤设定
        self.navigationBarTitle = @"审核结果";
        self.lmodel = [[LeaveSubModel alloc]init];
        self.lmodel.status = 3; //2拒绝,3同意
        [self.submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.doneBtn setImage:[UIImage imageNamed:@"choosed"] forState:UIControlStateSelected];
        [self.undoneBtn setImage:[UIImage imageNamed:@"choosed"] forState:UIControlStateSelected];
        [self.doneBtn setTitle:@"   同意" forState:UIControlStateNormal];
        [self.undoneBtn setTitle:@"   拒绝" forState:UIControlStateNormal];
        self.textview.placeholder = @"请输入审核意见...";
        self.doneBtn.selected = YES;
    }

    self.doneBtnTop.constant = SAFE_NAV_HEIGHT + 15;
    [self initData];
}
-(void)initData{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake((screenW - 50)/3 -1, (screenW - 60)/3);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.collectionview setCollectionViewLayout:flowLayout];
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}
-(NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray  = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}
- (IBAction)doneClick:(UIButton *)sender {
    sender.selected = YES;
    if (!self.isAmend) {
        self.doneBtn == sender ? (self.undoneBtn.selected = NO) : (self.doneBtn.selected = NO);
    }
    if ([UserUtils getUserRole] == UserStyleInstructor){
        self.lmodel.status = sender == self.doneBtn ? 3 : 2;
    }

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
    if ([UserUtils getUserRole] == UserStyleInstructor){
        self.lmodel.check_content = textView.text;
    }
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
    [self.collectionview reloadData];
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *image = self.imageArray[indexPath.row];
    if ([image isEqual:self.picture]) {
        if (self.imageArray.count > 5) {
            [self presentLoadingTips:@"最多选择5张图片!"];
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
        [self alertController:@"提示" prompt:@"此应用没有权限访问您的照片或视频，您可以在”隐私设置“中启用访问" sure:@"确定" cancel:@"取消" success:^{
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
        [self presentViewController:pic animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:self];
        imagePickerVc.maxImagesCount = 6 - self.imageArray.count ;
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowCrop = YES;
        imagePickerVc.cropRect = CGRectMake(0, (screenH-screenW)/2, screenW, screenW);
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark  图片选择成功的方法
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    [self.imageArray removeAllObjects];
    for (UIImage *im in photos) {
        [self.imageArray addObject:im];
    }
    [self.imageArray addObject:self.picture];
    
    [self.collectionview reloadData];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *editimage = info[UIImagePickerControllerOriginalImage];
    
    editimage = [editimage fixOrientation];
    for (UIImage *image in self.imageArray) {
        if ([image isEqual:self.picture]) {
            [self.imageArray removeObject:image];
            
        }
    }
    [self.imageArray addObject:self.picture];
    [self.collectionview reloadData];
    //移除图片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 确定
- (IBAction)SubmitClick:(UIButton *)sender {
    __block NSMutableDictionary *mdt = [NSMutableDictionary dictionary];
    NSString *url = @"";
    if ([UserUtils getUserRole] == UserStyleStudent) {
        if (!self.textview.text.length) {
            [self presentLoadingTips:self.isAmend ? @"请输入补分理由！" :@"请输入作业完成情况"];
            return;
        }
        [mdt setObject:self.textview.text forKey:@"content"];
        if (self.isAmend) {
            url = IntegralStuSubmitUrl;
        }else{
            [mdt setObject:self.doneBtn.selected == YES ? @"2" :@"3" forKey:@"type"];//2已完成，3未完成
            url = OperationStuSubmitUrl;
            // @"打卡";
            
        }
    }else if ([UserUtils getUserRole] == UserStyleInstructor){//考勤设定
        //@"审核结果";
        url = LeaveInsApprovaltUrl;
        mdt = [self.lmodel mj_keyValues];

    }
    if (self.ID) {
        [mdt setObject:self.ID forKey:@"id"];
    }
    NSMutableArray *marr = [NSMutableArray arrayWithArray:self.imageArray];
    [marr removeObject:self.picture];
    if (marr.count) {
        [self presentLoadingTips];
        [UploadManager uploadImagesWith:marr uploadFinish:^(NSArray *imFailArr){
            if (imFailArr.count) {
                [self alertController:@"提示" prompt:[NSString stringWithFormat:@"您有%lu张图片上传失败！，是否继续",(unsigned long)marr.count] sure:@"是" cancel:@"否" success:^{
                    [self UpdateLoad:mdt url:url];
                } failure:^{
                    [self dismissTips];
                }];
            }else{
                [self UpdateLoad:mdt url:url];
            }
            
        } success:^(NSDictionary *imgDic, int idx) {
            NSInteger code = [imgDic[@"code"] integerValue];
            if (code == 1) {
                NSString *key = @"images";
                if ([UserUtils getUserRole] == UserStyleInstructor){
                    key = @"check_images";
                }
                NSString *imageurl = mdt[key];
                if ([imgDic[@"data"][@"type"] isEqualToString:@"1"]) {
                    imageurl = [imgDic[@"data"][@"url"] SeparatorStr:imageurl];
                }
                [mdt setObject:imageurl forKey:key];
            }else{
                [AlertView showMsg:imgDic[@"msg"]];
            }
        } failure:^(NSError *error, int idx) {

        }];
    }else{
        [self UpdateLoad:mdt url:url];
    }
    
}

#pragma mark 提交
-(void)UpdateLoad:(NSMutableDictionary *)mdt url:(NSString *)url{
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,url) params:mdt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"tijaio:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            NSLog(@"注册成功");
            if (self.successBlock) {
                self.successBlock();
            }
            [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.];
        }
        [AlertView showMsg:response[@"msg"]];
        
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"error：%@",error);
    }];
}
-(void)dismissView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
