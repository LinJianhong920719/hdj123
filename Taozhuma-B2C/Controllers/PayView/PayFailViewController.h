//
//  PaySuccessViewController.h
//  Taozhuma-B2C
//
//  Created by edz on 17/1/3.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PayFailViewController : BaseViewController

@property (nonatomic, strong) NSString* payType;
//重新支付
- (IBAction)payAgain:(id)sender;

@end
