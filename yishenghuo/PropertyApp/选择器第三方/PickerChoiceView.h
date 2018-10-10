//
//  PickerChoiceView.h
//  TFPickerView
//
//  Created by TF_man on 16/5/11.
//  Copyright © 2016年 tituanwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFPickerDelegate <NSObject>

@optional;
- (void)PickerSelectorIndixString:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType ;
- (void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType ;
- (void)provinceSelectorIndixString:(NSString *)pricent city:(NSString *)city;

- (void)ThreeSelectorIndixString:(NSString *)type pricent:(NSString *)pricent city:(NSString *)city;

@end

typedef NS_ENUM(NSInteger, ARRAYTYPE) {
    GenderArray,
    HeightArray,//单行
    weightArray,
    DeteArray,
    ThreeArray,
    YearsArray
};

typedef void(^MybolckAddress) (NSString *stra);



@interface PickerChoiceView : UIView
@property (nonatomic,strong)NSString *titlestr;
@property (nonatomic,strong)UIPickerView *pickerV;

@property (nonatomic, assign) ARRAYTYPE arrayType;

@property (nonatomic, strong) NSArray *customArr;

@property (nonatomic,strong)UILabel *selectLb;

@property (nonatomic,assign)id<TFPickerDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *provinceArr;

@property (nonatomic, strong) NSMutableArray *cityArr;

@property (nonatomic, strong) NSMutableArray *typearr;

@property (nonatomic, strong) NSMutableArray *unitarr;

@property(nonatomic,copy) MybolckAddress addressBlockName;
@property (nonatomic, assign) NSInteger inter;

@property (nonatomic, assign) NSInteger item;//标识本身

-(void)setAddressBlockName:(MybolckAddress)addressBlockName;
-(void)reloadcomment:(NSInteger )row;

@end
