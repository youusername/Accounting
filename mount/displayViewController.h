//
//  displayViewController.h
//  mount
//
//  Created by zd2011 on 13-5-14.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "typeViewController.h"
#import "XYPieChart.h"
#import "displayManagement.h"
@interface displayViewController : UIViewController<XYPieChartDelegate, XYPieChartDataSource>

@property(strong,nonatomic)typeViewController *typeViewController;  
@property (strong, nonatomic) UISegmentedControl *SegmentedControl;
@property(nonatomic, strong) NSMutableArray *slices;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedTypeLabel;

@property (strong, nonatomic) IBOutlet UILabel *BudgetLabel;
@property (strong, nonatomic) IBOutlet XYPieChart *piceChart;
@property(nonatomic, strong) NSArray        *sliceColors;
@property(nonatomic,strong)UIViewController*typev;
@property(nonatomic,strong)UIViewController*persv;
@property(nonatomic,strong)UIViewController*datev;
@property(nonatomic,strong)displayManagement*displayM;


@property(nonatomic,assign)int pickMonth;
- (IBAction)pickMonth:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *MonthLabel;

@end
