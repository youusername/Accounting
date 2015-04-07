//
//  personnelViewController.m
//  mount
//
//  Created by zd2011 on 13-6-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "personnelViewController.h"
#import "displayManagement.h"
#import "displayViewController.h"
@interface personnelViewController ()
@property(nonatomic,strong)NSMutableDictionary*dic;

@end

@implementation personnelViewController
@synthesize dic,Month;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"view.png"]];

//    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    displayViewController*displayV=[storyboard instantiateViewControllerWithIdentifier:@"display"];
//    self.Month=displayV.pickMonth;
    displayManagement*displayM=[[displayManagement alloc]init];
    dic=[displayM getClassPayout:@"personnel" Month:self.Month];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    displayManagement*displayM=[[displayManagement alloc]init];
    dic=[displayM getClassPayout:@"personnel"  Month:self.Month];
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
    static NSString *CellIdentifier = @"pcell";
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
    // Configure the cell...
    
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
