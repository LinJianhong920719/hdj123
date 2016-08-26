//
//  AddressEntity.h
//  Taozhuma-B2C
//
//  Created by Average on 16/8/26.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressEntity : NSObject

@property (nonatomic, strong) NSString *addressID;//地址id
@property (nonatomic, strong) NSString *uID;//用户id
@property (nonatomic, strong) NSString *comId;//小区id
@property (nonatomic, strong) NSString *address;//地址
@property (nonatomic, strong) NSString *guestName;//接收人名字
@property (nonatomic, strong) NSString *mobile;//手机号码
@property (nonatomic, strong) NSString *gender;//0男1女
@property (nonatomic, strong) NSString *level;//0普通1默认地址


- (id)initWithAttributes:(NSDictionary *)attributes;
@end
