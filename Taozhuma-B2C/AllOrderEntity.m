//
//  Created by lixf on 15-01-12.
//  Copyright (c) 2015年 lixf. All rights reserved.
//
//  订单列表Entity
//

#import "AllOrderEntity.h"


@implementation AllOrderEntity


@synthesize num;//订单商品数量
@synthesize shopName;//店铺名称
@synthesize orderStatus;//订单状态
@synthesize allPrice;//总额
@synthesize _carts;
@synthesize oid;//订单id
@synthesize orderSn;//订单号
@synthesize isCancel;//是否取消
@synthesize shopId;//店铺id
@synthesize shopLogo;//店铺LOGO
@synthesize isDiscuss;//是否评论
@synthesize freight;//运费
@synthesize isRefuse;//是否拒绝
@synthesize shipping_status;//配送状态
//@synthesize sendPrice;//起送价
//@synthesize errorMsg;
- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    _carts = [[NSMutableArray alloc]init];
    num = [attributes valueForKey:@"nums"];//WU
    shopName = [attributes valueForKey:@"sj_shop_name"];
    orderStatus = [attributes valueForKey:@"pay_status"];
    allPrice= [attributes valueForKey:@"real_amount"];
    _carts = [attributes valueForKey:@"goodInfo"];
    oid = [attributes valueForKey:@"order_total_id"];
    orderSn = [attributes valueForKey:@"order_sn"];
    shopLogo = [attributes valueForKey:@"sj_image"];
    isCancel = [attributes valueForKey:@"is_cancel_order"];
    shopId = [attributes valueForKey:@"shop_id"];
    isDiscuss = [attributes valueForKey:@"is_denial_orders"];
    freight = [attributes valueForKey:@"sj_freight_amount"];
    isRefuse = [attributes valueForKey:@"is_denial_orders"];
    shipping_status = [attributes valueForKey:@"shipping_status"];
//    sendPrice = [attributes valueForKey:@"bid_price"];
//    errorMsg = [attributes valueForKey:@"error_msg"];
    
    //    for (NSDictionary  *cart in carts) {
    //        OrderProEntity *shop4 = [[OrderProEntity alloc]initWithAttributes:cart];
    //        [_carts addObject:shop4];
    //    }
    
    return self;
}

@end
