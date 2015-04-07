//
//  addPersonViewController.m
//  mount
//
//  Created by zd2011 on 13-6-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "addPersonViewController.h"
#import "enterTheCategoryViewController.h"
#import "settingManagement.h"
@interface addPersonViewController (){
    UISegmentedControl *segmentedController;
}
@property(nonatomic,strong)NSMutableDictionary*Listarray;
@property(nonatomic,strong)settingManagement*settingM;
@end

@implementation addPersonViewController
@synthesize Listarray,settingM;
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
    [self InitButton];
    settingM=[[settingManagement alloc]init];
    self.Listarray=[settingM selectTypeOfpersonnel:@"personnel"];
    self.navigationItem.title=@"成员管理";
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"view.png"]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)InitButton{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply  target:self action:@selector(selectLeftAction:)];  
    self.navigationItem.leftBarButtonItem = leftButton;


        NSArray *array = [NSArray arrayWithObjects:@"添加",@"删除", nil];
    segmentedController = [[UISegmentedControl alloc]initWithItems:array ];
    segmentedController.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedController addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];

    UIBarButtonItem*segButton=[[UIBarButtonItem alloc]initWithCustomView:segmentedController];
    self.navigationItem.rightBarButtonItem = segButton;
}
-(void) selectLeftAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) segmentAction:(id)sender
{

    switch ([sender selectedSegmentIndex]) {
        case 0:
        {
            UIStoryboard*storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            enterTheCategoryViewController*enter=[storyboard instantiateViewControllerWithIdentifier:@"enter"];
            [enter setValue:[NSNumber numberWithInt:3] forKey:@"number"];
            [self.navigationController pushViewController:enter animated:YES];
        }
            break;
        case 1:
        {
            segmentedController.selectedSegmentIndex=-1;
            [self.tableView setEditing:!self.tableView.editing animated:YES];
            if (self.tableView.editing) {
                [self.navigationItem.rightBarButtonItem setTitle:@"done"];
                
            }
            else {
                [self.navigationItem.rightBarButtonItem setTitle:@"删除"];
            }
        }
            break;
            
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.Listarray=[self.settingM selectTypeOfpersonnel:@"personnel"];
    [self.tableView reloadData];
}
-(void)viewDidDisappear:(BOOL)animated
{
    
    segmentedController.selectedSegmentIndex=-1;
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

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.Listarray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"personnel";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    int row=indexPath.row;
    cell.textLabel.text=[self.Listarray objectForKey:[[self.Listarray allKeys] objectAtIndex:row]];
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSString* key=[[self.Listarray allKeys]objectAtIndex:indexPath.row];
        [self.Listarray removeObjectForKey:key];
        [self.settingM DeletePayoutTypeData:@"personnel" payout_ID:[NSNumber numberWithInt:[key intValue]]];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }  
    [self.tableView reloadData];
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
