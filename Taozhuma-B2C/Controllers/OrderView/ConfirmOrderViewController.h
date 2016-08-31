//
//  ConfirmOrderViewController.h
//  确认订单
//
//  Created by lixinfan on 15-03-01.
//  Copyright (c) 2015年 taozhuma. All rights reserved.
//

#import "BaseViewController.h"

@interface ConfirmOrderViewController : BaseViewController

@property (nonatomic, assign) NSInteger from;
@property (nonatomic, strong) NSString *submitStr;
@property (nonatomic, strong) NSString *proId;
@property (nonatomic, strong) NSString *proNum;

@end
