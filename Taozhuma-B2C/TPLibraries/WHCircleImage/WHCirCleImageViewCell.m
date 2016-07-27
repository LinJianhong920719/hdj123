//
//  WHCirCleImageViewCell.m
//  WHCircleImageView测试
//
//  Created by wanghao on 16/3/9.
//  Copyright © 2016年 wanghao. All rights reserved.
//

#import "WHCirCleImageViewCell.h"

@interface WHCirCleImageViewCell ()

@property(nonatomic,strong)UIImageView *imageView;

@end

@implementation WHCirCleImageViewCell

-(void)setUrlimageView:(UIImageView *)UrlimageView{

    _UrlimageView = UrlimageView;
    self.imageView = UrlimageView;
    [self.contentView addSubview:UrlimageView];

}

@end
