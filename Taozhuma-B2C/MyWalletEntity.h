//
//  MyWalletEntity.h
//  Taozhuma-B2C
//
//  Created by Average on 16/8/27.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWalletEntity : NSObject

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *val;
@property (nonatomic, strong) NSString *left_val;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
