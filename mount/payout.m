//
//  payout.m
//  mount
//
//  Created by zd2011 on 13-5-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "payout.h"
#define kAmount @"amount"
#define kDate @"date"
#define kType @"type"
#define kSuType @"suType"
#define kComment @"comment"
#define kPersonnel @"personnel"
#define kPayout_ID @"ID"

@implementation payout
@synthesize payout_ID,amount,date,type,subType,comment,image,personnel;

-(NSString *)description{
    NSString *str=[[NSString alloc]initWithFormat:@"id:%d; amount:%f; date:%@; type:%@; subType:%@; comment:%@; image:%@; personnel:%@", payout_ID,amount,date,type,subType,comment,image,personnel];
    return str;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:payout_ID forKey:kPayout_ID];
    [aCoder encodeFloat:amount forKey:kAmount];
    [aCoder encodeObject:type forKey:kType];
    [aCoder encodeDataObject:image];
    [aCoder encodeObject:date forKey:kDate];
    [aCoder encodeObject:subType forKey:kSuType];
    [aCoder encodeObject:comment forKey:kComment];
    [aCoder encodeObject:personnel forKey:kPersonnel];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        payout_ID=[aDecoder decodeIntForKey:kPayout_ID];
        amount=[aDecoder decodeFloatForKey:kAmount];
        date=[aDecoder decodeObjectForKey:kDate];
        type=[aDecoder decodeObjectForKey:kType];
        subType=[aDecoder decodeObjectForKey:kSuType];
        comment=[aDecoder decodeObjectForKey:kComment];
        image=[aDecoder decodeDataObject];
        personnel=[aDecoder decodeObjectForKey:kPersonnel];
        
    }
    return self;
}
-(int)getMonth{
    //转换日期格式
    NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
    [Formatter setDateFormat:@"yyyy-MM-dd"];// HH:mm:ss
    NSDate*da=[Formatter dateFromString:self.date];
    //取出月份
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
    [dateFormatter setDateFormat:@"MM"];
    NSString *destDateString = [dateFormatter stringFromDate:da];
    
    return [destDateString intValue];
    
}
-(NSString*)getType:(int)typeOrPersonnel{
    //为1返回类型，为其它数返回人员
    if (typeOrPersonnel==1) {
       
        return self.type;
        
    }else if (typeOrPersonnel==2){
        NSString*str=[NSString stringWithFormat:@"%d",[self getMonth]];
        return str;
    }
     return self.personnel;
}


@end
