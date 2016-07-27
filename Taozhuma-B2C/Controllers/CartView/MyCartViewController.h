//
//  MyCartViewController.h
//  购物车
//
//  Created by lixinfan on 15-03-01.
//  Copyright (c) 2015年 taozhuma. All rights reserved.
//

#import "BaseViewController.h"
//#import "MJRefresh.h"
//#import "MBProgressHUD.h"

@interface MyCartViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *stoData;
    NSMutableArray *proData;
    UITableView *_tableView;
}
@property (nonatomic, strong) NSString *ptagid;
@property (nonatomic, assign) NSInteger comeTag;

@end
