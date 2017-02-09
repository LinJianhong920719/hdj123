//
//  CommentOrderCell.h
//  Taozhuma-B2C
//
//  Created by edz on 17/2/9.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;//商品图片
@property (weak, nonatomic) IBOutlet UILabel *productName;//商品名称
@property (weak, nonatomic) IBOutlet UITextField *productComment;//商品评论


@end
