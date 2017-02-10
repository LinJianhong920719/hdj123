//
//  OrderDetailEntity.m
//  Taozhuma-B2C
//
//  Created by edz on 17/2/10.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "OrderDetailEntity.h"

@implementation OrderDetailEntity


-(id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (!self) {
        return nil;
    }
    _goodId = [attributes valueForKey:@"id"];
    _goodImage = [attributes valueForKey:@"good_image"];
    _goodName = [attributes valueForKey:@"good_name"];
    _goodPrice = [attributes valueForKey:@"good_price"];
    _goodSize = [attributes valueForKey:@"good_size"];
    _nums = [attributes valueForKey:@"nums"];
    
    return self;
}
@end
