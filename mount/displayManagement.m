//
//  displayManagement.m
//  mount
//
//  Created by Mac on 13-6-2.
//
//

#import "displayManagement.h"
#import "payout.h"


@implementation displayManagement
@synthesize billM;
-(NSArray*)selectType{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM type"];
    
    FMResultSet *rs =[billM.Fdb executeQuery:sql];
    
    NSMutableArray*array=[[NSMutableArray alloc]init];
    while ([rs next]) {
        payout*_payout=[[payout alloc]init];
        _payout.payout_ID=[rs intForColumn:@"ID"];
        _payout.type=[rs stringForColumn:@"type"];
        [array addObject:_payout];
            }
    
    [rs close];

    return array;
}
//根据类别查询子类别
-(NSArray*)selectSubType:(NSString*)Type{
    return 0;
}
- (id)init
{
    self = [super init];
    if (self) {
        billM=[[billManagement alloc]init];
    }
    return self;
}
//按月份显示饼图
-(NSMutableArray*)XYPieChart:(int)Month{
    
    NSMutableArray*array=[[NSMutableArray alloc]init];

    NSDictionary*dic=[billM getMonthPayout:Month];
    if ([[dic allKeys] count]==0) {
        return nil;
    }
    
    NSNumber*key=[[dic allKeys]objectAtIndex:0];
    for (payout*p in [dic objectForKey:key]) {
        [array addObject:p];
    }


    return array;
}
//查询预算
-(NSNumber*)selectBudget{
    FMResultSet *rs =[billM.Fdb executeQuery:@"SELECT * FROM budget"];
    NSString*str=[[NSString alloc]init];
    while ([rs next]) {
        
        str=[rs stringForColumn:@"type"];
    }
    return [NSNumber numberWithInt:[str intValue]];
}
//用类型为参数，返回以参数为key的字典
-(NSMutableDictionary*)getClassPayout:(NSString *)TypeOrPersonnel Month:(int)theMonth{
    int i;
    if ([TypeOrPersonnel isEqualToString:@"Type"]) {
        i=1;
    }else if([TypeOrPersonnel isEqualToString:@"Personnel"]){
        i=0;
    }else if ([TypeOrPersonnel isEqualToString:@"date"]){
        i=2;
    }
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
    for (payout *p in [self XYPieChart:theMonth]) {
        NSString *moth=[NSString stringWithFormat:@"%@",[p getType:i]];
        
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


@end
