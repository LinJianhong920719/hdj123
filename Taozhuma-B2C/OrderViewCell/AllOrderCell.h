//
//  AllOrderCell.h
//  订单列表Cell
//
//  Created by lixinfan on 15-03-01.
//  Copyright (c) 2015年 taozhuma. All rights reserved.
//

#import "EMAsyncImageView.h"

@interface AllOrderCell : UITableViewCell {
}

@property (nonatomic, strong) IBOutlet EMAsyncImageView *shopImage;
@property (strong, nonatomic) IBOutlet UILabel *shopName;
@property (strong, nonatomic) IBOutlet UILabel *shopPrice;
@property (strong, nonatomic) IBOutlet UILabel *shopNum;

@end
