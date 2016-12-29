//
//  ConfirmOrderEntity.m
//  确认订单列表Entity
//
//  Created by lixinfan on 15-03-01.
//  Copyright (c) 2015年 taozhuma. All rights reserved.
//

#import "ConfirmOrderEntity.h"

@implementation ConfirmOrderEntity

//@synthesize shopLogo;
@synthesize shopId;
@synthesize shopName;
@synthesize sumPrice;
@synthesize allCount;
@synthesize espressPrice;
@synthesize products;
@synthesize note;
//@synthesize skuLinkId;
//@synthesize skuValue;
//@synthesize isActive;
//@synthesize activityId;
//@synthesize discountText;
//@synthesize discountType;
//@synthesize type;
- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

//    shopLogo = [attributes valueForKey:@"shopLogo"];
    shopId = [attributes valueForKey:@"shop_id"];
    shopName = [attributes valueForKey:@"shop_name"];
    allCount = [attributes valueForKey:@"all_count"];
    espressPrice= [attributes valueForKey:@"freight_amount"];
    products = [attributes valueForKey:@"goodList"];
    sumPrice = [attributes valueForKey:@"count_price"];
//    skuLinkId = [attributes valueForKey:@"skuLinkId"];
//    skuValue = [attributes valueForKey:@"skuValue"];
//    isActive = [attributes valueForKey:@"isActive"];
//    activityId = [attributes valueForKey:@"activityId"];
//    discountText = [attributes valueForKey:@"discountText"];
//    discountType = [attributes valueForKey:@"discountType"];
//    type = [attributes valueForKey:@"type"];
    return self;
}

@end
