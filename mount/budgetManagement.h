//
//  budgetManagement.h
//  mount
//
//  Created by zd2011 on 13-5-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface budgetManagement : NSObject

//给一个预算数，插入预算数据
-(BOOL)insertIntoBudgetTable:(NSString*)BudgetData;
//返回总支出金额
-(NSNumber*)backPayAmount;
@end
