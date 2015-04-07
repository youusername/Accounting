//
//  enterTheCategoryViewController.h
//  mount
//
//  Created by zd2011 on 13-6-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface enterTheCategoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (strong, nonatomic) IBOutlet UITextField *TextFieldStr;
@property (strong, nonatomic) IBOutlet UILabel *TextFieldName;
- (IBAction)addButton:(id)sender;
@property(nonatomic,strong)NSNumber*number;
@end
