//
//  AddressEntity.m
//  Taozhuma-B2C
//
//  Created by Average on 16/8/26.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "AddressEntity.h"

@implementation AddressEntity

@synthesize addressID;//地址id
@synthesize uID;//用户id
@synthesize comId;//小区id
@synthesize address;//地址
@synthesize guestName;//接收人名字
@synthesize mobile;//手机号码
@synthesize gender;//0男1女
@synthesize level;//0普通1默认地址

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

    addressID = [attributes valueForKey:@"id"];
    uID = [attributes valueForKey:@"user_id"];
    comId = [attributes valueForKey:@"com_id"];
    address = [attributes valueForKey:@"address"];
    guestName = [attributes valueForKey:@"guest_name"];
    mobile = [attributes valueForKey:@"mobile"];
    gender = [attributes valueForKey:@"gender"];
    level = [attributes valueForKey:@"Level"];
    
    
    return self;
}
@end
