//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */

#import "AppConfig.h"
#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"

@implementation SDCollectionViewCell
{
    __weak UILabel *_titleLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        _titleLabel.numberOfLines = 2;
        [self setupImageView];
        [self setupTitleLabel];
    }
    
    return self;
}

- (void)setCelltype:(NSInteger )celltype
{
    _celltype = celltype;
    
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    
    _titleLabel.textColor = ColorFromHex(0x333333);
    
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = [UIFont fontWithName:FontName_Default_Bold size:turn6(18)];
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"%@", title];
    if (_celltype == 1) {
        
        CGSize size = [_titleLabel sizeThatFits:CGSizeMake(ScreenWidth-turn6(98), MAXFLOAT)];
        _titleLabel.frame = CGRectMake(turn6(49), viewBottom(_imageView)+turn6(10), ScreenWidth-turn6(98), size.height);
    }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.onlyDisplayText) {
        _titleLabel.frame = self.bounds;
    } else {
        
        if (_celltype == 1) {
            _imageView.frame = CGRectMake(0, 0, ScreenWidth, turn6(210));
        }else{
            _imageView.frame = self.bounds;
            CGFloat titleLabelW = self.sd_width;
            CGFloat titleLabelH = _titleLabelHeight;
            CGFloat titleLabelX = 0;
            CGFloat titleLabelY = self.sd_height - titleLabelH;
            _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
        }
        
        _titleLabel.numberOfLines = 2;
        CGSize size = [_titleLabel sizeThatFits:CGSizeMake(ScreenWidth-turn6(98), MAXFLOAT)];
        _titleLabel.frame = CGRectMake(turn6(49), viewBottom(_imageView)+turn6(10), ScreenWidth-turn6(98), size.height);
    }
}

@end
