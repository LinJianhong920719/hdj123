//
//  ChooseAddressEntity.m
//  Taozhuma-B2C
//
//  Created by edz on 17/1/2.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "ChooseAddressEntity.h"

@implementation ChooseAddressEntity

@synthesize communityId;
@synthesize communityName;
@synthesize addressDetail;

-(id)initWithAttributes:(NSDictionary *)attributes{
    
    communityId = [attributes valueForKey:@"id"];
    communityName = [attributes valueForKey:@"com_name"];
    addressDetail = [attributes valueForKey:@"address"];
    
    return self;
}

@end
