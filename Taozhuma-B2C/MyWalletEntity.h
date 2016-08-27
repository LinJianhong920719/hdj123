//
//  MyWalletEntity.h
//  Taozhuma-B2C
//
//  Created by Average on 16/8/27.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWalletEntity : NSObject

@property (nonatomic, strong) NSString *payTitle;
@property (nonatomic, strong) NSString *payDate;
@property (nonatomic, strong) NSString *payMoney;
@property (nonatomic, strong) NSString *balance;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
