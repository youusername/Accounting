//
//  displayViewController.m
//  mount
//
//  Created by zd2011 on 13-5-14.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "displayViewController.h"
#import "ASDepthModalViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "payout.h"
#import "personnelViewController.h"
#import "dateViewController.h"
@interface displayViewController ()

@end

@implementation displayViewController
@synthesize selectedSliceLabel;
@synthesize piceChart,BudgetLabel;
@synthesize slices,sliceColors;
@synthesize typeViewController,SegmentedControl;
@synthesize typev,persv,datev,displayM,pickMonth,MonthLabel,selectedTypeLabel;
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
    [self getMoth];
    [self Init];//
    [self InitXYPieChart];//初始化饼图
    [self backButton];//navigation上的返回按钮
    [self NavigationButtons];//navigation上的分段按钮
    [self SwipeGestureRecognizer];//滑动代码

    
    [self InitSubView];//初始化子视图
    
	// Do any additional setup after loading the view.
}
-(void)getMoth{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    
    self.pickMonth = [comps month];
}
-(void)Init{

    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"display.png"]];
     self.displayM=[[displayManagement alloc]init];
    self.MonthLabel.text=[NSString stringWithFormat:@"%d",self.pickMonth];
}
-(void)InitXYPieChart{
    //-----------------------饼图-------------------  
    self.slices=[[NSMutableArray alloc]init];
    for (payout* p in [displayM XYPieChart:self.pickMonth] ) {
        
        [self.slices addObject:[NSNumber numberWithFloat:p.amount]];
    }

    //    for(int i = 0; i < 5; i ++)
    //    {
    //        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
    //        [_slices addObject:one];
    //    }
    
    
    
    [self.piceChart setDelegate:self];
    [self.piceChart setDataSource:self];
    [self.piceChart setPieCenter:CGPointMake(140, 100)];
    [self.piceChart setShowPercentage:NO];
    [self.piceChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],
                       [UIColor colorWithRed:220/255.0 green:20/255.0 blue:60/255.0 alpha:1],
                       [UIColor colorWithRed:123/255.0 green:104/255.0 blue:238/255.0 alpha:1],
                       [UIColor colorWithRed:95/255.0 green:158/255.0 blue:160/255.0 alpha:1],
                       [UIColor colorWithRed:0/255.0 green:206/255.0 blue:209/255.0 alpha:1],
                       [UIColor colorWithRed:0/255.0 green:255/255.0 blue:255/255.0 alpha:1],
                       [UIColor colorWithRed:0/255.0 green:0/255.0 blue:205/255.0 alpha:1],
                       [UIColor colorWithRed:75/255.0 green:0/255.0 blue:130/255.0 alpha:1],
                       [UIColor colorWithRed:72/255.0 green:61/255.0 blue:139/255.0 alpha:1],
                       [UIColor colorWithRed:176/255.0 green:196/255.0 blue:222/255.0 alpha:1],
                       [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1],
                       [UIColor colorWithRed:95/255.0 green:158/255.0 blue:160/255.0 alpha:1],nil];
    //-----------------------饼图-------------------
    

}
-(void)InitSubView{
    UIStoryboard*storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
//    self.typev=[storyboard instantiateViewControllerWithIdentifier:@"typeView"];//类型显示
    typeViewController*type=[storyboard instantiateViewControllerWithIdentifier:@"typeView"];
    type.Month=self.pickMonth;
    typev=type;
    self.typev.view.hidden=YES;
    
    [self addChildViewController:self.typev];
    [self.view addSubview:self.typev.view];
    
    personnelViewController*pers=[storyboard instantiateViewControllerWithIdentifier:@"personnelView"];//成员显示
    pers.Month=self.pickMonth;
    persv=pers;
    self.persv.view.hidden=YES;
    [self addChildViewController:self.persv];
    [self.view addSubview:self.persv.view];
    
     dateViewController*date=[storyboard instantiateViewControllerWithIdentifier:@"dateView"];//时间显示
    date.Month=self.pickMonth;
    datev=date;
    self.datev.view.hidden=YES;
    [self addChildViewController:self.datev];
    [self.view addSubview:self.datev.view];

    
}

-(void)SwipeGestureRecognizer{
    //滑动代码

    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
}
-(void)NavigationButtons{
    NSArray *Items = [[NSArray alloc] initWithObjects:@"图表查看",@"类型查看",@"人员查看",@"时间查看", nil];
    self.SegmentedControl = [[UISegmentedControl alloc] initWithItems:Items];
    self.SegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    //SegmentedControl.frame = CGRectMake(90, 30, 180, 30);
    //    根据索引值，表示mapSegmentedControl默认响应哪个
    self.SegmentedControl.selectedSegmentIndex = 0;
    //    SegmentedControl.momentary=YES;
    //    给mapSegmentedContol添加响应方法
    [self.SegmentedControl addTarget:self action:@selector(selectedMapType:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:self.SegmentedControl];
    
    self.navigationItem.rightBarButtonItem = segButton;
}
-(void)backButton{
    //-----------------------返回-------------------
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"  style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];//UIBarButtonItem
    //-----------------------返回-------------------
}
//-----------------------饼图-------------------
- (void)viewWillAppear:(BOOL)animated
{
    int bg=0;
    for (NSNumber *number in self.slices) {
        bg+=[number intValue];
    }
    bg=bg-[[displayM selectBudget] intValue];
    NSString*Budgetstr=[NSString stringWithFormat:@"%d",bg];
    self.BudgetLabel.text=Budgetstr;
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.piceChart reloadData];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
#pragma mark - XYPieChart DataSource
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return [self.slices count];
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
   
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}
#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
//    NSLog(@"did select slice at index %d",index);
//    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
//    self.selectedTypeLabel.text=[[[displayM XYPieChart:self.pickMonth] objectAtIndex:1] objectAtIndex:index];
    [self performSelector:@selector(ASDepthModalAtIndex:) withObject:[NSNumber numberWithInteger:index] afterDelay:0.3];
}
-(void)ASDepthModalAtIndex:(NSNumber *)index{
    UIColor *color = nil;
    ASDepthModalOptions style = ASDepthModalOptionAnimationGrow;
    ASDepthModalOptions options;

    
  UIImage *image;
        

        image = [UIImage imageNamed:@"pattern1.jpg"];
        color = [UIColor colorWithPatternImage:image];

    
           style = ASDepthModalOptionAnimationShrink;
    
    options =ASDepthModalOptionBlur;
    
    UIView *Nib=[[[UINib nibWithNibName:@"ASDepthModal" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];

    Nib.layer.cornerRadius = 12;
    Nib.layer.shadowOpacity = 0.7;
    Nib.layer.shadowOffset = CGSizeMake(6, 6);
    Nib.layer.shouldRasterize = YES;
    Nib.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    [Nib setAlpha:0.7];
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:Nib.frame];
    [button addTarget:self action:@selector(ASDepthModalViewDismiss) forControlEvents:UIControlEventTouchUpInside];
    [Nib addSubview:button];
    [self InitASDepthModalLable:Nib LabelStr:index];
    [ASDepthModalViewController presentView:Nib
                            backgroundColor:color
                                    options:options
                          completionHandler:^{
                              NSLog(@"Modal view closed.");
                          }];
}
-(void)ASDepthModalViewDismiss{
    [ASDepthModalViewController dismiss];
}
-(void)InitASDepthModalLable:(UIView*)view LabelStr:(NSNumber*)index{
    UILabel*money=[[UILabel alloc]initWithFrame:CGRectMake(10, 10,100, 50)];
    UILabel*per=[[UILabel alloc]initWithFrame:CGRectMake(10, 50,100, 50)];
    UILabel*type=[[UILabel alloc]initWithFrame:CGRectMake(10, 90,100, 50)];
    UILabel*subType=[[UILabel alloc]initWithFrame:CGRectMake(10, 130,100, 50)];
    UILabel*date=[[UILabel alloc]initWithFrame:CGRectMake(10, 150,100, 80)];
    UIImage*image=[UIImage imageNamed:@"404error.png"];

    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width/2-30, view.frame.size.height/2-110,150, 150)];
    
    NSMutableArray*array=[displayM XYPieChart:self.pickMonth];
    payout*p=[array objectAtIndex:[index integerValue]];
    type.text=p.type;
    subType.text=p.subType;
    date.text=p.date;
    per.text=p.personnel;
    money.text=[NSString stringWithFormat:@"￥%.0f",p.amount];
    if (p.image!=nil) {
        image=[UIImage imageWithData:p.image];
    }
    [imageView setImage:image];
    [view addSubview:per];
    [view addSubview:date];
    [view addSubview:subType];
    [view addSubview:imageView];
    [view addSubview:money];
    [view addSubview:type];
}
//-----------------------饼图-------------------

-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
      
        
        [self.navigationController popViewControllerAnimated:YES];
//        NSLog(@"swipe Right");
        
        //执行程序
        
    }
}
-(void)selectedMapType:(id)sender
{   
    UISegmentedControl *control = (UISegmentedControl *)sender;
    if (SegmentedControl) {
        
        
        if (control.selectedSegmentIndex == 0) {

            self.typev.view.hidden=YES;
            self.persv.view.hidden=YES;
            self.datev.view.hidden=YES;
            [self InitXYPieChart];
            [self.piceChart reloadData];
        }
        else if (control.selectedSegmentIndex == 1) {
            self.typev.view.hidden=NO;
            
            self.persv.view.hidden=YES;
            self.datev.view.hidden=YES;
            
        }
        else if (control.selectedSegmentIndex == 2) {

            self.typev.view.hidden=YES;
            self.persv.view.hidden=NO;
            self.datev.view.hidden=YES;
        }
        else if (control.selectedSegmentIndex == 3) {
            self.typev.view.hidden=YES;
            self.persv.view.hidden=YES;
            self.datev.view.hidden=NO;

            
        }
    }
}
- (void)viewDidUnload
{
    [self setPiceChart:nil];
    [self setSelectedSliceLabel:nil];
    [self setSelectedTypeLabel:nil];
    [self setMonthLabel:nil];
    [self setBudgetLabel:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pickMonth:(id)sender {
    int bg=0;
    for (NSNumber *number in self.slices) {
        bg+=[number intValue];
    }
    bg=bg-[[displayM selectBudget] intValue];
    NSString*Budgetstr=[NSString stringWithFormat:@"%d",bg];
    self.BudgetLabel.text=Budgetstr;
    
    
    if ([sender tag]==11) {
        if (self.pickMonth<=1) {
            self.pickMonth=13;
        }
        
        self.pickMonth-=1;
        [self InitSubView];
        self.MonthLabel.text=[NSString stringWithFormat:@"%d",self.pickMonth];
        [self InitXYPieChart];
        [[self piceChart] reloadData];
        self.selectedSliceLabel.text=@"";
        self.selectedTypeLabel.text=@"";
        
    }else{
        if (self.pickMonth>=12) {
            self.pickMonth=0;
        }
        self.pickMonth+=1;
        [self InitSubView];
        self.MonthLabel.text=[NSString stringWithFormat:@"%d",self.pickMonth];
        [self InitXYPieChart];
        [[self piceChart] reloadData];
        self.selectedSliceLabel.text=@"";
        self.selectedTypeLabel.text=@"";
        
    }
}
@end
