//
//  GoodsEntity.m
//  商品entity
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import "GoodsEntity.h"

@implementation GoodsEntity

@synthesize productId;
@synthesize productImage;
@synthesize productName;
@synthesize productPrice;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
        productImage = [attributes valueForKey:@"good_image"];
        productName = [attributes valueForKey:@"good_name"];
        productPrice = [attributes valueForKey:@"good_price"];
    return self;
}

@end


