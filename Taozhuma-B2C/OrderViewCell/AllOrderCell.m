//
//  AllOrderCell.m
//  订单列表Cell
//
//  Created by lixinfan on 15-03-01.
//  Copyright (c) 2015年 taozhuma. All rights reserved.
//

#import "AllOrderCell.h"

@implementation AllOrderCell

@synthesize shopImage;
@synthesize shopName;
@synthesize shopPrice;
@synthesize shopNum;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [contentView setBackgroundColor:[UIColor whiteColor]];
//        
//        CALayer *layer = [contentView layer];
//        [layer setContentsGravity:kCAGravityTopLeft];
//        [layer setNeedsDisplayOnBoundsChange:YES];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setNeedsDisplay];
}

@end
