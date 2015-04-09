//
//  billManagement.m
//  mount
//
//  Created by zd2011 on 13-5-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "billManagement.h"
//#import "DatebaseManagement.h"
//#define kDatabaseName   [NSString stringWithFormat:@"%@.%@",[UserDefaults objectForKey:@"user"],@"sqlite"]
#define kTypeName   @"type.plist"
 
@implementation billManagement

@synthesize Fdb;

+(billManagement *)openCommentDatabase
{
    static billManagement *aDatabase=nil;
    static dispatch_once_t predicate;  
    dispatch_once(&predicate, ^{  
        aDatabase = [[self alloc] init];   
    });  
    return aDatabase;
}
- (id)init
{
    self = [super init];
    if (self) {
        
        
        [self InitSQLite];
    
    
    }
    return self;
}
-(void)InitSQLite{
    Fdb=[FMDatabase databaseWithPath:[self FilePaths:kDatabaseName]];
    if (![Fdb open]) {
        NSLog(@"Could not open Fdb.");
    }

    [Fdb executeUpdate:@"CREATE TABLE IF NOT EXISTS PAYOUT(ID INTEGER PRIMARY KEY AUTOINCREMENT,amount double,date date,type text,subtype text,comment text,image blob,personnel text)"];
    [Fdb executeUpdate:@"CREATE TABLE IF NOT EXISTS personnel(ID INTEGER PRIMARY KEY AUTOINCREMENT,personnel text)"];
    [Fdb executeUpdate:@"CREATE TABLE IF NOT EXISTS type(ID INTEGER PRIMARY KEY AUTOINCREMENT,type text)"];
    [Fdb executeUpdate:@"CREATE TABLE IF NOT EXISTS subtype(ID INTEGER PRIMARY KEY AUTOINCREMENT,type_id text,subtype text)"];
//    [Fdb executeUpdate:@"CREATE TABLE IF NOT EXISTS subtype(ID INTEGER PRIMARY KEY AUTOINCREMENT,type_ID integer REFERENCES type(ID),subtype text)"];
    [Fdb executeUpdate:@"CREATE TABLE IF NOT EXISTS budget(ID INTEGER PRIMARY KEY AUTOINCREMENT,budget text)"];
    if ([[self getPayoutType] count]<1) {
        [self InitPayoutType];
        [self InitPersonnel];
    }
}
    

-(void)InitPersonnel{
    NSString*sql=[NSString stringWithFormat:@"insert into personnel(personnel) values ('老公')"];
    NSString*sql1=[NSString stringWithFormat:@"insert into personnel(personnel) values ('老婆')"];
    NSString*sql2=[NSString stringWithFormat:@"insert into personnel(personnel) values ('家庭')"];
    NSString*sql3=[NSString stringWithFormat:@"insert into personnel(personnel) values ('女儿')"];
//    NSString*sql4=[NSString stringWithFormat:@"insert into budget(budget) values ('5000')"];
    [Fdb executeUpdate:sql];
    [Fdb executeUpdate:sql1];
    [Fdb executeUpdate:sql2];
    [Fdb executeUpdate:sql3];
//    [Fdb executeUpdate:sql4];
}

-(void)InitPayoutType{
    NSString *path=[[NSBundle mainBundle]pathForResource:@"type" ofType:@"plist"];
    NSDictionary*dic=[NSDictionary dictionaryWithContentsOfFile:path];
    [dic writeToFile:[self FilePaths:kTypeName] atomically:YES];
    for (NSString*s in [dic allKeys]) {
        [self intersectType:s];
//        NSLog(@"type  %@",s);
    }
    for (int i=0; i<[[dic allKeys]count]; i++) {
        for (id s in [dic objectForKey:[[dic allKeys]objectAtIndex:i]]) {
            [self intersectSubType:i subtype:s];
        }
    }
}
-(void)intersectType:(NSString*)type{
    NSString*sql=[NSString stringWithFormat:@"insert into type(type) values ('%@')",type];
    [Fdb executeUpdate:sql];
}
-(void)intersectSubType:(int)type_id subtype:(NSString*)subtype{
    NSString*sql=[NSString stringWithFormat:@"insert into subtype(type_ID,subtype) values ('%d','%@')",type_id+1,subtype];
    [Fdb executeUpdate:sql];
}
-(NSMutableArray*)getPayoutType{
    NSMutableArray*array=[[NSMutableArray alloc]init];
    FMResultSet *rs =[Fdb executeQuery:@"SELECT * FROM type"];
    
    while ([rs next]) {
        NSString*str=[[NSString alloc]init];
        str=[rs stringForColumn:@"type"];
        [array addObject:str];
    }
    return array;
}
//设置数据库文件路径
-(NSString*)FilePaths:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:fileName];
//    self.Fdb = [FMDatabase databaseWithPath:dbPath] ;
//    if (![Fdb open]) {
//        NSLog(@"Could not open Fdb.");
//    }
    NSLog(@"billM______\n%@",dbPath);
    return dbPath;
}
//得到最近几笔帐单日期，返回成一个数组
-(NSMutableArray*)getRecentlyPayouDate{
    
    NSMutableArray*array=[self getAllPayout];
    NSMutableArray*arrayto=[[NSMutableArray alloc]init];
    for (int i=[array count]-1; i>=0; i--) {
        [arrayto addObject:[array objectAtIndex:i]];
    }
    return arrayto;
}
//得到某月帐单数据，月份为参数
-(NSDictionary*)getMonthPayout:(int)ThisMonth{
    
    
    if (ThisMonth==0) {
        
        NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
        for (payout *p in [self getAllPayout]) {
            NSNumber *moth=[NSNumber numberWithInt:[p getMonth]];
            
            if ([dic objectForKey:moth]) {
                NSMutableArray *array=[[NSMutableArray alloc]init];
                array=[dic objectForKey:moth];
                [array addObject:p];
            }
            else{
                NSMutableArray *array=[[NSMutableArray alloc]init];
                [array addObject:p];
                [dic setObject:array forKey:moth];
            }
            
        }
        
        return dic;
    }
    
    
    else {
        NSMutableArray*array=[[NSMutableArray alloc]init];
        NSString*sql;
        if (ThisMonth>=10) {
            sql=[NSString stringWithFormat:@"SELECT * from payout where strftime('%%m',date)=='%d'",ThisMonth];
        }
        else {
            sql=[NSString stringWithFormat:@"SELECT * from payout where strftime('%%m',date)=='0%d'",ThisMonth];
        }
        FMResultSet *rs =[Fdb executeQuery:sql];
        
        while ([rs next]) {
            payout*_payout=[[payout alloc]init];
            _payout.payout_ID=[rs intForColumn:@"ID"];
            _payout.amount = [rs doubleForColumn:@"amount"];
            _payout.date=[rs stringForColumn:@"date"];
            _payout.type=[rs stringForColumn:@"type"];
            _payout.subType=[rs stringForColumn:@"subType"];
            _payout.comment=[rs stringForColumn:@"comment"];
            _payout.image=[rs dataForColumn:@"image"];
            _payout.personnel=[rs stringForColumn:@"personnel"];
            [array addObject:_payout];
        }
        
        [rs close];
        NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
        for (payout *p in array) {
            NSNumber *moth=[NSNumber numberWithInt:ThisMonth];
            
            if ([dic objectForKey:moth]) {
                NSMutableArray *array=[[NSMutableArray alloc]init];
                array=[dic objectForKey:moth];
                [array addObject:p];
            }
            else{
                NSMutableArray *array=[[NSMutableArray alloc]init];
                [array addObject:p];
                [dic setObject:array forKey:moth];
            }
            
        }
        
        return dic;
    }
}

//给一个帐单id，查询出一笔帐的详细信息，
-(payout*)selectPayout:(NSNumber*)payoutID{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM payout where id=%@",payoutID];
    
    FMResultSet *rs =[Fdb executeQuery:sql];
    payout*_payout=[[payout alloc]init];
    
    while ([rs next]) {
        _payout.payout_ID=[rs intForColumn:@"ID"];
        _payout.amount = [rs doubleForColumn:@"amount"];
        _payout.date=[rs stringForColumn:@"date"];
        _payout.type=[rs stringForColumn:@"type"];
        _payout.subType=[rs stringForColumn:@"subType"];
        _payout.comment=[rs stringForColumn:@"comment"];
        _payout.image=[rs dataForColumn:@"image"];
        _payout.personnel=[rs stringForColumn:@"personnel"];
        
    }
    
    [rs close];
    return _payout;
}
//保存一笔帐
-(void)savePayout:(payout*)payout{
    NSData*da=payout.image;
    
    NSString*sql=[NSString stringWithFormat:@"insert into payout(amount,date,type,subtype,comment,image,personnel) values (%f,'%@','%@','%@','%@',?,'%@')",payout.amount,payout.date,payout.type,payout.subType,payout.comment,payout.personnel];
    BOOL a=[Fdb executeUpdate:sql,da];
    if (a) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"保存成功" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        NSLog(@"保存失败！");
    }
}

//删除一笔帐
-(void)deletePayout:(int)payout_ID{
    NSString*delete=[NSString stringWithFormat:@"DELETE FROM payout WHERE ID = %d",payout_ID];
    BOOL a=[Fdb executeUpdate:delete];
    if (a) {
        NSLog(@"%d,删除成功！",payout_ID);
    }
}
-(NSArray*)selectPersonnel{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM personnel"];
    
    FMResultSet *rs =[Fdb executeQuery:sql];
    NSMutableArray*array=[[NSMutableArray alloc]init];
    while ([rs next]) {
        NSString*str=[rs stringForColumn:@"personnel"];
        [array addObject:str];
        
    }
    
    [rs close];
    return array;
}
//修改一笔帐
-(void)alterPayout:(payout*)payout{
//    payout.payout_ID=14;
    NSString*amount=[NSString stringWithFormat:@"UPDATE payout SET amount = %f WHERE ID = %d",payout.amount,payout.payout_ID];
    [Fdb executeUpdate:amount];
    NSString*date=[NSString stringWithFormat:@"UPDATE payout SET date = '%@' WHERE ID = %d",payout.date,payout.payout_ID];
    [Fdb executeUpdate:date];
    NSString*type=[NSString stringWithFormat:@"UPDATE payout SET type = '%@' WHERE ID = %d",payout.type,payout.payout_ID];
    [Fdb executeUpdate:type];
    NSString*subtype=[NSString stringWithFormat:@"UPDATE payout SET subtype = '%@' WHERE ID = %d",payout.subType,payout.payout_ID];
    [Fdb executeUpdate:subtype];
    NSString*comment=[NSString stringWithFormat:@"UPDATE payout SET comment = '%@' WHERE ID = %d",payout.comment,payout.payout_ID];
    [Fdb executeUpdate:comment];
    NSString*image=[NSString stringWithFormat:@"UPDATE payout SET image = ? WHERE ID = %d",payout.payout_ID];
    [Fdb executeUpdate:image,payout.image];
    NSString*personnel=[NSString stringWithFormat:@"UPDATE payout SET personnel = '%@' WHERE ID = %d",payout.personnel,payout.payout_ID];
    [Fdb executeUpdate:personnel];
    
}
-(NSArray *)selectType{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM type"];
    
    FMResultSet *rs =[Fdb executeQuery:sql];
    NSMutableArray*array=[[NSMutableArray alloc]init];
       while ([rs next]) {
        NSString*str=[rs stringForColumn:@"type"];
           [array addObject:str];
        
    }
    
    [rs close];
    return array;
}


-(NSArray *)selectSubType:(NSString*)type{
    NSString *sql=[NSString stringWithFormat:@"select*from subtype where type_id=(SELECT ID from type where type='%@')",type];
    
    FMResultSet *rs =[Fdb executeQuery:sql];
    NSMutableArray*array=[[NSMutableArray alloc]init];
    while ([rs next]) {
        NSString*str=[rs stringForColumn:@"subtype"];
        [array addObject:str];
        
    }
    
    [rs close];
    return array;
}


-(NSMutableArray*)getAllPayout{
    NSMutableArray*array=[[NSMutableArray alloc]init];
    FMResultSet *rs =[Fdb executeQuery:@"SELECT * FROM payout"];
    
    while ([rs next]) {
        payout*_payout=[[payout alloc]init];
        _payout.payout_ID=[rs intForColumn:@"ID"];
        _payout.amount = [rs doubleForColumn:@"amount"];
        _payout.date=[rs stringForColumn:@"date"];
        _payout.type=[rs stringForColumn:@"type"];
        _payout.subType=[rs stringForColumn:@"subType"];
        _payout.comment=[rs stringForColumn:@"comment"];
        _payout.image=[rs dataForColumn:@"image"];
        _payout.personnel=[rs stringForColumn:@"personnel"];
        NSLog(@"%d",_payout.payout_ID);
        [array addObject:_payout];
    }
    
    [rs close];
    return array;
}
-(BOOL)checkingPayout:(payout *)payout{

//    if (payout.amount>0&&[payout.type length]>1&&[payout.subType length]>1&&[payout.personnel length]>1&&[payout.date length]>1) {
//        return YES;
//    }
    if (payout.amount<0.1) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"金额不能为空" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        return NO;
    }else if([payout.type length]<1){
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"类别不能为空" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        return NO;
        
    }else if ([payout.subType length]<1){
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"子类别不能为空" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        return NO;
        
    }else if ([payout.date length]<1){
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"时间不能为空" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        return NO;
    }else if ([payout.personnel length]<1){
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"成员不能为空" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        return NO;
    }else{
        return YES;
    }
}
@end
