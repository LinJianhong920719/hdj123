//
//  HotProductEntity.h
//  Taozhuma-B2C
//
//  Created by Average on 16/12/27.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotProductEntity : NSObject

@property (nonatomic, strong) NSString *hid;
@property (nonatomic, strong) NSString *goodName;
@property (nonatomic, strong) NSString *goodImage;
@property (nonatomic, strong) NSString *goodPrice;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *goodSize;

- (id)initWithAttributes:(NSDictionary *)attributes;
@end
