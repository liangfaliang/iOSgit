//
//  PickerChoiceView.m
//  TFPickerView
//
//  Created by TF_man on 16/5/11.
//  Copyright © 2016年 tituanwang. All rights reserved.
//
//屏幕宽和高
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

//RGB
//#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// 缩放比
#define kScale ([UIScreen mainScreen].bounds.size.width) / 375

#define hScale ([UIScreen mainScreen].bounds.size.height) / 667

//字体大小
#define kfont 15

#import "PickerChoiceView.h"
#import "Masonry.h"

@interface PickerChoiceView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
}

@property (nonatomic,strong)UIView *bgV;

@property (nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,strong)UIButton *conpleteBtn;




@property (nonatomic,strong)NSMutableArray *array;

@property (nonatomic,assign)NSInteger selecinteger;

@property (nonatomic,strong)NSString *province;

@property (nonatomic,assign)NSString * city;
@end

@implementation PickerChoiceView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.array = [NSMutableArray array];
        self.maxDate = LONG_MAX;
        self.minDate = 0;
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = RGBA(51, 51, 51, 0.8);
        self.bgV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 324*hScale)];
        self.bgV.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgV];
        
        [self showAnimation];
        
        //取消
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgV addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(44);
            
        }];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:kfont];
        [self.cancelBtn sizeToFit];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelBtn setTitleColor:RGBA(0, 122, 255, 1) forState:UIControlStateNormal];
        //完成
        self.conpleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.conpleteBtn sizeToFit];
        [self.bgV addSubview:self.conpleteBtn];
        [self.conpleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(44);
            
        }];
        self.conpleteBtn.titleLabel.font = [UIFont systemFontOfSize:kfont];
        [self.conpleteBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.conpleteBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.conpleteBtn setTitleColor:RGBA(0, 122, 255, 1) forState:UIControlStateNormal];
        
        //选择titi
        self.selectLb = [UILabel new];
        [self.bgV addSubview:self.selectLb];
        [self.selectLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.bgV.mas_centerX).offset(0);
            make.centerY.mas_equalTo(self.conpleteBtn.mas_centerY).offset(0);
            
        }];
        self.selectLb.font = [UIFont systemFontOfSize:kfont];
        self.selectLb.textAlignment = NSTextAlignmentCenter;
        
        //线
        UIView *line = [UIView new];
        [self.bgV addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.cancelBtn.mas_bottom).offset(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(0.5);
            
        }];
        line.backgroundColor = RGBA(224, 224, 224, 1);
        
        //选择器
        self.pickerV = [UIPickerView new];

//        self.pickerV.showsSelectionIndicator = YES;
        [self.bgV addSubview:self.pickerV];
        [self.pickerV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(line.mas_bottom).offset(0);
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            
        }];
        self.pickerV.delegate = self;
        self.pickerV.dataSource = self;
        _selectDate = [[NSDate date] timeIntervalSince1970];
        
        
    }
    return self;
}

-(void)reloadcomment:(NSInteger )row{
    
    [self.pickerV reloadComponent:row];
    
}
-(NSMutableArray *)provinceArr{
    
    if (_provinceArr == nil) {
        _provinceArr = [[NSMutableArray alloc]init];
    }
    
    return _provinceArr;
}

-(NSMutableArray *)cityArr{
    
    if (_cityArr == nil) {
        _cityArr = [[NSMutableArray alloc]init];
    }
    
    return _cityArr;
}
-(NSMutableArray *)typearr{
    
    if (_typearr == nil) {
        _typearr = [[NSMutableArray alloc]init];
    }
    
    return _typearr;
}

-(NSMutableArray *)unitarr{
    
    if (_unitarr == nil) {
        _unitarr = [[NSMutableArray alloc]init];
    }
    
    return _unitarr;
}
-(void)setAddressBlockName:(MybolckAddress)addressBlockName{
    
    _addressBlockName = addressBlockName;
    
}
- (void)setCustomArr:(NSArray *)customArr{
    _arrayType = 5;
    _customArr = customArr;
    [self.array addObject:customArr];
    
}

- (void)setArrayType:(ARRAYTYPE)arrayType
{
    _arrayType = arrayType;
    switch (arrayType) {
        case GenderArray:
        {
            if (self.titlestr) {
                self.selectLb.text = _titlestr;
            }else{
                self.selectLb.text = @"选择城市";
            }
        }
            break;
        case HeightArray:
        {
            if (self.titlestr) {
                self.selectLb.text = _titlestr;
            }else{
                self.selectLb.text = @"选择缴费类型";
            }
            
            [self.array removeAllObjects];
            [self.array addObject:(NSArray *)self.typearr];
        }
            break;
        case weightArray:
        {
            if (self.titlestr) {
                self.selectLb.text = _titlestr;
            }else{
                self.selectLb.text = @"选择单位";
            }
            
            [self.array addObject:(NSArray *)self.unitarr];
        }
            break;
        case DeteArray:
        {
            if (self.titlestr) {
                self.selectLb.text = _titlestr;
            }else{
                self.selectLb.text = @"选择出生年月";
            }
            
            [self creatDate];
        }
            break;
        case ThreeArray:
        {
            if (self.titlestr) {
                self.selectLb.text = _titlestr;
            }else{
                 self.selectLb.text = @"品牌列表";
            }
           
            
        }
            break;
        case YearsArray:
        {
            self.selectLb.text = @"启用年份";
            [self createYears];
        }
            break;
        case YMDWarray:
        {
            [self.pickerV selectRow:self.selectDate/(24*60*60) inComponent:0 animated:NO];
            [self createYears];
        }
            break;
            
        default:
            break;
    }
}



- (void)creatDate{
    
    
    NSMutableArray *yearArray = [[NSMutableArray alloc] init];
    for (int i = 1970; i <= 2050 ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d年",i]];
    }
    [self.array addObject:yearArray];
    
    NSMutableArray *monthArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 13; i ++) {
        
        [monthArray addObject:[NSString stringWithFormat:@"%d月",i]];
    }
    [self.array addObject:monthArray];
    
//    NSMutableArray *daysArray = [[NSMutableArray alloc]init];
//    for (int i = 1; i < 32; i ++) {
//        
//        [daysArray addObject:[NSString stringWithFormat:@"%d日",i]];
//    }
//    [self.array addObject:daysArray];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSString *currentYear = [NSString stringWithFormat:@"%@年",[formatter stringFromDate:date]];
    [self.pickerV selectRow:[yearArray indexOfObject:currentYear]+81*50 inComponent:0 animated:YES];
    
    [formatter setDateFormat:@"MM"];
    NSString *currentMonth = [NSString stringWithFormat:@"%ld月",(long)[[formatter stringFromDate:date]integerValue]];
    [self.pickerV selectRow:[monthArray indexOfObject:currentMonth]+12*50 inComponent:1 animated:YES];
    
//    [formatter setDateFormat:@"dd"];
//    NSString *currentDay = [NSString stringWithFormat:@"%@日",[formatter stringFromDate:date]];
//    [self.pickerV selectRow:[daysArray indexOfObject:currentDay]+31*50 inComponent:2 animated:YES];
    
    
}

-(void)createYears{
    
    
    [self.array addObject:self.typearr];
    
    NSMutableArray *monthArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 13; i ++) {
        
        [monthArray addObject:[NSString stringWithFormat:@"%d月",i]];
    }
    [self.array addObject:monthArray];
    
    //    NSDate *date = [NSDate date];
    //
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //
    //    [formatter setDateFormat:@"yyyy"];
    //    NSString *currentYear = [NSString stringWithFormat:@"%@年",[formatter stringFromDate:date]];
    //    [self.pickerV selectRow:[_typearr indexOfObject:currentYear]+81*50 inComponent:0 animated:YES];
    //
    //    [formatter setDateFormat:@"MM"];
    //    NSString *currentMonth = [NSString stringWithFormat:@"%ld月",(long)[[formatter stringFromDate:date]integerValue]];
    //    [self.pickerV selectRow:[monthArray indexOfObject:currentMonth]+12*50 inComponent:1 animated:YES];
    
    
    
    
    
    
    
    
}

#pragma mark-----UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    if (self.arrayType == GenderArray){
        return 2;
    }else if (self.arrayType == ThreeArray){
        return 3;
    }else if (self.arrayType == YMDWarray){
        return 1;
    }
    return self.array.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    if (self.arrayType == DeteArray) {
        NSArray * arr = (NSArray *)[self.array objectAtIndex:component];
        return arr.count*100;
        
    }else if (self.arrayType == GenderArray){
        if (component == 0) {
            return self.provinceArr.count;
        }else{
            return self.cityArr.count;
        }
    }else if (self.arrayType == ThreeArray){
        if (component == 0) {
            return self.typearr.count;
        }else if(component == 1){
            return self.provinceArr.count;
        }else {
            return self.cityArr.count;
        }
    }else if (self.arrayType == YMDWarray){
        return [[NSDate date] timeIntervalSince1970]/(24*60*60) *2;
    }else{
        NSArray * arr = (NSArray *)[self.array objectAtIndex:component];
        return arr.count;
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = JHColor(200, 200, 200);
        }
    }
    UILabel *label=[[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 0;
    label.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return label;
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.arrayType == GenderArray){
        if (component == 0) {
            if (row == 0) {
                if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:row:isType:)]) {
                    [self.delegate PickerSelectorIndixString:self.provinceArr[row] row:row isType:0];
                }
                if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:str:row:isType:)]) {
                    [self.delegate PickerSelectorIndixString:self str:self.provinceArr[row] row:row isType:0];
                }
                
                
            }
            return self.provinceArr[row];
        }else{
            
            return self.cityArr[row];
            
        }
    }else if (self.arrayType == ThreeArray){
        if (component == 0) {
            if (row == 0) {
                if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:row:isType:)]) {
                    [self.delegate PickerSelectorIndixString:self.typearr[row] row:0 isType:5];
                }
                if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:str:row:isType:)]) {
                    [self.delegate PickerSelectorIndixString:self str:self.typearr[row] row:0 isType:5];
                }
                
                
            }
            return self.typearr[row];
        }else if(component == 1){
            if (row == 0) {
                //                [self.delegate PickerSelectorIndixString:self.provinceArr[row] row:1 isType:5];
            }
            NSLog(@"%@",self.provinceArr[row]);
            return self.provinceArr[row];
            
        }else{
            
            
            return _cityArr[row];
        }
        
        
    }else if (self.arrayType == YMDWarray){
        NSArray *weekArr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        NSInteger newDate = row * 24*60*60;
        NSDate *now = [NSDate dateWithTimeIntervalSince1970:newDate];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                                             fromDate:now];
        // 得到星期几
        NSInteger weekDay = [comp weekday];
        // 得到几号
        NSInteger day = [comp day];
        NSInteger month = [comp month];
        NSInteger year = [comp year];
        self.selectLb.text = [NSString stringWithFormat:@"%ld",(long)year];
        if (row == (int)[[NSDate date] timeIntervalSince1970]/(24*60*60)) {
            return @"今天";
        }
        return [NSString stringWithFormat:@"%ld月%ld日 星期%@",(long)month,(long)day,weekArr[weekDay-1]];
    }else{
        
        NSArray *arr = (NSArray *)[self.array objectAtIndex:component];
        return [arr objectAtIndex:row % arr.count];
    }
    
}


//返回每一列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    if (self.arrayType == DeteArray) {
        
        return 60;
        
    }else if (self.arrayType == GenderArray){
        
        if (component == 0) {
            return screenW/2 - 50;
        }else{
            return screenW/2 + 30;
            
        }
    }else if (self.arrayType == ThreeArray){
        if (component == 0) {
            return 70;
        }else if (component == 1){
            return 50;
            
        }else{
            
            return 150;
        }
        
    }else if (self.arrayType == YearsArray){
        
        if (component == 0) {
            return screenW/2 - 20;
        }else{
            return screenW/2 - 20;
            
        }
    }else{
        
        return 300;
    }
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        if (self.arrayType == YMDWarray) {
            NSInteger minRow = roundf(self.minDate/(24*60*60.0));
            NSInteger maxRow = roundf(self.maxDate/(24*60*60.0));
            if (row < minRow) {
                [self.pickerV selectRow:minRow inComponent:0 animated:YES];
            }
            if (row > maxRow) {
                [self.pickerV selectRow:maxRow inComponent:0 animated:YES];
            }
            return;
        }
        if (self.inter == 1) {
            
            NSString *str =[NSString stringWithFormat:@"%@",self.provinceArr[row]];
            if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:row:isType:)]) {
                [self.delegate PickerSelectorIndixString:str row:0 isType:0];
            }
            if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:str:row:isType:)]) {
                [self.delegate PickerSelectorIndixString:self str:str row:0 isType:0];
            }
            
            
            
        }else if (self.inter == 5){
            
            NSString *str =[NSString stringWithFormat:@"%@",self.typearr[row]];
            if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:row:isType:)]) {
                [self.delegate PickerSelectorIndixString:str row:0 isType:5];
            }
            if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:str:row:isType:)]) {
                [self.delegate PickerSelectorIndixString:self str:str row:0 isType:5];
            }
        }
    }if (component == 1) {
        if (self.inter == 5) {
            NSString *str =[NSString stringWithFormat:@"%@",self.provinceArr[row]];
            if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:row:isType:)]) {
                [self.delegate PickerSelectorIndixString:str row:1 isType:5];
            }
            if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:str:row:isType:)]) {
                [self.delegate PickerSelectorIndixString:self str:str row:1 isType:5];
            }
            
            
        }
    }
    
    
    
}
-(void)setSelectDate:(NSInteger)selectDate{
    _selectDate = selectDate;
    [self.pickerV selectRow:selectDate/24/60/60 inComponent:0 animated:NO];
}
//-(void)setMinDate:(NSInteger)minDate{
//    _minDate = minDate;
//    NSInteger now = [self.pickerV selectedRowInComponent:0]*24*60*60;
//    if (minDate>now) {
//        [self.pickerV selectRow:minDate/24/60/60 inComponent:0 animated:NO];
//    }
//}
//-(void)setMaxDate:(NSInteger)maxDate{
//    _maxDate = maxDate;
//    NSInteger now = [self.pickerV selectedRowInComponent:0]*24*60*60;
//    if (maxDate<now) {
//        [self.pickerV selectRow:maxDate/24/60/60 inComponent:0 animated:NO];
//    }
//}
#pragma mark-----点击方法

- (void)cancelBtnClick{
    [self hideAnimation];
}

- (void)completeBtnClick{
    if (self.arrayType == YMDWarray){
       NSInteger row = [self.pickerV selectedRowInComponent:0];
        NSInteger minRow = roundf(self.minDate/(24*60*60.0));
        NSInteger maxRow = roundf(self.maxDate/(24*60*60.0));
        if (row < minRow || row > maxRow) {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:str:row:isType:)]) {
            [self.delegate PickerSelectorIndixString:self str:[NSString stringWithFormat:@"%ld",row*24*60*60 ] row:0 isType:0];
        }
        if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:row:isType:)]) {
            [self.delegate PickerSelectorIndixString:[NSString stringWithFormat:@"%ld",row*24*60*60] row:0 isType:0];
        }
        [self hideAnimation];
        return;
    }
    NSString *fullStr = [NSString string];
    
    for (int i = 0; i < self.array.count; i++) {
        
        NSArray *arr = [self.array objectAtIndex:i];
        if (arr.count >0) {
            if (self.arrayType == DeteArray) {
                
                NSString *str = [arr objectAtIndex:[self.pickerV selectedRowInComponent:i]% arr.count];
                fullStr = [fullStr stringByAppendingString:str];
                
            }else if (self.arrayType == GenderArray){
                
                
                
            }else{
                
                NSString *str = [arr objectAtIndex:[self.pickerV selectedRowInComponent:i]];
                fullStr = [fullStr stringByAppendingString:str];
            }
        }
        
        
    }
    
    if (self.arrayType == GenderArray) {
        
        for (int i = 0; i < self.provinceArr.count; i++) {
            
            NSString * province = [self.provinceArr objectAtIndex:[self.pickerV selectedRowInComponent:0]];
            self.province = province;
        }
        for (int i = 0; i < self.cityArr.count; i++) {
            NSString * city = [self.cityArr objectAtIndex:[self.pickerV selectedRowInComponent:1]];
            self.city = city;
        }
        if ([self.delegate respondsToSelector:@selector(provinceSelectorIndixString:city:)]) {
            [self.delegate provinceSelectorIndixString:self.province city:self.city];
        }
        if ([self.delegate respondsToSelector:@selector(provinceSelectorIndixString:str:city:)]) {
            [self.delegate provinceSelectorIndixString:self str:self.province city:self.city];
        }
        
    }
    
    
    
    if (self.arrayType == HeightArray){
        if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:row:isType:)]) {
            [self.delegate PickerSelectorIndixString:fullStr row:2 isType:1];
        }
        if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:str:row:isType:)]) {
            [self.delegate PickerSelectorIndixString:self str:fullStr row:2 isType:1];
        }
    }else if (self.arrayType == weightArray){
        if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:row:isType:)]) {
            [self.delegate PickerSelectorIndixString:fullStr row:2 isType:2];
        }
        if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:str:row:isType:)]) {
            [self.delegate PickerSelectorIndixString:self str:fullStr row:2 isType:2];
        }
        
        
    }else if (self.arrayType == ThreeArray){
        
        NSString *type = [[NSString alloc]init];
        for (int i = 0; i < self.typearr.count; i++) {
            
            type = [self.typearr objectAtIndex:[self.pickerV selectedRowInComponent:0]];
            
        }
        for (int i = 0; i < self.provinceArr.count; i++) {
            
            NSString * province = [self.provinceArr objectAtIndex:[self.pickerV selectedRowInComponent:1]];
            self.province = province;
        }
        for (int i = 0; i < self.cityArr.count; i++) {
            NSString * city = [self.cityArr objectAtIndex:[self.pickerV selectedRowInComponent:2]];
            self.city = city;
        }
        
        [self.delegate ThreeSelectorIndixString:type pricent:self.province city:self.city];
        
        
    }else{
        if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:row:isType:)]) {
            [self.delegate PickerSelectorIndixString:fullStr row:5 isType:2];
        }
        if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:str:row:isType:)]) {
            [self.delegate PickerSelectorIndixString:self str:fullStr row:5 isType:2];
        }
        
        
    }
    
    
    
    [self hideAnimation];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hideAnimation];
    
}

//隐藏动画
- (void)hideAnimation{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = self.bgV.frame;
        frame.origin.y = kScreenHeight;
        self.bgV.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [self.bgV removeFromSuperview];
        [self removeFromSuperview];
        
    }];
    
}

//显示动画
- (void)showAnimation{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = self.bgV.frame;
        frame.origin.y = kScreenHeight-260*hScale - 64;
        self.bgV.frame = frame;
    }];
    
}


@end
