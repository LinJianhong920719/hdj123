//
//  Created by lixf on 15-01-12.
//  Copyright (c) 2015年 lixf. All rights reserved.
//
//  订单列表Entity
//


#import <Foundation/Foundation.h>

@interface AllOrderEntity : NSObject
@property (nonatomic, strong) NSString *oid;//订单id
@property (nonatomic, strong) NSString *orderSn;//订单号
@property (nonatomic, strong) NSString *num;//订单商品数量
@property (nonatomic, strong) NSString *shopName;//店铺名称
@property (nonatomic, strong) NSString *shopLogo;
@property (nonatomic, strong) NSString *shopId;//店铺id
@property (nonatomic, strong) NSString *orderStatus;//订单状态
@property (nonatomic, strong) NSString *allPrice;//总额
@property (nonatomic, strong) NSString *isCancel;//是否取消
@property (nonatomic, strong) NSString *isDiscuss;//是否评论
@property (nonatomic, strong) NSString *isRefuse;//是否拒绝
@property (nonatomic, strong) NSString *isDelete;//是否删除
@property (nonatomic, strong) NSString *shipping_status;//配送状态
@property (nonatomic, strong) NSString *freight;//运费
//@property (nonatomic, strong) NSString *sendPrice;//起送价
@property (nonatomic, strong) NSMutableArray *_carts;
//@property (nonatomic, strong) NSString *errorMsg;//提示信息

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
