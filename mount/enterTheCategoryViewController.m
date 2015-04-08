//
//  enterTheCategoryViewController.m
//  mount
//
//  Created by zd2011 on 13-6-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "enterTheCategoryViewController.h"
#import "settingManagement.h"
#import "addSubtypeViewController.h"
#define kTypeTable  @"type"
#define kSubTypeTable   @"subtype"
#define kPersonnel  @"personnel"

@interface enterTheCategoryViewController ()
@property(nonatomic,strong)settingManagement*settingM;
@property(nonatomic,strong)NSNumber*type_id;
@end

@implementation enterTheCategoryViewController
@synthesize number,settingM,TextFieldStr,type_id;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"add.png"]];
    [self InitTitle];
    self.settingM=[[settingManagement alloc]init];
    if ([self.number intValue]==4) {
        self.TextFieldStr.keyboardType=UIKeyboardTypeNumberPad;
    }
	// Do any additional setup after loading the view.
}
-(void)InitTitle{
    if ([self.number intValue]==1) {
        self.TitleLabel.text=@"欢迎进入类别添加！";
        self.TextFieldName.text=@"请输入类别：";
    }else if ([self.number intValue]==2){
        self.TitleLabel.text=@"欢迎进入子类别添加！";
        self.TextFieldName.text=@"请输入子类别：";
    }else if ([self.number intValue]==3){
        self.TitleLabel.text=@"欢迎进入成员添加！";
        self.TextFieldName.text=@"请输入成员：";
    }else if ([self.number intValue]==4){
        
        self.TitleLabel.text=@"欢迎进预算添加！";
        self.TextFieldName.text=@"请输入预算金额：";
    }
}

- (void)viewDidUnload
{
    [self setTextFieldStr:nil];
    [self setTitleLabel:nil];
    [self setTextFieldName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)addButton:(id)sender {
    if ([self.number intValue]==1) {
        [self.settingM AddPayoutTypeData:kTypeTable str:self.TextFieldStr.text];
    }else if ([self.number intValue]==2){
        [self.settingM AddSubType:self.type_id subtype:self.TextFieldStr.text];
        
    }else if ([self.number intValue]==3){
        [self.settingM AddPayoutTypeData:kPersonnel str:self.TextFieldStr.text];
    }else if ([self.number intValue]==4){
        
        [self.settingM insertIntoBudgetTable:[NSNumber numberWithInt:[self.TextFieldStr.text intValue]]];
    }
    SHOW_ALERT(@"添加成功", @"");
    [self.navigationController popViewControllerAnimated:YES];
}
@end
