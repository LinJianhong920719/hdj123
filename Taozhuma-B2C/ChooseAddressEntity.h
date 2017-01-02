//
//  ChooseAddressEntity.h
//  Taozhuma-B2C
//
//  Created by edz on 17/1/2.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChooseAddressEntity : NSObject

@property (nonatomic, strong) NSString *communityId;//小区id
@property (nonatomic, strong) NSString *communityName;//小区名称
@property (nonatomic, strong) NSString *addressDetail;//地址

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
