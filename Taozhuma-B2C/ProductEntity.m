//
//  ProductEntity.m
//
//  Created by yusaiyan on 15/8/11.
//  Copyright (c) 2015年 lixinfan. All rights reserved.
//

#import "ProductEntity.h"

@implementation ProductEntity
@synthesize pID;//分类中的商品id
@synthesize productID;//商品id
@synthesize productName;//商品名称
@synthesize productImage;//商品图片
@synthesize productPrice;//商品价格

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    pID             = [attributes valueForKey:@"id"];
    productID             = [attributes valueForKey:@"good_id"];
    productName          = [attributes valueForKey:@"good_name"];
    productImage     = [attributes valueForKey:@"good_image"];
    productPrice           = [attributes valueForKey:@"good_price"];

    return self;
}

@end
