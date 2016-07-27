//
//  TableViewCell.h
//  MailWorldClient
//
//  Created by liyoro on 13-10-15.
//  Copyright (c) 2013年 liyoro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"
@interface TableViewCell : UITableViewCell {
    UIView *contentView;
    BOOL showsDividing;
}

@property (nonatomic, assign) BOOL showsDivider;

- (void)drawContentView:(CGRect)rect; // subclasses should implement


@end
