//
//  AddressModuleView.h
//  MailWorldClient
//
//  Created by yusaiyan on 15/10/30.
//  Copyright © 2015年 liyoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressModuleView : UIView

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *name;        //联系人
@property (nonatomic, strong) UILabel *phone;       //联系电话
@property (nonatomic, strong) UILabel *address;     //详细地址
@property (nonatomic, strong) UILabel *prompt;      //提示语句

@property (nonatomic, strong) NSString *addressID;  //地址ID
@property (nonatomic, assign) BOOL isRemote;        //是否偏远地区

- (void)setHeight:(CGFloat)height;
- (void)setAddressID:(NSString *)addressID nameText:(NSString *)name phoneText:(NSString *)phone addressText:(NSString *)address;

@end
