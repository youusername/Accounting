//
//  payout.h
//  mount
//
//  Created by zd2011 on 13-5-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface payout : NSObject<NSCoding>
@property(assign,nonatomic) int payout_ID;//帐单ID
@property (assign,nonatomic) float amount;//金额
@property (copy,nonatomic) NSString *date;//时间
@property (copy,nonatomic) NSString *type;//类型
@property (copy,nonatomic) NSString *subType;//子类型
@property (copy,nonatomic) NSString *comment;//备注
@property (copy,nonatomic) NSData *image;//照片
@property (copy,nonatomic) NSString *personnel;//成员
-(int)getMonth;
-(NSString*)getType:(int)typeOrPersonnel;
@end
