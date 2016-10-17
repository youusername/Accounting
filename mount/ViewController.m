//
//  ViewController.m
//  mount
//
//  Created by zd2011 on 13-5-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "settingViewController.h"
#import "displayViewController.h"
#import "billViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIGlossyButton.h"
#import "UIView+LayerEffects.h"
#import "billManagement.h"
#import "settingManagement.h"
#import "payout.h"
#import "WebViewController.h"
@interface ViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIButton *IconButton;
    settingManagement*settingM;
}
@property(strong,nonatomic)FMDatabase*Fdb;
@property(strong,nonatomic)billManagement*billM;
@property(strong,nonatomic)NSArray*BillArray;

@end

@implementation ViewController
@synthesize myImage;
@synthesize tableOutlet;

@synthesize list,Fdb;
@synthesize billM;
@synthesize BillArray;

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.title=@"欢迎使用";
    billM=[[billManagement alloc]init];
    self.tableOutlet.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.navigationItem.hidesBackButton=YES;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"view.png"]];
    
    IconButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [IconButton setFrame:CGRectMake(-5, -5, 40, 40)];
//    [IconButton setTitle:@"登出" forState:UIControlStateNormal];
//    [IconButton setFont:[UIFont systemFontOfSize:15]];
//    [IconButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (settingM==nil) {
        settingM=[[settingManagement alloc]init];
    }
    [IconButton.layer setMasksToBounds:YES];
    [IconButton.layer setCornerRadius:20.0];
    [IconButton setImage:[settingM getUserIcon] forState:UIControlStateNormal];
    [IconButton addTarget:self action:@selector(changeIcon:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:IconButton];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    UIButton*buttonf=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonf setFrame:CGRectMake(0, 0, 40, 40)];
    [buttonf setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonf setTitle:@"财经" forState:UIControlStateNormal];
    [buttonf addTarget:self action:@selector(pushWebVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:buttonf];
    self.navigationItem.rightBarButtonItem=rightBarItem;
    
    
//-----------------自定义记一笔button-------------------------
//    UIGlossyButton *b;
//    b = (UIGlossyButton*) [self.view viewWithTag: 1018];
//	[b useWhiteLabel: YES]; b.tintColor = [UIColor whiteColor];
//	[b setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
//    [b setGradientType:kUIGlossyButtonGradientTypeLinearSmoothExtreme];
//-------------------自定义记一笔button------------------------
//    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    
/*
    UISwipeGestureRecognizer *recognizer; 
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [[self view] addGestureRecognizer:recognizer];
    

    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    [[self view] addGestureRecognizer:recognizer];
    

    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    [[self view] addGestureRecognizer:recognizer];
    


    
    //UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    [[self view] addGestureRecognizer:recognizer];

*/
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)pushWebVC{
    WebViewController*web=[[WebViewController alloc]init];
    web.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController pushViewController:web animated:YES];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        displayViewController*svc=[storyboard instantiateViewControllerWithIdentifier:@"display"];
        [self.navigationController pushViewController:svc animated:YES];
        NSLog(@"swipe left");

    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        settingViewController*svc=[storyboard instantiateViewControllerWithIdentifier:@"setting"];
        CATransition*transition=[CATransition animation];
        transition.duration=0.3;
        transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type=kCATransitionPush;
        transition.subtype=kCATransitionFromLeft;
        
        [self.navigationController.view setBackgroundColor:[UIColor colorWithRed:0.0 green:156.0/255 blue:181.0/255 alpha:1]];
        [self.navigationController.view.layer addAnimation:transition forKey:nil];

        [self.navigationController pushViewController:svc animated:NO];
        NSLog(@"swipe right");
        
        //执行程序
        
    }
    
}
-(void)changeIcon:(id)obj{
    UIActionSheet * choosePhotoActionSheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"图片选取方式", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"从相机", @""),NSLocalizedString(@"从相册", @""), nil ];
        
    }else {
        choosePhotoActionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"图片选取方式", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"从相册中选择", @""), nil ];
        
        //        take_photo_from_library Replace 从相册中选择
    }
    [choosePhotoActionSheet showInView:self.view];
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
    [self presentViewController:imagePickerController animated:YES completion:^{}];
//    [self presentModalViewController:imagePickerController animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{}];
//    [picker dismissModalViewControllerAnimated:YES];
//    self.photo = [info objectForKey:UIImagePickerControllerEditedImage];
    [IconButton setImage:[info objectForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    [settingM setUserIcon:[info objectForKey:UIImagePickerControllerEditedImage]];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
//    [self dismissModalViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)viewDidUnload
{
    [self setMyImage:nil];
  
    [self setTableOutlet:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}
-(void)viewWillAppear:(BOOL)animated{
    self.view.window.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.BillArray=[self.billM getRecentlyPayouDate];
    [self.tableOutlet reloadData];
    if (settingM==nil) {
        settingM=[[settingManagement alloc]init];
    }
    [IconButton setImage:[settingM getUserIcon] forState:UIControlStateNormal];
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [BillArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    payout* _payout=[BillArray objectAtIndex:indexPath.row];
    NSLog(@"%d",_payout.payout_ID);
//    NSLog(@"%d---%@",indexPath.row,_payout.type);
    UILabel*label=(UILabel*)[cell viewWithTag:1];
    label.text=[NSString stringWithFormat:@"%.2f",_payout.amount];
    label=(UILabel*)[cell viewWithTag:2];
    label.text=_payout.date;
    label=(UILabel*)[cell viewWithTag:3];
    label.text=_payout.type;
    label=(UILabel*)[cell viewWithTag:4];
    label.text=_payout.personnel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    payout* _payout=[BillArray objectAtIndex:indexPath.row];
    NSLog(@"payout_id %d",_payout.payout_ID);
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    billViewController*svc=[storyboard instantiateViewControllerWithIdentifier:@"bill"];
    svc.billIndex=_payout.payout_ID;
    svc.backTypeNSString=@"View";
    CATransition*transition=[CATransition animation];
    transition.duration=0.5;
    transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type=kCATransitionPush;
    transition.subtype=kCATransitionFromTop;
    
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:svc animated:NO];
}

- (IBAction)bill:(id)sender {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    billViewController*svc=[storyboard instantiateViewControllerWithIdentifier:@"bill"];
    svc.billIndex=-1;
    svc.backTypeNSString=@"View";
    CATransition*transition=[CATransition animation];
    transition.duration=0.5;
    transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type=kCATransitionPush;
    transition.subtype=kCATransitionFromTop;
    
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:svc animated:NO];
}
@end
