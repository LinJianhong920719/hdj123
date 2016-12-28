//
//  HotProCollectionViewCell.h
//  Taozhuma-B2C
//
//  Created by edz on 16/12/28.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotProCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *hotProImage;
@property (weak, nonatomic) IBOutlet UILabel *hotProName;
@property (weak, nonatomic) IBOutlet UILabel *hotProPrice;

@end
