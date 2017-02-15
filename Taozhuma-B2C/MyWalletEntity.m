//
//  MyWalletEntity.m
//  Taozhuma-B2C
//
//  Created by Average on 16/8/27.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "MyWalletEntity.h"

@implementation MyWalletEntity


- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

    _uid = [attributes valueForKey:@"uid"];
    _message = [attributes valueForKey:@"message"];
    _createTime = [attributes valueForKey:@"create_time"];
    _val = [attributes valueForKey:@"val"];
    _left_val = [attributes valueForKey:@"left_val"];

    return self;
}
@end
