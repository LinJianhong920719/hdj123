//
//  GoodsEntity.h
//  商品entity
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsEntity : NSObject

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *productImage;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productPrice;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
