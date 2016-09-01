//
//  AddressModuleView.m
//  MailWorldClient
//
//  Created by yusaiyan on 15/10/30.
//  Copyright © 2015年 liyoro. All rights reserved.
//

#import "AddressModuleView.h"
#import "AppConfig.h"

#define viewIndentation 20   //视图两边缩进

@implementation AddressModuleView {
    UIImageView *envelopeImage;
    UIImageView *addImage;
    UIImageView *arrowImage;
    CGSize envelopeImageSize;
    CGSize addImageSize;
    CGSize arrowImageSize;
    UIImageView *envelopeImage1;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self drawRectView:self.frame];
        
    }
    [self bedeckView];
    
    return self;
}

/**
 *  绘制初始视图
 */
- (void)drawRectView:(CGRect)rect {
    // Drawing code
    envelopeImageSize    = CGSizeMake(self.frame.size.width, 6);
    addImageSize         = CGSizeMake(20, 23);
    arrowImageSize       = CGSizeMake(7, 10);
    
    envelopeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, envelopeImageSize.width, envelopeImageSize.height)];
    envelopeImage.image = [UIImage imageNamed:@"envelope"];
    [self addSubview:envelopeImage];
    
    envelopeImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, envelopeImageSize.width, envelopeImageSize.height)];
    envelopeImage1.image = [UIImage imageNamed:@"envelope"];
    [self addSubview:envelopeImage1];
    
    addImage = [[UIImageView alloc]initWithFrame:CGRectMake(viewIndentation, (self.frame.size.height-addImageSize.height)/2, addImageSize.width, addImageSize.height)];
    addImage.image = [UIImage imageNamed:@"address2"];
    [self addSubview:addImage];
    
    arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-viewIndentation-arrowImageSize.width, (self.frame.size.height-arrowImageSize.height)/2, arrowImageSize.width, arrowImageSize.height)];
    arrowImage.image = [UIImage imageNamed:@"address_go"];
    [self addSubview:arrowImage];
    
    //视图展示内容
    _prompt = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _prompt.textAlignment = NSTextAlignmentCenter;
    _prompt.text = @"请新建收货地址以确保商品顺利到达";
    [_prompt setTextColor:COLOR_595757];
    [_prompt setFont:[UIFont fontWithName:FontName_Default size:12]];
    [self addSubview:_prompt];
    
    //收货人姓名
    _name = [[UILabel alloc]init];
    _name.font = [UIFont fontWithName:FontName_Default size:15];
    _name.textColor = FONT_COLOR;
    [self addSubview:_name];
    
    //联系方式
    _phone = [[UILabel alloc]init];
    _phone.font = [UIFont fontWithName:FontName_Default size:15];
    _phone.textColor = FONT_COLOR;
    [self addSubview:_phone];
    
    //收货地址
    _address = [[UILabel alloc]init];
    _address.font = [UIFont fontWithName:FontName_Default size:13];
    _address.textColor = FONT_COLOR;
    _address.text = @"(设置收获地址)";
    [self addSubview:_address];
    
    //选择按钮
    _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_button];
}

/**
 *  自定义高度 重新设置frame
 */
- (void)setHeight:(CGFloat)height
{
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, origionRect.size.width, height);
    self.frame = newRect;
    
    [self bedeckView];
}

/**
 *  根据获取的内容 重新设置frame
 */
- (void)setAddressID:(NSString *)addressID nameText:(NSString *)name phoneText:(NSString *)phone addressText:(NSString *)address
{
    CGRect origionRect = self.frame;
    
    _addressID = addressID;
    _name.text = name;
    _phone.text = phone;
    _address.text = address;
    
    [_name setFrame:CGRectMake(48, viewIndentation, DEVICE_SCREEN_SIZE_WIDTH-88, 20)];
    
    CGSize telSize = [_phone.text sizeWithFont:_phone.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    [_phone setFrame:CGRectMake(self.frame.size.width-telSize.width-40, viewIndentation, telSize.width, 20)];
    
    [_address setNumberOfLines:3];
    CGSize addSize = [_address.text sizeWithFont:_address.font constrainedToSize:CGSizeMake(DEVICE_SCREEN_SIZE_WIDTH-88,100) lineBreakMode:NSLineBreakByWordWrapping];
    [_address setFrame:CGRectMake(48, viewBottom(_name)+8, addSize.width, addSize.height)];
    
    CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, origionRect.size.width, viewBottom(_address)+10);
    self.frame = newRect;
    
    [_button setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    _prompt.text = @"";
    
    [self bedeckView];
}

/**
 *  视图修饰
 */
- (void)bedeckView {
 
    [envelopeImage setFrame:CGRectMake(0, 0, envelopeImageSize.width, envelopeImageSize.height)];

    [addImage setFrame:CGRectMake(viewIndentation, (self.frame.size.height-addImageSize.height)/2, 12, 17)];
    
    [arrowImage setFrame:CGRectMake(self.frame.size.width-viewIndentation-arrowImageSize.width, (self.frame.size.height-arrowImageSize.height)/2, arrowImageSize.width, arrowImageSize.height)];
    [envelopeImage setFrame:CGRectMake(0, self.frame.size.height, envelopeImageSize.width, envelopeImageSize.height)];
    
}

@end
