//
//  Created by lixf on 15-01-12.
//  Copyright (c) 2015年 lixf. All rights reserved.
//
//  购物车Entity
//

#import "CartEntity.h"

@implementation CartEntity

@synthesize cid;
@synthesize proId;
@synthesize proImage;
@synthesize proName;
@synthesize price;
@synthesize number;
@synthesize status;
@synthesize chooseTag;
@synthesize subtotal;
@synthesize ladderNum1;
@synthesize ladderNum2;
@synthesize ladderNum3;
@synthesize ladderPrice1;
@synthesize ladderPrice2;
@synthesize ladderPrice3;


- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

    cid = [attributes valueForKey:@"cid"];
    proId = [attributes valueForKey:@"productId"];
    proImage = [attributes valueForKey:@"image"];
    proName = [attributes valueForKey:@"name"];
    price = [attributes valueForKey:@"price"];
    number = [attributes valueForKey:@"number"];
    status = [attributes valueForKey:@"status"];
    
    ladderNum1= [attributes valueForKey:@"min"];
    ladderNum2 = [attributes valueForKey:@"mid"];
    ladderNum3 = [attributes valueForKey:@"max"];
    ladderPrice1 = [attributes valueForKey:@"minprices"];
    ladderPrice2 = [attributes valueForKey:@"midprices"];
    ladderPrice3 = [attributes valueForKey:@"maxprices"];

    return self;
}

@end
