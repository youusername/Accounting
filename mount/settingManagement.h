//
//  typeManagement.h
//  mount
//
//  Created by zd2011 on 13-5-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface settingManagement : NSObject
+(settingManagement *)openCommentDatabase;//YES
//查询预算
-(NSNumber*)selectBudget;//YES
//查询所有类别
-(NSMutableDictionary*)selectTypeOfpersonnel:(NSString*)TableName;//YES
//查询子类别
-(NSMutableArray*)selectSubType:(NSNumber*)type_id;
//查询所有人员
//-(NSMutableArray*)selectPersonnel;
//添加账单类型数据，人员数据，带入表名和要添加的数据即可添加
-(void)AddPayoutTypeData:(NSString*)TableName str:(NSString*)str;//YES
//代入父类别id 添加子类别
-(void)AddSubType:(NSNumber*)type_id subtype:(NSString*)subtypeStr;
//代入父类别id 删除子类别
-(void)DeleteSubType:(NSNumber*)type_id subtype:(NSString*)subtypeStr;
//删除账单类型数据，人员数据，带入表名和要删除的数据即可删除
-(void)DeletePayoutTypeData:(NSString*)TableName payout_ID:(NSNumber*)payout_ID;//YES
//给一个预算数，插入预算数据
-(void)insertIntoBudgetTable:(NSNumber*)BudgetNumber;//YES
//备份账单数据库
-(void)backupsPayoutDataBase;
//还原账单数据库
-(void)restorePayoutDataBase;
-(void)DeleteSQLiteData;

-(void)setUserIcon:(UIImage*)image;
-(UIImage*)getUserIcon;
@end
