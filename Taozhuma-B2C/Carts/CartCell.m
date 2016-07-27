//
//  CartCell.m
//  购物车列表cell
//
//  Created by lixinfan on 15-03-01.
//  Copyright (c) 2015年 taozhuma. All rights reserved.
//

#import "CartCell.h"
#define NUMBERS @"0123456789\n"
@implementation CartCell{
    NSInteger totalNum;
    NSInteger totalChangeNum;
    UIImage *chooseImage;
    
}

@synthesize i;
@synthesize title;
@synthesize activityType;
@synthesize attribute;
@synthesize price;
@synthesize imagesView;
@synthesize subtotal;
@synthesize number;
@synthesize choose;
@synthesize reduceBtn;
@synthesize delBtn;
@synthesize increaseBtn;
@synthesize transparent;
@synthesize subtotalInt;
@synthesize cid;
@synthesize num;
@synthesize type;
@synthesize shopId;
@synthesize chooseTag;
@synthesize priceFloat;
@synthesize inventory;
@synthesize promptImages;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        CALayer *layer = [contentView layer];
        [layer setContentsGravity:kCAGravityTopLeft];
        [layer setNeedsDisplayOnBoundsChange:YES];
        
    }
    return self;
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    
    number.delegate = self;
    [number addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [number addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender{
    [number resignFirstResponder];
    
    
}

// 文本框失去first responder 时，执行
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (number.text.length == 0) {
        number.text = @"1";
    }
     totalNum = [number.text integerValue];
     totalChangeNum = [num integerValue];
    [self performSelector: @selector(editNumClick:) withObject: self afterDelay: 0];
}

// 限制输入长度
- (void) textFieldDidChange:(UITextField *) textField{

    if(type==2){
        
        if ([textField.text integerValue]>=4) {
            textField.text = @"3";
        }
    }
    
    if ([textField.text integerValue] > [inventory integerValue]) {
        textField.text = inventory;
    }
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = @"1";
    }
    
}

// 限制输入类型为数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs;
    
    if (textField == number) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        
        if (!basicTest) {
            return NO;
        }
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setNeedsDisplay];
}

// 增减按钮点击执行
- (IBAction) buttonClick:(id)sender {
    
    totalNum = [number.text integerValue];
    totalChangeNum =[number.text integerValue];
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) {
        if ([number.text integerValue] < [inventory integerValue]) {
            totalNum = totalNum + 1;
            
            if(type==2){
                
                if (totalNum>=4) {
                    number.text = @"3";
                    totalNum = 3 ;
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"限量购活动只限购3件，不能贪哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
            }
            
        }
    } else if (button.tag == 2) {
        
        if ([number.text integerValue] > 1) {
            totalNum = totalNum - 1;
        }
    }
    
    [self performSelector: @selector(editNumClick:) withObject: self afterDelay: 0];
    
    
}

-(IBAction)editNumClick:(id)sender{
//    NSString *str = [NSString stringWithFormat:@"%@:%ld",cid,(long)totalNum];
//    //执行修改
//    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
//                         [Tools stringForKey:KEY_USER_ID],           @"uid",
//                         str,              @"cids",
//                         nil];
//    NSString *xpoint = @"toEditCart.do?";
//    [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
//        if (error) {
//            
//        } else {
//            if(respond.result == 1) {
//                //计算单品总价
//                //    price.text = [NSString stringWithFormat:@"¥%ld",(long)priceInt];
//                subtotalInt = priceFloat * totalNum;
//                subtotal.text = [NSString stringWithFormat:@"¥%0.1f",subtotalInt];
//                
//                NSMutableArray *array2 = [[NSMutableArray alloc]init];
//                [array2 addObject:cid];
//                
//                if ([chooseTag integerValue] == 1) {
//                    [array2 addObject:[NSString stringWithFormat:@"%0.1f",subtotalInt]];
//                } else {
//                    [array2 addObject:[NSString stringWithFormat:@"%0.1f",subtotalInt]];
//                }
//                
//                NSMutableArray *array = [[NSMutableArray alloc]init];
//                [array addObject:cid];
//                [array addObject:[NSString stringWithFormat:@"%ld",(long)totalNum]];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCartNum" object:array];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"cartSubtotal" object:array2];
//            }else{
//                
//                
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.detailsLabelText = respond.error_msg;
//                hud.yOffset = 200.f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:2];
//                
//                
//                subtotalInt = priceFloat * totalChangeNum;
//                subtotal.text = [NSString stringWithFormat:@"¥%0.1f",subtotalInt];
//                
//                NSMutableArray *array2 = [[NSMutableArray alloc]init];
//                [array2 addObject:cid];
//                
//                if ([chooseTag integerValue] == 1) {
//                    [array2 addObject:[NSString stringWithFormat:@"%0.1f",subtotalInt]];
//                } else {
//                    [array2 addObject:[NSString stringWithFormat:@"%0.1f",subtotalInt]];
//                }
//                
//                NSMutableArray *array = [[NSMutableArray alloc]init];
//                [array addObject:cid];
//                [array addObject:[NSString stringWithFormat:@"%ld",(long)totalChangeNum]];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCartNum" object:array];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"cartSubtotal" object:array2];
//                
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，该宝贝不能购买更多哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//                
//            }
//            
//        }
//    }];
    
}
//临时修改按钮状态，发送修改数据
- (IBAction) chooseClick:(id)sender {
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:cid];
    [array addObject:shopId];
    
    if ([chooseTag integerValue] == 0) {
        chooseImage = [UIImage imageNamed:@"icon-checked-60.png"];
        //修改实际状态
        [array addObject:@"1"];
        //修改缓存状态
        chooseTag = @"1";
    } else {
        chooseImage = [UIImage imageNamed:@"icon-check-60.png"];
        //修改实际状态
        [array addObject:@"0"];
        //修改缓存状态
        chooseTag = @"0";
    }
    [choose setImage:chooseImage forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseCartNum" object:array];
}

//根据实际数据，显示按钮状态
- (void)setChecked:(BOOL)checked {
    if (checked) {
        chooseImage = [UIImage imageNamed:@"icon-checked-60.png"];
        //修改缓存状态
        chooseTag = @"1";
    } else {
        chooseImage = [UIImage imageNamed:@"icon-check-60.png"];
        //修改缓存状态
        chooseTag = @"0";
    }
    [choose setImage:chooseImage forState:UIControlStateNormal];
}
- (void)setHidden:(BOOL)hidden {
    if (hidden) {
        delBtn.hidden = YES;
        activityType.hidden = NO;
    } else {
        delBtn.hidden = NO;
        activityType.hidden = YES;
    }
}
@end
