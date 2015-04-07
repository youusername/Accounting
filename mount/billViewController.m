//
//  billViewController.m
//  mount
//
//  Created by zd2011 on 13-5-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "billViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "Config.h"
#import "payout.h"

//#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#define FIELDS_COUNT       7
#define TYPE_FIELD_TAG     3
#define SUBTYPE_FIELD_TAG  4
#define DATE_FIELD_TAG     5
#define PERSON_FIELD_TAG   6
#define COMMENT_FIELD_TAG  8
@interface billViewController ()

@end

@implementation billViewController
@synthesize clearButtonOutlet;
@synthesize moneyTextField;
@synthesize typeTextField;
@synthesize subTypeTxetField;
@synthesize dateTextField;
@synthesize personnelTextField;
@synthesize commentTextField;
@synthesize photoButton;
@synthesize typeLabel;
@synthesize subTypeLabel;
@synthesize dateLabel;
@synthesize personnelLabel;
@synthesize commentLabel;
@synthesize keyboardToolbar;
@synthesize typePicker;
@synthesize subTypePicker;
@synthesize personPickerView;
@synthesize datePicker;
@synthesize types,PickerArray;
@synthesize theDate,PickerIndex;
@synthesize person,billM,backTypeNSString;
@synthesize photo,billIndex,keyboardView;

//@synthesize photoButton;


-(void)Init{
    self.navigationItem.title= @"记一笔";
    billM=[[billManagement alloc]init];
    PickerArray=[[NSArray alloc]init];
    //------------------手势------------------------
    UISwipeGestureRecognizer *recognizer; 
    if ([self.backTypeNSString isEqualToString:@"Dtype"]) {
        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        
        [[self view] addGestureRecognizer:recognizer];
    }else if([self.backTypeNSString isEqualToString:@"View"]){
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    [[self view] addGestureRecognizer:recognizer];
    
    }
    //------------------手势------------------------
    
}


-(void)backButton{
    //-----------------------返回-------------------
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"  style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];//UIBarButtonItem
    //-----------------------返回-------------------
}

-(void)backBtnAction{
    if ([self.backTypeNSString isEqualToString:@"Dtype"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    CATransition*transition=[CATransition animation];
    transition.duration=0.5;
//    transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.timingFunction= UIViewAnimationCurveEaseInOut;
//    transition.fillMode=kCAFillModeForwards;
    transition.type=kCATransitionPush;
    transition.subtype=kCATransitionFromBottom;//方向
    
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];//
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];

}
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
    NSLog(@"bill index -->%d",billIndex);
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"payout.png"]];
    [self Init];

    [self backButton];
    
    [self initPicker];

    if (billIndex>=0) {
        self.clearButtonOutlet.titleLabel.text=@"删除";
        [self aPayout];    
    }else {
        self.clearButtonOutlet.titleLabel.text=@"清空";
    }

    // Do any additional setup after loading the view.
}
-(void)aPayout{
    
    payout*_payout;
    _payout=[billM selectPayout:[NSNumber numberWithInteger:billIndex]];
    self.moneyTextField.text=[NSString stringWithFormat:@"%.2f",_payout.amount];
    self.photo = [UIImage imageWithData:_payout.image];
    [self.photoButton setImage:self.photo forState:UIControlStateNormal];
    self.typeTextField.text=[NSString stringWithFormat:@"%@",_payout.type];
    self.subTypeTxetField.text=_payout.subType;
    
    self.dateTextField.text=_payout.date;
    self.personnelTextField.text=_payout.personnel;
    self.commentTextField.text=_payout.comment;
   
}
-(void)initPicker{
    //type picker
    if (self.typePicker == nil) {
        self.typePicker = [[UIPickerView alloc] init];
        self.typePicker.delegate = self;
        self.typePicker.showsSelectionIndicator = YES;
    }
    //subtype picker
    if (self.subTypePicker == nil) {
        self.subTypePicker = [[UIPickerView alloc]init ];
        self.subTypePicker.delegate = self;
        self.subTypePicker.showsSelectionIndicator = YES;
    }
    //date picker
    if (self.datePicker == nil) {
        self.datePicker = [[UIDatePicker alloc]init ];
        [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        NSDate * currentDate = [NSDate date];
        NSDateComponents *dateComponents = [[NSDateComponents alloc]init ];
        [dateComponents setYear:-18];
        NSDate *selectedDate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents toDate:currentDate options:0 ];
        [self.datePicker setDate:selectedDate animated:YES];
            self.datePicker.date=[NSDate new];
        [self.datePicker setMaximumDate:currentDate];
        
        //
    }
    // person Picker
    if (self.personPickerView == nil) {
        self.personPickerView = [[UIPickerView alloc]init ];
        self.personPickerView.delegate = self;
        self.personPickerView.showsSelectionIndicator = YES;
    }
    
    //Keyboard toolbar
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"上一个", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(previousField:) ];
        UIBarButtonItem * nextButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"下一个", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(nextField:) ];
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil action:nil];
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", @"")style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard:)];
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem,nextButtonItem,spaceBarItem,doneBarItem, nil]];
        self.moneyTextField.inputAccessoryView = self.keyboardToolbar;
        self.typeTextField.inputAccessoryView = self.keyboardToolbar;
        self.subTypeTxetField.inputAccessoryView = self.keyboardToolbar;
        self.dateTextField.inputAccessoryView = self.keyboardToolbar;
        self.personnelTextField.inputAccessoryView = self.keyboardToolbar;
        self.commentTextField.inputAccessoryView = self.keyboardToolbar;
        self.typeTextField.inputView = self.typePicker;
        self.subTypeTxetField.inputView = self.subTypePicker;
        self.dateTextField.inputView = self.datePicker;
        self.personnelTextField.inputView = self.personPickerView;
    }
    //set localization
    self.moneyTextField.placeholder = NSLocalizedString(@"money", @"");
    self.typeTextField.text = [NSLocalizedString(@"", @"")uppercaseString];
    self.subTypeTxetField.text = [NSLocalizedString(@"", @"")uppercaseString];
    self.dateTextField.text = [NSLocalizedString(@"", @"")uppercaseString];
    self.personnelTextField.text = [NSLocalizedString(@"", @"")uppercaseString];
    self.commentTextField.text = [NSLocalizedString(@"", @"")uppercaseString];
    self.commentTextField.text=@" ";
    [self resetLabelsColors];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"swipe left");
        
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        CATransition*transition=[CATransition animation];
        transition.duration=0.5;
        transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type=kCATransitionPush;
        transition.subtype=kCATransitionFromBottom;//方向
        
        [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];//
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [self.navigationController popViewControllerAnimated:NO];
        NSLog(@"swipe Left");
        
        //执行程序
        
    }
}
- (void)viewDidUnload
{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:nil];
    
    [self setMoneyTextField:nil];
    [self setSubTypeTxetField:nil];
    [self setDateTextField:nil];
    [self setPersonnelTextField:nil];
    [self setCommentTextField:nil];
    [self setPhotoButton:nil];
    [self setTypeLabel:nil];
    [self setSubTypeLabel:nil];
    [self setDateLabel:nil];
    [self setPersonnelLabel:nil];
    [self setCommentLabel:nil];
    [self setClearButtonOutlet:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Others


-(void)resignKeyboard:(id)sender
{
    if ([self.types isEqualToString:@"type"]) {
        [self setTypeData];
    }
    else if ([self.types isEqualToString:@"subtype"]){
        [self setSubTypeData]; 
    }
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]||[firstResponder isKindOfClass:[UITextView class]]) {
        [firstResponder resignFirstResponder];
        [self animateView:1];
        [self resetLabelsColors];
    }
    
}
-(void)previousField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]||[firstResponder isKindOfClass:[UITextView class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger previousTag = tag == 1 ? 1 :tag - 1;
        [self checkBarButton:previousTag];
        [self animateView:previousTag];
        UITextField * previousField = (UITextField *)[self.view viewWithTag:previousTag];
        [previousField becomeFirstResponder];
        UILabel *nextLabel = (UILabel *)[self.view viewWithTag:previousTag + 10];
        if (nextLabel) {
            [self resetLabelsColors];
            [nextLabel setTextColor:[billViewController labelSelectedColor]];
        }
        [self checkSpecialFields:previousTag];
    }
}
- (void)nextField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger nextTag = tag == FIELDS_COUNT ? FIELDS_COUNT : tag + 1;
        [self checkBarButton:nextTag];
        [self animateView:nextTag];
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        [nextField becomeFirstResponder];
        UILabel *nextLabel = (UILabel *)[self.view viewWithTag:nextTag + 10];
        if (nextLabel) {
            [self resetLabelsColors];
            [nextLabel setTextColor:[billViewController labelSelectedColor]];
        }
        [self checkSpecialFields:nextTag];
    }
}
- (id)getFirstResponder
{
    NSUInteger index = 0 ;
    while (index <= FIELDS_COUNT) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return nil;
}

- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag > 3) {
        rect.origin.y = -44.0f * (tag - 3);
    } else {
        rect.origin.y = 0;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)checkBarButton:(NSUInteger)tag
{
    UIBarButtonItem *previousBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:0];
    UIBarButtonItem *nextBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:1];
    
    [previousBarItem setEnabled:tag == 1 ? NO : YES];
    [nextBarItem setEnabled:tag == FIELDS_COUNT ? NO : YES];
}

- (void)checkSpecialFields:(NSUInteger)tag
{
    if (tag == DATE_FIELD_TAG && [self.dateTextField.text isEqualToString:@""]) {
        [self setDateData];
    } else if (tag == PERSON_FIELD_TAG && [self.personnelTextField.text isEqualToString:@""]) {
        [self setPersonData];
    }else if (tag == TYPE_FIELD_TAG && [self.typeTextField.text isEqualToString:@""]) {
        [self setTypeData];
    }else if (tag == SUBTYPE_FIELD_TAG && [self.subTypeTxetField.text isEqualToString:@""]) {
        [self setSubTypeData];
    }else if (tag == COMMENT_FIELD_TAG && [self.commentTextField.text isEqualToString:@""]) {
        [self setComment];
    }
}
-(void)setComment
{
    self.commentTextField.text = @"aaaaaaaaaac";
    //self.types = @"S";
    
}
-(void)setTypeData
{

         self.typeTextField.text = [PickerArray objectAtIndex:[self.typePicker selectedRowInComponent:0]];

   //self.types = @"S";
    
}
-(void)setSubTypeData
{

        self.subTypeTxetField.text=[PickerArray objectAtIndex:[self.subTypePicker selectedRowInComponent:0]];
   
    
        //self.subType = @"Z";
   }
-(void)setDateData
{
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init ];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [self.datePicker setAccessibilityLanguage:@"Chinese"];

    self.theDate = self.datePicker.date;
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.dateTextField.text = [dateFormatter stringFromDate:self.theDate];
    
}
-(void)setPersonData
{
//    if ([self.personPickerView selectedRowInComponent:0] == 0) {
//        self.personnelTextField.text = NSLocalizedString(@"本人1", @"");
//        self.person = @"B";
//    }else {
    
    self.personnelTextField.text =[PickerArray objectAtIndex:[self.personPickerView selectedRowInComponent:0]];
        self.person = @"N";
//    }
}
-(void)datePickerChanged:(id)sender
{
    [self setDateData];
}
-(void)resetLabelsColors
{
    self.typeLabel.textColor = [billViewController labelNormalColor];
    self.subTypeLabel.textColor = [billViewController labelNormalColor];
    self.dateLabel.textColor = [billViewController labelNormalColor];
    self.personnelLabel.textColor = [billViewController labelNormalColor];
    self.commentLabel.textColor = [billViewController labelNormalColor];
}

+(UIColor *)labelNormalColor
{
    return [UIColor colorWithRed:0.016 green:0.216 blue:0.286 alpha:1.000];
}
+(UIColor *)labelSelectedColor
{
    return [UIColor colorWithRed:0.114 green:0.600 blue:0.737 alpha:1.000];
}
#pragma mark - saveApayout
- (IBAction)saveApayout:(id)sender {
    if (billIndex>=0) {
        payout*apayout=[[payout alloc]init];
        apayout.amount=[self.moneyTextField.text floatValue];
        apayout.payout_ID=billIndex;
        apayout.type=self.typeTextField.text;
        apayout.subType=self.subTypeTxetField.text;
        apayout.personnel=self.personnelTextField.text;
        apayout.comment=self.commentTextField.text;
        apayout.date=self.dateTextField.text;
        apayout.image=UIImagePNGRepresentation(self.photo);
        [billM alterPayout:apayout];
//        [self.navigationController popViewControllerAnimated:NO];
        [self backBtnAction];
    }
    else {
        
    
    payout*p=[[payout alloc]init];
    p.amount=[self.moneyTextField.text floatValue];
    p.type=self.typeTextField.text;
    p.subType=self.subTypeTxetField.text;
    p.date=self.dateTextField.text;
    p.personnel=self.personnelTextField.text;
    p.comment=self.commentTextField.text;
    p.image=UIImagePNGRepresentation(self.photo);
    if ([billM checkingPayout:p]) {
        [billM savePayout:p];

        [self clearBill];
    }else {
//        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"不能为空！" message:nil delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil, nil];
//        [alert show];
    }
        
    }
}


#pragma mark - clear
-(void)clearBill{
    self.moneyTextField.text=@"";
    self.typeTextField.text=@"";
    self.subTypeTxetField.text=@"";
    self.dateTextField.text=@"";
    self.commentTextField.text=@"";
    self.personnelTextField.text=@"";
    self.types=@"";
    [self.photoButton setImage:nil forState:UIControlStateNormal];
}
- (IBAction)clearButton:(id)sender {
    if (billIndex>=0) {
       
        [billM deletePayout:billIndex];
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"删除成功！" message:nil delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil, nil];
        [alert show];
        [self clearBill];
    }else {
        [self clearBill];
    }
    
}

#pragma mark - ZenKeyboard
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [moneyTextField becomeFirstResponder];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
- (void)setZenKeyboard {
  
    moneyTextField.textColor = RGB(104, 114, 121);
    //    _tfIncome.backgroundColor = [UIColor lightGrayColor];
    moneyTextField.textAlignment = UITextAlignmentLeft;
    moneyTextField.adjustsFontSizeToFitWidth = YES;
    //    _tfIncome.clearButtonMode = UITpextFieldViewModeWhileEditing;
    //    _tfIncome.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TotalAmount"]];
    //    _tfIncome.leftViewMode = UITextFieldViewModeAlways;
//    moneyTextField.text = @"0.00";
    //    _tfIncome.keyboardType = UIKeyboardTypeDecimalPad;
    
   
        keyboardView = [[ZenKeyboard alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    keyboardView.textField = moneyTextField;
    [self.view addSubview:moneyTextField];

}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    [moneyTextField resignFirstResponder];
       return YES;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==2) {
          [self setZenKeyboard];
    }
    if (textField.tag==3) {
        self.PickerArray=nil;
        self.types=@"type";
        self.PickerArray=[billM selectType];
        [self.subTypePicker selectedRowInComponent:0];

    }
    else if(textField.tag==4){
//        [self.typePicker selectedRowInComponent:0];
//        [self.subTypePicker selectedRowInComponent:0];
        self.types=@"subtype";
        
        if ([self.typeTextField.text length]>1) {
            [self.subTypePicker reloadComponent:0];
            self.PickerArray=[billM selectSubType:self.typeTextField.text];
        }
        else {
            self.PickerArray=[billM selectType];
            [self.subTypePicker selectedRowInComponent:0];
            self.typeTextField.text=[PickerArray objectAtIndex:0];
            
            self.PickerArray=[billM selectSubType:self.typeTextField.text];

        }
        
    }
    else if (textField.tag==6) {
        self.types=@"personnel";
        self.PickerArray=nil;
        self.PickerArray=[billM selectPersonnel];
    }
    
    NSUInteger tag = [textField tag];
    [self animateView:tag];
    [self checkBarButton:tag];
    [self checkSpecialFields:tag];
    UILabel * label = (UILabel *)[self.view viewWithTag:tag + 10];
    if (label) {
        [self resetLabelsColors];
        [label setTextColor:[billViewController labelSelectedColor]];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger tag = [textField tag];
    if (tag == DATE_FIELD_TAG || tag == PERSON_FIELD_TAG || tag == TYPE_FIELD_TAG || tag == SUBTYPE_FIELD_TAG) {
        return NO;
    }
    return YES;
    
}

 - (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
     NSUInteger tag = [textView tag];
     [self animateView:tag];
     [self checkBarButton:tag];
     [self checkSpecialFields:tag];
     UILabel * label = (UILabel *)[self.view viewWithTag:tag + 10];
     if (label) {
         [self resetLabelsColors];
         [label setTextColor:[billViewController labelSelectedColor]];
     }

     return YES; 
 }

#pragma mark -selectedRowInComponent


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;   
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [self.PickerArray count];
    
}

#pragma mark - UIPickerViewDelegate

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (row >= [self.PickerArray count]) {
        return nil;
    }
    if ([self.types isEqualToString:@"subtype"]) {
        NSLog(@"subtype row %d",row);
    }
    UIImage *image = row ==0 ? [UIImage imageNamed:@"male.png"] : [UIImage imageNamed:@"female.png"];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image ]; 
    imageView.frame = CGRectMake(0, 0, 32, 32);
    UILabel *typesLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 32) ];

    UILabel *personLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 32) ];

      typesLabel.text=[self.PickerArray objectAtIndex:row];  
    

    typesLabel.textAlignment = UITextAlignmentLeft;
    typesLabel.backgroundColor = [UIColor clearColor];

    personLabel.textAlignment = UITextAlignmentLeft;
    personLabel.backgroundColor = [UIColor clearColor];
    
    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 100, 32)] ;
    [rowView insertSubview:imageView atIndex:0];
    
    [rowView insertSubview:typesLabel atIndex:1];

    [rowView insertSubview:personLabel atIndex:3];
    
    return rowView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    [self.subTypePicker reloadComponent:0];
    if ([self.types isEqualToString:@"type"]) {
        [self setTypeData];
         self.PickerIndex=[self.typePicker selectedRowInComponent:0];
    }else if ([self.types isEqualToString:@"subtype"]) {
        //[self.typePicker reloadComponent:0];
        
        [self setSubTypeData];
    }else if ([self.types isEqualToString:@"personnel"]) {
        [self setPersonData];
    }
    
}


#pragma mark - UIActionSheetDelegate


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    }else {
        if (buttonIndex == 1) {
            return;
        }else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentModalViewController:imagePickerController animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    self.photo = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.photoButton setImage:self.photo forState:UIControlStateNormal];
} 
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - IBActions
- (IBAction)choosePhoto:(id)sender {
    UIActionSheet * choosePhotoActionSheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"图片选取方式", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"从相机", @""),NSLocalizedString(@"从相册", @""), nil ];

    }else {
        choosePhotoActionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"图片选取方式", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"从相册中选择", @""), nil ];

//        take_photo_from_library Replace 从相册中选择
    }
    [choosePhotoActionSheet showInView:self.view];
}
@end
