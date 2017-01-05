//
//  MainNavBar.m
//  Taozhuma-B2C
//
//  Created by yusaiyan on 17/1/5.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "MainNavBar.h"

@implementation MainNavBar

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = ColorFromHex(0xFFD53D);
        
        [self addOwnViews];
    }
    return self;
}

- (void)addOwnViews {
    
    loactionIV = [[UIImageView alloc]init];
    [loactionIV setFrame:CGRectMake(14, 34, 11, 16)];
    [loactionIV setImage:[UIImage imageNamed:@"address"]];
    [self addSubview:loactionIV];
    
    loactionLabel = [[UILabel alloc]init];
    loactionLabel.frame = CGRectMake(loactionIV.right + 5, 20, 100, 44);
    loactionLabel.font = [UIFont systemFontOfSize:16];
    loactionLabel.textColor = ColorFromHex(0x333333);
    loactionLabel.text = @"定位中";
    [self addSubview:loactionLabel];
    
    arrowIV = [[UIImageView alloc]init];
    [arrowIV setFrame:CGRectMake(loactionLabel.right + 5, 40, 8, 4)];
    [arrowIV setImage:[UIImage imageNamed:@"drop-down"]];
    arrowIV.hidden = YES;
    [self addSubview:arrowIV];
    
    loactionBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 150, 44)];
    [loactionBtn addTarget:self action:@selector(loactionClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loactionBtn];
    
    serachBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 160, 30, 150, 24)];
    [serachBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [serachBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:serachBtn];
}

- (void)loactionClick {
    if (self.loactionClickBlock) {
        self.loactionClickBlock();
    }
}

- (void)searchClick {
    if (self.searchClickBlock) {
        self.searchClickBlock();
    }
}

- (void)setLoactionName:(NSString *)str {
    if (![Tools isBlankString:str]) {
        loactionLabel.text = str;
        
        CGSize size = [loactionLabel sizeThatFits:CGSizeMake(MAXFLOAT, 16)];
        loactionLabel.width = size.width;
        
        arrowIV.left = loactionLabel.right + 5;
        arrowIV.hidden = NO;
    }
}

@end
