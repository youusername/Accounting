//
//  ViewController.h
//  mount
//
//  Created by zd2011 on 13-5-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
- (IBAction)bill:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *myImage;
@property (strong, nonatomic) IBOutlet UITableView *tableOutlet;
@property (strong,nonatomic)IIViewDeckController* deckController;
@property (strong,nonatomic) NSArray*list;
@end
