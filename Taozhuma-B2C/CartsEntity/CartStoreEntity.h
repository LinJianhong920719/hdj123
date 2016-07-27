//
//  CartB2CEntity.h
//  b2c购物车Entity
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CartStoreEntity : NSObject

@property (nonatomic, strong) NSArray *carts;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, assign) NSInteger discountType;
@property (nonatomic, strong) NSArray *discountArray;
@property (nonatomic, strong) NSString *chooseTag;
@property (nonatomic, strong) NSString *subPrice;
@property (nonatomic, strong) NSString *discountPrice;
@property (nonatomic, assign) CGFloat preferential;
@property (nonatomic, strong) NSString *subNumber;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
