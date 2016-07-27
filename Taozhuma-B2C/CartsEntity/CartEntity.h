//
//  Created by lixf on 15-01-12.
//  Copyright (c) 2015年 lixf. All rights reserved.
//
//  购物车Entity
//


#import <Foundation/Foundation.h>

@interface CartEntity : NSObject

@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *proId;
@property (nonatomic, strong) NSString *proImage;
@property (nonatomic, strong) NSString *proName;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *status;//产品状态
@property (nonatomic, strong) NSString *chooseTag;//购物车是否选中
@property (nonatomic, strong) NSString *subtotal;//小计

@property (nonatomic, strong) NSString *ladderNum1;
@property (nonatomic, strong) NSString *ladderNum2;
@property (nonatomic, strong) NSString *ladderNum3;
@property (nonatomic, strong) NSString *ladderPrice1;
@property (nonatomic, strong) NSString *ladderPrice2;
@property (nonatomic, strong) NSString *ladderPrice3;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
