//
//  billManagement.h
//  mount
//
//  Created by zd2011 on 13-5-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "payout.h"
@interface billManagement : NSObject
@property(strong,nonatomic)FMDatabase*Fdb;
//得到最近几笔帐单日期，返回成一个数组
-(NSMutableArray*)getRecentlyPayouDate;//yes
//得到某月帐单数据，月份为参数
-(NSDictionary*)getMonthPayout:(int)ThisMonth;//YES
//得到所有的帐单数据
-(NSMutableArray*)getAllPayout;//YES
//给一个帐单id，查询出一笔帐的详细信息，
-(payout*)selectPayout:(NSNumber*)payoutID;//YES
//保存一笔帐
-(void)savePayout:(payout*)payout;//YES
//删除一笔帐
-(void)deletePayout:(int)payout_ID;//YES
//修改一笔帐
-(void)alterPayout:(payout*)payout;//YES
//查询返回类型数据库的数据
-(NSArray*)selectType;//yes

-(NSArray*)selectPersonnel;//yes

-(NSArray*)selectSubType:(NSString*)type;//yes
//判断保存的帐是否完整
-(BOOL)checkingPayout:(payout*)payout;//yes
//构建数据库
-(void)InitSQLite;//yes
//返回文件路径
-(NSString*)FilePaths:(NSString*)fileName;//yes
//单例模式
+(billManagement *)openCommentDatabase;//yes

@end
