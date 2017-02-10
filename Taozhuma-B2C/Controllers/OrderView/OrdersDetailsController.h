//
//  OrdersDetailsController.h
//
//  Created by yusaiyan on 15/8/11.
//  Copyright (c) 2015年 lixinfan. All rights reserved.
//

#import "BaseViewController.h"


@interface OrdersDetailsController :BaseViewController


@property (nonatomic, strong) NSString *orderId;//订单总id
@property (nonatomic, strong) NSString *shopId;//店铺id
@property (nonatomic, strong) UITableView* mTableView;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, strong) NSMutableArray* data;//商品数组
@property (nonatomic, strong) NSMutableArray* orderData;//订单数组
@property (nonatomic, strong) NSMutableArray* addressData;//地址数组
@property (nonatomic, strong) NSMutableArray* shopData;//店铺数组
@end
