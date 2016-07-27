//
//  WHCircleImageView.h
//  WHCircleImageView测试
//
//  Created by wanghao on 16/3/9.
//  Copyright © 2016年 wanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHCircleImageView : UICollectionView


//提供一个接口
-(instancetype)initWithFrame:(CGRect)frame AndImageUrlArray:(NSArray *)ImageUrlArray view:(UIView *)view;


@end
