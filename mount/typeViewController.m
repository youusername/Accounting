//
//  typeViewController.m
//  mount
//
//  Created by zd2011 on 13-5-14.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "typeViewController.h"
#import "displayManagement.h"
#import "billViewController.h"
#import "displayViewController.h"
@interface typeViewController ()

@end

@implementation typeViewController
@synthesize dic,Month;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)getMoth{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    
    self.Month = [comps month];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUInteger index = 10 ;
    [self.tableView viewWithTag:index];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"view.png"]];
//    [self getMoth];
    displayManagement*displayM=[[displayManagement alloc]init];
    dic=[displayM getClassPayout:@"Type" Month:self.Month];
    NSLog(@"display type ^");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{

    displayManagement*displayM=[[displayManagement alloc]init];
    dic=[displayM getClassPayout:@"Type"  Month:self.Month];
    [self.tableView reloadData];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [[self.dic allKeys] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *moth=[[dic allKeys]sortedArrayUsingSelector:@selector(compare:)];
    return [moth objectAtIndex:section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *moth=[[self.dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSArray *number=[self.dic objectForKey:[moth objectAtIndex:section]];
    
    return [number count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *moth=[[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSNumber*number=[moth objectAtIndex:indexPath.section];
    NSArray*str=[dic objectForKey:number];
    payout*str1=[str objectAtIndex:indexPath.row];
    UILabel *cellLabel=(UILabel *)[cell viewWithTag:1];
    cellLabel.text=[NSString stringWithFormat:@"%.1f",str1.amount];
    cellLabel=(UILabel *)[cell viewWithTag:2];
    cellLabel.text=str1.subType;
    cellLabel=(UILabel *)[cell viewWithTag:3];
    cellLabel.text=str1.date;
    cellLabel=(UILabel *)[cell viewWithTag:4];
    cellLabel.text=str1.personnel;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *moth=[[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSNumber*number=[moth objectAtIndex:indexPath.section];
        NSArray*str=[dic objectForKey:number];
        payout*str1=[str objectAtIndex:indexPath.row];

        [[dic objectForKey:number] removeObjectAtIndex:indexPath.row];

        billManagement*billM=[[billManagement alloc]init];
        [billM deletePayout:str1.payout_ID];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    [tableView reloadData];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *moth=[[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSNumber*number=[moth objectAtIndex:indexPath.section];
    NSArray*str=[dic objectForKey:number];
    payout* _payout=[str objectAtIndex:indexPath.row];
//    NSLog(@"payout_id %d",_payout.payout_ID);
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    billViewController*svc=[storyboard instantiateViewControllerWithIdentifier:@"bill"];
    svc.billIndex=_payout.payout_ID;
    svc.backTypeNSString=@"Dtype";
    [self.navigationController pushViewController:svc animated:YES];
}

@end
