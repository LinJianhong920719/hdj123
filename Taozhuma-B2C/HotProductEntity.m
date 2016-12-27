//
//  HotProductEntity.m
//  Taozhuma-B2C
//
//  Created by Average on 16/12/27.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "HotProductEntity.h"

@implementation HotProductEntity

@synthesize hid;
@synthesize goodName;
@synthesize goodImage;
@synthesize goodPrice;
@synthesize shopId;
@synthesize goodSize;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    hid = [attributes valueForKey:@"id"];
    goodName = [attributes valueForKey:@"good_name"];
    goodImage = [attributes valueForKey:@"good_image"];
    goodPrice = [attributes valueForKey:@"good_price"];
    shopId = [attributes valueForKey:@"shop_id"];
    goodSize = [attributes valueForKey:@"good_size"];
    
    return self;
}
@end
