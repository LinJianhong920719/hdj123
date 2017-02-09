//
//  CommentOrderViewController.h
//  Taozhuma-B2C
//
//  Created by edz on 17/2/9.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "BaseViewController.h"
#import "AllOrderEntity.h"

@interface CommentOrderViewController : BaseViewController

@property (nonatomic, strong) AllOrderEntity* data;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* commentArray;

@end
