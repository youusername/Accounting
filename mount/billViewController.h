//
//  billViewController.h
//  mount
//
//  Created by zd2011 on 13-5-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "billManagement.h"
#import "ZenKeyboard.h"
@interface billViewController : UIViewController<UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    sqlite3 *db;
    FMDatabase*Fdb;
    UITextField *moneyTextField;
    UITextField *typeTextField;
    UITextField *subTypeTextField;
    UITextField *dateTextField;
    UITextField *personnelTextField;
    UITextView *commentTextField;
    UIButton *photoButton;
    
    UILabel *typeLabel;
    UILabel *subTypeLabel;
    UILabel *dateLabel;
    UILabel *personnelLabel;
    UILabel *conmmentLabel;
    
    UIToolbar *keyboardToolbar;
    UIPickerView *typePicker;
    UIPickerView *subTypePicker;
    UIPickerView *personPickerView;
    UIDatePicker *datePicker;
    
    NSString *types;
    NSString *subType;
    NSDate *theDate;
    NSString *person;
    UIImage *photo;
}

//@property(nonatomic,retain)IBOutlet UIButton *photoButton;

//-(IBAction)choosePhot:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *moneyTextField;
@property (strong, nonatomic) IBOutlet UITextField *typeTextField;
@property (strong, nonatomic) IBOutlet UITextField *subTypeTxetField;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet UITextField *personnelTextField;
@property (strong, nonatomic) IBOutlet UITextView *commentTextField;

@property (strong, nonatomic) IBOutlet UIButton *photoButton;
@property(assign,nonatomic) NSInteger billIndex;

@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *personnelLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;

@property(nonatomic,retain) UIToolbar *keyboardToolbar;
@property(nonatomic,retain) UIPickerView *typePicker;
@property(nonatomic,retain) UIPickerView*subTypePicker;
@property(nonatomic,retain) UIPickerView*personPickerView;
@property(nonatomic,retain) UIDatePicker*datePicker;

@property(nonatomic,retain) NSString*types;
@property(nonatomic,assign) int PickerIndex;
@property(nonatomic,retain) NSDate*theDate;
@property(nonatomic,retain) NSString*person;
@property(nonatomic,retain) UIImage*photo;
@property(nonatomic,strong) billManagement*billM;
@property(nonatomic,strong) NSArray*PickerArray;


- (IBAction)choosePhoto:(id)sender;

- (void)resignKeyboard:(id)sender;//辞职键盘
- (void)previousField:(id)sender;//之前的字段
- (void)nextField:(id)sender;
- (id)getFirstResponder;//得到第一个回答者
- (void)animateView:(NSUInteger)tag;//动画视图
- (void)checkBarButton:(NSUInteger)tag;//检查栏按钮
- (void)checkSpecialFields:(NSUInteger)tag;//检查特殊字段
- (void)setTypeData;
- (void)setSubTypeData;
- (void)setDateData;
- (void)setPersonData;
- (void)datePickerChanged:(id)sender;
- (void)resetLabelsColors;//复位标签颜色

+ (UIColor *)labelNormalColor;
+ (UIColor *)labelSelectedColor;

- (IBAction)saveApayout:(id)sender;
- (IBAction)clearButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *clearButtonOutlet;

@property (nonatomic, strong) ZenKeyboard *keyboardView;
@property(nonatomic,strong)NSString*backTypeNSString;
@end
