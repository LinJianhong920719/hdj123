//
//  ConfirmOrderCell.m
//  确认订单cell
//
//  Created by lixinfan on 15-03-01.
//  Copyright (c) 2015年 taozhuma. All rights reserved.
//

#import "ConfirmOrderCell.h"

@implementation ConfirmOrderCell

@synthesize imageName;
@synthesize name;
@synthesize itemNum;
@synthesize price;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
