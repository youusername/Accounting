//
//  typeManagement.m
//  mount
//
//  Created by zd2011 on 13-5-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "settingManagement.h"
#define kDatabaseName   @"mount.sqlite"

@implementation settingManagement
{
    FMDatabase*Fdb;
}
+(settingManagement *)openCommentDatabase
{
    static settingManagement *aDatabase=nil;
    static dispatch_once_t predicate;  
    dispatch_once(&predicate, ^{  
        aDatabase = [[self alloc] init];   
    });  
    return aDatabase;
}
//设置数据库文件路径
-(NSString*)FilePaths{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:kDatabaseName];
    if (![Fdb open]) {
        NSLog(@"Could not open Fdb.");
    }
//    NSLog(@"%@",dbPath);
    return dbPath;
}
- (id)init
{
    self = [super init];
    if (self) {
        Fdb=[FMDatabase databaseWithPath:[self FilePaths]];
        if (![Fdb open]) {
            NSLog(@"OPEN FAIL");
        }
    }
    return self;
}
//查询预算
-(NSNumber *)selectBudget{
    float budget;
    FMResultSet *rs =[Fdb executeQuery:@"SELECT * FROM budget"];

    while ([rs next]) {
       
        budget = [rs doubleForColumn:@"budget"];
        
    }
    
    [rs close];
    
    return [NSNumber numberWithFloat:budget];
    
}
//添加账单类型数据，人员数据，带入表名和要添加的数据即可添加
-(void)AddPayoutTypeData:(NSString*)TableName str:(NSString*)str{

    if ([TableName isEqualToString:@"type"]) {
        NSString*sql=[NSString stringWithFormat:@"insert into %@(type) values ('%@')",TableName,str];
        [Fdb executeUpdate:sql];
    }else if ([TableName isEqualToString:@"personnel"]) {
        NSString*sql=[NSString stringWithFormat:@"insert into %@(personnel) values ('%@')",TableName,str];
        [Fdb executeUpdate:sql];
    }
   
}
//代入父类别id 添加子类别
-(void)AddSubType:(NSNumber*)type_id subtype:(NSString*)subtypeStr{
    NSString*sql=[NSString stringWithFormat:@"insert into subtype(type_id,subtype) values ('%@','%@')",type_id,subtypeStr];
    [Fdb executeUpdate:sql];
}
//删除账单类型数据，人员数据，带入表名和要删除的数据即可删除
-(void)DeletePayoutTypeData:(NSString*)TableName payout_ID:(NSNumber*)payout_ID{
    BOOL a;
    
//    if ([TableName isEqualToString:@"type"]) {
        NSString*sql=[NSString stringWithFormat:@"DELETE FROM %@ WHERE ID = ?",TableName];
        a=[Fdb executeUpdate:sql,payout_ID];
//    }else if ([TableName isEqualToString:@"subtype"]) {
//        NSString*sql=[NSString stringWithFormat:@"DELETE FROM %@ WHERE ID = ?",TableName];
//        a=[Fdb executeUpdate:sql,payout_ID];
//    }else if ([TableName isEqualToString:@"personnel"]) {
//        NSString*sql=[NSString stringWithFormat:@"DELETE FROM %@ WHERE ID = ?",TableName];
//        a=[Fdb executeUpdate:sql,payout_ID];
//    }
    if (a) {
        NSLog(@"%@  %@ 删除成功！",TableName,payout_ID);
    }else {
        NSLog(@"%@  %@ 删除失败！",TableName,payout_ID);
    }

}
//给一个预算数，插入预算数据
-(void)insertIntoBudgetTable:(NSNumber*)BudgetNumber{
    
    [Fdb executeUpdate:@"delete from budget"];
    [Fdb executeUpdate:@"insert into budget(budget) values (?)",BudgetNumber];
}
//代入父类别id 删除子类别
-(void)DeleteSubType:(NSNumber*)type_id subtype:(NSString*)subtypeStr{
    NSString*sql=[NSString stringWithFormat:@"DELETE FROM subtype where type_id= %@ and subtype='%@'",type_id,subtypeStr];
    [Fdb executeUpdate:sql];
}
//查询所有类别
-(NSMutableDictionary*)selectTypeOfpersonnel:(NSString *)TableName{
    NSString*sql=[NSString stringWithFormat:@"SELECT * FROM %@",TableName];
    FMResultSet *rs =[Fdb executeQuery:sql];
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
    while ([rs next]) {
        
//        dic= [rs doubleForColumn:@"type"];
        [dic setObject:[rs stringForColumn:TableName] forKey:[rs stringForColumn:@"ID"]];
    }
    
    [rs close];
    
    return dic;
}
//查询所有人员
/*
-(NSMutableArray*)selectPersonnel{
    FMResultSet *rs =[Fdb executeQuery:@"SELECT * FROM personnel"];
    NSMutableArray*array=[[NSMutableArray alloc]init];
    while ([rs next]) {
        
    NSString*str= [rs stringForColumn:@"personnel"];
        [array addObject:str];
    }
    
    [rs close];
    

    return array;
}*/
//备份账单数据库
-(void)backupsPayoutDataBase{

}
//还原账单数据库
-(void)restorePayoutDataBase{
    
}
-(void)DeleteSQLiteData{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    //更改到待操作的目录下
//    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
//    //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
//    NSString * fileName = @"mount.sqlite";
//    [fileManager removeItemAtPath:fileName error:nil];
//
//    NSLog(@"settingManagement_Delete!!!!!");
    [Fdb executeUpdate:@"DROP TABLE payout"];
    [Fdb executeUpdate:@"CREATE TABLE IF NOT EXISTS PAYOUT(ID INTEGER PRIMARY KEY AUTOINCREMENT,amount double,date date,type text,subtype text,comment text,image blob,personnel text)"];
}
//查询子类别
-(NSMutableArray*)selectSubType:(NSNumber*)type_id{
    FMResultSet *rs =[Fdb executeQuery:@"SELECT * FROM subtype where type_id =?",type_id];
    NSMutableArray*array=[[NSMutableArray alloc]init];
    while ([rs next]) {
        
        NSString*str= [rs stringForColumn:@"subtype"];
        [array addObject:str];
    }
    
    [rs close];
    
    
    return array;
}
@end
