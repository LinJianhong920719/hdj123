//
//  ClassGoodsEntity.h.m
//  商品大分类entity
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import "ClassGoodsEntity.h"

@implementation ClassGoodsEntity

@synthesize catId;
@synthesize catName;
@synthesize catPid;
@synthesize catImage;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
        catId = [attributes valueForKey:@"id"];
        catName = [attributes valueForKey:@"cat_name"];
        catPid = [attributes valueForKey:@"cat_pid"];
        catImage = [attributes valueForKey:@"image"];
    return self;
}

@end


