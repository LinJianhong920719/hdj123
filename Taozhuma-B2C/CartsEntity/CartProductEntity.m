//
//  CartB2CEntity.m
//  b2c购物车Entity
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import "CartProductEntity.h"

@implementation CartProductEntity

@synthesize cid;
@synthesize image;
@synthesize name;
@synthesize number;
@synthesize price;
@synthesize productId;
@synthesize shopId;
@synthesize shopName;
@synthesize status;
@synthesize chooseTag;
@synthesize inventory;
@synthesize subtotal;
@synthesize skuLinkId;
@synthesize skuValue;
@synthesize isActive;
@synthesize activityId;
@synthesize type;
- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    cid = [attributes valueForKey:@"id"];
    image = [attributes valueForKey:@"good_image"];
    name = [attributes valueForKey:@"good_name"];
    number = [attributes valueForKey:@"nums"];
    price = [attributes valueForKey:@"good_price"];
    productId = [attributes valueForKey:@"good_id"];
    shopId = [attributes valueForKey:@"shop_id"];
    shopName = [attributes valueForKey:@"shopName"];
    status = [attributes valueForKey:@"status"];
    inventory = [attributes valueForKey:@"inventory"];
    skuLinkId = [attributes valueForKey:@"skuLinkId"];
    skuValue = [attributes valueForKey:@"skuValue"];
    isActive = [attributes valueForKey:@"isActive"];
    activityId = [attributes valueForKey:@"activityId"];
    type = [attributes valueForKey:@"type"];
    return self;
}

@end
