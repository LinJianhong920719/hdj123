//
//  CartStoreEntity.h
//  Taozhuma-B2C
//
//  Created by Average on 16/8/27.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartStoreEntity : NSObject

@property (nonatomic, strong) NSArray *carts;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *shopId;

- (id)initWithAttributes:(NSDictionary *)attributes;


@end
