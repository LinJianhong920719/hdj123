//
//  ConfirmOrderCell.h
//  确认订单cell
//
//  Created by lixinfan on 15-03-01.
//  Copyright (c) 2015年 taozhuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"

@interface ConfirmOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EMAsyncImageView *imageName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *itemNum;
@property (weak, nonatomic) IBOutlet UILabel *price;


@end
