//
//  ConfirmOrderEntity.h
//  确认订单列表Entity
//
//  Created by lixinfan on 15-03-01.
//  Copyright (c) 2015年 taozhuma. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ConfirmOrderEntity : NSObject

//@property (nonatomic, strong) NSString *shopLogo;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *shopName;
//@property (nonatomic, strong) NSString *sumPrice;
//@property (nonatomic, strong) NSString *allCount;
//@property (nonatomic, strong) NSString *espressPrice;
@property (nonatomic, strong) NSArray *products;
//@property (nonatomic, strong) NSString *note;
//@property (nonatomic, strong) NSString *discountText;
//@property (nonatomic, strong) NSString *discountType;
//@property (nonatomic, strong) NSString *skuLinkId; //规格id
//@property (nonatomic, strong) NSString *skuValue; //规格名称
//@property (nonatomic, strong) NSString *isActive; //是否活动
//@property (nonatomic, strong) NSString *activityId; //活动id
//@property (nonatomic, strong) NSString *type; //活动类型
- (id)initWithAttributes:(NSDictionary *)attributes;

@end

