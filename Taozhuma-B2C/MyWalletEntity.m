//
//  MyWalletEntity.m
//  Taozhuma-B2C
//
//  Created by Average on 16/8/27.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "MyWalletEntity.h"

@implementation MyWalletEntity
@synthesize payTitle;
@synthesize payDate;
@synthesize payMoney;
@synthesize balance;


- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    payTitle = [attributes valueForKey:@"id"];
    payDate = [attributes valueForKey:@"user_id"];
    payMoney = [attributes valueForKey:@"com_id"];
    balance = [attributes valueForKey:@"address"];


    
    
    return self;
}
@end
