//
//  addTypeViewController.m
//  mount
//
//  Created by zd2011 on 13-6-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "addTypeViewController.h"
#import "enterTheCategoryViewController.h"
#import "settingManagement.h"
#import "addSubtypeViewController.h"

@interface addTypeViewController (){
    UISegmentedControl *segmentedController;
}
@property(nonatomic,strong)NSMutableDictionary*dic;
@property(nonatomic,strong)settingManagement*settingM;
@end

@implementation addTypeViewController
@synthesize dic,settingM;
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
    self.navigationItem.title=@"父类别管理";
    [self InitButton];

    settingM=[[settingManagement alloc]init];
    self.dic=[settingM selectTypeOfpersonnel:@"type"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"view.png"]];

}

-(void)InitButton{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply  target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
    
    
    NSArray *array = [NSArray arrayWithObjects:@"添加",@"删除", nil];
    segmentedController = [[UISegmentedControl alloc]initWithItems:array ];
    segmentedController.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedController addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem*segButton=[[UIBarButtonItem alloc]initWithCustomView:segmentedController];
    //  [segmentedController selectedSegmentIndex];
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
            
            enter.number=[NSNumber numberWithInt:1];
            [enter setValue:[NSNumber numberWithInt:1] forKey:@"type_id"];
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

    self.dic=[settingM selectTypeOfpersonnel:@"type"];
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

    return [self.dic count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"addtype";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    int row=indexPath.row;
//    NSString* key=[NSString stringWithFormat:@"%d",row+1];
//    for (NSString* key in dic) {
//        cell.textLabel.text=[dic objectForKey:key];
//        
//    }
    cell.textLabel.text=[dic objectForKey:[[dic allKeys] objectAtIndex:row]];
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
        
    NSString* key=[[dic allKeys]objectAtIndex:indexPath.row];
        [self.dic removeObjectForKey:key];
        [self.settingM DeletePayoutTypeData:@"type" payout_ID:[NSNumber numberWithInt:[key intValue]]];
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    addSubtypeViewController*addsubtype=[storyboard instantiateViewControllerWithIdentifier:@"addsubtype"];
    
    [addsubtype setValue:[[dic allKeys]objectAtIndex:indexPath.row]  forKey:@"type_Id"];
    [self.navigationController pushViewController:addsubtype animated:YES];
}

@end
