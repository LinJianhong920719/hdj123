//
//  EditAddressViewController.m
//  Taozhuma-B2C
//
//  Created by Average on 16/8/26.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "EditAddressViewController.h"
#import "AddressPickView.h"
#import "IQKeyBoardManager.h"
#import "LTPickerView.h"
@interface EditAddressViewController ()<UIActionSheetDelegate,UITextFieldDelegate>{
    UILabel *userName;
    UITextField *userNameField;
    UILabel *userSex;
    UITextField *userSexField;
    UILabel *userPhone;
    UITextField *userPhoneField;
    UILabel *userArea;
    UITextField *userAreaField;
    UILabel *userCom;
    UITextField *userComField;
    UILabel *userAddress;
    UITextField *userAddressField;
    NSString *sexNum;
    NSMutableArray *comNameArray;
    NSMutableArray *comIdArray;
    NSString *communityId;//小区id
    NSString *communityName;//小区名称
    UIAlertView *alert;
    NSString *provinceStr;
    NSString *cityStr;
    NSString *townStr;
    
    NSString* address;
    NSString* guestName;
    NSString* mobile;

}

@end

@implementation EditAddressViewController
@synthesize addressId;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [IQKeyBoardManager installKeyboardManager];
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;//手势敲击的次数
    [self.view addGestureRecognizer:gesture];
    comNameArray = [[NSMutableArray alloc]init];
    comIdArray = [[NSMutableArray alloc]init];
    [self loadAddressMsg];
    [self loadAdrMsg];
}
-(void)initUI{
    //导航栏右侧按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:255/255.0f green:80/255.0f blue:0 alpha:1.0 ] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize: 15];
    [rightBtn addTarget:self action:@selector(addAddressMsg:) forControlEvents:UIControlEventTouchUpInside];
    [self setNaviBarRightBtn:rightBtn];

    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewOrignY+20, DEVICE_SCREEN_SIZE_WIDTH, 245)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    //联系人
    userName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    userName.text = @"联系人";
    userName.textAlignment = NSTextAlignmentCenter;
    userName.font = [UIFont systemFontOfSize:14];
    userName.textColor = FONTS_COLOR102;
    [baseView addSubview:userName];
    
    userNameField = [[UITextField alloc]initWithFrame:CGRectMake(viewRight(userName)+10, 0, DEVICE_SCREEN_SIZE_WIDTH-userName.frame.size.width-20, 40)];
    userNameField.placeholder = @"收货人姓名";
    userNameField.font = [UIFont systemFontOfSize:14];
    userNameField.textColor = FONTS_COLOR153;
    userNameField.backgroundColor = UIColorWithRGBA(255, 255, 255, 0.5);
    //设置圆角
    userNameField.delegate = self;
    userNameField.keyboardType = UIKeyboardTypeDefault;
    userNameField.returnKeyType = UIReturnKeyNext;
    userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [userNameField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [baseView addSubview:userNameField];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, viewBottom(userNameField), DEVICE_SCREEN_SIZE_WIDTH-20, 1)];
    line1.backgroundColor = LINECOLOR_DEFAULT;
    [baseView addSubview:line1];
    
    //性别
    userSex = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line1), 80, 40)];
    userSex.text = @"性别";
    userSex.textAlignment = NSTextAlignmentCenter;
    userSex.font = [UIFont systemFontOfSize:14];
    userSex.textColor = FONTS_COLOR102;
    [baseView addSubview:userSex];
    
    
    userSexField = [[UITextField alloc]initWithFrame:CGRectMake(viewRight(userSex)+10, viewBottom(line1), DEVICE_SCREEN_SIZE_WIDTH-userSex.frame.size.width-20, 40)];
    userSexField.placeholder = @"请选择您的性别";
    userSexField.font = [UIFont systemFontOfSize:14];
    userSexField.textColor = FONTS_COLOR153;
    userSexField.backgroundColor = UIColorWithRGBA(255, 255, 255, 0.5);
    //设置圆角
//    userSexField.delegate = self;
//    userSexField.keyboardType = UIKeyboardTypeDefault;
//    userSexField.returnKeyType = UIReturnKeyNext;
//    userSexField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [userSexField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [baseView addSubview:userSexField];
    UIButton *sexBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewRight(userSex)+10, viewBottom(line1), DEVICE_SCREEN_SIZE_WIDTH-userSex.frame.size.width-20, 40)];
    [sexBtn addTarget:self action:@selector(sexPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:sexBtn];
    
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, viewBottom(userSexField), DEVICE_SCREEN_SIZE_WIDTH-20, 1)];
    line2.backgroundColor = LINECOLOR_DEFAULT;
    [baseView addSubview:line2];
    
    //手机号码
    userPhone = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line2), 80, 40)];
    userPhone.text = @"手机号码";
    userPhone.textAlignment = NSTextAlignmentCenter;
    userPhone.font = [UIFont systemFontOfSize:14];
    userPhone.textColor = FONTS_COLOR102;
    [baseView addSubview:userPhone];
    
    userPhoneField = [[UITextField alloc]initWithFrame:CGRectMake(viewRight(userPhone)+10, viewBottom(line2), DEVICE_SCREEN_SIZE_WIDTH-userPhone.frame.size.width-20, 40)];
    userPhoneField.placeholder = @"请输入您的手机号码";
    userPhoneField.font = [UIFont systemFontOfSize:14];
    userPhoneField.textColor = FONTS_COLOR153;
    userPhoneField.backgroundColor = UIColorWithRGBA(255, 255, 255, 0.5);
    //设置圆角
    userPhoneField.delegate = self;
    userPhoneField.keyboardType = UIKeyboardTypeDefault;
    userPhoneField.returnKeyType = UIReturnKeyNext;
    userPhoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [userPhoneField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [baseView addSubview:userPhoneField];
    
    UIImageView *line3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, viewBottom(userPhoneField), DEVICE_SCREEN_SIZE_WIDTH-20, 1)];
    
    line3.backgroundColor = LINECOLOR_DEFAULT;
    [baseView addSubview:line3];
    
    //所在地区
    userArea = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line3), 80, 40)];
    userArea.text = @"所在地区";
    userArea.textAlignment = NSTextAlignmentCenter;
    userArea.font = [UIFont systemFontOfSize:14];
    userArea.textColor = FONTS_COLOR102;
    [baseView addSubview:userArea];
    
    userAreaField = [[UITextField alloc]initWithFrame:CGRectMake(viewRight(userArea)+10, viewBottom(line3), DEVICE_SCREEN_SIZE_WIDTH-userArea.frame.size.width-20, 40)];
    userAreaField.placeholder = @"请选择您所在的地区";
    userAreaField.font = [UIFont systemFontOfSize:14];
    userAreaField.textColor = FONTS_COLOR153;
    userAreaField.backgroundColor = UIColorWithRGBA(255, 255, 255, 0.5);
    //设置圆角
//    userAreaField.delegate = self;
//    userAreaField.keyboardType = UIKeyboardTypeDefault;
//    userAreaField.returnKeyType = UIReturnKeyNext;
//    userAreaField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [userAreaField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [baseView addSubview:userAreaField];
    
    UIButton *areaBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewRight(userArea)+10, viewBottom(line3), DEVICE_SCREEN_SIZE_WIDTH-userArea.frame.size.width-20, 40)];
    [areaBtn addTarget:self action:@selector(addressPickViewMethod:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:areaBtn];
    
    UIImageView *line4 = [[UIImageView alloc]initWithFrame:CGRectMake(10, viewBottom(userAreaField), DEVICE_SCREEN_SIZE_WIDTH-20, 1)];
    line4.backgroundColor = LINECOLOR_DEFAULT;
    [baseView addSubview:line4];
    
    //所在小区
    userCom = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line4), 80, 40)];
    userCom.text = @"所在小区";
    userCom.textAlignment = NSTextAlignmentCenter;
    userCom.font = [UIFont systemFontOfSize:14];
    userCom.textColor = FONTS_COLOR102;
    [baseView addSubview:userCom];
    
    userComField = [[UITextField alloc]initWithFrame:CGRectMake(viewRight(userCom)+10, viewBottom(line4), DEVICE_SCREEN_SIZE_WIDTH-userCom.frame.size.width-20, 40)];
    userComField.placeholder = @"请选择您所在的小区";
    userComField.font = [UIFont systemFontOfSize:14];
    userComField.textColor = FONTS_COLOR153;
    userComField.backgroundColor = UIColorWithRGBA(255, 255, 255, 0.5);
    
    //设置圆角
    userComField.delegate = self;
    userComField.keyboardType = UIKeyboardTypeDefault;
    userComField.returnKeyType = UIReturnKeyNext;
    userComField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [userComField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [baseView addSubview:userComField];
    UIButton *comBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewRight(userCom)+10, viewBottom(line4), DEVICE_SCREEN_SIZE_WIDTH-userCom.frame.size.width-20, 40)];
    [comBtn addTarget:self action:@selector(comPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:comBtn];
    
    UIImageView *line5 = [[UIImageView alloc]initWithFrame:CGRectMake(10, viewBottom(userComField), DEVICE_SCREEN_SIZE_WIDTH-20, 1)];
    line5.backgroundColor = LINECOLOR_DEFAULT;
    [baseView addSubview:line5];
    
    //详细地址
    userAddress = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line5), 80, 40)];
    userAddress.text = @"详细地址";
    userAddress.textAlignment = NSTextAlignmentCenter;
    userAddress.font = [UIFont systemFontOfSize:14];
    userAddress.textColor = FONTS_COLOR102;
    [baseView addSubview:userAddress];
    
    userAddressField = [[UITextField alloc]initWithFrame:CGRectMake(viewRight(userAddress)+10, viewBottom(line5), DEVICE_SCREEN_SIZE_WIDTH-userAddress.frame.size.width-20,40)];
    userAddressField.placeholder = @"请输入楼号门牌号等详细信息";
    userAddressField.font = [UIFont systemFontOfSize:14];
    userAddressField.textColor = FONTS_COLOR153;
    userAddressField.backgroundColor = UIColorWithRGBA(255, 255, 255, 0.5);

    //设置圆角
    userAddressField.delegate = self;
    userAddressField.keyboardType = UIKeyboardTypeDefault;
    userAddressField.returnKeyType = UIReturnKeyDone;
    userAddressField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [userAddressField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [baseView addSubview:userAddressField];
    
//    UIView *delAddress = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(baseView)+20, DEVICE_SCREEN_SIZE_WIDTH, 40)];
//    delAddress.backgroundColor = [UIColor whiteColor];
//    UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 40)];
//    [delBtn setTitle:@"删除地址" forState:UIControlStateNormal];
//    [delBtn setTitleColor:FONTS_COLOR102 forState:UIControlStateNormal];
//    delBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [delAddress addSubview:delBtn];
//    
//    [self.view addSubview:delAddress];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender{
    if (sender == userNameField) {
        [userSexField becomeFirstResponder];
    }else if (sender == userSexField) {
        [userPhoneField becomeFirstResponder];
    }else if (sender == userPhoneField) {
        [userAreaField becomeFirstResponder];
    }else if (sender == userAreaField) {
        [userComField becomeFirstResponder];
    }else if (sender == userComField) {
        [userAddressField becomeFirstResponder];
    }else if (sender == userAddressField) {
        [self hideKeyboard];
    }
}


//隐藏键盘方法
-(void)hideKeyboard{
    [userNameField resignFirstResponder];
    [userSexField resignFirstResponder];
    [userPhoneField resignFirstResponder];
    [userAreaField resignFirstResponder];
    [userComField resignFirstResponder];
    [userAddressField resignFirstResponder];
}

- (IBAction)addressPickViewMethod:(id)sender {
    [self hideKeyboard];
    AddressPickView *addressPickView = [AddressPickView shareInstance];
    [self.view addSubview:addressPickView];
    addressPickView.block = ^(NSString *province,NSString *city,NSString *town){
        provinceStr = province;
        cityStr = city;
        townStr = town;
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@ %@",province,city,town]);
        userAreaField.text = [NSString stringWithFormat:@"%@%@%@",province,city,town];
        
    };
}
- (IBAction)sexPickerView:(id)sender {
    [self hideKeyboard];
    LTPickerView* pickerView = [LTPickerView new];
    pickerView.dataSource = @[@"男",@"女"];//设置要显示的数据
//    pickerView.defaultStr = @"男";//默认选择的数据
    [pickerView show];//显示
    //回调block
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        //obj:LTPickerView对象
        //str:选中的字符串
        //num:选中了第几行
        NSLog(@"选择了第%d行的%@",num,str);
        if (num == 0) {
            sexNum = @"0";
        }else{
           sexNum = @"1";
        }
        userSexField.text = str;

    };
}

//小区
- (IBAction)comPickerView:(id)sender {
    LTPickerView* pickerView = [LTPickerView new];
    pickerView.dataSource = comNameArray;//设置要显示的数据
    //    pickerView.defaultStr = @"男";//默认选择的数据
    [pickerView show];//显示
    //回调block
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        //obj:LTPickerView对象
        //str:选中的字符串
        //num:选中了第几行
        NSLog(@"选择了第%d行的%@",num,str);
        userComField.text = str;
        communityId = comIdArray[num];
        NSLog(@"小区ID:%@;小区名称为:%@",communityId,str);
        
    };
}

//获取小区地址信息
- (void)loadAddressMsg {
    
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          [Tools stringForKey:CURRENT_LONGITUDE],  @"longitude",
                          [Tools stringForKey:CURRENT_LATITUDE],   @"latitude",
                          nil];
    
    NSString *xpoint = @"/Api/Community/show?";
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dics success:^(id response) {
        
        NSDictionary *dic = response;
        NSLog(@"response:%@",response);
        NSString *statusMsg = [dic valueForKey:@"status"];
        
        if([statusMsg intValue] == 4001){
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        }else if([statusMsg intValue] == 201){
            //弹框提示获取失败
            [self showHUDText:@"附近暂无合作小区!"];
        }else {
            
            NSArray *data = [dic valueForKey:@"data"];
            for(NSDictionary *com in data){
                [comNameArray addObject:[com valueForKey:@"com_name"]];
                [comIdArray addObject:[com valueForKey:@"id"]];
                communityId = [com valueForKey:@"com_id"];
            }

        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

//获取地址详情信息
- (void)loadAdrMsg {
    
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          addressId,  @"id",
                          nil];
    
    NSString *xpoint = @"/Api/User/AddressDetail?";
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dics success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        
        if([statusMsg intValue] == 4001){
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        }else if([statusMsg intValue] == 201){
            //弹框提示获取失败
            [self showHUDText:@"暂无内容!"];
        }else {
            
            NSArray *data = [dic valueForKey:@"data"];
            userNameField.text = [data valueForKey:@"guest_name"];
            userSex = [data valueForKey:@"guest"];
            if ([[data valueForKey:@"guest"] isEqualToString:@"0"]) {
                userSexField.text = @"男";
            }else{
                userSexField.text = @"女";
            }
            userPhoneField.text = [data valueForKey:@"mobile"];
            userAreaField.text = [NSString stringWithFormat:@"%@ %@ %@",[data valueForKey:@"province"],[data valueForKey:@"city"],[data valueForKey:@"area"]];
            userComField.text = [data valueForKey:@"com_name"];
            
            NSArray *array = [[data valueForKey:@"address"] componentsSeparatedByString:[data valueForKey:@"com_name"]]; //从字符A中分隔成2个元素的数组
            
            userAddressField.text = [array objectAtIndex:1];
            
            //保存数据
            communityId = [data valueForKey:@"com_id"];
            address = [data valueForKey:@"address"];
            guestName = [data valueForKey:@"guest_name"];
            mobile = [data valueForKey:@"mobile"];
            sexNum = [data valueForKey:@"gender"];
            provinceStr = [data valueForKey:@"province"];
            cityStr = [data valueForKey:@"city"];
            townStr =[data valueForKey:@"area"];
            
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}


//编辑地址信息
- (IBAction)addAddressMsg:(id)sender{
    if (userNameField.text.length == 0) {
        alert=[[UIAlertView alloc]initWithTitle:nil message:@"请填写联系人" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (userSexField.text.length == 0) {
        alert=[[UIAlertView alloc]initWithTitle:nil message:@"请选择性别" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (userPhoneField.text.length == 0) {
        alert=[[UIAlertView alloc]initWithTitle:nil message:@"请填写您的手机号码" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (userAreaField.text.length == 0) {
        alert=[[UIAlertView alloc]initWithTitle:nil message:@"请选择您所在的地区" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (userComField.text.length == 0) {
        alert=[[UIAlertView alloc]initWithTitle:nil message:@"请选择您所在的小区" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (userAddressField.text.length == 0) {
        alert=[[UIAlertView alloc]initWithTitle:nil message:@"请选择您的详细信息" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    //地址拼接
    NSString *string1 = [userAreaField.text stringByAppendingString:userComField .text];
    NSString *string2 = [string1 stringByAppendingString:userAddressField.text];
    
    NSDictionary *dica = [[NSDictionary alloc]initWithObjectsAndKeys:
                          [Tools stringForKey:KEY_USER_ID],  @"userId",
                          communityId,   @"comId",
                          string2,@"address",
                          userNameField.text,@"guest_name",
                          userPhoneField.text,@"mobile",
                          sexNum,@"gender",
                          @"0",@"level",
                          addressId,@"id",
                          provinceStr,@"province",
                          cityStr,@"city",
                          townStr,@"area",
                          nil];
    
    NSString *xpointa = @"/Api/User/updAddress?";
    NSLog(@"dics:%@",dica);
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpointa refreshCache:YES emphasis:NO params:dica success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        
        if([statusMsg intValue] == 4001){
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        }else if([statusMsg intValue] == 201){
            //弹框提示获取失败
            [self showHUDText:@"附近暂无合作小区!"];
        }else {
            [self showHUDText:@"修改成功!"];

            //通知 发出
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refAddressList" object:nil];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}



@end
